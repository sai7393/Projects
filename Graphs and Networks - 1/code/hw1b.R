
library(igraph)



g <- barabasi.game(1000, directed=F)
plot(degree.distribution(g))
h=hist(degree(g),main="Fat Tailed Degree distribution", freq = F, breaks= seq(-0.5, by = 1, length.out = max(degree(g))+2))
pl <- data.frame(x=h$mids, y=h$density)
plot(pl , type="o",main="Fat Tailed Degree distribution")
dia=diameter(g)
print(dia)


con=is.connected(g)
print(con)


# find the giant connected component
cl <- clusters(g)
gccIndex = which.max(cl$csize)
nonGccNodes <- (1:vcount(g))[cl$membership != gccIndex]
gcc <- delete.vertices(g, nonGccNodes)
plot(degree.distribution(gcc),type="o",main="Degree distribution of GCC")



# find communities
fg <- fastgreedy.community(gcc)
cmsize <- sizes(fg)
cmsize <- as.vector(sizes(fg))
gccNodes <- (1:vcount(g))[cl$membership == gccIndex]
cm1Nodes <- gccNodes[fg$membership == 1]
barplot(table(cmsize),main="Community Structure")

#modularity
m=modularity(fg)
print(m)




#10000 node graph

bg <- barabasi.game(10000, directed=F)

# find the giant connected component
cl <- clusters(bg)
gccIndex = which.max(cl$csize)
nonGccNodes <- (1:vcount(bg))[cl$membership != gccIndex]
gcc <- delete.vertices(bg, nonGccNodes)

# find communities
fg <- fastgreedy.community(gcc)
cmsize <- sizes(fg)
cmsize <- as.vector(sizes(fg))
gccNodes <- (1:vcount(bg))[cl$membership == gccIndex]
cm1Nodes <- gccNodes[fg$membership == 1]
barplot(table(cmsize),main="Community Structure")

#modularity
m=modularity(fg)
print(m)


#Measure and plot the degree distribution of nodes j
tg <- barabasi.game(10000, directed=F)
dd =c()
for(k in 1:100000 ){
i = sample(1:999,1)
nb = neighbors(tg,i,1)
j = sample(1:length(nb),1)
dd = c(dd,degree(tg,nb[j]))
}
h=hist(dd,main="Degree distribution of nodes j that are picked", freq = F, breaks= seq(-0.5, by = 1, length.out = max(dd)+2))
pl <- data.frame(x=h$mids, y=h$density)
plot(pl , type="o",main="Degree distribution of nodes j that are picked")


