check(X,Y):- initi(X), !,gen(Y).

initi(X):- not(X=1).
gen(Y):- Y=2.

gennmax(X):- not(initi(X)).

bc(A,B):- B>A,B<5.


ch(Moves):- setof(M,bc(2,M),Moves).
