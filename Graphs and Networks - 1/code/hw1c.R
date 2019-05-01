library(igraph)

g=aging.prefatt.game(1000,pa.exp=1,aging.exp=-4, directed=F)
hist(degree(g), freq = F, main="Deg dist of rnd graph by simulating evolution",breaks= seq(0, by = 1, length.out = max(degree(g))+2))
plot(degree.distribution(g),type="o",main="Deg dist of rnd graph by simulating evolution")


d=degree(g)

for(i in 1:99){
  g=aging.prefatt.game(1000,pa.exp=1,aging.exp=-4, directed=F)
  d=c(d,degree(g))
}
h=hist(d,main="Over 100 graphs", freq = F, breaks= seq(-0.5, by = 1, length.out = max(d)+2))
pl <- data.frame(x=h$mids, y=h$density)
plot(pl , type="o",main="Over 100 graphs")

# find the giant connected component
cl <- clusters(g)
gccIndex = which.max(cl$csize)
nonGccNodes <- (1:vcount(g))[cl$membership != gccIndex]
gcc <- delete.vertices(g, nonGccNodes)

# find communities
fg <- fastgreedy.community(gcc)
cmsize <- sizes(fg)
cmsize <- as.vector(sizes(fg))
gccNodes <- (1:vcount(g))[cl$membership == gccIndex]
cm1Nodes <- gccNodes[fg$membership == 1]
barplot(table(cmsize),xlab="Community Structure")


#modularity
m=modularity(fg)
print(m)