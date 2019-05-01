play(Position,Player,Result):- choose_move(Position,Player,Move),
                                move(Move,Position,Position1),display_game(Position1,Player),
                                nextplayer(Player,Player1), ! , play(Position1,Player1,Result).

play(Position,Player,Result):- game_over(Position,Player,Result), ! , announce(Result).

playGame(_):- init(Position),setplayer(Player),display_game(Position,Player),play(Position,Player,-1).


%position is the current contents of the board 
%Move is in the form of ((a,i,j) ,(b,i1,j1) ).

/*choose-move*/
choose_move(Position,1,Move):- read_input(Move),legal(Position,Move,1).
choose_move(Position,1,Move):-print('Please enter a valid move'),nl,choose_move(Position,1,Move).

choose_move(Position,2,Move):- read_input(Move),legal(Position,Move,2).         
choose_move(Position,2,Move):-print('Please enter a valid move'),nl,choose_move(Position,2,Move).

%choose_move(Position,2,Move):- makerandom(Position,Move),print(Move),nl,legal(Position,Move,2).
%choose_move(Position,2,Move):- choose_move(Position,2,Move).
:- use_module(library(random)).

geninit(L):- L= [[a],[b],[c],[d],[e],[f],[g],[h],[i],[j],[k]].
makerandom(Position,R):- random(1,11,B),random(1,12,I),random(1,12,J),random(1,11,B1),random(1,12,I1),random(1,12,J1),geninit(L),genfroml(L,B,1,A),genfroml(L,B1,1,A1),X1=(A,I,J),X2=(A1,I1,J1),R=[X1|X2].

genfroml(L,B,Count,A):- L=[X|Y],Count=B,X=[T|_],A=T.
genfroml(L,B,Count,A):- L=[X|Y],Count1 is Count+1,genfroml(Y,B,Count1,A).




/*announce result*/
announce(Result):- Result=1, write('Player 1 wins').
announce(Result):- Result=2, write('Player 2 wins').
announce(Result):- Result=0, write('Stalemate').
announce(Result):- Result = -1.

/*display_game*/
display_game(Position,Player):- write(Position),nl,write(Player),nl.


/*initialising position,player*/
/*setplayer(Player):- Player=1.*/
init4(Position):- Position = [(a,1,6),(-1,-1),(a,2,7),(-1,-1),(a,3,8),(-1,-1),(a,4,9),(-1,-1),(a,5,10),(-1,-1),(a,6,11),(-1,-1),
                               (b,1,5),(-1,-1),(b,2,6),(-1,-1),(b,3,7),(-1,-1),(b,4,8),(-1,-1),(b,5,9),(-1,-1),(b,6,10),(-1,-1),(b,7,11),(-1,-1) 
                               ,(c,1,4),(p,1),(c,2,5),(-1,-1),(c,3,6),(-1,-1),(c,4,7),(-1,-1),(c,5,8),(-1,-1),(c,6,9),(-1,-1),(c,7,10),(-1,-1),(c,8,11),(p,2),
                    (d,1,3),(r,1),(d,2,4),(p,1),(d,3,5),(-1,-1),(d,4,6),(-1,-1),(d,5,7),(-1,-1),(d,6,8),(-1,-1),(d,7,9),(-1,-1),(d,8,10),(p,2),(d,9,11),(r,2),
(e,1,2),(q,1),(e,2,3),(h,1),(e,3,4),(p,1),(e,4,5),(-1,-1),(e,5,6),(-1,-1),(e,6,7),(-1,-1),(e,7,8),(-1,-1),(e,8,9),(p,2),(e,9,10),(h,2),(e,10,11),(q,2),
 
(f,1,1),(b,1),
(f,2,2),(b,1),(f,3,3),(b,1),(f,4,4),(p,1),(f,5,5),(-1,-1),(f,6,6),(-1,-1),(f,7,7),(-1,-1),(f,8,8),(p,2),(f,9,9),(b,2),(f,10,10),(b,2),(f,11,11),(b,2),          

(k,6,1),(-1,-1),(k,7,2),(-1,-1),(k,8,3),(-1,-1),(k,9,4),(-1,-1),(k,10,5),(-1,-1),(k,11,6),(-1,-1),
                               (j,5,1),(-1,-1),(j,6,2),(-1,-1),(j,7,3),(-1,-1),(j,8,4),(-1,-1),(j,9,5),(-1,-1),(j,10,6),(-1,-1),(j,11,7),(-1,-1) 
                               ,(i,4,1),(-p,1),(i,5,2),(-1,-1),(i,6,3),(-1,-1),(i,7,4),(-1,-1),(i,8,5),(-1,-1),(i,9,6),(-1,-1),(i,10,7),(-1,-1),(i,11,8),(p,2),
                    (h,3,1),(r,1),(h,4,2),(p,1),(h,5,3),(-1,-1),(h,6,4),(-1,-1),(h,7,5),(-1,-1),(h,8,6),(-1,-1),(h,9,7),(-1,-1),(h,10,8),(p,2),(h,11,9),(r,2),
(g,2,1),(k,1),(g,3,2),(h,1),(g,4,3),(p,1),(g,5,4),(-1,-1),(g,6,5),(-1,-1),(g,7,6),(-1,-1),(g,8,7),(-1,-1),(g,9,8),(p,2),(g,10,9),(h,2),(g,11,10),(k,2) ].



