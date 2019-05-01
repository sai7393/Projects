# -*- coding: utf-8 -*-
"""
Created on Thu Jun 04 16:36:50 2015

@author: Mak

"""
import fileinput
from sets import Set

#Question 1
listoflists = []
alist=[]
i=0
with open('actor_movies.txt') as f:
   for l in f:
       alist= l.strip().split("\t\t")
#       print l.strip().split("\t\t")
       i=i+1
       if(i%10000==0):
           print(i)
       if(len(alist)>5):
           listoflists.append(alist)
           
           
i=0
alist=[]
with open('actress_movies.txt') as f:
   for l in f:
       alist= l.strip().split("\t\t")
#       print l.strip().split("\t\t")
       i=i+1
       if(i%10000==0):
           print(i)
       if(len(alist)>5):
           listoflists.append(alist)
           
#%%
#Question 2 

movmap={} 
mamap={}        
count=0  
for l in listoflists:
    movmap[l[0].replace(" ","")]=Set([])
    count=count+1
    for i in range(1,len(l)):
        movmap[l[0].replace(" ","")].add(l[i].replace(" ",""))
        if(l[i].replace(" ","") not in mamap):
            mamap[l[i].replace(" ","")]=Set([])            
        mamap[l[i].replace(" ","")].add(l[0].replace(" ",""))
        
cllistoflists = []
count=0
for l in list(movmap.viewkeys()):
    count=count+1
    if(count%10000 == 0):
        print(count)
    for k in movmap[l]:
        for m in mamap[k]:
            if(m != l):
                clalist=[]
                temp=len(movmap[l].intersection(movmap[m]))
                if(temp>0):
                    clalist.append(l)
                    clalist.append(m)
                    weight=float(float(temp)/float(len(movmap[l])))
                    clalist.append(weight)
                    cllistoflists.append(clalist)
#%%     
i = 0
edgelist = Set([])
for l in cllistoflists:
    edgelist.add(l[0].replace(" ","")+' '+l[1].replace(" ","")+' '+str(l[2])+'\n')
    i=i+1
    if(i%10000==0):
        print(i)
   
#%%
i = 0
with open('temp3.txt', 'a') as export:
    for l in edgelist:       
        export.write(l)
        if(i%10000==0):
            print(i)
        i=i+1