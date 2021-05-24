% This buffer is for notes you don't want to save.
% If you want to create a file, visit that file with C-x C-f,
% then enter the text in that file's own buffer.

% This buffer is for notes you don't want to save.
% If you want to create a file, visit that file with C-x C-f,
% then enter the text in that file's own buffer.

%            ���� ��� ����
%-------------------------------------

startMenu:-
	retractall(finishWindow(_)),
	assert(finishWindow(0)),
	new(W,window('Start Menu',size(600,500))),writeln(W),
	new(Board,bitmap('MenuBoard.bmp')),
	send(W,background,Board),
	send(W,open_centered),
	new(OnevsOneButtom,bitmap('1vs1Buttom2.bmp')),
	send(W,display,OnevsOneButtom,point(181,278)),
	send(OnevsOneButtom,recogniser,click_gesture(left,'',single,and(message(@prolog,startGame1vs1,W)))),
	new(OnevsComputerButtom,bitmap('1vscButtom2.bmp')),
	send(W,display,OnevsComputerButtom,point(182,379)),
	send(OnevsComputerButtom,recogniser,click_gesture(left,'',single,message(@prolog,startGame1vsc,W))).


%����� ����� �������
drawBoard:-
	new(W,window('4inarow',size(700,650))),
	new(Board,bitmap('board.bmp')),
	send(W,background,Board),
	send(W,open_centered),
	drawAllArrow(W,6).


%������ �������� - ����� ����
startBoard([]).


%�� ����� �� ����� ���� ����� ������
drawRed(W,X,Y):-
	new(R,bitmap('red.bmp')),
	X1 is (X*100)+2,
	Y1 is (Y*100)+52,
	send(W,display,R,point(X1,Y1)).


%�� ����� �� ����� ���� ����� ������
drawBlue(W,X,Y):-
	new(B,bitmap('blue.bmp')),
	X1 is (X*100)+2,
	Y1 is (Y*100)+52,
	send(W,display,B,point(X1,Y1)).


%�� ����� �� ����� ��� ����� ������
drawWhite(W,X,Y):-
	new(Wh,bitmap('white.bmp')),
	X1 is (X*100)+2,
	Y1 is (Y*100)+52,
	send(W,display,Wh,point(X1,Y1)).


%�� ����� �� ����� ���� ����� ������
drawGreen(W,X,Y):-
	new(G,bitmap('green.bmp')),
	X1 is (X*100)+2,
	Y1 is (Y*100)+52,
	send(W,display,G,point(X1,Y1)).


%�� ����� �� �� ����� ������ �� ������ �����
drawArrow(W,X):-
	new(A,bitmap('arrow.bmp')),
	X1 is X*100,
	send(W,display,A,point(X1,0)),
	send(A,recogniser,click_gesture(left,'',single,
	message(@prolog,changeboard,X,W))).


%��� �������� ��� ����� �� �� ����� �������
drawAllArrow(W,0):-
	drawArrow(W,0).
drawAllArrow(W,X):-
	drawArrow(W,X),
	X1 is X-1,
	drawAllArrow(W,X1).


