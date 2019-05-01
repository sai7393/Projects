library(igraph)
library(netrw)


#Question 1
print("Question 1")


g= read.graph("facebook_combined.txt", format = "edgelist",directed=FALSE)

#Is the network connected? Measure the diameter of the network.
con=is.connected(g)
dia=diameter(g)
print(con)
print(dia)

#Plot the degree distribution
d=degree.distribution(g)
plot(d)

#try to fit a curve on it
xdata=seq(1,1046)
p1 <- 1
p2 <- .2
fit <- nls(d ~ p1*(xdata)^-p2, start=list(p1=p1,p2=p2))
lines(seq(1,1046),predict(fit,xdata))

#total mean square error
t1=predict(fit,xdata)
res=sum((d-t1)^2)/length(t1)
print(res)



#Average degree
print(mean(d))


#Question 2
print("Question 2")


n = neighbors(g, 1)
sg = induced.subgraph(g, c(n,1))
nnodes=vcount(sg)
nedges=ecount(sg)
print(nnodes)
print(nedges)

#Question 3
print("Question 3")
j=0
davg=0

for( i in 1:vcount(g))
{
  n = neighbors(g, i)
  if(length(n)>200)
  {
    j=j+1
    davg=davg+degree(g,i)    
  }
  
}
#How many core nodes do you find in the network
print(j)
#What is the average degree of these core nodes
print(davg/j)


#For one of these nodes, find the community structure of the core's personal network

n = neighbors(g, 1)
sg = induced.subgraph(g, c(n,1))

# find the giant connected component
cl <- clusters(sg)
gccIndex = which.max(cl$csize)
nonGccNodes <- (1:vcount(sg))[cl$membership != gccIndex]
gcc <- delete.vertices(sg, nonGccNodes)

# find communities using FG
fg <- fastgreedy.community(gcc)
cmsize <- sizes(fg)
cmsize <- as.vector(sizes(fg))
gccNodes <- (1:vcount(sg))[cl$membership == gccIndex]
cm1Nodes <- gccNodes[fg$membership == 1]
barplot(table(cmsize),main="Community Structure: using F.G")
#plot(fg,g,vertex.size=7,edge.width=.3,vertex.label=NA,mark.groups = NA)
#plot(sg,vertex.size=7,edge.width=.3,vertex.label=NA,mark.groups = NA)
#plot(fg,gcc,vertex.size=7,edge.width=.3,vertex.label=NA,mark.groups = NA)
#V(sg)$size=(ifelse(V(sg)!=1,5,10))
V(sg)$color = ifelse(V(sg)==1,"black","blue")
plot(sg,vertex.label=NA,main="test",vertex.size=7,edge.width=.3,vertex.label=NA,mark.groups = NA)
plot(fg,sg,vertex.label=NA,main="fg",vertex.size=7,edge.width=.3,vertex.label=NA,mark.groups = NA)

# find communities using EB
eb <- edge.betweenness.community(gcc)
cmsize <- as.vector(sizes(eb))
barplot(table(cmsize),main="Community Structure: using E.B.C")
plot(eb,sg,vertex.label=NA,main="fg",vertex.size=7,edge.width=.3,vertex.label=NA,mark.groups = NA)


# find communities using InfoMAp
im = infomap.community(gcc)
cmsize <- as.vector(sizes(im))
barplot(table(cmsize),main="Community Structure: using I.M")
plot(im,sg,vertex.label=NA,main="fg",vertex.size=7,edge.width=.3,vertex.label=NA,mark.groups = NA)


#Question 4

print("Question 4")

#For one of these nodes, find the community structure of the core's personal network

n = neighbors(g, 1)
sg = induced.subgraph(g, c(n))

# find the giant connected component
cl <- clusters(sg)
gccIndex = which.max(cl$csize)
nonGccNodes <- (1:vcount(sg))[cl$membership != gccIndex]
gcc <- delete.vertices(sg, nonGccNodes)

# find communities using FG
fg <- fastgreedy.community(gcc)
cmsize <- sizes(fg)
cmsize <- as.vector(sizes(fg))
gccNodes <- (1:vcount(sg))[cl$membership == gccIndex]
cm1Nodes <- gccNodes[fg$membership == 1]
barplot(table(cmsize),main="Community Structure: using F.G")
#V(sg)$size=(ifelse(V(sg)!=1,5,10))
V(sg)$color = ifelse(V(sg)==1,"black","blue")
plot(sg,vertex.label=NA,main="test",vertex.size=7,edge.width=.3,vertex.label=NA,mark.groups = NA)
plot(fg,sg,vertex.label=NA,main="fg",vertex.size=7,edge.width=.3,vertex.label=NA,mark.groups = NA)


# find communities using EB
eb <- edge.betweenness.community(gcc)
cmsize <- as.vector(sizes(eb))
barplot(table(cmsize),main="Community Structure: using E.B.C")
plot(eb,sg,vertex.label=NA,main="fg",vertex.size=7,edge.width=.3,vertex.label=NA,mark.groups = NA)


# find communities using InfoMAp
im = infomap.community(gcc)
cmsize <- as.vector(sizes(im))
barplot(table(cmsize),main="Community Structure: using I.M")
plot(im,sg,vertex.label=NA,main="fg",vertex.size=7,edge.width=.3,vertex.label=NA,mark.groups = NA)
