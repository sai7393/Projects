library(igraph)

g<-read.graph("final.txt",format="ncol",directed=T)

g1 <- delete.edges(g, which(E(g)$weight<=0.027780))

g2 <- as.undirected(g1, "collapse", "last")

g3 <- delete.edges(g2, which(E(g2)$weight<=0.03704))

cl <- clusters(g3)
big <- which(cl$membership==which.max(cl$csize))
gcc <- induced.subgraph(g3, big)

g4 <- delete.edges(g3, which(E(g3)$weight<=0.04545))

cl <- clusters(g4)
big <- which(cl$membership==which.max(cl$csize))
gcc <- induced.subgraph(g4, big)

write.graph(gcc, 'gwd.txt', format="ncol", names="name", weights="weight")

adj.list <- get.adjacency(gcc, "upper", attr="weight", names=T)

gwd<-graph.adjacency(adj.list)

comm.gcc <- fastgreedy.community(gwd, weights = E(gwd)$weight)
