library(igraph)
library(netrw)


# Question 1

TimeStep=1000
WalkNum=1000
g1=random.graph.game(1000,0.01,directed=F)
sim <- netrw (g1,WalkNum,seq(1,1000),damping=1,T=TimeStep,output.walk.path=TRUE)$ave.visit.prob
plot(sim,xlab="Nodes",ylab="Walker Visit Probability",main="Undirected")

ave=rep(0,1000)
din=rep(1,1000)

for( i in 1:1000)
{
  ave[degree(g1,i)]=ave[degree(g1,i)]+sim[i]
  din[degree(g1,i)]=din[degree(g1,i)]+1
}
ave=ave/din

plot(1:17,ave[1:17],type="o",xlab="Degree",ylab="Ave. Walker Visit Probability")


#Question 2 :


TimeStep=1000
WalkNum=1000
g2=random.graph.game(1000,0.01,directed=T)
sim1 <- netrw (g2,WalkNum,seq(1,1000),damping=1,T=TimeStep,output.walk.path=TRUE)$ave.visit.prob
plot(sim1,xlab="Nodes",ylab="Walker Visit Probability",main="Directed")

dave=rep(0,1000)
dden=rep(1,1000)

for( i in 1:1000)
{
  dave[degree(g2,i)]=dave[degree(g2,i)]+sim1[i]
  dden[degree(g2,i)]=dden[degree(g2,i)]+1
}
ave=ave/dden

plot(1:16,ave[1:16],type="o",xlab="Degree",ylab="Ave. Walker Visit Probability")
dave=rep(0,1000)
dden=rep(1,1000)

for( i in 1:1000)
{
  dave[degree(g2,i,mode="in")]=dave[degree(g2,i,mode="in")]+sim1[i]
  dden[degree(g2,i,mode="in")]=dden[degree(g2,i,mode="in")]+1
}
dave=dave/dden
plot(1:16,dave[1:16],pch=2,type="o",xlab="In-Degree",ylab="Ave. Walker Visit Probability")


#Question 3

TimeStep=1000
WalkNum=1000
g3=random.graph.game(1000,0.01,directed=F)
sim2 <- netrw (g3,WalkNum,seq(1,1000),damping=0.85,T=TimeStep,output.walk.path=TRUE)$ave.visit.prob
plot(sim,xlab="Nodes",ylab="Walker Visit Probability",main="Undirected: Damp=.85")

ave=rep(0,1000)
din=rep(1,1000)

for( i in 1:1000)
{
  ave[degree(g3,i)]=ave[degree(g3,i)]+sim2[i]
  din[degree(g3,i)]=din[degree(g3,i)]+1
}
ave=ave/din

plot(1:17,ave[1:17],type="o",xlab="Degree",ylab="Ave. Walker Visit Probability",main="Undirected: Damp=.85")
