% This buffer is for notes you don't want to save.
% If you want to create a file, visit that file with C-x C-f,
% then enter the text in that file's own buffer.

% This buffer is for notes you don't want to save.
% If you want to create a file, visit that file with C-x C-f,
% then enter the text in that file's own buffer.

%            שחקן נגד שחקן
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


%בניית החלון ההתחלתי
drawBoard:-
	new(W,window('4inarow',size(700,650))),
	new(Board,bitmap('board.bmp')),
	send(W,background,Board),
	send(W,open_centered),
	drawAllArrow(W,6).


%הרשימה ההתחלתית - רשימה ריקה
startBoard([]).


%שם תמונה של עיגול אדום במקום ספציפי
drawRed(W,X,Y):-
	new(R,bitmap('red.bmp')),
	X1 is (X*100)+2,
	Y1 is (Y*100)+52,
	send(W,display,R,point(X1,Y1)).


%שם תמונה של עיגול כחול במקום ספציפי
drawBlue(W,X,Y):-
	new(B,bitmap('blue.bmp')),
	X1 is (X*100)+2,
	Y1 is (Y*100)+52,
	send(W,display,B,point(X1,Y1)).


%שם תמונה של עיגול לבן במקום ספציפי
drawWhite(W,X,Y):-
	new(Wh,bitmap('white.bmp')),
	X1 is (X*100)+2,
	Y1 is (Y*100)+52,
	send(W,display,Wh,point(X1,Y1)).


%שם תמונה של עיגול ירוק במקום ספציפי
drawGreen(W,X,Y):-
	new(G,bitmap('green.bmp')),
	X1 is (X*100)+2,
	Y1 is (Y*100)+52,
	send(W,display,G,point(X1,Y1)).


%שם תמונה של חץ במקום ספציפי עם אפשרות לחיצה
drawArrow(W,X):-
	new(A,bitmap('arrow.bmp')),
	X1 is X*100,
	send(W,display,A,point(X1,0)),
	send(A,recogniser,click_gesture(left,'',single,
	message(@prolog,changeboard,X,W))).


%חוק רקורסיבי ששם תמונה של חץ בשורה הראשונה
drawAllArrow(W,0):-
	drawArrow(W,0).
drawAllArrow(W,X):-
	drawArrow(W,X),
	X1 is X-1,
	drawAllArrow(W,X1).


