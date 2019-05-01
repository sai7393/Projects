library(igraph)
library(netrw)


#Question 1
print("Question 1")

#edges=read.table("sorted_directed_net.txt")
#g= graph.data.frame(edges, directed=T)
#read ofr weighted graph
g<-read.graph("sorted_directed_net.txt",format="ncol",directed=T)

#E(g)$weight
#Check if the network is connected
con=is.connected(g)
print(con)

#find the giant connected component

#find the GCC
cl <- clusters(g)
gccIndex = which.max(cl$csize)
nonGccNodes <- (1:vcount(g))[cl$membership != gccIndex]
gcc <- delete.vertices(g, nonGccNodes)

#Q2
plot(degree.distribution(g,mode="in"),main="In Degree")
plot(degree.distribution(g,mode="out"),main="Out Degree")

#Q3
#Combination method 1 with same number of edges
#LPC
ng1= as.undirected(gcc,mode="each")
lpc = label.propagation.community(ng1)
cmsize <- as.vector(sizes(lpc))
barplot(table(cmsize),main="Bar1:Community Structure: using L.P.C")



# Combination method 2 with lesser number of edges
ng2=as.undirected(gcc, mode="collapse",edge.attr.comb="prod")
E(ng2)$weight=sqrt(E(ng2)$weight)
#LPC
lpc = label.propagation.community(ng2)
cmsize <- as.vector(sizes(lpc))
barplot(table(cmsize),main="Bar2:Community Structure: using L.P.C")
#FG
fg = fastgreedy.community(ng2)
cmsize <- as.vector(sizes(fg))
barplot(table(cmsize),main="Bar2:Community Structure: using F.G")

#Q 4

gmax= which.max(cmsize)
nmax <- (1:vcount(ng2))[fg$membership != gmax]
larg <- delete.vertices(ng2, nmax)
#subcommunity FG
fg = fastgreedy.community(larg)
cmsize <- as.vector(sizes(fg))
barplot(table(cmsize),main="Bar3:Community Structure: using F.G")

#subcommunity LPC
lpc = label.propagation.community(larg)
cmsize <- as.vector(sizes(lpc))
barplot(table(cmsize),main="Bar3:Community Structure: using L.P.C")

#Q5
fg = fastgreedy.community(ng2)
cmsize <- as.vector(sizes(fg))


gt100 = c()
j=1
for( i in 1:length(cmsize))
{
  if( cmsize[i] >100)
  {
    gt100[j]=i
    j=j+1
  }
  
}

for( i in gt100)
{
gmax= i
nmax <- (1:vcount(ng2))[fg$membership != gmax]
larg <- delete.vertices(ng2, nmax)
#subcommunity FG
fg = fastgreedy.community(larg)
cmsize1 <- as.vector(sizes(fg))
barplot(table(cmsize1),main=paste("Bar4:Community Structure: using F.G ",cmsize[i]))
}



#Question 6


fg = fastgreedy.community(ng2)
cmsize <- as.vector(sizes(fg))

TimeStep=1000
WalkNum=10
vec=matrix(0,vcount(gcc),8)
#probvec=rep(0,vcount(g))
for( i in  (1:(vcount(gcc))))
{
#if( i != 1)
#{
 #probvec[i-1]=0
#}
 # probvec[i]=1
  sim <- netrw (gcc,WalkNum,start.node = i ,weights=(E(gcc)$weight),local.pagerank=TRUE,damping=.85,T=TimeStep,output.walk.path=TRUE)$ave.visit.prob
  sortsim = sort(sim, method = "sh", index.return = TRUE,decreasing=TRUE)
  tsim = sortsim$x[1:30]
  indx = sortsim$ix[1:30]
  mebr= fg$membership[indx]
  for( j in 1:30)
  {
    vec[i,mebr[j]] = vec[i,mebr[j]]+tsim[j]
  }
  print(i)
}

cn=0
for( i in 1:vcount (gcc)){
count=length(vec[i,vec[i,]>.145])

 if(count>1)
 {
   print(i)
   print(count)
   cn=cn+1
 }
 }


#graph plotter
cn1=rep(0, vcount(gcc))
for( i in 1:vcount (gcc)){
  cn1[i] = length(vec[i,vec[i,]>.14])
}
cn1[1]=5

plot(cn1,main=".14",type="o")