%(����� �����(����� ������ ������ ������ ������� ����� �������
startGame1vs1(W):-
	(   (finishWindow(0),
	     send(W,destroy));
	    (finishWindow(W1),
	     send(W1,destroy))
	),
	startBoard(List),
	retractall(board(_)),
	assert(board(List)),
	retractall(player(_)),
	assert(player(1)),
	drawBoard.


%����� ����� �� ��� ���� ��� ����� �����
drawByPlayer(W,P,X,Y):-
	(   P is 1,
	    drawRed(W,X,Y)
	);
	(   P is 2,
	    drawBlue(W,X,Y)
	);
	(   P is 3,
	    drawGreen(W,X,Y)
	).


%����� ���� ���� ��� ������ ��� �� ���
changeboard(X,W):-
	board(List),
	player(P),
	not((member((X,_,_),List))),
	append([(X,5,P)],List,List1),
	retract(board(_)),
	assert(board(List1)),
	fallingPlayers0(W,X,0),
	(   (win(W));
	    (changeTurn(P))
	).

%����� ���� ���� ��� �� ������ ��� ����
changeboard(X,W):-
	board(List),
	player(P),
	member((X,Y1,_),List),
	not((member((X,Y2,_),List),Y2<Y1)),
	Y3 is Y1-1,
	Y3>=0,
	append([(X,Y3,P)],List,List1),
	retract(board(_)),
	assert(board(List1)),
	fallingPlayers1(W,X,0,Y3),
	(   (win(W));
	    (changeTurn(P))
	).


%(���� �� ���� (���� �� �����
changeTurn(P):-
	(   P is 1,
	    retract(player(_)),
	    assert(player(2))
	);
	(   P is 2,
	    retract(player(_)),
	    assert(player(1))
	).


%���� �� ����� �� ����� ��� ����� ������
winPicture(W):-
	    player(P),
	    P is 1,
	    send(W,destroy),
	    new(W1,window('Red Victory',size(600,455))),
	    new(Board,bitmap('redwon.bmp')),
	    send(W1,background,Board),
	    send(W1,open_centered),
	    new(OnevsOneButtom,bitmap('1vs1Buttom.bmp')),
	    send(W1,display,OnevsOneButtom,point(20,400)),
	    send(OnevsOneButtom,recogniser,click_gesture(left,'',single,message(@prolog,startGame1vs1,0))),
	    new(OnevsComputerButtom,bitmap('1vscButtom.bmp')),
	    send(W1,display,OnevsComputerButtom,point(320,400)),
	    send(OnevsComputerButtom,recogniser,click_gesture(left,'',single,message(@prolog,startGame1vsc,0))),
	    retract(finishWindow(_)),
	    assert(finishWindow(W1)).

winPicture(W):-
	    player(P),
	    P is 2,
	    send(W,destroy),
	    new(W1,window('Blue Victory',size(600,455))),
	    new(Board,bitmap('bluewon.bmp')),
	    send(W1,background,Board),
	    send(W1,open_centered),
	    new(OnevsOneButtom,bitmap('1vs1Buttom.bmp')),
	    send(W1,display,OnevsOneButtom,point(20,400)),
	    send(OnevsOneButtom,recogniser,click_gesture(left,'',single,message(@prolog,startGame1vs1,0))),
	    new(OnevsComputerButtom,bitmap('1vscButtom.bmp')),
	    send(W1,display,OnevsComputerButtom,point(320,400)),
	    send(OnevsComputerButtom,recogniser,click_gesture(left,'',single,message(@prolog,startGame1vsc,0))),
	    retract(finishWindow(_)),
	    assert(finishWindow(W1)).


%����� ����� �� ����� ������� ������� ���� ������ ����
winnerPlayers(W,(X1,Y1),(X2,Y2),(X3,Y3),(X4,Y4)):-
	drawGreen(W,X1,Y1),
	drawGreen(W,X2,Y2),
	drawGreen(W,X3,Y3),
	drawGreen(W,X4,Y4),
	send(timer(3),delay).


%������ �� ���� ���� �� ������ ������ ����� ��� ��� ������ ����
fallingPlayers0(W,X,5):-
	player(P),
	drawByPlayer(W,P,X,5).

fallingPlayers0(W,X,Y):-
	player(P),
	drawByPlayer(W,P,X,Y),
	send(timer(0.1),delay),
	drawWhite(W,X,Y),
	Y1 is Y+1,
	fallingPlayers0(W,X,Y1).


%������ �� ���� ���� �� ������ ������ ����� ��� ��� ������ ����
fallingPlayers1(W,X,Y,Y):-
	player(P),
	drawByPlayer(W,P,X,Y).

fallingPlayers1(W,X,Y,Y3):-
	player(P),
	drawByPlayer(W,P,X,Y),
	send(timer(0.1),delay),
	drawWhite(W,X,Y),
	Y1 is Y+1,
	fallingPlayers1(W,X,Y1,Y3).


%���� ��� �� ������� ������ ����� ���� ����
win(W):-
     board(List),
     member((X,Y1,P),List),
     member((X,Y2,P),List),
     member((X,Y3,P),List),
     member((X,Y4,P),List),
     Y2 is Y1+1,
     Y3 is Y2+1,
     Y4 is Y3+1,
     winnerPlayers(W,(X,Y1),(X,Y2),(X,Y3),(X,Y4)),
     winPicture(W).

%���� ��� �� ������� ������ ����� ���� �����
win(W):-
     board(List),
     member((X1,Y,P),List),
     member((X2,Y,P),List),
     member((X3,Y,P),List),
     member((X4,Y,P),List),
     X2 is X1+1,
     X3 is X2+1,
     X4 is X3+1,
     winnerPlayers(W,(X1,Y),(X2,Y),(X3,Y),(X4,Y)),
     winPicture(W).

%���� ��� �� ������� ������ ����� ���� ������� ���� �����
win(W):-
      board(List),
      member((X1,Y1,P),List),
      member((X2,Y2,P),List),
      X2 is X1+1,
      Y2 is Y1+1,
      member((X3,Y3,P),List),
      X3 is X2+1,
      Y3 is Y2+1,
      member((X4,Y4,P),List),
      X4 is X3+1,
      Y4 is Y3+1,
      winnerPlayers(W,(X1,Y1),(X2,Y2),(X3,Y3),(X4,Y4)),
      winPicture(W).

%���� ��� �� ������� ������ ����� ���� ������� ���� �����
win(W):-
      board(List),
      member((X1,Y1,P),List),
      member((X2,Y2,P),List),
      X1 is X2+1,
      Y1 is Y2-1,
      member((X3,Y3,P),List),
      X2 is X3+1,
      Y2 is Y3-1,
      member((X4,Y4,P),List),
      X3 is X4+1,
      Y3 is Y4-1,
      winnerPlayers(W,(X1,Y1),(X2,Y2),(X3,Y3),(X4,Y4)),
      winPicture(W).

%���� �� ����� ���� ���� ��� ��� ����
win(W):-
       board(List),
       length(List,42),
       send(W,destroy),
       new(W1,window('Tie',size(600,455))),
       new(Board,bitmap('tie.bmp')),
       send(W1,background,Board),
       send(W1,open_centered),
       new(OnevsOneButtom,bitmap('1vs1Buttom.bmp')),
       send(W1,display,OnevsOneButtom,point(20,400)),
       send(OnevsOneButtom,recogniser,click_gesture(left,'',single,message(@prolog,startGame1vs1,0))),
       new(OnevsComputerButtom,bitmap('1vscButtom.bmp')),
       send(W1,display,OnevsComputerButtom,point(320,400)),
       send(OnevsComputerButtom,recogniser,click_gesture(left,'',single,message(@prolog,startGame1vsc,0))),
       retract(finishWindow(_)),
       assert(finishWindow(W1)).






%	     ���� ��� �����
%--------------------------------------

%��� ����� ��� ������ ������ ����� ��� ��� �������� ��������
findTwoPlayers(List,P,(X1,Y),(X2,Y)):-
	member((X1,Y,P),List),
	X2 is X1+1,
	member((X2,Y,P),List),
	 X3 is X2+1,
	 X5 is X3+1,
	 X4 is X1-1,
	 X6 is X4-1,
	(
	 ( not(member((X3,Y,_),List)),
	   X3=<6,
	   not(member((X5,Y,_),List)),
	   X5=<6
	 );

         ( not(member((X4,Y,_),List)),
	   X4>=0,
	   not(member((X6,Y,_),List)),
	   X6>=0
         )
       ).

% ��� ����� ��� ������ ������� ����� �������� ���� �� ��� �������
% ��������
findTwoPlayers(List,P,(X1,Y),(X2,Y)):-
	member((X1,Y,P),List),
	X2 is X1+1,
	member((X2,Y,P),List),
	X3 is X1-1,
	X3>=0,
	not(member((X3,Y,_),List)),
	X4 is X2+1,
	X4=<6,
	not(member((X4,Y,_),List)).

%��� ����� ��� ������ ������� ����� ����� �� ������� �����
findTwoPlayers(List,P,(X1,Y),(X2,Y)):-
	member((X1,Y,P),List),
	member((X2,Y,P),List),
	X2 is X1+3,
	X3 is X1+1,
	not(member((X3,Y,_),List)),
	X4 is X3+1,
	not(member((X4,Y,_),List)).

% ��� ����� ��� ������ ������� ����� �������� ���� ��� ���� ����� �����
% ����� ������ �����
findTwoPlayers(List,P,(X1,Y),(X2,Y)):-
	member((X1,Y,P),List),
	member((X2,Y,P),List),
	X2 is X1+2,
	X3 is X1-1,
	X3>=0,
	not(member((X3,Y,_),List)),
	X4 is X1+1,
	not(member((X4,Y,_),List)).

% ��� ����� ��� ������ ������� ����� �������� ���� ��� ���� ����� �����
% ����� ����� �����
findTwoPlayers(List,P,(X1,Y),(X2,Y)):-
	member((X1,Y,P),List),
	member((X2,Y,P),List),
	X2 is X1+2,
	X3 is X1+1,
	not(member((X3,Y,_),List)),
	X4 is X2+1,
	X4=<6,
	not(member((X4,Y,_),List)).

%��� ����� ��� ������ ������ ���� ��� ��� �������� ��������
findTwoPlayers(List,P,(X,Y1),(X,Y2)):-
	member((X,Y1,P),List),
	Y2 is Y1-1,
	member((X,Y2,P),List),
	Y3 is Y2-1,
	Y3>=0,
	not(member((X,Y3,_),List)).

%��� ����� ��� ������ ������� ���� ����� ��� ��� ������� ��������
findTwoPlayers(List,P,(X1,Y1),(X2,Y2)):-
	member((X1,Y1,P),List),
	member((X2,Y2,P),List),
	X2 is X1+1,
	Y2 is Y1-1,
	X3 is X2+1,
	X3=<6,
	Y3 is Y2-1,
	Y3>=0,
	not(member((X3,Y3,_),List)),
	X4 is X1-1,
	Y4 is Y1+1,
	X4>=0,
	Y4=<5,
	not(member((X4,Y4,_),List)).

%��� ����� ��� ������ ������ ������� ���� ����� ���� �������� ��������
findTwoPlayers(List,P,(X1,Y1),(X2,Y2)):-
	member((X1,Y1,P),List),
	member((X2,Y2,P),List),
	X2 is X1+1,
	Y2 is Y1-1,
	X3 is X2+1,
	Y3 is Y2-1,
	X5 is X3+1,
	Y5 is Y3-1,
	X4 is X1-1,
	Y4 is Y1+1,
	X6 is X4-1,
	Y6 is Y4+1,
	(
	   ( not(member((X3,Y3,_),List)),
	     X3=<6,Y3>=0,
	     not(member((X5,Y5,_),List)),
	     X5=<6,Y5>=0

           );

           ( not(member((X4,Y4,_),List)),
	     X4>=0,Y4=<5,
	     not(member((X6,Y6,_),List)),
	     X6>=0,Y6=<5
	   )
       ).

%��� ����� ��� ������ ��� ����� �� ������� ������� ���� �����
findTwoPlayers(List,P,(X1,Y1),(X2,Y2)):-
	member((X1,Y1,P),List),
	member((X2,Y2,P),List),
	X2 is X1+3,
	Y2 is Y1-3,
	X3 is X1+1,
	Y3 is Y1-1,
	not(member((X3,Y3,_),List)),
	X4 is X1+2,
	Y4 is Y1-2,
	not(member((X4,Y4,_),List)).

% ��� ����� ��� ������� ������� ����� �������� ���� ���� ���� ������
% ����� ����� ������ ������� ���� �����
findTwoPlayers(List,P,(X1,Y1),(X2,Y2)):-
	member((X1,Y1,P),List),
	member((X2,Y2,P),List),
	X2 is X1+2,
	Y2 is Y1-2,
	X3 is X1+1,
	Y3 is Y1-1,
	not(member((X3,Y3,_),List)),
	X4 is X2+1,
	X4=<6,
	Y4 is Y2-1,
	Y4>=0,
	not(member((X4,Y4,_),List)).

% ��� ����� ��� ������ ������� ����� �������� ���� ���� ���� ����� �����
% ����� ������ ������� ���� �����
findTwoPlayers(List,P,(X1,Y1),(X2,Y2)):-
	member((X1,Y1,P),List),
	member((X2,Y2,P),List),
	X2 is X1+2,
	Y2 is Y1-2,
	X3 is X1+1,
	Y3 is Y1-1,
	not(member((X3,Y3,_),List)),
	X4 is X1-1,
	X4>=0,
	Y4 is Y1+1,
	Y4=<5,
	not(member((X4,Y4,_),List)).

%��� ����� ��� ������ ������ ������� ���� ����� ���� �������� ��������
findTwoPlayers(List,P,(X1,Y1),(X2,Y2)):-
	member((X1,Y1,P),List),
	member((X2,Y2,P),List),
	X2 is X1+1,
	Y2 is Y1+1,
	X3 is X2+1,
	Y3 is Y2+1,
	X5 is X3+1,
	Y5 is Y3+1,
	X4 is X1-1,
	Y4 is Y1-1,
	X6 is X4-1,
	Y6 is Y4-1,
	(
	   ( not(member((X3,Y3,_),List)),
	     X3=<6,Y3=<5,
	     not(member((X5,Y5,_),List)),
	     X5=<6,Y5=<5
           );

	   ( not(member((X4,Y4,_),List)),
	     X4>=0,Y4>=0,
	     not(member((X6,Y6,_),List)),
	     X6>=0,Y6>=0
	   )
	).

%��� ����� ��� ������ ������� ���� ����� ��� ��� ������� ��������
findTwoPlayers(List,P,(X1,Y1),(X2,Y2)):-
	member((X1,Y1,P),List),
	member((X2,Y2,P),List),
	X2 is X1+1,
	Y2 is Y1+1,
	X3 is X2+1,
	X3=<6,
	Y3 is Y2+1,
	Y3=<5,
	not(member((X3,Y3,_),List)),
	X4 is X1-1,
	Y4 is Y1-1,
	X4>=0,
	Y4>=0,
	not(member((X4,Y4,_),List)).

%��� ����� ��� ������ ������� ����� ����� �� ������� ������� ���� �����
findTwoPlayers(List,P,(X1,Y1),(X2,Y2)):-
	member((X1,Y1,P),List),
	member((X2,Y2,P),List),
	X2 is X1+3,
	Y2 is Y1+3,
	X3 is X1+1,
	Y3 is Y1+1,
	not(member((X3,Y3,_),List)),
	X4 is X1+2,
	Y4 is Y1+2,
	not(member((X4,Y4,_),List)).

% ��� ����� ��� ������ ������� ����� ������� ���� ��� ���� ������ �����
% ����� ����� ������� ���� �����
findTwoPlayers(List,P,(X1,Y1),(X2,Y2)):-
	member((X1,Y1,P),List),
	member((X2,Y2,P),List),
	X2 is X1+2,
	Y2 is Y1+2,
	X3 is X1+1,
	Y3 is Y1+1,
	not(member((X3,Y3,_),List)),
	X4 is X2+1,
	X4=<6,
	Y4 is Y2+1,
	Y4=<5,
	not(member((X4,Y4,_),List)).

% ��� ����� ��� ������ ������� ����� �������� ���� ��� ���� ����� �����
% ����� ������ ������� ���� �����
findTwoPlayers(List,P,(X1,Y1),(X2,Y2)):-
	member((X1,Y1,P),List),
	member((X2,Y2,P),List),
	X2 is X1+2,
	Y2 is Y1+2,
	X3 is X1+1,
	Y3 is Y1+1,
	not(member((X3,Y3,_),List)),
	X4 is X1-1,
	X4>=0,
	Y4 is Y1-1,
	Y4>=0,
	not(member((X4,Y4,_),List)).


%��� ����� ������� ����� ��� ����� ����
findThreePlayers(List,P,(X1,Y),(X2,Y),(X3,Y)):-
	member((X1,Y,P),List),
	member((X2,Y,P),List),
	X2 is X1+1,
	member((X3,Y,P),List),
	X3 is X2+1,
	X4 is X3+1,
	X5 is X1-1,
	(   ( not(member((X4,Y,_),List)),
	      X4=<6
	    );
	    ( not(member((X5,Y,_),List)),
	      X5>=0
	    )
	).

%��� ����� ������� ����� ��� ����� ���
findThreePlayers(List,P,(X,Y1),(X,Y2),(X,Y3)):-
	member((X,Y1,P),List),
	member((X,Y2,P),List),
	Y2 is Y1-1,
	member((X,Y3,P),List),
	Y3 is Y2-1,
	Y4 is Y3-1,
	Y4>=0,
	not(member((X,Y4,_),List)).

%��� ����� ������� ����� ������� ���� �����
findThreePlayers(List,P,(X1,Y1),(X2,Y2),(X3,Y3)):-
	member((X1,Y1,P),List),
	member((X2,Y2,P),List),
	X2 is X1+1,
	Y2 is Y1-1,
	member((X3,Y3,P),List),
	X3 is X2+1,
	Y3 is Y2-1,
	X4 is X3+1,
	Y4 is Y3-1,
	X5 is X1-1,
	Y5 is Y1+1,
	(   ( not(member((X4,Y4,_),List)),
	      X4=<6,
	      Y4>=0
	    );
	    ( not(member((X5,Y5,_),List)),
	      X5>=0,
	      Y5=<5
	    )
	).

%��� ����� ������� ����� ������� ���� �����
findThreePlayers(List,P,(X1,Y1),(X2,Y2),(X3,Y3)):-
	member((X1,Y1,P),List),
	member((X2,Y2,P),List),
	X2 is X1+1,
	Y2 is Y1+1,
	member((X3,Y3,P),List),
	X3 is X2+1,
	Y3 is Y2+1,
	X4 is X3+1,
	Y4 is Y3+1,
	X5 is X1-1,
	Y5 is Y1-1,
	(   ( not(member((X4,Y4,_),List)),
	      X4=<6,
	      Y4=<5
	    );
	    ( not(member((X5,Y5,_),List)),
	      X5>=0,
	      Y5>=0
	    )
	).



%��� ����� ������� ����� ���� ���� ���� �����
findThreePlayers(List,P,(X1,Y),(X2,Y),(X3,Y)):-
	member((X1,Y,P),List),
	member((X2,Y,P),List),
	X2 is X1+2,
	XE is X1+1,
	not(member((XE,Y,_),List)),
	member((X3,Y,P),List),
	X3 is X2+1.

%��� ����� ������� ����� ���� ���� ���� �����
findThreePlayers(List,P,(X1,Y),(X2,Y),(X3,Y)):-
	member((X1,Y,P),List),
	member((X2,Y,P),List),
	X2 is X1+1,
	XE is X2+1,
	not(member((XE,Y,_),List)),
	member((X3,Y,P),List),
	X3 is XE+1.

%��� ����� ������� ������� ���� ����� ���� ���� ���� �����
findThreePlayers(List,P,(X1,Y1),(X2,Y2),(X3,Y3)):-
	member((X1,Y1,P),List),
	member((X2,Y2,P),List),
	X2 is X1+2,
	Y2 is Y1+2,
	XE is X1+1,
	YE is Y1+1,
	not(member((XE,YE,_),List)),
	member((X3,Y3,P),List),
	X3 is X2+1,
	Y3 is Y2+1.

%��� ����� ������� ������� ���� ����� ���� ���� ���� �����
findThreePlayers(List,P,(X1,Y1),(X2,Y2),(X3,Y3)):-
	member((X1,Y1,P),List),
	member((X2,Y2,P),List),
	X2 is X1+1,
	Y2 is Y1+1,
	XE is X2+1,
	YE is Y2+1,
	not(member((XE,YE,_),List)),
	member((X3,Y3,P),List),
	X3 is XE+1,
	Y3 is YE+1.

%��� ����� ������� ������� ���� ����� ���� ���� ���� �����
findThreePlayers(List,P,(X1,Y1),(X2,Y2),(X3,Y3)):-
	member((X1,Y1,P),List),
	member((X2,Y2,P),List),
	X2 is X1+2,
	Y2 is Y1-2,
	XE is X1+1,
	YE is Y1-1,
	not(member((XE,YE,_),List)),
	member((X3,Y3,P),List),
	X3 is X2+1,
	Y3 is Y2-1.

%��� ����� ������� ������� ���� ����� ���� ���� ���� �����
findThreePlayers(List,P,(X1,Y1),(X2,Y2),(X3,Y3)):-
	member((X1,Y1,P),List),
	member((X2,Y2,P),List),
	X2 is X1+1,
	Y2 is Y1-1,
	XE is X2+1,
	YE is Y2-1,
	not(member((XE,YE,_),List)),
	member((X3,Y3,P),List),
	X3 is XE+1,
	Y3 is YE-1.


%��� ����� ��� �� ������� ������ ����
findFourPlayers(List,P):-
     member((X,Y1,P),List),
     member((X,Y2,P),List),
     member((X,Y3,P),List),
     member((X,Y4,P),List),
     Y2 is Y1+1,
     Y3 is Y2+1,
     Y4 is Y3+1.

%���� ��� �� ������� ������ ����� ���� �����
findFourPlayers(List,P):-
     member((X1,Y,P),List),
     member((X2,Y,P),List),
     member((X3,Y,P),List),
     member((X4,Y,P),List),
     X2 is X1+1,
     X3 is X2+1,
     X4 is X3+1.

%���� ��� �� ������� ������ ����� ���� ������� ����
findFourPlayers(List,P):-
      member((X1,Y1,P),List),
      member((X2,Y2,P),List),
      X2 is X1+1,
      Y2 is Y1+1,
      member((X3,Y3,P),List),
      X3 is X2+1,
      Y3 is Y2+1,
      member((X4,Y4,P),List),
      X4 is X3+1,
      Y4 is Y3+1.

%���� ��� �� ������� ������ ����� ���� ������� ����
findFourPlayers(List,P):-
      member((X1,Y1,P),List),
      member((X2,Y2,P),List),
      X1 is X2+1,
      Y1 is Y2-1,
      member((X3,Y3,P),List),
      X2 is X3+1,
      Y2 is Y3-1,
      member((X4,Y4,P),List),
      X3 is X4+1,
      Y3 is Y4-1.


%��� ����� �� ���� ������ ����
countPairs(List,N,P):-
	findall(((X1,Y1),(X2,Y2)),findTwoPlayers(List,P,(X1,Y1),(X2,Y2)),Pairs),
	length(Pairs,N).


%��� ����� �� ���� �������� ����
countThrees(List,N,P):-
	findall(((X1,Y1),(X2,Y2),(X3,Y3)),findThreePlayers(List,P,(X1,Y1),(X2,Y2),(X3,Y3)),Threes),
	length(Threes,N).


%��� ������ ���� ���� ���
addPlayerToList(X,P,Board,[(X,5,P)|Board]):-
	not((member((X,_,_),Board))).

%��� ������ ���� ���� ��� �� ��� ������
addPlayerToList(X,P,Board,[(X,Y3,P)|Board]):-
	member((X,Y1,_),Board),
	not((member((X,Y2,_),Board),Y2<Y1)),
	Y3 is Y1-1,
	Y3>=0.


% ��� �������� ����� ����� �� ����� ��� ����� ������ ����� �� ������
% �������
boardsList(_,[],7,_).

boardsList((Board,XFirst),[(Board1,XFirst)|Boards],X,P):-
	addPlayerToList(X,P,Board,Board1),
	X1 is X+1,
	boardsList((Board,XFirst),Boards,X1,P).

%X is full in board
boardsList((Board,XFirst),Boards,X,P):-
%not((	addPlayerToList(X,P,Board,(_,X)))),
	X1 is X+1,
	boardsList((Board,XFirst),Boards,X1,P).


%��� �������� ����� ����� �� ����� ��� ����� ������
boardsList1(_,[],7,_).

boardsList1(Board,[(Board1,X)|Boards],X,P):-
	addPlayerToList(X,P,Board,Board1),
	X1 is X+1,
	boardsList1(Board,Boards,X1,P).

%X is full in board
boardsList1(Board,Boards,X,P):-
%not((	addPlayerToList(X,P,Board,(_,X)))),
	X1 is X+1,
	boardsList1(Board,Boards,X1,P).


%��� ����� ���� ������� �� �����
gradeBoardComputer(List,Grade):-
	    countThrees(List,Nt,1),
	    G1 is 5000*Nt,
	    countPairs(List,Np,1),
	    G2 is 50*Np,
	    Grade is G1+G2.

%��� ����� ���� ������� �� ����� ������
gradeBoardHuman(List,Grade):-
	   countThrees(List,Nt,2),
	    G1 is 5000*Nt,
	    countPairs(List,Np,2),
	    G2 is 50*Np,
	    Grade is G1+G2.


%��� ����� ���� ���� ����
gradeBoard(List,Grade):-
	gradeBoardComputer(List,Grade1),
	gradeBoardHuman(List,Grade2),
	Grade is Grade1-Grade2.


%��� ����� ���� ��� ��� ���� ���
gradeEachBoardInLevel([],[]).

gradeEachBoardInLevel([(List,X)|Boards],[(List,X,Grade)|Boards2]):-
	gradeBoard(List,Grade),
	gradeEachBoardInLevel(Boards,Boards2).


%��� ����� �� ���� ��� ����� ����� �����
bestBoardInLevel(Boards,X,Grade):-
	member((_,X,Grade),Boards),
	not(((member((_,_,Grade1),Boards),Grade1>Grade))).


%��� ����� �� ����� ������ ������ ������� �������� ���� ����
blockedFour(List,P,X):-
	boardsList1(List,Boards,0,P),
	member((Board,X),Boards),
	findFourPlayers(Board,P),!.


% ��� ������ �� ������� ����� ��� ���� ����� ����� ����� ��� ����� ����
% ����� ��� ����� �������
% minMax1(Board,Level,BestMove,BestGrade,Player)
minMax1(Board,BestMove,BestGrade,DeepestLevel,1):-
	boardsList1(Board,AllBoards,0,1),!,
	NewLevel is DeepestLevel - 1,
	minMax(AllBoards,NewLevel,BestMove,BestGrade,1).

%��� �������� ����� ��� ����� ���� ����� ��� ����� �������
% minMax(Board,Level,BestMove,BestGrade,Player)
%���� ���� ���� �������
minMax([(Board,XFirst)],0,XFirst,BestGrade,1):-
	gradeBoard(Board,BestGrade).

%���� ���� ���� �������
minMax(Boards,0,BestMove,BestGrade,1):-
	gradeEachBoardInLevel(Boards,AllBoards2),
	bestBoardInLevel(AllBoards2,BestMove,BestGrade).

%���� ���� ���� ������
minMax([(Board,XFirst)|_],_,XFirst,1000000,1):-
	findFourPlayers(Board,1).

%���� ���� ���� ���� ����� ����
minMax([(Board,XFirst)|_],_,XFirst,-1000000,2):-
	findFourPlayers(Board,2).

%���� ���� ����� ��� ������ ������� ������ ���� �� �����
%����
minMax([(Board,XFirst)|AllBoards],Level,BestMove,BestGrade,1):-
	length(Board,42),/*tie*/
	(   (AllBoards=[],BestMove = XFirst, BestGrade = 0);
	    (minMax(AllBoards,Level,BroMove,BroGrade,1),
		(   (0>=BroGrade,BestGrade is 0,BestMove is XFirst);
	            (BestGrade is BroGrade,BestMove is BroMove)
		)
	    )
	).

%���� ���� ����� ��� ������ ������� ������ ���� �� ����
%����
minMax([(Board,XFirst)|AllBoards],Level,BestMove,BestGrade,2):-
	length(Board,42),/*tie*/
	(   (AllBoards=[],BestMove = XFirst, BestGrade = 0);
	    (minMax(AllBoards,Level,BroMove,BroGrade,2),
		(   (0=<BroGrade,BestGrade is 0,BestMove is XFirst);
	            (BestGrade is BroGrade,BestMove is BroMove)
	        )
	    )
	).

%������� ����������� �����
minMax([(Board,XFirst)],Level,BestMove,BestGrade,P):-
	(   (P is 1,P1 is 2);
            (P1 is 1)
	),
	boardsList((Board,XFirst),AllBoards,0,P1),
	NewLevel is Level-1,
        minMax(AllBoards,NewLevel,BestMove,BestGrade,P1).

%������� ����������� ����� ������
minMax([(Board,XFirst)|Boards],Level,BestMove,BestGrade,1):-
/*	(   (P is 1,P1 is 2);
            (P1 is 1)
	),*/
	boardsList((Board,XFirst),AllBoards,0,2),
	NewLevel is Level-1,
	minMax(AllBoards,NewLevel,BestMoveFirst,BestGradeFirst,2),
	minMax(Boards,Level,BestMoveBro,BestGradeBro,1),
	(   (BestGradeFirst>=BestGradeBro,BestGrade is BestGradeFirst,BestMove is BestMoveFirst);
	    (BestGrade is BestGradeBro,BestMove is BestMoveBro)
	).

%������� ����������� ����� ������
minMax([(Board,XFirst)|Boards],Level,BestMove,BestGrade,2):-
/*	(   (P is 1,P1 is 2);
            (P1 is 1)
	),*/
	boardsList((Board,XFirst),AllBoards,0,1),
	NewLevel is Level-1,
	minMax(AllBoards,NewLevel,BestMoveFirst,BestGradeFirst,1),
	minMax(Boards,Level,BestMoveBro,BestGradeBro,2),
	(   (BestGradeFirst=<BestGradeBro,BestGrade is BestGradeFirst,BestMove is BestMoveFirst);
	    (BestGrade is BestGradeBro,BestMove is BestMoveBro)
	).






%     ����� ���� �� ���� ��� �����
%----------------------------------------

%����� ����� �� �� ��� ��� �����
startGame1vsc(W1):-
	(   (finishWindow(0),
	     send(W1,destroy));
	    (finishWindow(W),
	     send(W,destroy))
	),
	startBoard(List),
	retractall(board(_)),
	assert(board(List)),
	retractall(player(_)),
	assert(player(2)),
	retractall(bestM(_)),
	assert(bestM(-1)),
	retractall(bestG(_)),
	assert(bestG(-1)),
	drawBoard1vsc.


%����� ���� ����� �� �����
computerTurn(W):-
	board(List),
	minMax1(List,BestMove1,BestGrade,3,1),
	write('Best Grade is: '),writeln(BestGrade),
	(   (BestGrade=(-1000000),blockedFour(List,2,BestMove));
	    (BestMove=BestMove1)
	),
	write('And Best Move is: '),writeln(BestMove),
	writeln(---------),
	new(BestM,text(BestMove)),
	send(W,display,BestM,point(387,683)),
	retract(bestM(_)),
	assert(bestM(BestM)),
	new(BestG,text(BestGrade)),
	send(W,display,BestG,point(290,714)),
	retract(bestG(_)),
	assert(bestG(BestG)),
	changeboard2(BestMove,W).



%����� ����� �������
drawBoard1vsc:-
	new(W,window('4inarow',size(700,750))),writeln(W),
	new(Board,bitmap('1VSCboard.bmp')),
	send(W,background,Board),
	send(W,open_centered),
	drawAllArrow1vsc(W,6).


%�� ����� �� �� ����� ������ �� ������ �����
drawArrow1vsc(W,X):-
	new(A,bitmap('arrow.bmp')),
	X1 is X*100,
	send(W,display,A,point(X1,0)),
	send(A,recogniser,click_gesture(left,'',single,
	message(@prolog,changeboard2,X,W))).


%��� �������� ��� ����� �� �� ����� �������
drawAllArrow1vsc(W,0):-
	drawArrow1vsc(W,0).
drawAllArrow1vsc(W,X):-
	drawArrow1vsc(W,X),
	X1 is X-1,
	drawAllArrow1vsc(W,X1).


%����� ���� ���� ��� ������ ��� �� ���
changeboard2(X,W):-
	board(List),
	player(P),
	not((member((X,_,_),List))),
	append([(X,5,P)],List,List1),
	retract(board(_)),
	assert(board(List1)),
	fallingPlayers0(W,X,0),
	(   (win(W));
	    (
		(   (bestM(-1),bestG(-1),
		     changeTurn1vsc1(P,W));
		    (changeTurn1vsc(P,W))
		)
	    )
	).

%����� ���� ���� ��� �� ������ ��� ������
changeboard2(X,W):-
	board(List),
	player(P),
	member((X,Y1,_),List),
	not((member((X,Y2,_),List),Y2<Y1)),
	Y3 is Y1-1,
	Y3>=0,
	append([(X,Y3,P)],List,List1),
	retract(board(_)),
	assert(board(List1)),
	fallingPlayers1(W,X,0,Y3),
	(   (win(W));
	    (
		(   (bestM(-1),bestG(-1),
		     changeTurn1vsc1(P,W));
		    (changeTurn1vsc(P,W))
		)
	    )
	).


%(���� �� ���� (���� �� �����
changeTurn1vsc1(P,W):-
	(   P is 1,
	    retract(player(_)),
	    assert(player(2))
	);
	(   P is 2,
	    retract(player(_)),
	    assert(player(1)),
	    new(A,bitmap('computerTurnButtom.bmp')),
            send(W,display,A,point(50,670)),
	    send(A,recogniser,click_gesture(left,'',single,
            message(@prolog,computerTurn,W)))
	).

%(���� �� ���� (���� �� �����
changeTurn1vsc(P,W):-
	(   P is 1,
	    retract(player(_)),
	    assert(player(2))
	);
	(   P is 2,
	    retract(player(_)),
	    assert(player(1)),
	    new(A,bitmap('computerTurnButtom.bmp')),
            send(W,display,A,point(50,670)),
	    bestM(BestM),
	    send(BestM,clear),
	    bestG(BestG),
	    send(BestG,clear),
	    send(A,recogniser,click_gesture(left,'',single,
            message(@prolog,computerTurn,W)))
	).
