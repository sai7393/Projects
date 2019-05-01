initialise(Game,Position,Player):- init(Position),setplayer(Player),move([(a,1,6)|(a,2,7)],Position,Position1).
%change the second parameter of initialise to Position1 if you want to display the final Position1 in the prompt.
% finally that wont matter because we will be using announce() to annouce the result, and displaying board after each step.


%everywhere 1 is white, 2 is black
%piece is denoted using : 'p' for pawn,'k' for king, 'r' for rook, 'b' for bishop, 'h' for knight/horse, 'q' for queen.
setplayer(Player):- Player=1.
init(Position):- Position = [(a,1,6),(-1,-1),(a,2,7),(-1,-1),(a,3,8),(-1,-1),(a,4,9),(-1,-1),(a,5,10),(-1,-1),(a,6,11),(-1,-1),
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

nextplayer(Player,Player1):- Player=1,Player1 = 2.
nextplayer(Player,Player1):- Player=2,Player1 = 1.


move(Move,Pos1,Pos2):- Move = [X|Y], getpcX(X,Pos1,Ans), replaceY(Y,Ans,Pos1,Posi),replaceX(X,Posi,Pos2).
% getpcX gets the (piece,colour) pair associated with X in the original position Pos1. it gets stored in Ans.
% replaceY changes the (piece,colour) of Y in Pos1 to Ans and gets to stage Posi.
% replaceX changes the (piece,colour) of X in Posi to null and gets to stage Pos2 which is the required output.

getpcX(X,Pos1,Ans):- Pos1  = [X|T1] , T1 = [Y|T] , Ans = Y.
getpcX(X,Pos1,Ans):- Pos1 = [Y|T] , getpcX(X,T,Ans).

replaceY(Y,Ans,Pos1,Posi):-Pos1=[Y|T1] ,T1 = [Z|T],T2 = [Ans|T] , Posi = [Y|T2].
replaceY(Y,Ans,[Z|T1],[Z|Posi]):- replaceY(Y,Ans,T1,Posi). 

replaceX(X,Pos1,Posi):-Pos1=[X|T1] ,T1 = [Z|T],T2 = [(-1,-1)|T] , Posi = [X|T2].
replaceX(X,[Z|T1],[Z|Posi]):- replaceX(X,T1,Posi).


/* my funcs start here */

init8(Position):- Position = [[a,1,6],[-1,-1],[a,2,7],[-1,-1],[a,3,8],[-1,-1],[a,4,9],[-1,-1],[a,5,10],[-1,-1],[a,6,11],[-1,-1],
                               [b,1,5],[-1,-1],[b,2,6],[-1,-1],[b,3,7],[-1,-1],[b,4,8],[-1,-1],[b,5,9],[-1,-1],[b,6,10],[-1,-1],[b,7,11],[-1,-1] 
                               ,[c,1,4],[p,1],[c,2,5],[-1,-1],[c,3,6],[-1,-1],[c,4,7],[-1,-1],[c,5,8],[-1,-1],[c,6,9],[-1,-1],[c,7,10],[-1,-1],[c,8,11],[p,2],
                    [d,1,3],[r,1],[d,2,4],[p,1],[d,3,5],[-1,-1],[d,4,6],[-1,-1],[d,5,7],[-1,-1],[d,6,8],[-1,-1],[d,7,9],[-1,-1],[d,8,10],[p,2],[d,9,11],[r,2],
[e,1,2],[q,1],[e,2,3],[h,1],[e,3,4],[p,1],[e,4,5],[-1,-1],[e,5,6],[-1,-1],[e,6,7],[-1,-1],[e,7,8],[-1,-1],[e,8,9],[p,2],[e,9,10],[h,2],[e,10,11],[q,2],
 
[f,1,1],[b,1],
[f,2,2],[b,1],[f,3,3],[b,1],[f,4,4],[p,1],[f,5,5],[-1,-1],[f,6,6],[-1,-1],[f,7,7],[-1,-1],[f,8,8],[p,2],[f,9,9],[b,2],[f,10,10],[b,2],[f,11,11],[b,2],          

[k,6,1],[-1,-1],[k,7,2],[-1,-1],[k,8,3],[-1,-1],[k,9,4],[-1,-1],[k,10,5],[-1,-1],[k,11,6],[-1,-1],
                               [j,5,1],[-1,-1],[j,6,2],[-1,-1],[j,7,3],[-1,-1],[j,8,4],[-1,-1],[j,9,5],[-1,-1],[j,10,6],[-1,-1],[j,11,7],[-1,-1] 
                               ,[i,4,1],[-p,1],[i,5,2],[-1,-1],[i,6,3],[-1,-1],[i,7,4],[-1,-1],[i,8,5],[-1,-1],[i,9,6],[-1,-1],[i,10,7],[-1,-1],[i,11,8],[p,2],
                    [h,3,1],[r,1],[h,4,2],[p,1],[h,5,3],[-1,-1],[h,6,4],[-1,-1],[h,7,5],[-1,-1],[h,8,6],[-1,-1],[h,9,7],[-1,-1],[h,10,8],[p,2],[h,11,9],[r,2],
[g,2,1],[k,1],[g,3,2],[h,1],[g,4,3],[p,1],[g,5,4],[-1,-1],[g,6,5],[-1,-1],[g,7,6],[-1,-1],[g,8,7],[-1,-1],[g,9,8],[p,2],[g,10,9],[h,2],[g,11,10],[k,2]].


/* first line is for two humans. next line if its ai.*/


ai(M):- init8(P),choose_move(P,2,M).

choose_move(Position,2,Move):- read_input(Move),!,legal(Position,Move).         

choose_move(Position,2,Move):- makeattackking(Position,Move), legal(Position,Move).

choose_move(Position,2,Move):- makeattackqueen(Position,Move), legal(Position,Move).
choose_move(Position,2,Move):- makeattackrook(Position,Move), legal(Position,Move).
choose_move(Position,2,Move):- makeattackknight(Position,Move), legal(Position,Move).
choose_move(Position,2,Move):- makeattackbishop(Position,Move), legal(Position,Move).


choose_move(Position,2,Move):- makerandom(Position,Move), legal(Position,Move).

:- use_module(library(random)).



geninit(L):- L= [[a],[b],[c],[d],[e],[f],[g],[h],[i],[j],[k]].

makeattackking(Position,R):- random(1,11,B),random(1,12,I),random(1,12,J),random(1,11,B1),random(1,12,I1),random(1,12,J1),geninit(L),genfroml(L,B,1,A),genfroml(L,B1,1,A1),X1=(A,I,J),X2=(A1,I1,J1),getpcX(X2,Position,Ans),Ans=[(k,1)|_],R=[X1|X2].

makeattackqueen(Position,R):- random(1,11,B),random(1,12,I),random(1,12,J),random(1,11,B1),random(1,12,I1),random(1,12,J1),geninit(L),genfroml(L,B,1,A),genfroml(L,B1,1,A1),X1=(A,I,J),X2=(A1,I1,J1),getpcX(X2,Position,Ans),Ans=[(q,1)|_],R=[X1|X2].

makeattackrook(Position,R):- random(1,11,B),random(1,12,I),random(1,12,J),random(1,11,B1),random(1,12,I1),random(1,12,J1),geninit(L),genfroml(L,B,1,A),genfroml(L,B1,1,A1),X1=(A,I,J),X2=(A1,I1,J1),getpcX(X2,Position,Ans),Ans=[(r,1)|_],R=[X1|X2].

makeattackknight(Position,R):- random(1,11,B),random(1,12,I),random(1,12,J),random(1,11,B1),random(1,12,I1),random(1,12,J1),geninit(L),genfroml(L,B,1,A),genfroml(L,B1,1,A1),X1=(A,I,J),X2=(A1,I1,J1),getpcX(X2,Position,Ans),Ans=[(h,1)|_],R=[X1|X2].

makeattackbishop(Position,R):- random(1,11,B),random(1,12,I),random(1,12,J),random(1,11,B1),random(1,12,I1),random(1,12,J1),geninit(L),genfroml(L,B,1,A),genfroml(L,B1,1,A1),X1=(A,I,J),X2=(A1,I1,J1),getpcX(X2,Position,Ans),Ans=[(b,1)|_],R=[X1|X2].






makerandom(Position,R):- random(1,11,B),random(1,12,I),random(1,12,J),random(1,11,B1),random(1,12,I1),random(1,12,J1),geninit(L),genfroml(L,B,1,A),genfroml(L,B1,1,A1),X1=(A,I,J),X2=(A1,I1,J1),R=[X1|X2].

genfroml(L,B,Count,A):- L=[X|Y],Count=B,X=[T|_],A=T.
genfroml(L,B,Count,A):- L=[X|Y],Count1 is Count+1,genfroml(Y,B,Count1,A).














/*ends here*/


/*the next two lines don't bother*/
%callAttack(Cell,P,Result):- init(Position),P=(Piece,Colour),attack(Position,Position,Cell,[Piece,Colour],Result).
%callAttack(Cell,P,Moves,Result):- init(Position),P=(Piece,Colour),createMoves(Position,Cell,(Piece,Colour),Moves,-1),!.

/*attack function and related functions start from here*/
%attack tells whether the current cell is under attack or not
attack([],_,_,_,Result):- Result = 0.
attack([_,(_,Colour)|Pieces],Position,Cell,[Piece,Colour],Result):- attack(Pieces,Position,Cell,[Piece,Colour],Result).
attack([_,(_,-1)|Pieces],Position,Cell,[Piece,Colour],Result):- attack(Pieces,Position,Cell,[Piece,Colour],Result).
attack([X,(Y,Colour_)|Pieces],Position,Cell,[Piece,Colour],Result):-createMoves(Position,X,(Y,Colour_),Moves,-1),member(Cell,Moves),print(X),nl,print(Y),nl,Result = 1.
attack([X,(Y,Colour_)|Pieces],Position,Cell,[Piece,Colour],Result):-attack(Pieces,Position,Cell,[Piece,Colour],Result).

test(Result,X):-X=Y,Result=X,Result=:=Y.
test(Result):-Result=3.

/*now begins the functions for creating possible moves for a given a piece on the board*/
createMoves(Position,Cell,(r,Colour),Moves,Steps):-
	rook_First(Position,Colour,Cell,X_,Steps),
	rook_First_(Position,Colour,Cell,Y_,Steps),
	rook_Sec(Position,Colour,Cell,Z_,Steps),
	rook_Sec_(Position,Colour,Cell,A_,Steps),
	rook_Third(Position,Colour,Cell,B_,Steps),
	rook_Third_(Position,Colour,Cell,C_,Steps),
	append(X_,Y_,X1),
	append(Z_,A_,Y1),
	append(B_,C_,Z1),
	append(X1,Y1,X2),
	append(X2,Z1,Moves),!.
createMoves(Position,Cell,(b,Colour),Moves,Steps):-
	bishopFirst(Position,Colour,Cell,X_,Steps),
	select(Cell,X_,X),
	bishopFirst_(Position,Colour,Cell,Y_,Steps),
	select(Cell,Y_,Y),
	bishopSec(Position,Colour,Cell,Z_,Steps),
	select(Cell,Z_,Z),
	bishopSec_(Position,Colour,Cell,A_,Steps),
	select(Cell,A_,A),
	bishopThird(Position,Colour,Cell,B_,Steps),
	select(Cell,B_,B),
	bishopThird_(Position,Colour,Cell,C_,Steps),
	select(Cell,C_,C),
	append(X,Y,X1),
	append(Z,A,Y1),
	append(B,C,Z1),
	append(X1,Y1,X2),
	append(X2,Z1,Moves),!.
createMoves(Position,Cell,(q,Colour),Moves,Steps):-
	createMoves(Position,Cell,(r,Colour),X,Steps),
	createMoves(Position,Cell,(b,Colour),Y,Steps),
	append(X,Y,Moves),!.
createMoves(Position,Cell,(k,Colour),Moves,Steps):-
	createMoves(Position,Cell,(q,Colour),Moves,1),!.
createMoves(Position,Cell,(h,Colour),Moves,Steps):-
        Moves_ = [H|T],
	knightOne(Position,Colour,Cell,H),
	T=[H1|T1],
	knightTwo(Position,Colour,Cell,H1),
	T1=[H2|T2],
	knightThird(Position,Colour,Cell,H2),
	T2=[H3|T3],
	knightFour(Position,Colour,Cell,H3),
	T3=[H4|T4],
	knightFive(Position,Colour,Cell,H4),
	T4=[H5|T5],
	knightSix(Position,Colour,Cell,H5),
	T5=[H6|T6],
	knightSeven(Position,Colour,Cell,H6),
	T6=[H7|T7],
	knightEight(Position,Colour,Cell,H7),
	T7=[H8|T8],
	knightNine(Position,Colour,Cell,H8),
	T8=[H9|T9],
	knightTen(Position,Colour,Cell,H9),
	T9=[H10,T10],
	knightEle(Position,Colour,Cell,H10),
	knightTwe(Position,Colour,Cell,T10),
	cleanList(Moves_,Moves),!.
createMoves(Position,Cell,(p,1),Moves,Steps):-
        bishopFirst(Position,1,Cell,H,1),
	select(Cell,H,H_),
        bishopThird(Position,1,Cell,T,1),
	select(Cell,T,T_),
        append(H_,T_,Moves),!.
createMoves(Position,Cell,(p,2),Moves,Steps):-
        bishopSec_(Position,2,Cell,H,1),
	select(Cell,H,H_),
        bishopThird_(Position,2,Cell,T,1),
	select(Cell,T,T_),
        append(H_,T_,Moves),!.

/*knight moves*/
knightOne(Position,Colour,(A,I,J),[]):-char_code(A,_A),A__ is _A-1,char_code(A_,A__),I_ is I+2, J_ is J+3,checkCell(Position,(A_,I_,J_),Result),Result =:= Colour.
knightOne(Position,Colour,(A,I,J),M):-char_code(A,_A),A__ is _A-1,char_code(A_,A__),I_ is I+2, J_ is J+3,checkCell(Position,(A_,I_,J_),Result),M=(A_,I_,J_).
knightOne(_,_,_,[]).

knightTwo(Position,Colour,(A,I,J),[]):-char_code(A,_A),A__ is _A-2,char_code(A_,A__),I_ is I+1, J_ is J+3,checkCell(Position,(A_,I_,J_),Result),Result =:= Colour.
knightTwo(Position,Colour,(A,I,J),M):-char_code(A,_A),A__ is _A-2,char_code(A_,A__),I_ is I+1, J_ is J+3,checkCell(Position,(A_,I_,J_),Result),M=(A_,I_,J_).
knightTwo(_,_,_,[]).

knightThird(Position,Colour,(A,I,J),[]):-char_code(A,_A),A__ is _A-3,char_code(A_,A__),I_ is I-1, J_ is J+2,checkCell(Position,(A_,I_,J_),Result),Result =:= Colour.
knightThird(Position,Colour,(A,I,J),M):-char_code(A,_A),A__ is _A-3,char_code(A_,A__),I_ is I-1, J_ is J+2,checkCell(Position,(A_,I_,J_),Result),M=(A_,I_,J_).
knightThird(_,_,_,[]).

knightFour(Position,Colour,(A,I,J),[]):-char_code(A,_A),A__ is _A-3,char_code(A_,A__),I_ is I-2, J_ is J+1,checkCell(Position,(A_,I_,J_),Result),Result =:= Colour.
knightFour(Position,Colour,(A,I,J),M):-char_code(A,_A),A__ is _A-3,char_code(A_,A__),I_ is I-2, J_ is J+1,checkCell(Position,(A_,I_,J_),Result),M=(A_,I_,J_).
knightFour(_,_,_,[]).

knightFive(Position,Colour,(A,I,J),[]):-char_code(A,_A),A__ is _A-2,char_code(A_,A__),I_ is I-3, J_ is J-1,checkCell(Position,(A_,I_,J_),Result),Result =:= Colour.
knightFive(Position,Colour,(A,I,J),M):-char_code(A,_A),A__ is _A-2,char_code(A_,A__),I_ is I-3, J_ is J-1,checkCell(Position,(A_,I_,J_),Result),M=(A_,I_,J_).
knightFive(_,_,_,[]).

knightSix(Position,Colour,(A,I,J),[]):-char_code(A,_A),A__ is _A-1,char_code(A_,A__),I_ is I-3, J_ is J-2,checkCell(Position,(A_,I_,J_),Result),Result =:= Colour.
knightSix(Position,Colour,(A,I,J),M):-char_code(A,_A),A__ is _A-1,char_code(A_,A__),I_ is I-3, J_ is J-2,checkCell(Position,(A_,I_,J_),Result),M=(A_,I_,J_).
knightSix(_,_,_,[]).

knightSeven(Position,Colour,(A,I,J),[]):-char_code(A,_A),A__ is _A+1,char_code(A_,A__),I_ is I-2, J_ is J-3,checkCell(Position,(A_,I_,J_),Result),Result =:= Colour.
knightSeven(Position,Colour,(A,I,J),M):-char_code(A,_A),A__ is _A+1,char_code(A_,A__),I_ is I-2, J_ is J-3,checkCell(Position,(A_,I_,J_),Result),M=(A_,I_,J_).
knightSeven(_,_,_,[]).

knightEight(Position,Colour,(A,I,J),[]):-char_code(A,_A),A__ is _A+2,char_code(A_,A__),I_ is I-1, J_ is J-3,checkCell(Position,(A_,I_,J_),Result),Result =:= Colour.
knightEight(Position,Colour,(A,I,J),M):-char_code(A,_A),A__ is _A+2,char_code(A_,A__),I_ is I-1, J_ is J-3,checkCell(Position,(A_,I_,J_),Result),M=(A_,I_,J_).
knightEight(_,_,_,[]).

knightNine(Position,Colour,(A,I,J),[]):-char_code(A,_A),A__ is _A+3,char_code(A_,A__),I_ is I+1, J_ is J-2,checkCell(Position,(A_,I_,J_),Result),Result =:= Colour.
knightNine(Position,Colour,(A,I,J),M):-char_code(A,_A),A__ is _A+3,char_code(A_,A__),I_ is I+1, J_ is J-2,checkCell(Position,(A_,I_,J_),Result),M=(A_,I_,J_).
knightNine(_,_,_,[]).

knightTen(Position,Colour,(A,I,J),[]):-char_code(A,_A),A__ is _A+3,char_code(A_,A__),I_ is I+2, J_ is J-1,checkCell(Position,(A_,I_,J_),Result),Result =:= Colour.
knightTen(Position,Colour,(A,I,J),M):-char_code(A,_A),A__ is _A+3,char_code(A_,A__),I_ is I+2, J_ is J-1,checkCell(Position,(A_,I_,J_),Result),M=(A_,I_,J_).
knightTen(_,_,_,[]).

knightEle(Position,Colour,(A,I,J),[]):-char_code(A,_A),A__ is _A+2,char_code(A_,A__),I_ is I+3, J_ is J+1,checkCell(Position,(A_,I_,J_),Result),Result =:= Colour.
knightEle(Position,Colour,(A,I,J),M):-char_code(A,_A),A__ is _A+2,char_code(A_,A__),I_ is I+3, J_ is J+1,checkCell(Position,(A_,I_,J_),Result),M=(A_,I_,J_).
knightEle(_,_,_,[]).

knightTwe(Position,Colour,(A,I,J),[]):-char_code(A,_A),A__ is _A+1,char_code(A_,A__),I_ is I+3, J_ is J+2,checkCell(Position,(A_,I_,J_),Result),Result =:= Colour.
knightTwe(Position,Colour,(A,I,J),M):-char_code(A,_A),A__ is _A+1,char_code(A_,A__),I_ is I+3, J_ is J+2,checkCell(Position,(A_,I_,J_),Result),M=(A_,I_,J_).
knightTwe(_,_,_,[]).

/*bishop moves*/
bishopFirst(_,_,X,[X],0).
bishopFirst(Position,Colour,(A,I,J),[(A,I,J)|M],Steps):- char_code(A,_A),A__ is _A-1,char_code(A_,A__),I_ is I+1, J_ is J+2,checkCell(Position,(A_,I_,J_),Result),Result =:= -1,Steps_ is Steps-1,bishopFirst(Position,Colour,(A_,I_,J_),M,Steps_).
bishopFirst(Position,Colour,(A,I,J),[(A,I,J)|M],Steps):- char_code(A,_A),A__ is _A-1,char_code(A_,A__),I_ is I+1, J_ is J+2,checkCell(Position,(A_,I_,J_),Result),changeColour(Colour,Result),bishopFirst(Position,Colour,(A_,I_,J_),M,0).
bishopFirst(Position,Colour,(A,I,J),[(A,I,J)],Steps):- char_code(A,_A),A__ is _A-1,char_code(A_,A__),I_ is I+1, J_ is J+2,checkCell(Position,(A_,I_,J_),Result),Result =:= Colour.
bishopFirst(_,_,X,[X],_).

bishopFirst_(_,_,X,[X],0).
bishopFirst_(Position,Colour,(A,I,J),[(A,I,J)|M],Steps):- char_code(A,_A),A__ is _A-2,char_code(A_,A__),I_ is I-1, J_ is J+1,checkCell(Position,(A_,I_,J_),Result),Result =:= -1,Steps_ is Steps-1,bishopFirst_(Position,Colour,(A_,I_,J_),M,Steps_).
bishopFirst_(Position,Colour,(A,I,J),[(A,I,J)|M],Steps):- char_code(A,_A),A__ is _A-2,char_code(A_,A__),I_ is I-1, J_ is J+1,checkCell(Position,(A_,I_,J_),Result),changeColour(Colour,Result),bishopFirst_(Position,Colour,(A_,I_,J_),M,0).
bishopFirst_(Position,Colour,(A,I,J),[(A,I,J)],Steps):- char_code(A,_A),A__ is _A-2,char_code(A_,A__),I_ is I-1, J_ is J+1,checkCell(Position,(A_,I_,J_),Result),Result =:= Colour.
bishopFirst_(_,_,X,[X],_).

bishopSec(_,_,X,[X],0).
bishopSec(Position,Colour,(A,I,J),[(A,I,J)|M],Steps):- char_code(A,_A),A__ is _A+2,I_ is I+1,char_code(A_,A__), J_ is J-1,checkCell(Position,(A_,I_,J_),Result),Result =:= -1,Steps_ is Steps-1,bishopSec(Position,Colour,(A_,I_,J_),M,Steps_).
bishopSec(Position,Colour,(A,I,J),[(A,I,J)|M],Steps):- char_code(A,_A),A__ is _A+2,I_ is I+1,char_code(A_,A__), J_ is J-1,checkCell(Position,(A_,I_,J_),Result),changeColour(Colour,Result),bishopSec(Position,Colour,(A_,I_,J_),M,0).
bishopSec(Position,Colour,(A,I,J),[(A,I,J)],Steps):- char_code(A,_A),A__ is _A+2,I_ is I+1,char_code(A_,A__), J_ is J-1,checkCell(Position,(A_,I_,J_),Result),Result =:= Colour.
bishopSec(_,_,X,[X],_).

bishopSec_(_,_,X,[X],0).
bishopSec_(Position,Colour,(A,I,J),[(A,I,J)|M],Steps):- char_code(A,_A),A__ is _A+1,char_code(A_,A__), J_ is J-2,I_ is I-1,checkCell(Position,(A_,I_,J_),Result),Result =:= -1,Steps_ is Steps-1,bishopSec_(Position,Colour,(A_,I_,J_),M,Steps_).
bishopSec_(Position,Colour,(A,I,J),[(A,I,J)|M],Steps):- char_code(A,_A),A__ is _A+1,char_code(A_,A__), J_ is J-2,I_ is I-1,checkCell(Position,(A_,I_,J_),Result),changeColour(Colour,Result),bishopSec_(Position,Colour,(A_,I_,J_),M,0).
bishopSec_(Position,Colour,(A,I,J),[(A,I,J)],Steps):- char_code(A,_A),A__ is _A+1,char_code(A_,A__), J_ is J-2,I_ is I-1,checkCell(Position,(A_,I_,J_),Result),Result =:= Colour.
bishopSec_(_,_,X,[X],_).

bishopThird(_,_,X,[X],0).
bishopThird(Position,Colour,(A,I,J),[(A,I,J)|M],Steps):- char_code(A,_A),A__ is _A+1,char_code(A_,A__), I_ is I+2,J_ is J+1,checkCell(Position,(A_,I_,J_),Result),Result =:= -1,Steps_ is Steps-1,bishopThird(Position,Colour,(A_,I_,J_),M,Steps_).
bishopThird(Position,Colour,(A,I,J),[(A,I,J)|M],Steps):- char_code(A,_A),A__ is _A+1,char_code(A_,A__), I_ is I+2,J_ is J+1,checkCell(Position,(A_,I_,J_),Result),changeColour(Colour,Result),bishopThird(Position,Colour,(A_,I_,J_),M,0).
bishopThird(Position,Colour,(A,I,J),[(A,I,J)],Steps):- char_code(A,_A),A__ is _A+1,char_code(A_,A__), I_ is I+2,J_ is J+1,checkCell(Position,(A_,I_,J_),Result),Result =:= Colour.
bishopThird(_,_,X,[X],_).

bishopThird_(_,_,X,[X],0).
bishopThird_(Position,Colour,(A,I,J),[(A,I,J)|M],Steps):- char_code(A,_A),A__ is _A-1,char_code(A_,A__), I_ is I-2,J_ is J-1,checkCell(Position,(A_,I_,J_),Result),Result =:= -1,Steps_ is Steps-1,bishopThird_(Position,Colour,(A_,I_,J_),M,Steps_).
bishopThird_(Position,Colour,(A,I,J),[(A,I,J)|M],Steps):- char_code(A,_A),A__ is _A-1,char_code(A_,A__), I_ is I-2,J_ is J-1,checkCell(Position,(A_,I_,J_),Result),changeColour(Colour,Result),bishopThird_(Position,Colour,(A_,I_,J_),M,0).
bishopThird_(Position,Colour,(A,I,J),[(A,I,J)],Steps):- char_code(A,_A),A__ is _A-1,char_code(A_,A__), I_ is I-2,J_ is J-1,checkCell(Position,(A_,I_,J_),Result),Result =:= Colour.
bishopThird_(_,_,X,[X],_).

/*rooks moves*/
rook_First(Position,Colour,(A,I,J),M,Steps):-I_ is I+1, J_ is J+1,checkCell(Position,(A,I_,J_),Result),rookFirst(Position,Colour,(A,I_,J_),M,Steps,Result).
rookFirst(_,_,X,[X],0,_).
rookFirst(Position,Colour,(A,I,J),[(A,I,J)|M],Steps,Result):- Result =:= -1,Steps_ is Steps-1,rook_First(Position,Colour,(A,I,J),M,Steps_).
rookFirst(Position,Colour,(A,I,J),[(A,I,J)],Steps,Result):- changeColour(Colour,Result).
rookFirst(_,Colour,_,[],_,Result):- Result =:= Colour.
rookFirst(_,_,X,[X],_,_).

rook_First_(Position,Colour,(A,I,J),M,Steps):-I_ is I-1, J_ is J-1,checkCell(Position,(A,I_,J_),Result),rookFirst_(Position,Colour,(A,I_,J_),M,Steps,Result).
rookFirst_(_,_,X,[X],0,_).
rookFirst_(Position,Colour,(A,I,J),[(A,I,J)|M],Steps,Result):- Result =:= -1,Steps_ is Steps-1,rook_First_(Position,Colour,(A,I,J),M,Steps_).
rookFirst_(Position,Colour,(A,I,J),[(A,I,J)],Steps,Result):- changeColour(Colour,Result).
rookFirst_(_,Colour,(A,I,J),[],_,Result):- Result =:= Colour.
rookFirst_(_,_,X,[X],_,_).

rook_Sec(Position,Colour,(A,I,J),M,Steps):- char_code(A,_A),A__ is _A+1,char_code(A_,A__), J_ is J-1,checkCell(Position,(A_,I,J_),Result),rookSec(Position,Colour,(A_,I,J_),M,Steps,Result).
rookSec(_,_,X,[X],0,_).
rookSec(Position,Colour,(A,I,J),[(A,I,J)|M],Steps,Result):-Result =:= -1,Steps_ is Steps-1,rook_Sec(Position,Colour,(A,I,J),M,Steps_).
rookSec(Position,Colour,(A,I,J),[(A,I,J)],Steps,Result):-changeColour(Colour,Result).
rookSec(_,Colour,(A,I,J),[],_,Result):-Result =:= Colour.
rookSec(_,_,X,[X],_,_).

rook_Sec_(Position,Colour,(A,I,J),M,Steps):- char_code(A,_A),A__ is _A-1,char_code(A_,A__), J_ is J+1,checkCell(Position,(A_,I,J_),Result),rookSec_(Position,Colour,(A_,I,J_),M,Steps,Result).
rookSec_(_,_,X,[X],0,_).
rookSec_(Position,Colour,(A,I,J),[(A,I,J)|M],Steps,Result):-Result =:= -1,Steps_ is Steps-1,rook_Sec_(Position,Colour,(A,I,J),M,Steps_).
rookSec_(Position,Colour,(A,I,J),[(A,I,J)],Steps,Result):-changeColour(Colour,Result).
rookSec_(_,Colour,(A,I,J),[],_,Result):-Result =:= Colour.
rookSec_(_,_,X,[X],_,_).

rook_Third(Position,Colour,(A,I,J),M,Steps):- char_code(A,_A),A__ is _A+1,char_code(A_,A__), I_ is I+1,checkCell(Position,(A_,I_,J),Result),rookThird(Position,Colour,(A_,I_,J),M,Steps,Result).
rookThird(_,_,X,[X],0,_).
rookThird(Position,Colour,(A,I,J),[(A,I,J)|M],Steps,Result):-Result =:= -1,Steps_ is Steps-1,rook_Third(Position,Colour,(A,I,J),M,Steps_).
rookThird(Position,Colour,(A,I,J),[(A,I,J)],Steps,Result):-changeColour(Colour,Result).
rookThird(_,Colour,(A,I,J),[],_,Result):-Result =:= Colour.
rookThird(_,_,X,[X],_,_).

rook_Third_(Position,Colour,(A,I,J),M,Steps):- char_code(A,_A),A__ is _A-1,char_code(A_,A__), I_ is I-1,checkCell(Position,(A_,I_,J),Result),rookThird_(Position,Colour,(A_,I_,J),M,Steps,Result).
rookThird_(_,_,X,[X],0,_).
rookThird_(Position,Colour,(A,I,J),[(A,I,J)|M],Steps,Result):-Result =:= -1,Steps_ is Steps-1,rook_Third_(Position,Colour,(A,I,J),M,Steps_).
rookThird_(Position,Colour,(A,I,J),[(A,I,J)],Steps,Result):-changeColour(Colour,Result).
rookThird_(_,Colour,(A,I,J),[],_,Result):-Result =:= Colour.
rookThird_(_,_,X,[X],_,_).
/*cleans a list*/
cleanList([],[]).
cleanList([[]|T],C):-cleanList(T,C).
cleanList([H|T],[H|C]):-cleanList(T,C).
/**/
changeColour(1,2).
changeColour(2,1).
/*check if cell is within limit*/
checkCell(Position,(A,I,J),Result):-char_code(A,A_), A_ < "l", A_ >= "a", I < 12, I > 0, J > 0, J <12, member(Position,(A,I,J),(P,C),Result).

member(Position,X,(P,C),Result):- Position=[X|Y],Y=[X1|Z],X1=(P,C),Result=C.
member(Position,X,(P,C),Result):- Position=[Y,Z|Z1],member(Z1,X,(P,C),Result).
