library(igraph)
library(netrw)


#Question 7
print("Question 7")

edges=read.table("100535338638690515335.edges",colClasses = "character")
g= graph.data.frame(edges, directed=T)
g = g + vertex("100535338638690515335", color="red")

r = rep("100535338638690515335",length(V(g)))
t = V(g)
q=list()
k=1
l=2
for( i in 1:length(V(g)))
{
  q[k] = r[i]
  q[l] = t[i]$name
  #print(t[i])
  #print(q[l])
  k=k+2
  l=l+2
}
g = g + edges(q, color="black")
plot(g,vertex.size=7,edge.width=.3,vertex.label=NA,edge.arrow.size=0.2)

#find the GCC
cl <- clusters(g)
gccIndex = which.max(cl$csize)
nonGccNodes <- (1:vcount(g))[cl$membership != gccIndex]
gcc <- delete.vertices(g, nonGccNodes)

#InfoMap
im = infomap.community(gcc)
cmsize <- as.vector(sizes(im))
barplot(table(cmsize),main="Community Structure: using I.M")
plot(im,g,vertex.label=NA,main="fg",vertex.size=7,edge.arrow.size=0.2,vertex.label=NA,mark.groups =NA)

#read circles file
circles=read.delim("100535338638690515335.circles",header=FALSE,sep="\t",colClasses = "character")
ci=list()
for(i in 1:dim(circles)[1])
{
  tem=c()
  j=2
  while(j<dim(circles)[2] && circles[i,j]!="") {
  #for(j in 2:dim(circles)[2]){
    tem[j-1]=circles[i,j]
    j=j+1
  }
  ci[[i]]=tem
}
print("plot")
V(g)[ci[[4]]]$color="green"
V(g)[ci[[3]]]$color="blue"
V(g)[ci[[2]]]$color="yellow"
V(g)[ci[[1]]]$color="black"


plot(im,g,vertex.label=NA,main="im",vertex.size=7,edge.arrow.size=0.2,vertex.label=NA)


#membership(im)[ci[[4]]]





      
      