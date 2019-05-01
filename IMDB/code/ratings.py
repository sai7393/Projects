import fileinput

i=0
with open('rating.txt','a') as f2:
	with open('movie_rating.txt') as f:
   		for l in f:
   			alist= l.strip().split("\t\t")
   			i=i+1
   			if(i%1000==0):
   				print(i)
   			s1 = str(alist[0]).replace(" ","") + '\t' + str(alist[1]) + '\n'
   			f2.write(s1)


