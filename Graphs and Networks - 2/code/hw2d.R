library(igraph)
library(netrw)


#Question 1

TimeStep=1000
WalkNum=1000
g1=random.graph.game(1000,0.01,directed=T)

sim1 <- netrw (g1,WalkNum,seq(1,1000),damping=0.85,T=TimeStep,output.walk.path=TRUE)$ave.visit.prob
plot(sim1,xlab="Nodes",ylab="Walker Visit Probability",main="Directed graph")

#Question 2
#Get regular PageRank, where teleportation probability to all nodes are the same 
#and equal to 1/N
sim1 <- netrw (g1,WalkNum,seq(1,1000),damping=0.85,T=TimeStep,output.walk.path=TRUE,teleport.prob=rep(0.001,1000))$ave.visit.prob
sim2 <- netrw (g1,WalkNum,seq(1,1000),damping=0.85,T=TimeStep,output.walk.path=TRUE,teleport.prob=sim1)$ave.visit.prob
plot(sim1,xlab="Nodes",ylab="Walker Visit Probability",main="Compare Personalised:Red vs Normal:Black")
points(sim2,col="red")
