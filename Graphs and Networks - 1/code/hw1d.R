library(igraph)
#.1 - .4
g = forest.fire.game(1000, fw.prob=0.1, bw.factor=1)
#plot(g)
plot(degree.distribution(g, mode="in"),main="Degree Dist for in degree: fw.p=.1")
plot(degree.distribution(g, mode="out"),main="Degree Dist for out degree: fw.p=.1")
#diameter
d=diameter(g)
print(d)

# find the giant connected component
cl <- clusters(g)
gccIndex = which.max(cl$csize)
nonGccNodes <- (1:vcount(g))[cl$membership != gccIndex]
gcc <- delete.vertices(g, nonGccNodes)

# find communities
gcc = as.undirected(gcc,"collapse")
fg <- fastgreedy.community(gcc)
cmsize <- sizes(fg)
cmsize <- as.vector(sizes(fg))
gccNodes <- (1:vcount(g))[cl$membership == gccIndex]
cm1Nodes <- gccNodes[fg$membership == 1]
barplot(table(cmsize),main="Community Structure : fw.p=.1")

eb <- edge.betweenness.community(gcc)
cmsize <- as.vector(sizes(eb))
barplot(table(cmsize),main="Community Structure: fw.p=.1 using E.B.C")

#modularity
m=modularity(fg)
print(m)

m=modularity(eb)
print(m)

v_in = degree.distribution(g, mode="in")
v_out = degree.distribution(g, mode="out")

plot(seq(along=v_in)-1, v_in, log="xy", main="fw.p=.1")
points(seq(along=v_out)-1, v_out, col=2, pch=2)






# .2


g = forest.fire.game(1000, fw.prob=0.2, bw.factor=1)
#plot(g)
plot(degree.distribution(g, mode="in"),main="Degree Dist for in degree: fw.p=.2")
plot(degree.distribution(g, mode="out"),main="Degree Dist for out degree: fw.p=.2")
#diameter
d=diameter(g)
print(d)


# find the giant connected component
cl <- clusters(g)
gccIndex = which.max(cl$csize)
nonGccNodes <- (1:vcount(g))[cl$membership != gccIndex]
gcc <- delete.vertices(g, nonGccNodes)

# find communities
gcc = as.undirected(gcc,"collapse")
fg <- fastgreedy.community(gcc)
cmsize <- sizes(fg)
cmsize <- as.vector(sizes(fg))
gccNodes <- (1:vcount(g))[cl$membership == gccIndex]
cm1Nodes <- gccNodes[fg$membership == 1]
barplot(table(cmsize),main="Community Structure: fw.p=.2")

eb <- edge.betweenness.community(gcc)
cmsize <- as.vector(sizes(eb))
barplot(table(cmsize),main="Community Structure: fw.p=.2 using E.B.C")

#modularity
m=modularity(fg)
print(m)

m=modularity(eb)
print(m)


v_in = degree.distribution(g, mode="in")
v_out = degree.distribution(g, mode="out")

plot(seq(along=v_in)-1, v_in, log="xy",main="fw.p=.2")
points(seq(along=v_out)-1, v_out, col=2, pch=2)












g = forest.fire.game(1000, fw.prob=0.27, bw.factor=1)
#plot(g)
plot(degree.distribution(g, mode="in"),main="Degree Dist for in degree: fw.p=.27")
plot(degree.distribution(g, mode="out"),main="Degree Dist for out degree: fw.p=.27")
#diameter
d=diameter(g)
print(d)


# find the giant connected component
cl <- clusters(g)
gccIndex = which.max(cl$csize)
nonGccNodes <- (1:vcount(g))[cl$membership != gccIndex]
gcc <- delete.vertices(g, nonGccNodes)

# find communities
gcc = as.undirected(gcc,"collapse")
fg <- fastgreedy.community(gcc)
cmsize <- sizes(fg)
cmsize <- as.vector(sizes(fg))
gccNodes <- (1:vcount(g))[cl$membership == gccIndex]
cm1Nodes <- gccNodes[fg$membership == 1]
barplot(table(cmsize),main="Community Structure: fw.p=.27")

eb <- edge.betweenness.community(gcc)
cmsize <- as.vector(sizes(eb))
barplot(table(cmsize),main="Community Structure: fw.p=.27 using E.B.C")

#modularity
m=modularity(fg)
print(m)
m=modularity(eb)
print(m)


v_in = degree.distribution(g, mode="in")
v_out = degree.distribution(g, mode="out")

plot(seq(along=v_in)-1, v_in, log="xy",main="fw.p=.27")
points(seq(along=v_out)-1, v_out, col=2, pch=2)











g = forest.fire.game(1000, fw.prob=0.37, bw.factor=1)
#plot(g)
plot(degree.distribution(g, mode="in"),main="Degree Dist for in degree: fw.p=.37")
plot(degree.distribution(g, mode="out"),main="Degree Dist for out degree: fw.p=.37")
#diameter
d=diameter(g)
print(d)


# find the giant connected component
cl <- clusters(g)
gccIndex = which.max(cl$csize)
nonGccNodes <- (1:vcount(g))[cl$membership != gccIndex]
gcc <- delete.vertices(g, nonGccNodes)

# find communities
gcc = as.undirected(gcc,"collapse")
fg <- fastgreedy.community(gcc)
cmsize <- sizes(fg)
cmsize <- as.vector(sizes(fg))
gccNodes <- (1:vcount(g))[cl$membership == gccIndex]
cm1Nodes <- gccNodes[fg$membership == 1]
barplot(table(cmsize),main="Community Structure: fw.p=.37")

eb <- edge.betweenness.community(gcc)
cmsize <- as.vector(sizes(eb))
barplot(table(cmsize),main="Community Structure: fw.p=.37 using E.B.C")


#modularity with conversion
m=modularity(fg)
print(m)

#modularity without
m=modularity(eb)
print(m)

v_in = degree.distribution(g, mode="in")
v_out = degree.distribution(g, mode="out")

plot(seq(along=v_in)-1, v_in, log="xy",main="fw.p=.37")
points(seq(along=v_out)-1, v_out, col=2, pch=2)









#.1

g = forest.fire.game(1000, fw.prob=0.1, bw.factor=1)



#.2

g = forest.fire.game(1000, fw.prob=0.2, bw.factor=1)




#.27

g = forest.fire.game(1000, fw.prob=0.27, bw.factor=1)




#.37

g = forest.fire.game(1000, fw.prob=0.37, bw.factor=1)


