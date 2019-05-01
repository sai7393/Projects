library(igraph)

#Question 5
print("Question 5")

g <- read.graph("facebook_combined.txt", format = "edgelist", directed=F)

names <- seq(1,length(V(g)))
V(g)$names <- names

core.nodes <- rep(F,vcount(g))
core.size <- rep(0,40)
c <- 1
for(i in 1:vcount(g))
{
  n = neighbors(g, i)
  if(length(n)>200)
  {
    core.nodes[i] <- T
    core.size[c] <- length(n) 
    c <- c + 1
  } 
}

core <- which(core.nodes==T)
embeddedness <- matrix(0,length(core),vcount(g))
dispersion <- matrix(0,length(core),vcount(g))
dispersion1 <- matrix(0,length(core),vcount(g))

count <- 1

for (i in core)
{
  n = neighbors(g, i)
  sg = induced.subgraph(g, c(n,i))
  
  for(node in V(sg)$names)
  {
    if(node != i) {
    node.friends <- neighbors(g, node)
    mutual.friends <- intersect(n, node.friends)
    embeddedness[count,node] <- length(intersect(n,node.friends))
    # i.id <- V(sg)[which(V(sg)$names == as.character(i))]
    # node.id <- V(sg)[which(V(sg)$names == as.character(node))]
    # sg.without <- delete.vertices(sg, c(i.id,node.id))
    mutual.friends.id <- rep(0, length(mutual.friends))
    mf.count <- 1
    for (mf in mutual.friends)
    {
      mutual.friends.id[mf.count] <- V(sg)[which(V(sg)$names == as.character(mf))]
      mf.count <- mf.count + 1
    }
    sg.without <- induced.subgraph(sg, mutual.friends.id)
    num <- length(V(sg.without))
    dispersion[count,node] <- average.path.length(sg.without, unconnected=F)*num*(num-1)/2
    
    for(friend1 in V(sg.without))
    {
      for(friend2 in V(sg.without))
      {
        if(friend1 != friend2)
        {
          # friend1.id <- V(sg)[which(V(sg)$names == as.character(i))]
          if(!(friend1 %in% neighborhood(sg.without, order=2, nodes=friend2)))
          {
            dispersion1[count,node] <- dispersion1[count,node] + 1
          }
        }
      }
    }
  }}
  embeddedness[count,i] <- 0
  count <- count+1
  # if(count==5)
    # break;
}

# ---------------------------------------------------
dispersion <- dispersion1
ed.ratio <- embeddedness/dispersion

embeddednes.pn <- rep(0,33)
dispersion.pn <- rep(0,33)

count <- 1

for (i in 1:33)
{
  embeddedness.values <- embeddedness[i,]
  embeddedness.values <- embeddedness.values[embeddedness.values!=0]
  embeddednes.pn[count] <- mean(embeddedness.values)
  
  dispersion.values <- dispersion[i,]
  dispersion.values[is.na(dispersion.values)] <- core.size[count] + 1
  dispersion.values <- dispersion.values[dispersion.values!=0]
  dispersion.pn[count] <- mean(dispersion.values)
  
  count <- count + 1
}

hist(embeddednes.pn)
plot(embeddednes.pn)

hist(dispersion.pn, main="Histogram of dispersion", xlab="dispersion")
plot(dispersion.pn, xlab="Index of Personal Network", ylab="dispersion")

core.count <- 1
core1 <- core
core <- core[1:33]
for(j in core)
{
  if(core.count == 4)
    break
  
  max.embeddednes.node <- which.max(embeddedness[core.count,])
  max.dispersion.node <- which.max(dispersion[core.count,])
  max.ed.ratio.node <- which.max(ed.ratio[core.count,])
  print(max.embeddednes.node)
  print(max.dispersion.node)
  print(max.ed.ratio.node)
  
  n = neighbors(g, j)
  sg = induced.subgraph(g, c(n,j))
  fg = fastgreedy.community(sg)
  
  sg.max.embeddednes.node <- V(sg)[which(V(sg)$names == as.character(max.embeddednes.node))]
  sg.max.dispersion.node <- V(sg)[which(V(sg)$names == as.character(max.dispersion.node))]
  sg.max.ed.ratio.node <- V(sg)[which(V(sg)$names == as.character(max.ed.ratio.node))]
  
  core.count <- core.count + 1
  vcolor <- rep(8, length(n)+1)
  vsize <- rep(3,length(n)+1)
  
  vcolor[sg.max.embeddednes.node] <- 2
  vcolor[sg.max.dispersion.node] <- 3
  vcolor[sg.max.ed.ratio.node] <- 4
  
  vsize[sg.max.embeddednes.node] <- 6
  vsize[sg.max.dispersion.node] <- 6
  vsize[sg.max.ed.ratio.node] <- 6
  
  
  E(sg)$color <- 8
  E(sg)[from(sg.max.embeddednes.node)]$color <- 2
  E(sg)[from(sg.max.dispersion.node)]$color <- 3
  E(sg)[from(sg.max.ed.ratio.node)]$color <- 4
  
  main <- "Graph of Personal Network "
  main <- paste(main,core.count-1)
  
  filename <- "Q5-"
  filename <- paste(filename,core.count,"png")
  
  leg.txt <- c("Max Embeddedness", "Max Dispersion", "Max Ratio")
  
  png(filename=filename)
  plot(sg, vertex.color = vcolor, vertex.size=vsize, vertex.label=NA, main=main, mark.groups = communities(fg))
  legend("topright",leg.txt, pch=19, col=c(2,3,4))
  dev.off()
}