/*next player*/
nextplayer(Player,Player1):- Player=1,Player1 = 2.
nextplayer(Player,Player1):- Player=2,Player1 = 1.

/*make-move*/
move(Move,Pos1,Pos2):- Move = [X,Y], getpcX(X,Pos1,Ans), replaceY(Y,Ans,Pos1,Posi),replaceX(X,Posi,Pos2).
% getpcX gets the (piece,colour) pair associated with X in the original position Pos1. it gets stored in Ans.
% replaceY changes the (piece,colour) of Y in Pos1 to Ans and gets to stage Posi.
% replaceX changes the (piece,colour) of X in Posi to null and gets to stage Pos2 which is the required output.

getpcX(X,Pos1,Ans):- Pos1  = [X|T1] , T1 = [Y|T] , Ans = Y.
getpcX(X,Pos1,Ans):- Pos1 = [Y|T] , getpcX(X,T,Ans).

replaceY(Y,Ans,Pos1,Posi):-Pos1=[Y|T1] ,T1 = [Z|T],T2 = [Ans|T] , Posi = [Y|T2].
replaceY(Y,Ans,[Z|T1],[Z|Posi]):- replaceY(Y,Ans,T1,Posi). 

replaceX(X,Pos1,Posi):-Pos1=[X|T1] ,T1 = [Z|T],T2 = [(-1,-1)|T] , Posi = [X|T2].
replaceX(X,[Z|T1],[Z|Posi]):- replaceX(X,T1,Posi).

/* legality*/

legal1(Position,M):- 
ch1(Moves):- init4(Position),setof(M,legal1(Position,M),Moves).

/*change it so that point4 is also added*/
legal(Position,[(A1,I1,J1),(A2,I2,J2)],Player):-
        X=[A1,I1,J1],Y=[A2,I2,J2],
        valid(X),valid(Y),
        getpcX1((A1,I1,J1),Position,X1),
        getpcX1((A2,I2,J2),Position,Y1),
        checkx1(X1,Player),
        checky1(Y1,Player),
        X1=(P1,C1),
        Y1=(P2,C2),
        legalMoveCheck(Position,(A1,I1,J1),(A2,I2,J2),(P1,C1),(P2,C2)),
        move([(A1,I1,J1),(A2,I2,J2)],Position,Position1),!,
        kingCheck(Position1,C1,Result),!,
        Result=:=0.

legalMoveCheck(Position,X,Y,(P1,C1),(P2,-1)):-
        createMoves(100,Position,X,(P1,C1),Moves,-1),
        member(Y,Moves).
legalMoveCheck(Position,X,Y,(P1,C1),(P2,C2)):-
        createMoves(1,Position,X,(P1,C1),Moves,-1),
        member(Y,Moves).

/*get kings cell*/
kingCheck(Position,Colour,Result):-
        getKingX1(Position,Colour,Cell),
        attack(Position,Position,Cell,[k,Colour],Result).


valid([A|B]):- B=[I,J],A=f,I=J,I>0,I<12.

valid([A|B]):- B=[I,J],A=e,I=:=J-1,J>0,J<12.

valid([A|B]):- B=[I,J],A=d,I=:=J-2,J>0,J<12.

valid([A|B]):- B=[I,J],A=c,I=:=J-3,J>0,J<12.

valid([A|B]):- B=[I,J],A=b,I=:=J-4,J>0,J<12.

valid([A|B]):- B=[I,J],A=a,I=:=J-5,J>0,J<12.

valid([A|B]):- B=[I,J],A=g,J=:=I-1,I>0,I<12.

valid([A|B]):- B=[I,J],A=h,J=:=I-2,I>0,I<12.

valid([A|B]):- B=[I,J],A=i,J=:=I-3,I>0,I<12.

valid([A|B]):- B=[I,J],A=j,J=:=I-4,I>0,I<12.

valid([A|B]):- B=[I,J],A=k,J=:=I-5,I>0,I<12.


getpcX1(X,Pos1,Ans):- Pos1  = [X|T1] , T1 = [Y|T] , Ans = Y.
getpcX1(X,Pos1,Ans):- Pos1 = [Y|T] , getpcX1(X,T,Ans).


checkx1((P,C),Player):- C=:=Player.

checky1((P,C),Player):- C=\=Player.


/* add read_input(), and gameover() functions.*/
/*remove this after adding ai*/
callgo(P,Result):-init(Position),game_over(Position,P,Result).
game_over(Position,P,Result):-
        kingCheck(Position,P,Result_),
        Result_=:=1,
        getKingX1(Position,P,Cell),
        createMoves(1,Position,Cell,(k,P),Moves,-1),
        checkMate(Position,Cell,Moves,P,Result).
game_over(_,_,0).

checkMate(Position,Cell,[M|Moves],P,Result):-
        move([Cell,M],Position,Position1),!,
        kingCheck(Position1,P,Result_),Result_=:=1,!,
        checkMate(Position,Cell,Moves,P,Result).
checkMate(_,_,[],P,Result):-nextplayer(P,P1),Result=P1.
checkMate(_,_,M,_,0).
read_input(Move):- read(Move).
/*gets king's position*/
getKingX1([X,(k,Colour)|Position],Colour,Cell):-
        Cell=X.
getKingX1([_,_|Position],Colour,Cell):-getKingX1(Position,Colour,Cell).

