library(igraph)


#Question 6
print("Question 6")

g <- read.graph("facebook_combined.txt", format = "edgelist", directed=F)

names <- seq(1,length(V(g)))
V(g)$names <- names

core.nodes <- rep(F,vcount(g))

for(i in 1:vcount(g))
{
  n = neighbors(g, i)
  if(length(n)>200)
  {
    core.nodes[i] <- T
  } 
}

core <- which(core.nodes==T)

community.size <- matrix(-1, length(core), 9)
community.density <- matrix(-1, length(core), 9)
community.cc <- matrix(-1, length(core), 9)
  
count <- 1

for(i in core){
  n <- neighbors(g, i)
  sg <- induced.subgraph(g, c(n,i))
  sg.cs <- fastgreedy.community(sg)
  
  for(community in 1:length(sg.cs)) {
    community.size[count,community] <- length(which(sg.cs$membership == community))
    community.subgraph <- induced.subgraph(sg, which(sg.cs$membership == community))
    community.density[count, community] <- graph.density(community.subgraph)
    community.cc[count, community] <- transitivity(community.subgraph)
  }
  
  count <- count + 1
}

# Communities with maximum density have the smallest sizes
density <- rep(0,length(core))
size <- rep(0,length(core))
cc <- rep(0,length(core))

for(row in 1:length(core))
{
  densities <- community.density[row,]
  max.den <- which.max(densities)
  density[row] <- densities[max.den]
  size[row] <- community.size[row,max.den]
  cc[row] <- community.cc[row,max.den]
}

# Communities with largest sizes

density1 <- rep(0,length(core))
size1 <- rep(0,length(core))
cc1 <- rep(0,length(core))

for(row in 1:length(core))
{
  sizes <- community.size[row,]
  max.size <- which.max(sizes)
  density1[row] <- community.density[row,max.size]
  size1[row] <- sizes[max.size]
  cc1[row] <- community.cc[row,max.size]
}
