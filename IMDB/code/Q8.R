

rating = read.table("rating.txt", sep="\t", encoding="ISO-8859-1", comment.char = "")

colnames(rating) <- c("Movie","rating")
rating$Movie <- as.character(rating$Movie)

train.data <- matrix(0,nrow=vcount(movies.network),ncol=6)

count=1
for (name in as.numeric(V(movies.network)))
{
  movie.name <- d$Movie[which(d$Id==name)]
  if(length(which(rating$Movie==movie.name))>0)
  {
    # Get the rating of this movie if it exists
    train.data[count,6] <- rating$rating[which(rating$Movie==movie.name)]
    
    # Get its top 5 neighbours
    # If Movie1 = name
    mov1.nw <- movies.edgelist.file[which(movies.edgelist.file$Movie1==name),c(3,2)]
    colnames(mov1.nw) <- c("wt","movie")
    
    # If Movie2 = name
    mov2.nw <- movies.edgelist.file[which(movies.edgelist.file$Movie2==name),c(3,1)]
    colnames(mov2.nw) <- c("wt","movie")
    
    # Combine these two
    mov.wt <- merge(mov1.nw,mov2.nw)
    
    top.movies <- mov.wt[(length(mov.wt[,1])-4):length(mov.wt[,1]),2]
    
    top.mnames <- d$Movie[which(d$Id %in% top.movies)]
    
    mct <- 1
    for(m in top.mnames)
    {
      if(length(which(rating$Movie==m))>0)
         train.data[count,mct] <- rating$rating[which(rating$Movie==m)]
      mct <- mct+1
    }
    # Get their ratings (if they exist?)
    
    count=count+1
  }
  print(count)
}

