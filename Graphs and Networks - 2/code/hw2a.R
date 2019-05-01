library(igraph)
library(netrw)


# Question 1

TimeStep=50
WalkNum=1000
plen=rep(0,TimeStep)
stddev = rep(0,TimeStep)
sim=list()
g1=random.graph.game(1000,0.01,directed=F)
g1_bk=g1

# Question 2

for( v in seq(1,10))
{
sim[[v]] <- netrw (g1,WalkNum,seq(1,1000),damping=1,T=TimeStep,output.walk.path=TRUE)$walk.path
  for(t in 1:TimeStep)
  {
    for( i in 1:WalkNum)
    {
      plen[t]=plen[t]+length(get.shortest.paths(g1, sim[[v]][1,i],sim[[v]][t,i])$vpath[[1]])-1
    }
  }
}
sim_bk=sim
plen=plen/(WalkNum*10)

for( v in seq(1,10))
{
  for(t in 1:TimeStep)
  {
    for( i in 1:WalkNum)
    {
      stddev[t]=stddev[t] + ((length(get.shortest.paths(g1, sim[[v]][1,i],sim[[v]][t,i])$vpath[[1]])-1) - plen[t])^2
    }
  } 
}
stddev=stddev/(WalkNum*10)


plot(seq(1:length(plen)),plen,xlab="Time Steps",ylab="Average Distance",main="Average Distance")
variance=(stddev)
stddev=sqrt(variance)
plot(seq(1:length(variance)),variance,xlab="Time Steps",ylab="Variance",main="Variance")
plot(seq(1:length(stddev)),stddev,xlab="Time Steps",ylab="Standard Deviation",main="Standard Deviation")
print(diameter(g1))

# Question 3 Nodes:100
# The graph is disconnected. Hence we find the giant connected componenet first.

TimeStep=50
plen=rep(0,TimeStep)
stddev = rep(0,TimeStep)
sim=list()
g1=random.graph.game(100,0.01,directed=F)
# find the giant connected component
cl <- clusters(g1)
gccIndex = which.max(cl$csize)
nonGccNodes <- (1:vcount(g1))[cl$membership != gccIndex]
gcc <- delete.vertices(g1, nonGccNodes)
g1=gcc
WalkNum=vcount(g1) # set it to number of vertices in the connected graph
print(WalkNum)
for( v in seq(1,10))
{
  sim[[v]] <- netrw (g1,WalkNum,seq(1,vcount(g1)),damping=1,T=TimeStep,output.walk.path=TRUE)$walk.path
  for(t in 1:TimeStep)
  {
    for( i in 1:WalkNum)
    {
      plen[t]=plen[t]+length(get.shortest.paths(g1, sim[[v]][1,i],sim[[v]][t,i])$vpath[[1]])-1
    }
  }
}
plen=plen/(WalkNum*10)

for( v in seq(1,10))
{
  for(t in 1:TimeStep)
  {
    for( i in 1:WalkNum)
    {
      stddev[t]=stddev[t] + ((length(get.shortest.paths(g1, sim[[v]][1,i],sim[[v]][t,i])$vpath[[1]])-1) - plen[t])^2
    }
  }
}
stddev=stddev/(WalkNum*10)


plot(seq(1:length(plen)),plen,xlab="Time Steps",ylab="Average Distance",main="Average Distance:100 Nodes")
variance=(stddev)
stddev=sqrt(variance)
plot(seq(1:length(variance)),variance,xlab="Time Steps",ylab="Variance",main="Variance:100 Nodes")
plot(seq(1:length(stddev)),stddev,xlab="Time Steps",ylab="Standard Deviation",main="Standard Deviation :100 Nodes")
print(diameter(g1))
print(diameter(gcc))


# Question 3 Nodes:10000


TimeStep=50
WalkNum=10000
plen=rep(0,TimeStep)
stddev = rep(0,TimeStep)
sim=list()
g1=random.graph.game(10000,0.01,directed=F)

for( v in seq(1,10))
{
  sim[[v]] <- netrw (g1,WalkNum,seq(1,10000),damping=1,T=TimeStep,output.walk.path=TRUE)$walk.path
  for(t in 1:TimeStep)
  {
    for( i in 1:WalkNum)
    {
      plen[t]=plen[t]+length(get.shortest.paths(g1, sim[[v]][1,i],sim[[v]][t,i])$vpath[[1]])-1
    }
  }
}
plen=plen/(WalkNum*10)

for( v in seq(1:10))
{
  for(t in 1:TimeStep)
  {
    for( i in 1:WalkNum)
    {
      stddev[t]=stddev[t] + ((length(get.shortest.paths(g1, sim[[v]][1,i],sim[[v]][t,i])$vpath[[1]])-1) - plen[t])^2
    }
  }
  print(v)
}
stddev=stddev/(WalkNum*10)

plot(seq(1:length(plen)),plen,xlab="Time Steps",ylab="Average Distance",main="Average Distance:10000 Nodes")
variance=(stddev)
stddev=sqrt(variance)
plot(seq(1:length(variance)),variance,xlab="Time Steps",ylab="Variance",main="Variance:10000 Nodes")
plot(seq(1:length(stddev)),stddev,xlab="Time Steps",ylab="Standard Deviation",main="Standard Deviation :10000 Nodes")
print(diameter(g1))


#Question 5

plot(degree.distribution(g1_bk),type="o",main="Degree Distribution of Graph")
dv=rep(0,1000)
for( v in 1:10)
{
  for (i in 1:1000){
    dv[degree(g1_bk,sim_bk[[v]][50,i])] = dv[degree(g1_bk,sim_bk[[v]][50,i])]+1;
  }
}
dv=dv/10000
plot(1:22,dv[1:22],type="o",main="Degree dist of nodes at end of random walk")


