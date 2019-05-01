library(igraph)

g<-read.graph("gwdwd.txt",format="ncol",directed=F)

d$Movie[which(d$Id==101943)]

g <- movies.network

min.id <- d$Id[which(d$Movie=="Mission:Impossible-RogueNation(2015)(uncredited)")]
min.id <- which(V(g)$name=="172401")

min.neigh <- E(g)[from(min.id)]
min.neigh.wt <- E(g)$weight[E(g)[from(min.id)]]

ij <- which(min.neigh.wt >= sort(min.neigh.wt, decreasing=T)[5], arr.ind=TRUE)

E(g)[as.numeric(min.neigh)[ij]]
# min.neigh <- as.numeric(min.neigh)

n.min.neigh.wt <- min.neigh.wt[ij]
n.min.neigh.id <- c(23770,74685,93885,112474,258990,328208,344408)
n.min.neigh.names <- V(g)$name[95010]


d$Movie[which(d$Id=="412248")]
# Minions(2015) - 200866 - 1
#[1] "Up(2009)(voice)"                             "InsideOut(2015)(voice)"                     
#[3] "Surf'sUp(2007)(voice)"                       "GakenouenoPonyo(2008)(voice:Englishversion)"
#[5] "TheLorax(2012)(voice)" 
# "WALLE(2008)(voice)"
#[1] "FeetFirst(1989)" "SoakedtotheBone(1989)" "Enemates1(1988)" 
#"GirlsofTreasureIsland(1988)" "Fatliners(1990)"

#[1] 0.2592593 0.2758621 0.2571429 0.2352941 0.3030303
#[1] 0.2142857 0.1818182 0.2000000 0.2000000 0.1666667

#Batman - 7953 - 1
# [1] "Eloise(2015)(uncredited)" [2] "TheJusticeLeaguePartOne(2017)"
# [3] "ManofSteel(2013)" [4] "HomeAgain(2015)"
# [5] "TheDouble(2011/I)"
# [1] 0.1111111 0.1538462 0.1176471 0.4444444 0.1176471
#[1] 0.11111111 0.06250000 0.06666667 0.06250000 0.06250000 0.11764706 0.06666667

#Mission Impossible - 1
#[1] "AngelMakers(2010){{SUSPENDED}}"                  "Phantom(2015)"                      
#[3] "Fan(2015)"                           "DerHimmelkannwarten(2000)"
#[5] "NowYouSeeMe:TheSecondAct(2016)" 
"TheMummyReturns(2001)(uncredited)"
"Phantom(2015)"
"TheWomaninBlack2:AngelofDeath(2014)(uncredited)"

# [1] "Paglipadnganghel(2011)" "Araw-araw,gabi-gabi(1995)" "TheDiplomatHotel(2013)"  
# "Bakitlabiskitangmahal(1992)" "BahayniLola2(2005)" 
# "SlumberParty(2012/II)"  "Sanadalawaangpusoko(1995)"

# [1] 0.08955224 0.09411765 0.12987013 0.08800000 0.09876543
#[1] 0.06896552 0.06896552 0.07692308 0.06896552 0.07894737 0.07407407 0.07407407