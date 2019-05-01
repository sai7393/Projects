/*BEGIN_LEGAL 
 Intel Open Source License

 Copyright (c) 2002-2013 Intel Corporation. All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are
 met:

 Redistributions of source code must retain the above copyright notice,
 this list of conditions and the following disclaimer.  Redistributions
 in binary form must reproduce the above copyright notice, this list of
 conditions and the following disclaimer in the documentation and/or
 other materials provided with the distribution.  Neither the name of
 the Intel Corporation nor the names of its contributors may be used to
 endorse or promote products derived from this software without
 specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE INTEL OR
 ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 END_LEGAL */
/*
 *  This file contains an ISA-portable PIN tool for tracing memory accesses.
 */

#include <stdio.h>
#include "pin.H"
# include<iostream>
# include<math.h>
# include<cstdlib>
# include<fstream>
FILE * cacheOut;

/*structure for each block*/
typedef struct {
	long long tag;
	long long time_last_used;
	bool valid;            //0 means not valid
} block;

/*class for cache*/
class cache {

public:
	long long block_size;
	long long assoc;
	long long latency;
	long long size;
	long long num_blocks;
	long long sets;

	long long recently_evicted_block;
	int bits_block;
	int bits_index;
	int bits_tag;

	long long counter;

	block** matrix_sets;

    /*constructor*/
	cache(long long s, long long ass, long long lat, long long bs) {
		size = s;
		assoc = ass;
		latency = lat;
		block_size = bs;
		counter = 0;
		num_blocks = size / block_size;
		sets = num_blocks / assoc;

		bits_block = (int) log2(block_size);
		bits_index = (int) log2(sets);
		bits_tag = 48 - bits_block - bits_index;

		matrix_sets = (block**) malloc(sizeof(block*) * sets);
		int i, j;
		for (i = 0; i < sets; i++) {
			matrix_sets[i] = (block*) malloc(sizeof(block) * assoc);
		}

		for (i = 0; i < sets; i++) {
			for (j = 0; j < assoc; j++) {
				matrix_sets[i][j].valid = false;
			}
		}
	}

    /*function to evict a block*/
	void evict_block(long long mem_addr) {
		long long mem_tag = extract_tag(mem_addr);
		long long mem_set = extract_set(mem_addr);
		int j;
		for (j = 0; j < assoc; j++) {
			if (matrix_sets[mem_set][j].tag == mem_tag
					&& matrix_sets[mem_set][j].valid) {
				matrix_sets[mem_set][j].valid = false;
			}
		}
	}

    /* function to extract the tag bits in a given address*/
	long long extract_tag(long long mem_addr) {
		return (mem_addr
				- (mem_addr % (long long) pow(2, bits_block + bits_index)));
	}

    /* function to extract the set bits in a given address*/
	long long extract_set(long long mem_addr) {
		long long no_tag = (mem_addr - extract_tag(mem_addr));
		return (no_tag - (no_tag % (long long) pow(2, bits_block)))
				/ pow(2, bits_block);
	}

    /*function to check if there is hit in the cache.If not, put it there*/
	bool cache_hit(long long mem_addr) {
		counter++;
		recently_evicted_block = -1;
		long long mem_tag = extract_tag(mem_addr);

		long long mem_set = extract_set(mem_addr);

		int j;
		for (j = 0; j < assoc; j++) {
			if (matrix_sets[mem_set][j].tag == mem_tag
					&& matrix_sets[mem_set][j].valid)        //hit in this cache
					{
				return true;
			}
		}
		//printf("%lld\n",mem_set);
		for (j = 0; j < assoc; j++) {
			if (!matrix_sets[mem_set][j].valid) {
				matrix_sets[mem_set][j].valid = true;
				matrix_sets[mem_set][j].tag = mem_tag;
				matrix_sets[mem_set][j].time_last_used = counter;
				return false;
			}
		}

		int pos = 0;
		//printf("%d\n",pos);
		for (j = 0; j < assoc; j++) {
			if (matrix_sets[mem_set][j].time_last_used
					< matrix_sets[mem_set][pos].time_last_used) {
				pos = j;
			}
		}
		// The first byte in the recently evicted block
		recently_evicted_block = matrix_sets[mem_set][pos].tag
				* (long long) pow(2, bits_block + bits_index)
				+ mem_set * (long long) pow(2, bits_block);
		matrix_sets[mem_set][pos].valid = true;
		matrix_sets[mem_set][pos].tag = mem_tag;
		matrix_sets[mem_set][pos].time_last_used = counter;
		return false;
	}
};

/*class for the hierarchy of caches*/
class cache_hierarchy {
public:
	int num_cache;
	cache* caches[10];
	int hits[10];
	int misses[10];
	int mem_access;
	bool was_hit;

	cache_hierarchy() {
		int i;
		num_cache = 0;
		mem_access = 0;
		for (i = 0; i < 10; i++) {
			hits[i] = 0;
			misses[i] = 0;
		}
	}