%(התחלת המשחק(יצירת עובדות ראשיות וקריאה לפעולות יישום וגרפיקה
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


%מצייר עיגול עם צבע נתון לפי מיקום מסוים
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


%שינוי הלוח במצב שבו בעמודה אין אף כלי
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

%שינוי הלוח במצב שבו יש בעמודה כבר כלים
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


%(משנה את התור (הצבע של השחקן
changeTurn(P):-
	(   P is 1,
	    retract(player(_)),
	    assert(player(2))
	);
	(   P is 2,
	    retract(player(_)),
	    assert(player(1))
	).


%מציג את החלון של המנצח לפי השחקן האחרון
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


%סימון בירוק של ארבעת השחקנים המנצחים לפני שהחלון נסגר
winnerPlayers(W,(X1,Y1),(X2,Y2),(X3,Y3),(X4,Y4)):-
	drawGreen(W,X1,Y1),
	drawGreen(W,X2,Y2),
	drawGreen(W,X3,Y3),
	drawGreen(W,X4,Y4),
	send(timer(3),delay).


%גרפיקה של שחקן נופל עד למקומו המתאים במקרה אין כלל שחקנים בטור
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


%גרפיקה של שחקן נופל עד למקומו המתאים במקרה שיש כבר שחקנים בטור
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


%בודק האם יש רביעיית שחקנים מאותו הצבע בטור
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

%בודק האם יש רביעיית שחקנים מאותו הצבע בשורה
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

%בודק האם יש רביעיית שחקנים מאותו הצבע באלכסון יורד ימינה
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

%בודק האם יש רביעיית שחקנים מאותו הצבע באלכסון עולה ימינה
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

%בודק את המקרה כאשר הלוח מלא ויש תיקו
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






%	     שחקן נגד המחשב
%--------------------------------------

%חוק המביא זוג איברים צמודים בשורה שיש להם פוטנציאל לרביעייה
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

% חוק המביא זוג איברים שיכולים להיות ברביעייה כאשר הם שני האיברים
% המרכזיים
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

%חוק המביא זוג איברים היכולים להיות קצוות של רביעייה בשורה
findTwoPlayers(List,P,(X1,Y),(X2,Y)):-
	member((X1,Y,P),List),
	member((X2,Y,P),List),
	X2 is X1+3,
	X3 is X1+1,
	not(member((X3,Y,_),List)),
	X4 is X3+1,
	not(member((X4,Y,_),List)).

% חוק המביא זוג איברים שיכולים להיות ברביעייה כאשר אחד בקצה הימני והשני
% באמצע השמאלי בקורה
findTwoPlayers(List,P,(X1,Y),(X2,Y)):-
	member((X1,Y,P),List),
	member((X2,Y,P),List),
	X2 is X1+2,
	X3 is X1-1,
	X3>=0,
	not(member((X3,Y,_),List)),
	X4 is X1+1,
	not(member((X4,Y,_),List)).

% חוק המביא זוג איברים שיכולים להיות ברביעייה כאשר אחד בקצה שמאלי והשני
% באמצע הימני בשורה
findTwoPlayers(List,P,(X1,Y),(X2,Y)):-
	member((X1,Y,P),List),
	member((X2,Y,P),List),
	X2 is X1+2,
	X3 is X1+1,
	not(member((X3,Y,_),List)),
	X4 is X2+1,
	X4=<6,
	not(member((X4,Y,_),List)).

%חוק המביא זוג איברים צמודים בטור שיש להם פוטנציאל לרביעייה
findTwoPlayers(List,P,(X,Y1),(X,Y2)):-
	member((X,Y1,P),List),
	Y2 is Y1-1,
	member((X,Y2,P),List),
	Y3 is Y2-1,
	Y3>=0,
	not(member((X,Y3,_),List)).

%חוק המביא זוג איברים באלכסון עולה ימינה שהם שני האיברים המרכזיים
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

%חוק המביא זוג איברים צמודים באלכסון עולה ימינה בעלי פוטנציאל לרביעייה
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

%חוק המביא זוג איברים שהם קצוות של רביעייה באלכסון עולה ימינה
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

% חוק המביא זוג אריברים שיכולים להיות ברביעייה כאשר האחד בקצה השמאלי
% והשני באמצע הימנהי באלכסון עולה ימינה
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

% חוק המביא זוג איברים שיכולים להיות ברביעייה כאשר האחד בקצה הימני והשני
% באמצע השמאלי באלכסון עולה ימינה
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

%חוק המביא זוג איברים צמודים באלכסון יורד ימינה בעלי פוטנציאל לרביעייה
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

%חוק המביא זוג איברים באלכסון יורד ימינה שהם שני האיברים המרכזיים
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

%חוק המביא זוג איברים שיכולים להיות קצוות של רביעייה באלכסון יורד ימינה
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

% חוק המבאי זוג איברים שיכולים להיות רביעייה כאשר אחד בקצה השמאלי והשני
% באמצע הימני באלכסון יורד ימינה
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

% חוק המביא זוג איברים שיכולים לביות ברביעייה כאשר אחד בקצה הימני והשני
% באמצע השמאלי באלכסון יורד ימינה
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


%חוק המביא שלישייה צמודה שהם באותה שורה
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

%חוק המביא שלישייה צמודה שהם באותו טור
findThreePlayers(List,P,(X,Y1),(X,Y2),(X,Y3)):-
	member((X,Y1,P),List),
	member((X,Y2,P),List),
	Y2 is Y1-1,
	member((X,Y3,P),List),
	Y3 is Y2-1,
	Y4 is Y3-1,
	Y4>=0,
	not(member((X,Y4,_),List)).

%חוק המביא שלישייה צמודה באלכסון עולה ימינה
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

%חוק המביא שלישייה צמודה באלכסון יורד ימינה
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



%חוק המביא שלישייה בשורה כשיש רווח בשני משמאל
findThreePlayers(List,P,(X1,Y),(X2,Y),(X3,Y)):-
	member((X1,Y,P),List),
	member((X2,Y,P),List),
	X2 is X1+2,
	XE is X1+1,
	not(member((XE,Y,_),List)),
	member((X3,Y,P),List),
	X3 is X2+1.

%חוק המביא שלישייה בשורה כשיש רווח בשני מימין
findThreePlayers(List,P,(X1,Y),(X2,Y),(X3,Y)):-
	member((X1,Y,P),List),
	member((X2,Y,P),List),
	X2 is X1+1,
	XE is X2+1,
	not(member((XE,Y,_),List)),
	member((X3,Y,P),List),
	X3 is XE+1.

%חוק המביא שלישייה באלכסון יורד ימינה כשיש רווח בשני משמאל
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

%חוק המביא שלישייה באלכסון יורד ימינה כשיש רווח בשני מימין
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

%חוק המביא שלישייה באלכסון עולה ימינה כשיש רווח בשני משמאל
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

%חוק המביא שלישייה באלכסון עולה ימינה כשיש רווח בשני מימין
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


%חוק הבודק האם יש רביעיית שחקנים בטור
findFourPlayers(List,P):-
     member((X,Y1,P),List),
     member((X,Y2,P),List),
     member((X,Y3,P),List),
     member((X,Y4,P),List),
     Y2 is Y1+1,
     Y3 is Y2+1,
     Y4 is Y3+1.

%בודק האם יש רביעיית שחקנים מאותו הצבע בשורה
findFourPlayers(List,P):-
     member((X1,Y,P),List),
     member((X2,Y,P),List),
     member((X3,Y,P),List),
     member((X4,Y,P),List),
     X2 is X1+1,
     X3 is X2+1,
     X4 is X3+1.

%בודק האם יש רביעיית שחקנים מאותו הצבע באלכסון יורד
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

%בודק האם יש רביעיית שחקנים מאותו הצבע באלכסון עולה
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


%חוק הסופר את כמות הזוגות בלוח
countPairs(List,N,P):-
	findall(((X1,Y1),(X2,Y2)),findTwoPlayers(List,P,(X1,Y1),(X2,Y2)),Pairs),
	length(Pairs,N).


%חוק הסופר את כמות השלישיות בלוח
countThrees(List,N,P):-
	findall(((X1,Y1),(X2,Y2),(X3,Y3)),findThreePlayers(List,P,(X1,Y1),(X2,Y2),(X3,Y3)),Threes),
	length(Threes,N).


%חוק שמוסיף חייל בטור ריק
addPlayerToList(X,P,Board,[(X,5,P)|Board]):-
	not((member((X,_,_),Board))).

%חוק שמוסיף חייל בטור שיש בו כבר חיילים
addPlayerToList(X,P,Board,[(X,Y3,P)|Board]):-
	member((X,Y1,_),Board),
	not((member((X,Y2,_),Board),Y2<Y1)),
	Y3 is Y1-1,
	Y3>=0.


% חוק רקורסיבי המביא רשימה של לוחות לכל לחיצה אפשרית ושומר על הלחיצה
% הראשונה
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


%חוק רקורסיבי המביא רשימה של לוחות לכל לחיצה אפשרית
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


%חוק הנותן ציון לשחקנים של המחשב
gradeBoardComputer(List,Grade):-
	    countThrees(List,Nt,1),
	    G1 is 5000*Nt,
	    countPairs(List,Np,1),
	    G2 is 50*Np,
	    Grade is G1+G2.

%חוק הנותן ציון לשחקנים של השחקן האנושי
gradeBoardHuman(List,Grade):-
	   countThrees(List,Nt,2),
	    G1 is 5000*Nt,
	    countPairs(List,Np,2),
	    G2 is 50*Np,
	    Grade is G1+G2.


%חוק הנותן ציון ללוח בודד
gradeBoard(List,Grade):-
	gradeBoardComputer(List,Grade1),
	gradeBoardHuman(List,Grade2),
	Grade is Grade1-Grade2.


%חוק הנותן ציון לכל לוח ברמה אחת
gradeEachBoardInLevel([],[]).

gradeEachBoardInLevel([(List,X)|Boards],[(List,X,Grade)|Boards2]):-
	gradeBoard(List,Grade),
	gradeEachBoardInLevel(Boards,Boards2).


%חוק המביא את הלוח בעל הציון הגדול ביותר
bestBoardInLevel(Boards,X,Grade):-
	member((_,X,Grade),Boards),
	not(((member((_,_,Grade1),Boards),Grade1>Grade))).


%חוק המוצא את האיבר שיגרום לסגירת שלישייה לרביעייה בצבע נתון
blockedFour(List,P,X):-
	boardsList1(List,Boards,0,P),
	member((Board,X),Boards),
	findFourPlayers(Board,P),!.


% חוק המתחיל את המינמקס הבודק לפי משחק מדומה לרמות קדימה מהו המהלך הטוב
% ביותר כדי להגיע לניצחון
% minMax1(Board,Level,BestMove,BestGrade,Player)
minMax1(Board,BestMove,BestGrade,DeepestLevel,1):-
	boardsList1(Board,AllBoards,0,1),!,
	NewLevel is DeepestLevel - 1,
	minMax(AllBoards,NewLevel,BestMove,BestGrade,1).

%חוק רקורסיבי המוצא מהו המהלך הטוב ביותר כדי להגיע לניצחון
% minMax(Board,Level,BestMove,BestGrade,Player)
%תנאי סיום לרמה האחרונה
minMax([(Board,XFirst)],0,XFirst,BestGrade,1):-
	gradeBoard(Board,BestGrade).

%תנאי סיום לרמה האחרונה
minMax(Boards,0,BestMove,BestGrade,1):-
	gradeEachBoardInLevel(Boards,AllBoards2),
	bestBoardInLevel(AllBoards2,BestMove,BestGrade).

%תנאי סיום כשיש ניצחון
minMax([(Board,XFirst)|_],_,XFirst,1000000,1):-
	findFourPlayers(Board,1).

%תנאי סיום כשיש הפסד והאדם מנצח
minMax([(Board,XFirst)|_],_,XFirst,-1000000,2):-
	findFourPlayers(Board,2).

%תנאי סיום כשאין עוד מקומות אפשריים ללחיצה ברמה של המחשב
%תיקו
minMax([(Board,XFirst)|AllBoards],Level,BestMove,BestGrade,1):-
	length(Board,42),/*tie*/
	(   (AllBoards=[],BestMove = XFirst, BestGrade = 0);
	    (minMax(AllBoards,Level,BroMove,BroGrade,1),
		(   (0>=BroGrade,BestGrade is 0,BestMove is XFirst);
	            (BestGrade is BroGrade,BestMove is BroMove)
		)
	    )
	).

%תנאי סיום כשאין עוד מקומות אפשריים ללחיצה ברמה של האדם
%תיקו
minMax([(Board,XFirst)|AllBoards],Level,BestMove,BestGrade,2):-
	length(Board,42),/*tie*/
	(   (AllBoards=[],BestMove = XFirst, BestGrade = 0);
	    (minMax(AllBoards,Level,BroMove,BroGrade,2),
		(   (0=<BroGrade,BestGrade is 0,BestMove is XFirst);
	            (BestGrade is BroGrade,BestMove is BroMove)
	        )
	    )
	).

%הקריאות הרקורסיביות לעומק
minMax([(Board,XFirst)],Level,BestMove,BestGrade,P):-
	(   (P is 1,P1 is 2);
            (P1 is 1)
	),
	boardsList((Board,XFirst),AllBoards,0,P1),
	NewLevel is Level-1,
        minMax(AllBoards,NewLevel,BestMove,BestGrade,P1).

%הקריאות הרקורסיביות לעומק ולרוחב
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

%הקריאות הרקורסיביות לעומק ולרוחב
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






%     ביצוע מעשי של שחקן נגד המחשב
%----------------------------------------

%התחלת המשחק של בן אדם נגד המחשב
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


%ביצוע מעשי לתורו של המחשב
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



%בניית החלון ההתחלתי
drawBoard1vsc:-
	new(W,window('4inarow',size(700,750))),writeln(W),
	new(Board,bitmap('1VSCboard.bmp')),
	send(W,background,Board),
	send(W,open_centered),
	drawAllArrow1vsc(W,6).


%שם תמונה של חץ במקום ספציפי עם אפשרות לחיצה
drawArrow1vsc(W,X):-
	new(A,bitmap('arrow.bmp')),
	X1 is X*100,
	send(W,display,A,point(X1,0)),
	send(A,recogniser,click_gesture(left,'',single,
	message(@prolog,changeboard2,X,W))).


%חוק רקורסיבי ששם תמונה של חץ בשורה הראשונה
drawAllArrow1vsc(W,0):-
	drawArrow1vsc(W,0).
drawAllArrow1vsc(W,X):-
	drawArrow1vsc(W,X),
	X1 is X-1,
	drawAllArrow1vsc(W,X1).


%שינוי הלוח במצב שבו בעמודה אין אף כלי
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

%שינוי הלוח במצב שבו יש בעמודה כבר שחקנים
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


%(משנה את התור (הצבע של השחקן
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

%(משנה את התור (הצבע של השחקן
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
