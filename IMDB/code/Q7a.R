
comm.ratings <- rep(0, length(movies.network.communities))

count <- 1

for(count in 1:length(comm.ratings))
{
  mct <- 1
  
  mov.names <- as.numeric(movies.network.communities$names[which(movies.network.communities$membership==count)])
  
  rat = 0
  for(m in mov.names)
  {
    if(length(which(rating$Movie==m))>0)
    {
      mct <- mct+1
      rat = rat + rating$rating[which(rating$Movie==m)]
    }
  }
  comm.ratings[count] <- rat/(mct-1)
}