	void print() {
		int i = 0;
		for (i = 0; i < num_cache; i++) {
			fprintf(cacheOut, "Hits %d\n", hits[i]);
			fprintf(cacheOut, "Misses %d\n", misses[i]);
			fprintf(cacheOut, "Total accesses is %d\n", hits[i] + misses[i]);
		    fprintf(cacheOut, "Miss Ratio is %f\n", misses[i]/hits[i]);
		}
	}

	void add_cache(long long size, long long associativity, long long latency,
			long long blockSize) {
		caches[num_cache] = new cache(size, associativity, latency, blockSize);
		num_cache++;
	}

    /*accessing each cache*/
	bool cache_access(long long mem_addr) {
		int i;
		was_hit = false;
		//cout<<"MemoryAccess "<<mem_addr<<"\n";

		for (i = 0; i < num_cache; i++) {
			if (caches[i]->cache_hit(mem_addr)) {
				//cout<<"Cache "<<i <<" hit\n";
				hits[i]++;
				was_hit = true;
				break;
			} else {
				int j;
				//cout<<"Cache "<<i <<" miss\n";
				misses[i]++;
				long long block_to_evict = caches[i]->recently_evicted_block;
				for (j = i - 1; j >= 0; j--) {
					caches[j]->evict_block(block_to_evict);
				}
			}
		}
		if (!was_hit)
			mem_access++;
		return was_hit;
	}
};

FILE * trace;
cache_hierarchy dataCache;
cache_hierarchy instrCache;

// Print a memory read record
VOID RecordMemRead(VOID * ip, VOID * addr) {
	char a[100], b[100];
	unsigned long int memAddr;

	sprintf(a, "%p", ip);
	sscanf(a, "%lx", &memAddr);
	instrCache.cache_access(memAddr);

	sprintf(b, "%p", addr);
	sscanf(b, "%lx", &memAddr);
	dataCache.cache_access(memAddr);
	fprintf(trace, "%p: R %p\n", ip, addr);
}

// Print a memory write record
VOID RecordMemWrite(VOID * ip, VOID * addr) {
	char a[100], b[100];
	unsigned long int memAddr;

	sprintf(a, "%p", ip);
	sscanf(a, "%lx", &memAddr);
	instrCache.cache_access(memAddr);

	sprintf(b, "%p", addr);
	sscanf(b, "%lx", &memAddr);
	dataCache.cache_access(memAddr);
	fprintf(trace, "%p: W %p\n", ip, addr);
}

// Is called for every instruction and instruments reads and writes
VOID Instruction(INS ins, VOID *v) {
	// Instruments memory accesses using a predicated call, i.e.
	// the instrumentation is called iff the instruction will actually be executed.
	//
	// On the IA-32 and Intel(R) 64 architectures conditional moves and REP
	// prefixed instructions appear as predicated instructions in Pin.
	UINT32 memOperands = INS_MemoryOperandCount(ins);

	// Iterate over each memory operand of the instruction.
	for (UINT32 memOp = 0; memOp < memOperands; memOp++) {
		if (INS_MemoryOperandIsRead(ins, memOp)) {
			INS_InsertPredicatedCall(ins, IPOINT_BEFORE,
					(AFUNPTR) RecordMemRead, IARG_INST_PTR, IARG_MEMORYOP_EA,
					memOp, IARG_END);
		}
		// Note that in some architectures a single memory operand can be
		// both read and written (for instance incl (%eax) on IA-32)
		// In that case we instrument it once for read and once for write.
		if (INS_MemoryOperandIsWritten(ins, memOp)) {
			INS_InsertPredicatedCall(ins, IPOINT_BEFORE,
					(AFUNPTR) RecordMemWrite, IARG_INST_PTR, IARG_MEMORYOP_EA,
					memOp, IARG_END);
		}
	}
}

VOID Fini(INT32 code, VOID *v) {
	fprintf(trace, "#eof\n");
	fprintf(cacheOut, "#eof\n");
	dataCache.print();
	fprintf(cacheOut, "#eof\n");
	instrCache.print();
	fclose(trace);
	fclose(cacheOut);
}

/* ===================================================================== */
/* Print Help Message                                                    */
/* ===================================================================== */

INT32 Usage() {
	PIN_ERROR(
			"This Pintool prints a trace of memory addresses\n"
					+ KNOB_BASE::StringKnobSummary() + "\n");
	return -1;
}

/* ===================================================================== */
/* Main                                                                  */
/* ===================================================================== */

int main(int argc, char *argv[]) {
	
	
	int k,a,b,c,d;
	
	ifstream fr;
    
    fr.open("a");
    fr>>k;
    for(int i=0;i<k;i++)
    {
        fr>>a>>b>>c>>d;
        dataCache.add_cache(a,b,c,d);
        instrCache.add_cache(a,b,c,d);        
    }
   
    fr.close();
	
	
	
	if (PIN_Init(argc, argv))
		return Usage();

	trace = fopen("pinatrace.out", "w");
	cacheOut = fopen("cacheOut.out", "w");

	INS_AddInstrumentFunction(Instruction, 0);
	PIN_AddFiniFunction(Fini, 0);

	// Never returns
	PIN_StartProgram();

	return 0;
}
