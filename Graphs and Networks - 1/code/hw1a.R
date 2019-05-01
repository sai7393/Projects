library(igraph)

g1=random.graph.game(1000,0.01,directed=F)
#plot(g1)
con1=is.connected(g1)
dia1=diameter(g1)
hist(degree(g1),main="p = 0.01",freq=F,breaks= seq(-0.5, by = 1, length.out = max(degree(g1))+2))
plot(degree.distribution(g1),type="o",main="p = 0.01")
print(con1)
print(dia1)
d=degree(g1)

for(i in 1:99){
  g=random.graph.game(1000,0.01,directed=F)
  d=c(d,degree(g))
}
h=hist(d,main="p = 0.01 over 100 graphs", freq = F, breaks= seq(-0.5, by = 1, length.out = max(d)+2))
pl <- data.frame(x=h$mids, y=h$density)
plot(pl , type="o",main="p = 0.01 over 100 graphs")



g2=random.graph.game(1000,0.05,directed=F)
#plot(g2)
con2=is.connected(g2)
dia2=diameter(g2)
hist(degree(g2),freq=F,main="p = 0.05",breaks= seq(-0.5, by = 1, length.out = max(degree(g2))+2))
plot(degree.distribution(g2),type="o",main="p = 0.05")
print(con2)
print(dia2)

d=degree(g2)
for(i in 1:99){
  g=random.graph.game(1000,0.05,directed=F)
  d=c(d,degree(g))
}
h=hist(d,main="p = 0.05 over 100 graphs", freq = F, breaks= seq(-0.5, by = 1, length.out = max(d)+2))
pl <- data.frame(x=h$mids, y=h$density)
plot(pl , type="o",main="p = 0.05 over 100 graphs")

g3=random.graph.game(1000,0.1,directed=F)
#plot(g3)
con3=is.connected(g3)
dia3=diameter(g3)
hist(degree(g3),main="p = 0.1",freq=F,breaks= seq(-0.5, by = 1, length.out = max(degree(g3))+2))
plot(degree.distribution(g3),type="o",main="p = 0.1")
print(con3)
print(dia3)

d=degree(g3)
for(i in 1:99){
  g=random.graph.game(1000,0.1,directed=F)
  d=c(d,degree(g))
}
h=hist(d,main="p = 0.1 over 100 graphs", freq = F, breaks= seq(-0.5, by = 1, length.out = max(d)+2))
pl <- data.frame(x=h$mids, y=h$density)
plot(pl , type="o",main="p = 0.1 over 100 graphs")


m1=1
m2=-1
for(j in 1:100)
{
  for ( i in 1:10000)
  {
    p=i/10000
    g=random.graph.game(1000,p,directed=F)
    if(is.connected(g))
    {
      #print(p)
      m1=min(m1,p)
      m2=max(m2,p)
      break
    }
  
  }
}
print(m1)
print(m2)

