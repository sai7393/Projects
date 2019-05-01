# -*- coding: utf-8 -*-
"""
Created on Sat Jun 06 19:38:22 2015

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
       if(len(alist)>20):
         listoflists.append(alist)
       i=i+1
       if(i%10000==0):
        print("ACTOR_MOVIES")
        print(i)

           
i=0
alist=[]
with open('actress_movies.txt') as f:
   for l in f:
       alist= l.strip().split("\t\t")
       if(len(alist)>20):
         listoflists.append(alist)
       i=i+1
       if(i%10000==0):
        print("ACTRESS_MOVIES")
        print(i)

#%% 
mamap={}        
count=0  
for l in listoflists:
    count=count+1
    if(count % 10000 == 0):
      print("Loop 3")
      print(count)
    for i in range(1,len(l)):
      lirep = l[i].replace(" ","")
      if(lirep not in mamap):
          mamap[lirep]=Set([])            
      mamap[lirep].add(l[0].replace(" ",""))
    
del listoflists        
#%%
i=0
for l in list(mamap.viewkeys()):
   if(len(mamap[l])<5):
       del mamap[l]
   i=i+1
   if(i% 10000 ==0):
    print("Loop 4")
    print(i)
       
#remove the null movie entry caused by actors without movies
     
del mamap[""]
print(len(mamap))    
#%%
mvmap={}
count=0
for l in list(mamap.viewkeys()):
    count=count+1
    if(count %10000 ==0):
      print("Loop 5")
      print(count)
    for i in mamap[l]:
      irep = i.replace(" ","")
      if(irep not in mvmap):
          mvmap[irep]=Set([])            
      mvmap[irep].add(l.replace(" ",""))
print(len(mvmap))        
    
#%%
        
edgelist = Set([])
with open('temp2.txt', 'a') as export:
  count=0
  for l in list(mamap.viewkeys()):
      count=count+1
      if(count%20000 == 0):
          print(count)
      for k in mamap[l.replace(" ","")]:
          for m in mvmap[k]:
              if(l != m):
                  temp=len(mamap[l].intersection(mamap[m]))
                  if(temp>0):
                      s1=l.replace(" ","")
                      s2=m.replace(" ","")
                      den=len(mamap[l].union(mamap[m]))
                      weight=float(float(temp)/float(den))
                      if(s1 <= s2):
                          res= s1+' '+s2+' '+str(weight)+'\n'
                          edgelist.add(res)
                      else:
                          res= s2+' '+s1+' '+str(weight)+'\n'
                          edgelist.add(res) 
del mamap
del mvmap

#%%
i = 0
with open('tempfin3.txt', 'a') as export:
    for l in edgelist:       
        export.write(l)
        if(i%10000==0):
          print("Loop 8")
          print(i)
        i=i+1