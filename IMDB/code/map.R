
d = read.table("mapping.txt", sep="\t", encoding="ISO-8859-1", comment.char = "")

comm.with.id <- data.frame(cbind(movies.network.communities$membership, movies.network.communities$names))
colnames(comm.with.id) <- c("Comm","Id")

comm.with.id$Comm <- as.character(comm.with.id$Comm)
comm.with.id$Id <- as.numeric(comm.with.id$Id)

colnames(d) <- c("Movie", "Id")
d$Movie <- as.character(d$Movie)
d$Id <- as.numeric(d$Id)

comm.with.id$name = d$Movie[which(d$Id==comm.with.id$Id)]

movies <- c(rep("",length(comm.with.id[,1])))

i=1
for (id in comm.with.id$Id)
{
  id
  if(length(d$Movie[which(d$Id==id)])==0)
  {
    print("next")
  }
  else
  {
    movies[i] <- d$Movie[which(d$Id==id)]
  }
  i = i+1
}

comm.with.id$Comm = as.numeric(comm.with.id$Comm)

write.table(comm.with.id, file="commid.txt", sep="\t", row.names = F, col.names = F)
