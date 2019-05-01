library(igraph)

test.data <- matrix(0,3,11)

test.movies <- c("Minions(2015)(voice)", "BatmanvSuperman:DawnofJustice(2016)","Mission:Impossible-RogueNation(2015)")

count <- 1

for(m in test.movies)
{
  name <- d$Id[which(d$Movie==m)]
  mov1.nw <- movies.edgelist.file[which(movies.edgelist.file$Movie1==name),c(3,2)]
  colnames(mov1.nw) <- c("wt","movie")
  
  # If Movie2 = name
  mov2.nw <- movies.edgelist.file[which(movies.edgelist.file$Movie2==name),c(3,1)]
  colnames(mov2.nw) <- c("wt","movie")
  
  # Combine these two
  mov.wt <- merge(mov1.nw,mov2.nw,sort=T,all=T)
  
  mct <- 1
  for(m1 in rev(mov.wt[,2]))
  {
    if(which(d$Id==m1)>0){
      mname <- d$Movie[which(d$Id==m1)]
      if(length(which(rating$Movie==mname))>0)
      {
        test.data[count,mct] <- rating$rating[which(rating$Movie==mname)]
        mct <- mct + 1
      }
      if(mct>10)
        break
    }
  }
  
  # Add avg rating of community
  com <- movies.network.communities$membership[which(as.numeric(movies.network.communities$names)==name)]
  test.data[count,11] = comm.ratings[com]
  
  count=count+1
  print(count)
}

test.data <- data.frame(test.data)

colnames(test.data) <- c("R1","R2","R3","R4","R5","R6","R7","R8","R9","R10","CR")

pred.ratings <- predict(lm.mov, test.data)
                        