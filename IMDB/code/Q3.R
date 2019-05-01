library(igraph)

g<-read.graph("temp3.txt",format="ncol",directed=T)

lpg<-page.rank(g)
sort(unlist(lpg$vector),decreasing=TRUE)[1:11]


# Flowers,Bess   Harris,Sam(II)       Jeremy,Ron  Tatasciore,Fred Miller,Harold(I)   Lowenthal,Yuri 
# 1.602309e-04     1.391398e-04     1.302379e-04     1.219430e-04     1.217791e-04     1.152357e-04 
# Roberts,Eric(I)    Phelps,Lee(I)    Sayre,Jeffrey  Farnum,Franklyn     Steers,Larry 
# 1.070096e-04     1.015716e-04     1.006471e-04     9.938589e-05     9.518335e-05 

pr.act <- cbind(round(lpg$vector,digits = 6), rownames(lpg$vector))

write.table(pr.act, "PrActors.txt", sep='\t\t')

a1 <- which(V(g)$name=="Jolie,Angelina")

a2 <- which(V(g)$name=="Cruise,Tom")

E(g)[a1 %--% a2]$weight

summary(E(g)$weight)

E(g)[which.min(E(g)$weight)]