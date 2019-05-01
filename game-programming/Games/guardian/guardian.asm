;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;GUARDIAN;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;Authors : Sabarinath N P     ( CS10B020 )
;;;;;;;;;;;;;          Saikrishna B       ( CS10B021 )
;;;;;;;;;;;;;          Dileep Kumar Gunda ( CS10B009 )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Source Code for the Guardian Game;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.MODEL SMALL
.STACK 400H

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Game Constants;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ShooterRow EQU 00aah
lengthOfShooter EQU 0020h
ShooterHeight EQU 000ah
ShooterHalfHeight EQU 0005h
HalfShooterLength EQU 0010h

BulletBaseLength EQU 0006h
HalfBulletBaseLength EQU 0003h

DevilWidth EQU 00010h
DevilHeight EQU 0010h
HalfDevilWidth EQU 0008h
HalfDevilHeight EQU 0008h

.DATA

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;God Power Variables;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Power1avail db 00h
Power2avail db 00h
Power3avail db 00h
Power4avail db 00h
BigGodDelay dw 0000h
SmallGodDelay dw 0000h
FourTimes dw 0000h

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Home Screen and other Non-Game Variables;;;;;;;;;;;;;;
PageNo db 0
Guide db 'Use keys w, s, a, d for Navigation',0
NewGame db 'NEW GAME',0
Instructions db 'INSTRUCTIONS',0
HighScores db 'HIGHSCORE',0
Quit db 'QUIT',0
HPage db 'HOME PAGE',0
HighScoreString db "** NEW HIGHSCORE **$"
NoHighScore db "No Games Played Yet$"
DevilHitShooter db "Sorry, Devil Hit the Shooter$"
OldHighScore db "The HighScore is $"
ImproveHs db "To Improve HighScore : $"
Hint1 db "Use > 1 God Power at a time.$"
Hint2 db "Ex: Freeze + 4X$"
Hint3 db "4X + Destroy$"
Hint4 db "Use Regain Power after other powers$"
Level1 db "Level 1$"
Level2 db "Level 2$"
Level3 db "Level 3$"
Level4 db "Level 4$"

Inst1 db "'a' -> Left$"
Inst2 db "'d' -> Right$"
Inst3 db "'Enter' -> Shooting$"
Inst4 db "'Esc' -> Pause$"
Inst5 db "'h' -> Quit to Home Page From Game$"
Inst6 db "'q' -> Freeze Power$"
Inst7 db "'w' -> Destroy Power$"
Inst8 db "'e' -> 4X Power$"
Inst9 db "'r' -> Regain All Powers$"
Inst10 db "Make Sure Caps is not pressed :P$"

PointString db "Score : $"
LifeString db "Life : $"
NameString db "Name  : $"
power db "Power : $"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;God Power Paint Varibles;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
buffer dw 0
file_handle dw 0
top_x dw 5
top_y dw 5
pixel_col dw 0
pixel_row dw 0
godrow dw 50
godcolumn dw 210
powerbar dw 0
powerstatus dw 0001
frequency dw 1560
dlay dw 5

filename1 db "..\inp1.txt$",0
filename2 db "..\inp2.txt$",0
filename3 db "..\inp3.txt$",0
filename4 db "..\inp4.txt$",0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Main Game Variables;;;;;;;;;;;;;;;;;;;;;;;;;;;;

EndIfDemonHits db 00h
lengthOfHorizontal dw 0
lengthOfVertical dw 0
RectangleHeight dw 0
RectangleWidth dw 0
InclinedLength dw 0
MajorDia dw 1
ShooterColumn dw 008ah
color db 4
TriangleDir dw -1
rowToClear db 0
RandomWidth dw 0000h
speedcounter db 0

BulletRowPositions db 100 dup(0)
BulletColPositions db 100 dup(0)
DevilRowPositions db 5 dup(0)			;initially 0 indicates no demon is there in that column
DevilColPositions db 5 dup(0)

MainCounter dw 0000h
NoOfBullets dw 0000h
Points dw 0000h
Life dw 0005h
DemonMov dw 0001h
HitPoint dw 000ah

input db 0
EndGame db 0
EndAll db 0
Level db 02h

PlayerName db 50 dup('$')
HScore dw 0000h

.CODE

START:
	SetCursor MACRO row, col, pageNo
		push ax
		push bx
		push dx
		
		mov dh, row		;;;ROW
		mov dl, col		;;;COL
		mov bh, pageNo	;;;PAGENo	
		mov ah, 2
		int 10h
		
		pop dx
		pop bx
		pop ax
	ENDM
		
	ColorPixel macro row, col
		push ax
		push dx
		push cx
		
		mov al, color
		mov cx, col
		mov dx, row
		mov ah, 0ch
		int 10h
		
		pop cx
		pop dx
		pop ax
		
	ENDM
	
	;;;;;;;;;;;;;;;;;;;;;;;To Print String prompts and messages;;;;;;;;;;;;;;;;;;;;;;
	PromptString macro prompt
		
		push dx
		push ax
		
		lea dx, prompt
		mov ah, 09h
		int 21h
		
		pop ax
		pop dx
		
	ENDM
	
	SetPageMode macro mode
		
		push ax
		
		mov ax, mode
		int 10h
		
		pop ax
		
	ENDM
	
	;;;;;;;;;;;;;;;;;;;For Getting the user input;;;;;;;;;;;;;;;;;;;;;
	GetString macro variable
	
		push dx
		push ax
		
		lea dx, variable
		mov ah, 0ah
		int 21h
		
		pop ax
		pop dx
		
	ENDM
	
	WriteChar macro char, pgNo, attribute
	
		push ax
		push cx
		push bx
		
		mov al, char
		mov bh, pgNo
		mov bl, attribute
		mov cx, 1
		mov ah, 09h
		int 10h
		
		pop bx
		pop cx
		pop ax
		
	ENDM

	VideoPage MACRO pgNo
		push ax
		mov pageNo, pgNo
		mov al, pgNo
		mov ah, 05h
		int 10h
		pop ax
	ENDM	
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;MAIN CODE;;;;;;;;;;;;;;;;;;;;
	MOV AX, @DATA
	MOV DS, AX
	
	StartingPoint:
	
	CALL Initialisation
	CALL SetUpScreen
	CALL Delay
	cmp EndAll, 01h
	je Exit1
	VideoPage 3
	SetPageMode 0013h
	CALL SetPageProp
	SetCursor 24, 32, 0
	PromptString Level1
	CALL CreateShooter
	CALL DrawMainPageLines				;;;;;;;;Contains Saik's code ( draw lines etc )
	
	InputLoop:
		CALL PowerFillSec
		CALL ModifyLevel
		cmp SmallGodDelay, 0000h
		jne NextJob
		CALL CheckForDevils	
		jmp RegularWork
		NextJob:
			dec SmallGodDelay			
			jmp RegularWork
		Exit1:
			jmp Exit
		RegularWork:
		CALL getInputAndCheck
		cmp input, 01h
		jz StartingPoint
		CALL PrintPoints
		CALL PrintLife
		
		mov frequency,1560
		
		CALL CheckClash
		CALL MoveOnScreenBullets
		
		push ax
		push cx
		
		mov ax, MainCounter
		mov cl, Level
		div cl
		cmp ah, 00h
		jne NoDevilMove
		cmp BigGodDelay, 0000h
		jne DecDelay
		CALL MoveOnScreenDemons
		cmp EndIfDemonHits, 01h
		jnz NoDevilMove
		pop cx
		pop ax
		SetPageMode 0003h
		jmp ExitWithChar
		DecDelay:
			dec BigGodDelay
		NoDevilMove:
			pop cx
			pop ax
			CALL CheckForEnd
			cmp EndGame, 01h
			je ExitWithChar
			jmp InputLoop
	ExitWithChar:
		CALL GetName
	jmp StartingPoint

	Exit:
		SetPageMode 0003h

		mov ax,4c00h 								;Returns control to DOS
		int 21h 									;HAS TO BE HERE! Program will crash without it!
;;;;;;;;;;;;;;;;;;;;;;;;;END MAIN CODE;;;;;;;;;;;;;;;
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Initialisation of All variables before New Game;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	Initialisation PROC
	
		push bx
		push cx
		
		mov bx, 0000h
		mov cx, 0064h
		ArrayLoopClear:
			mov BulletRowPositions[bx], 00h
			mov BulletColPositions[bx], 00h
			inc bx
			loop ArrayLoopClear
		
		mov bx, 0000h
		mov cx, 0005h
		ArrayLoopClear1:
			mov DevilRowPositions[bx], 00h
			mov DevilColPositions[bx], 00h
			inc bx
			loop ArrayLoopClear1
			
		mov MainCounter, 0000h
		mov NoOfBullets, 0000h
		mov Points, 0000h
		mov Life, 0005h

		mov input, 0
		mov EndGame, 0
		mov EndAll, 0
		mov Level, 02h
		mov DemonMov, 0001h
		
		mov ShooterColumn, 008ah
		mov PageNo, 0
		
		mov	Power1avail, 00h
		mov Power2avail, 00h
		mov Power3avail, 00h
		mov Power4avail, 00h
		
		mov BigGodDelay, 0000h
		mov SmallGodDelay, 0000h
		mov FourTimes, 0000h
		
		mov buffer, 0
		mov file_handle, 0
		mov top_x, 5
		mov top_y, 5
		mov pixel_col, 0
		mov pixel_row, 0
		mov godrow, 50
		mov godcolumn, 210
		mov powerbar, 0
		mov powerstatus, 0001
		mov dlay, 5
		mov speedcounter, 0
		mov frequency, 1560
		mov EndIfDemonHits, 00h
		mov HitPoint, 000ah
		
		pop cx
		pop bx
		
		RET
	Initialisation ENDP
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Modifies the speed of the Devils and the Hit Points based on the level;;;;;;;;;;;;;;;;;;;;;;;;
	ModifyLevel PROC
	
		cmp Points, 200
		jl midContLoop
		mov DemonMov, 0002h
		SetCursor 24, 32, 0
		PromptString Level2
		mov Level, 03h
		mov HitPoint, 000fh
		
		cmp Points, 500
		jl ContinueLoop
		mov DemonMov, 0002h
		mov Level, 02h
		SetCursor 24, 32, 0
		PromptString Level3
		mov HitPoint, 0014h
		
		jmp nextCheck11
		midContLoop:
			jmp ContinueLoop
			
		nextCheck11:
		cmp Points, 800
		mov DemonMov, 0003h
		mov Level, 04h
		SetCursor 24, 32, 0
		PromptString Level4
		mov HitPoint, 001eh
		
		ContinueLoop:
		RET
	ModifyLevel ENDP
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Function to Fill to Power Bar;;;;;;;;;;;;;;;;;;;;;;;;;;
	PowerFillSec PROC
		
		inc speedcounter
		push ax
		push bx
		mov ah,0
		mov al,200
		cmp speedcounter,al
		jl speed11
		mov speedcounter,ah
		
		speed11:
		
		mov bl,05
		
		mov al,speedcounter
		div bl
		cmp ah,00
		jne jumpedover
		CALL CheckPowerFill				;;;;;;;;Contains the call to powerfill
		jumpedover:
		pop bx
		pop ax
		
		RET
	PowerFillSec ENDP
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Draws the Borders and other lines in the Main Game Page;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	DrawMainPageLines PROC
	
		mov color, 84h
		mov lengthOfVertical,182
		mov dx,0002h
		mov di,1
		call DrawVertical
		
		mov color, 54h
		mov lengthOfVertical,182
		mov dx,010fh
		mov di,1
		call DrawVertical
		
		mov color, 0fh
		mov lengthOfHorizontal,320
		mov dx,0
		mov di,182
		call DrawHorizontal
		
		
		mov color, 0eh
		mov lengthOfHorizontal,124
		mov lengthofVertical,7
		mov dx,100					;;;(187,100)(193,100)(187,224)(193,224)
		mov di,187
		call DrawHorizontal
		call DrawVertical
		mov di,193
		call DrawHorizontal
		mov dx,224
		mov di,187
		call DrawVertical
		
		SetCursor 23, 3, 0
		PromptString power
		
		mov powerbar, 100
	
		RET
	DrawMainPageLines ENDP
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Checks for filled Power Bar and starts new Fills;;;;;;;;;;;;;;;;;;;;;;;;;;;
	CheckPowerFill PROC
		
		mov di,187
	
		mov ax,powerstatus
		mov bh,5
		mul bh
		
		mov bx,ax
		mov ax, MainCounter
		div bl
		
		cmp ah,2
		jne EndCheckFill
		
		cmp powerstatus,0005
		jg EndCheckFill
		
		CALL powerFill						;;;;;;;;Uncomment this line for PowerFill to work
		
		EndCheckFill:
		RET
	CheckPowerFill ENDP
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;To Get the Player's Name and to display the HighScores;;;;;;;;;;;;;;;;;;;;;;;;;
	GetName PROC
	
		push ax
		push cx
		push si
		
		CALL SetCursorType
		SetCursor 4, 3, 0
		WriteChar '+', 0, 0ah
		SetCursor 4, 6, 0
		PromptString PointString
		SetCursor 4, 15, 0
		mov ax, Points
		CALL PrintNumber
		
		cmp EndIfDemonHits, 01h
		jnz NoCrash
		SetCursor 10, 10, 0
		PromptString DevilhitShooter
		NoCrash:
		mov cx, Points
		cmp HScore, cx
		jge EndGetName
		mov HScore, cx
		CALL GetSec
		jmp EndGetName1
		
		EndGetName:
			SetCursor 6, 3, 0
			WriteChar '+', 0, 0ah
			SetCursor 6, 6, 0
			PromptString OldHighScore
			mov ax, HScore
			CALL PrintNumber
			EndGetNamelp:
				mov ax, 0000h
				int 16h
				mov cl, 'h'
				cmp al,  cl
				jnz EndGetNamelp
			
		EndGetName1:
			pop si
			pop cx
			pop ax
		RET
	GetName ENDP
	
	GetSec PROC
		push si
		push ax
		
		SetCursor 2, 8, 0
		PromptString HighScoreString
		SetCursor 6, 3, 0
		WriteChar '+', 0, 0ah
		SetCursor 6, 6, 0
		PromptString NameString
		
		GetAgain:
		mov cx, 50
		lea si, PlayerName
		loopClearChar:
			mov al, '$'
			mov [si], al
			inc si
			loop loopClearChar
		
		SetCursor 6, 15, 0
		GetString PlayerName
		lea si, PlayerName
		mov ax, 0000h
		mov al, PlayerName + 1
		cmp ax, 0000h
		je GetAgain
		EndGetNamelp1:
				mov ax, 0000h
				int 16h
				mov cl, 'h'
				cmp al,  cl
				jnz EndGetNamelp1
		
		pop ax
		pop si
		RET
	GetSec ENDP
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;Sets the Page mode and creates the Home Screen and other Pages;;;;;;;;;;;;;;;;;;;;;;;;
	SetUpScreen PROC
	
		SetPageMode 000dh
		
		VideoPage 0
		call CreateHomePage
		VideoPage 1
		call CreateINSTRUCTIONSpage
		VideoPage 2
		call CreateHIGHSCORESpage
		VideoPage 0
		Call Navigation
	
		RET
	SetUpScreen ENDP
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Navigation in the Home screen and other screens;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	Navigation PROC
	mov ch, 0
	mov cl, 10
	push cx
		Navi:
			cmp pageNo,0
			je PAGE_0
			JMP PAGE_12
		
			PAGE_0:
				pop cx
				SetCursor cl, 12, 0
				KeyPress:
					mov ah, 00h
					int 16h
						cmp al, 'w'		;;; CHECKING FOR 'W'
					jne Check_S
						cmp cl, 10
					je KeyPress
						SetCursor cl, 12, 0
						WriteChar ' ', 0, 0ah
						sub cl, 3
						SetCursor  cl, 12, 0
						WriteChar '*', 0, 0ah
					Check_S:
						cmp al, 's'		;;;; CECKING FOR 'S'
					jne Check_ENTER
						cmp cl, 19
					je KeyPress
						SetCursor cl, 12, 0
						WriteChar ' ', 0, 0ah
						add cl, 3
						SetCursor  cl, 12, 0
						WriteChar '*', 0, 0ah
					Check_ENTER:
						cmp al, 13
						jne ContinueKeyPress
						SetCursor cl, 14, 0
						mov bh, 0
						mov ah, 08h
						int 10h				;;;READING CHARACTER NEXT NEXT TO '*'
						cmp al, 'N'			;;;;IF 'N' JUMPS TO GAME PAGE
						je EndCheckNavigationmid
						;jne Check_INSTRUCTIONS	;;;;;IF 'I' JUMPS TO INSTRUCTIONS PAGE
						;PUSH CX					;;;;;;IF 'H' JUMPS TO HIGHSCORES PAGE	
						;VideoPage 3				;;;;;;IF 'Q' EXITS GAME
						;jmp Navi							
					Check_INSTRUCTIONS:			
						cmp al, 'I'
						jne Check_HIGHSCORES
						push cx
						VideoPage 1
						jmp Navi
					Check_HIGHSCORES:
						cmp al, 'H'
						jne Check_QUIT
						push cx
						VideoPage 2
						jmp Navi
					Check_QUIT:
						cmp al, 'Q'
						jne ContinueKeyPress
						mov EndAll, 01h
						jmp EndCheckNavigation
					ContinueKeyPress:
					jmp KeyPress
			
			EndCheckNavigationmid:
				jmp EndCheckNavigation
			PAGE_12:	
				mov cl, 6
				KeyPress_inst:
					mov ah, 00h
					int 16h
					cmp al, 13
					jne ContinueKeyPress_inst
					add cl, 2
					SetCursor 23, cl, pageNo
					mov bh, pageNo
					mov ah, 08h
					int 10h
					cmp al, 'H'
					jne Check_QUIT_inst
					VideoPage 0
					jmp Navi
				Check_QUIT_inst:
					cmp al, 'Q'
					jne ContinueKeyPress_inst
					mov EndAll, 01h
					jmp EndCheckNavigation
				ContinueKeyPress_inst:
				JMP KeyPress_inst	
		EndCheckNavigation:
	RET
	Navigation ENDP
	
;;;;;;;;;;;;;;;;;;;;;;GAME HOME PAGE
	CreateHomePage PROC
		
		SetCursor 1, 1, 0
				;;;PRINTING "GUIDE"
		mov cl, 3
		mov bx, 0
		printGUIDE:
			SetCursor 1, cl, 0
			mov dl, Guide[bx]
			WriteChar dl, 0, 03h
			inc cl
			inc bx
			cmp bx, 34
			jl printGUIDE
		
		SetCursor 10, 12, 0		;;; ROW(max 24), COL(max 38), PAGENo 
		WriteChar '*', 0, 0ah	;;; CHAR, PAGENo, COLOR
		
				;;;PRINTING "NEW GAME"
		mov cl, 14
		mov bx, 0
		printNEWGAME:
			SetCursor 10, cl, 0
			mov dl, NewGame[bx]
			WriteChar dl, 0, 0ch
			inc cl
			inc bx
			cmp bx, 8
			jl printNEWGAME
		
				;;;;;PRINTING  "INSTRUCTIONS"
		mov cl, 14
		mov bx, 0
		printINSTRUCTIONS:
			SetCursor 13, cl, 0
			mov dl, Instructions[bx]
			WriteChar dl, 0, 0ch
			inc cl
			inc bx
			cmp bx, 12
			jl printINSTRUCTIONS
			
				;;;;;PRINTING  "HIGH SCORES"
		mov cl, 14
		mov bx, 0
		printHIGHSCORES:
			SetCursor 16, cl, 0
			mov dl, HighScores[bx]
			WriteChar dl, 0, 0ch
			inc cl
			inc bx
			cmp bx, 10
			jl printHIGHSCORES

				;;;;;PRINTING  "QUIT"
		mov cl, 14
		mov bx, 0
		printQUIT:
			SetCursor 19, cl, 0
			mov dl, Quit[bx]
			WriteChar dl, 0, 0ch
			inc cl
			inc bx
			cmp bx, 4
			jl printQUIT
	
	RET
	CreateHomePage ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;CREATE INSTRUCTIONS PAGE
	CreateINSTRUCTIONSpage PROC
		mov cl, 13
		mov bx, 0			;;;;;PRINTING INSTRUCTIONS
		printINSTRUCTIONS_inst:
			SetCursor 1, cl, 1
			mov dl, Instructions[bx]
			WriteChar dl, 1, 0eh
			inc cl
			inc bx
			cmp bx, 12
			jl printINSTRUCTIONS_inst
			
		SetCursor 3, 3, 1
		WriteChar '+', 1, 0ah
		SetCursor 3, 5, 1
		PromptString Inst1
		
		SetCursor 5, 3, 1
		WriteChar '+', 1, 0ah
		SetCursor 5, 5, 1
		PromptString Inst2
		
		SetCursor 7, 3, 1
		WriteChar '+', 1, 0ah
		SetCursor 7, 5, 1
		PromptString Inst3
		
		SetCursor 9, 3, 1
		WriteChar '+', 1, 0ah
		SetCursor 9, 5, 1
		PromptString Inst4
		
		SetCursor 11, 3, 1
		WriteChar '+', 1, 0ah
		SetCursor 11, 5, 1
		PromptString Inst5
		
		SetCursor 13, 3, 1
		WriteChar '+', 1, 0ah
		SetCursor 13, 5, 1
		PromptString Inst6
		
		SetCursor 15, 3, 1
		WriteChar '+', 1, 0ah
		SetCursor 15, 5, 1
		PromptString Inst7
		
		SetCursor 17, 3, 1
		WriteChar '+', 1, 0ah
		SetCursor 17, 5, 1
		PromptString Inst8
		
		SetCursor 19, 3, 1
		WriteChar '+', 1, 0ah
		SetCursor 19, 5, 1
		PromptString Inst9
		
		SetCursor 21, 3, 1
		WriteChar '+', 1, 0ah
		SetCursor 21, 5, 1
		PromptString Inst10
		
		SetCursor 23, 6, 1
		WriteChar '*', 1, 0ah
		
		mov cl, 8
		mov bx, 0
		printHOMEPAGE_inst:		;;;;;;;;;;;PRINTING HOME PAGE
			SetCursor 23, cl, 1
			mov dl, HPage[bx]
			WriteChar dl, 1, 0ch
			inc bx
			inc cl
			cmp bx, 9
			jl printHOMEPAGE_inst			
		
	RET
	CreateINSTRUCTIONSpage ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;CREATE HIGHSCORES PAGE
	CreateHIGHSCORESpage PROC
						;;;;;PRINTING  "HIGH SCORES"
		mov cl, 14
		mov bx, 0
		printHIGHSCORES_score:
			SetCursor 1, cl, 2
			mov dl, HighScores[bx]
			WriteChar dl, 2, 0eh
			inc cl
			inc bx
			cmp bx, 10
			jl printHIGHSCORES_score
		
		cmp HScore, 0000h
		je Nohigh
		SetCursor 5, 3, 2
		MOV AH,09H
        LEA DX, PlayerName + 2
        INT 21H
		SetCursor 5, 18, 2
		WriteChar ':', 2, 0fh
		SetCursor 5, 20, 2
		mov ax, HScore
		CALL PrintNumber
		CALL HighScoreSec
		
		jmp nextprint
		Nohigh:
			SetCursor 5, 5, 2
			PromptString NoHighScore
		nextprint:
		SetCursor 23, 6, 2
		WriteChar '*', 2, 0ah
		
		mov cl, 8
		mov bx, 0
		printHOMEPAGE_score:		;;;;;;;;;;;PRINTING HOME PAGE
			SetCursor 23, cl, 2
			mov dl, HPage[bx]
			WriteChar dl, 2, 0ch
			inc bx
			inc cl
			cmp bx, 9
			jl printHOMEPAGE_score

	RET
	CreateHIGHSCORESpage ENDP
	
	HighScoreSec PROC
	
		SetCursor 11, 5, 2
		PromptString ImproveHs
		SetCursor 14, 2, 2
		WriteChar '+', 2, 0ah
		SetCursor 14, 4, 2
		PromptString Hint1
		SetCursor 16, 2, 2
		WriteChar '+', 2, 0ah
		SetCursor 16, 4, 2
		PromptString Hint2
		SetCursor 18, 8, 2
		PromptString Hint3
		SetCursor 20, 2, 2
		WriteChar '+', 2, 0ah
		SetCursor 20, 4, 2
		PromptString Hint4
	
		RET
	HighScoreSec ENDP
	
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Setting the Page Properties;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	SetPageProp PROC
			
		push ax
		push bx
		push cx
		push dx

		mov ax, 0600h
		mov bh, 00h
		mov cx, 0000h
		mov dx, 184fh
		int 10h
		
		pop dx
		pop cx
		pop bx
		pop ax
		
		RET
	SetPageProp ENDP
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; To Change the cursor type from default;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	SetCursorType PROC
	
		push cx
		push ax
		
		mov ch,0
		mov cl,7
		mov ah,1
		int 10h
		
		pop ax
		pop cx
		RET
	SetCursorType ENDP
	
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;To randomly generate devils;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	CheckForDevils PROC

	
		push bx
		push cx
		
		inc MainCounter
		cmp MainCounter, 00f9h
		jl DontLoopBack
		
		mov MainCounter, 0001h
		
		DontLoopBack:
		
		mov ah, 00h
		int 1ah
		
		push dx
		mov ax, dx	; dx has number of clock ticks
		mov bx, 001eh
		mov dx, 0000h
		div bx
		mov Randomwidth, dx
		pop dx
		
	;;;;;;;;;;;;Generating Random Number;;;;;;;;;;;
		mov ax, dx
		mov dx, 0000h
		mov bx, 0005h
		div bx
		
		mov bx, 0028h
		mov ax, dx
		mov dx, 0000h
		mul bx
		add cx, ax
		add cx, MainCounter
		mov ax, cx
		mov bx, 240
		div bx
		mov cx, dx
		
		
		cmp cx, 0028h
		je demon1
		
		cmp cx, 0050h
		je demon2
		
		cmp cx, 0078h
		je demon3
		
		cmp cx, 00a0h
		je demon4
		
		cmp cx, 00d8h
		je demon5
		
		jmp EndCheckDevils
		
		demon1:
				mov bx,0000h
				CALL PrintDevils
				jmp EndCheckDevils
		
		demon2:
				mov bx,0001h
				CALL PrintDevils
				jmp EndCheckDevils
		demon3:
				mov bx,0002h
				cmp RandomWidth, 001eh
				jl EndCheckDevils
				CALL PrintDevils
				jmp EndCheckDevils
		demon4:
		
				mov bx,0003h
				CALL PrintDevils
				jmp EndCheckDevils
		demon5:
		
				mov bx,0004h
				CALL PrintDevils
			
		EndCheckDevils:
			pop cx
			pop bx
			
		RET
	CheckForDevils ENDP
	
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;To paint the randomly generated devils;;;;;;;;;;;;;;;;;;;;;;;;;;
	PrintDevils PROC
	
		push di
		push bx
		push ax
		push dx
		
		mov di, 0001h
		mov cl, 00h
		cmp DevilColPositions[bx], cl
		jne demonexists
		
		mov cx, 0028h
		inc bx
		mov ax, bx
		mul cx
		
		mov dx, ax
		add dx, RandomWidth
		
		CALL CreateDevil
		
		demonexists: 
		
		pop dx			
		pop ax
		pop bx
		pop di
		RET
	PrintDevils ENDP
	
	PrintPoints PROC
	
		push ax
		
		mov ax, Points
		SetCursor 1, 0ebh, 0
		CALL PrintNumber
		
		pop ax
		
		RET
	PrintPoints ENDP
	
	PrintLife PROC
	
		push ax
		
		mov ax, Life
		SetCursor 3, 0ebh, 0
		CALL PrintNumber
		
		pop ax
		
		RET
	PrintLife ENDP
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Function to print the number stored in ax;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	PrintNumber PROC
	
		push dx
		push cx
		push bx
		push ax
			
		mov dx, 0000h
		mov cx, dx
		mov bx, 000ah
		StoreLoop:
			div bx
			push dx
			mov dx, 0000h
			inc cx
			cmp ax, 0000h
			jne StoreLoop
			
		PrintLoop:
			pop dx
			add dx, 030h
			mov ah, 02h
			int 21h
			loop PrintLoop
			
		pop ax
		pop bx
		pop cx
		pop dx
		
		RET
	PrintNumber ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Checks for the End of Game;;;;;;;;;;;;;;;;;;;;;;;;;;;
	CheckForEnd PROC
	
		push ax
		
		cmp Life, 0000h
		jne EndCheckLife
		SetPageMode 0003h
		mov EndGame, 01h
		
		EndCheckLife:
		pop ax
		
		RET
	CheckForEnd ENDP
	
	CreateShooter PROC
	
		mov color, 02h
		CALL DrawShooter
		
		RET
	CreateShooter ENDP
	
	VanishShooter PROC
	
		mov color, 00h
		CALL DrawShooter
		
		RET
	VanishShooter ENDP
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Function to Draw shooter;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	DrawShooter PROC
		
		push cx
		push di
		push dx
	

;;;;;;;;;;;;;;;;;;; ShooterDiagram;;;;;;;;;;;;;;;;;;;;;;
;
;				 --   --				The Rectangles Height is ShooterHalfHeight and Width is 0005h
;				_| |_| |_				The distance between Rectangles is 0006h and the distance of first rectangle from left pt is 0003h
;			   /         \ 				The BaseLength of the Trianlges is 000ah
;			  /    ___    \				The length of the Horizontal part is 00016h
;            /____|   |____\
;	
		mov lengthOfHorizontal, lengthOfShooter
		sub lengthOfHorizontal, 000ah
		mov cx, ShooterHalfHeight
		mov dx, ShooterColumn
		add dx, 0005h
		mov di, ShooterRow
		add di, cx
		
		dec cx
		loopDrawHorizontals:
			CALL DrawHorizontal
			add di, 01h
			loop loopDrawHorizontals
		
		sub dx, 0005h
		mov lengthOfHorizontal, 000ah
		inc di
		mov TriangleDir, -1
		CALL DrawTriangle
		
		add dx, lengthOfShooter
		sub dx, 000ah
		CALL DrawTriangle
		
		sub di, ShooterHalfHeight
		mov dx, ShooterColumn
		add dx, 0008h
		mov RectangleHeight, ShooterHalfHeight
		mov RectangleWidth, 0005h
		CALL DrawRectangle
		
		add dx, 000bh
		CALL DrawRectangle		
		
		pop dx
		pop di
		pop cx
		
		RET
	DrawShooter ENDP
	
	GetInputAndCheck PROC
	
		push ax
		push dx
		push cx
		push bx
		push di
		push si
		
		mov ah, 01h			;;;;;Checking for keystroke
		int 16h
		jnz CheckInput
		
		jmp EndCheck
		
		CheckInput:
			mov color,00h
			mov top_y,40
			mov top_x,011dh
		mov ah, 00h			;;;;;Removing keystroke from keyboard buffer
		int 16h
		
		mov dl, 'a'
		cmp al, dl
		jz moveLeft111
		
		mov dl, 'd'
		cmp al, dl
		jz moveRight111
		
		mov dl, 000dh
		cmp al, dl
		jz fireBullet111
		
		mov dl, 001bh
		cmp al, dl
		jz DelayTillNext
		
		mov dl, 'h'
		cmp al, dl
		jz ExitGame111
		
		mov dl, 'q'
		cmp al, dl
		jz Power1
		
		mov dl, 'w'
		cmp al, dl
		jz Power2
		
		mov dl, 'e'
		cmp al, dl
		jz Power3
		
		mov dl, 'r'
		cmp al, dl
		jz Power4
		
		jmp EndCheck
		
		DelayTillNext:
			CALL PauseFunc
			jmp EndCheck		
			
		Power4:
			CALL GodPower4
			push dx
			mov top_y,160
			lea dx,filename4
			mov color,00h
			CALL singleColorDraw
			pop dx
			jmp EndCheck
			
		Power3:
			CALL GodPower3
			mov top_y,120
			push dx
			lea dx,filename3
			CALL singleColorDraw
			pop dx
			jmp EndCheck
		
		fireBullet111:
			jmp fireBullet
			moveLeft111:	
			jmp moveLeft
		Power2:
			CALL GodPower2
			mov top_y,80
			push dx
			lea dx,filename2
			CALL singleColorDraw
			pop dx
			jmp EndCheck
			
		moveRight111:	
			jmp moveRight	
		
		
		
		Power1:
			CALL GodPower1
			push dx
			lea dx,filename1
			CALL singleColorDraw
			pop dx
			jmp EndCheck
		
		ExitGame111:
			jmp ExitGame
			
		moveLeft:
			cmp ShooterColumn, 0005h
			jle EndCheck
			CALL VanishShooter
			sub ShooterColumn, 0005h
			CALL CreateShooter
			jmp EndCheck
			
		moveRight:
			cmp ShooterColumn, 00eah
			jg EndCheck
			CALL VanishShooter
			add ShooterColumn, 0005h
			CALL CreateShooter
			jmp EndCheck
			
		fireBullet:
			CALL FireBullets
			mov si,6530
			mov frequency,si
			CALL putsound				
			jmp EndCheck
			
		ExitGame:
			mov input, 1
			
		EndCheck:
		
		pop si
		pop di
		pop bx
		pop cx
		pop dx
		pop ax
		RET
	GetInputAndCheck ENDP
	
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Function to Pause the Game;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	PauseFunc PROC

		push dx
		push ax
		
		InfiniteDelayLoop:
			mov ah, 01h			;;;;;Checking for keystroke
			int 16h
			jnz CheckInput1
			
			jmp InfiniteDelayLoop
			CheckInput1:
			
				mov ah, 00h			;;;;;Removing keystroke from keyboard buffer
				int 16h
				mov dl, 001bh
				cmp al, dl
				jz ReturnGame
			jmp InfiniteDelayLoop
			
		ReturnGame:
		pop ax
		pop dx

		RET
	PauseFunc ENDP
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Function to generate Bullets;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	FireBullets PROC
	
		mov dx, 0000h
		mov bx, NoOfBullets
		inc NoOfBullets
		
;;;;;;;;Bullet will be just above the Shooter immediately after it's fired;;;;;;;			
		mov cx, ShooterRow
		sub cl, 000ah
		mov BulletRowPositions[bx], cl
;;;;;;;;Generalized way of calculating mid column value of shooter;;;;;;;
		mov cx, ShooterColumn
		add cl, HalfShooterLength
		mov BulletColPositions[bx], cl
		
		mov di, 0000h
		mov ax, di
		
		mov al, BulletRowPositions[bx]                           
		mov di, ax
		mov dx, cx
		sub dx, HalfBulletBaseLength 
		
		CALL CreateBullet
		RET
	FireBullets ENDP
	
	CheckClash PROC
		
		push bx
		push ax
		push cx
		push dx
		push si
		
		cmp FourTimes, 0000h
		je StartChecking
		dec FourTimes
		
		StartChecking:
		mov si, 0000h
		mov ax, si
		
		LoopOverDevils:
			cmp si, 0005h
			jge EndCheckClash
	
			mov bx, 0000h
			LoopOverBullets:
				cmp bx, NoOfBullets
				jge NextDevil
				
				mov ah, DevilColPositions[si]
				mov al, DevilRowPositions[si]
				
				mov cl, BulletRowPositions[bx]
				mov ch, BulletColPositions[bx]
				sub cl, HalfBulletBaseLength
				
				add ch, HalfBulletBaseLength
				
				cmp ch, ah
				jl NextBullet
				
				sub ch, DevilWidth
				sub ch, BulletBaseLength
				
				cmp ch, ah
				jg NextBullet
				sub cl, DevilHeight
				
				mov ch, 00h
				mov ah, 00h
				cmp ax, cx
				jl NextBullet
				
				CALL ExtraPointsClash
				CALL putsound
				mov dx, 0000h
				mov di, dx
				mov ax, di
				
				mov dl, BulletColPositions[bx]
				sub dl, HalfBulletBaseLength
				mov al, BulletRowPositions[bx]
				mov di, ax
				
				CALL VanishBullet
				CALL MakeArrayChanges
				
				mov al, DevilRowPositions[si]
				mov di, ax
				mov dl, DevilColPositions[si]
				mov dh, 00h
				
				CALL VanishDevil
				
				mov DevilColPositions[si], 00h
				mov DevilRowPositions[si], 00h
				
				jmp DestroyedNext
				
				NextBullet:
					inc bx
					DestroyedNext:
						jmp LoopOverBullets
			
			NextDevil:
				inc si
				jmp LoopOverDevils
			
		
		EndCheckClash:
		pop si
		pop dx
		pop cx
		pop ax
		pop bx
	
		RET
	CheckClash ENDP
	
	ExtraPointsClash PROC
	
		push ax
		push cx
		
		cmp FourTimes, 0000h
		je NoExtraPoints
		mov ax, HitPoint
		mov cx, 0003h
		mul cx
		add Points, ax
		NoExtraPoints:
		mov ax, HitPoint
		add Points, ax
		
		pop cx
		pop ax
	
		RET
	ExtraPointsClash ENDP
	
	putsound PROC
		push ax
		push bx
		push cx
		
		
			mov     al, 182         ; Prepare the speaker for the
			out     43h, al         ;  note.
			mov     ax, frequency        ; Frequency number (in decimal)
									;  for middle C.
			out     42h, al         ; Output low byte.
			mov     al, ah          ; Output high byte.
			out     42h, al 
			in      al, 61h         ; Turn on note (get value from
									;  port 61h).
			or      al, 00000011b   ; Set bits 1 and 0.
			out     61h, al         ; Send new value.
			mov     bx, 25          ; Pause for duration of note.
		.pause1:
			mov     cx, 655
		.pause2:
			dec     cx
			jne     .pause2
			dec     bx
			jne     .pause1
			in      al, 61h         ; Turn off note (get value from
									;  port 61h).
			and     al, 11111100b   ; Reset bits 1 and 0.
			out     61h, al         ; Send new value.
		
		
		pop cx
		pop bx
		pop ax
		RET
	putsound ENDP
	
	putsound1 PROC
		push ax
		push bx
		push cx
		
			mov frequency,5634
			mov     al, 182         ; Prepare the speaker for the
			out     43h, al         ;  note.
			mov     ax, frequency        ; Frequency number (in decimal)
									;  for middle C.
			out     42h, al         ; Output low byte.
			mov     al, ah          ; Output high byte.
			out     42h, al 
			in      al, 61h         ; Turn on note (get value from
									;  port 61h).
			or      al, 00000011b   ; Set bits 1 and 0.
			out     61h, al         ; Send new value.
			mov     bx, 25          ; Pause for duration of note.
		.pause11:
			mov     cx, 10055
		.pause22:
			dec     cx
			jne     .pause22
			dec     bx
			jne     .pause11
			in      al, 61h         ; Turn off note (get value from
									;  port 61h).
			and     al, 11111100b   ; Reset bits 1 and 0.
			out     61h, al         ; Send new value.
		
		
		pop cx
		pop bx
		pop ax
		RET
	putsound1 ENDP
	
	MoveOnScreenBullets PROC
		
		push cx
		push bx
		push di
		push dx
		push ax
		
		CALL Delay
		
		mov bx, 0000h
		mov cx, NoOfBullets
		
		MoveBullet:
		
			cmp bx, cx
			jge EndMove
			
			mov di, 0000h
			mov ax, di
			mov dx, di      
			      
			mov al, BulletRowPositions[bx]
			mov di, ax
			mov dl, BulletColPositions[bx]
			sub dl, HalfBulletBaseLength
			CALL VanishBullet
			
			cmp di, 1
			je ChangeAndNext
			
			dec di
			mov ax, di
			mov BulletRowPositions[bx], al
			CALL CreateBullet			
			inc bx
			jmp MoveBullet
			
			ChangeAndNext:
				CALL MakeArrayChanges
				mov cx, NoOfBullets
				jmp MoveBullet
			
		EndMove:

		pop ax
		pop dx
		pop di
		pop bx
		pop cx
		RET
	MoveOnScreenBullets ENDP
	
	MoveOnScreenDemons PROC
		
		push cx
		push bx
		push di
		push dx
		push ax
		push si
		
		mov bx, 0000h
		mov cx, 0005h
		
		MoveDemon:
		
			cmp bx, cx
			jge EndMove1
			
			cmp DevilColPositions[bx], 00h
			je incrementingdemon
			
			mov di, 0000h
			mov ax, di
			mov dx, di      
			      
			mov al, DevilRowPositions[bx]
			mov di, ax
			mov dl, DevilColPositions[bx]
			CALL VanishDevil
			
			mov si, ShooterRow
			sub si, DevilHeight
			inc si
			sub si, DemonMov
			cmp di, si
			jge ChangeAndNext1
			add di, DemonMov
						
			CALL CreateDevil			
			
			incrementingdemon:
				inc bx
				jmp MoveDemon
			
			ChangeAndNext1:
				dec Life
				call putsound1
				CALL CheckForDevilHit
				cmp EndIfDemonHits, 01h
				jz EndMove1
				mov DevilRowPositions[bx],0000h
				mov DevilColPositions[bx],0000h
				inc bx
				jmp MoveDemon
			
		EndMove1:

		pop si
		pop ax
		pop dx
		pop di
		pop bx
		pop cx
		RET
	MoveOnScreenDemons ENDP
	
	CheckForDevilHit PROC
	
		push ax
		push cx
		
		mov ax, 0000h
		mov cx, ax
		
		mov al, DevilColPositions[bx]
		mov cx, ShooterColumn
		add ax, DevilWidth
		cmp cx, ax
		jg NoCrash1
		
		sub ax, DevilWidth
		add cx, lengthOfShooter
		
		cmp cx, ax
		jl NoCrash1
		mov EndIfDemonHits, 01h
		
		NoCrash1:	
		pop cx
		pop ax
		RET
	CheckForDevilHit ENDP
	
	MakeArrayChanges PROC
	
		push bx
		push si
		push dx
		
		mov si, bx
		inc si
		CopyLoop:
			cmp si, NoOfBullets
			jg EndChange
			mov dl, BulletRowPositions[si]
			mov BulletRowPositions[bx], dl
			mov dl, BulletColPositions[si]
			mov BulletColPositions[bx], dl
			inc si
			inc bx
			jmp CopyLoop
					
		EndChange:
			dec NoOfBullets
			
		pop dx
		pop si
		pop bx
		
		RET
	MakeArrayChanges ENDP
	
	CreateBullet PROC
		
		mov color, 05h
		CALL DrawBullet
		
		RET
	CreateBullet ENDP
	
	VanishBullet PROC
	
		mov color, 00h
		CALL DrawBullet
				
		RET
	VanishBullet ENDP
	
;;;;;;;;;;;;;;;dx has column number and di has the row number of the left bottom pt of the triangle;;;;;;;;;;;;;

	DrawBullet PROC
		
		push cx
		push dx
		push di
		
		mov lengthOfHorizontal, BulletBaseLength
		mov TriangleDir, -1
		CALL DrawTriangle
		
		mov lengthOfHorizontal, BulletBaseLength
		sub lengthOfHorizontal, 0002h
		inc dx
		add di, 0003h
		mov cx, 0003h
		DrawLines:
			CALL DrawHorizontal
			add di, 0002h
			loop DrawLines
			
		pop di
		pop dx
		pop cx
				
		RET
	DrawBullet ENDP
	
;;;;;;;;;;;;;;;;;;;;;dx has left base column number and di has the left base row number;;;;;;;;;;;;;;;;;;;

	DrawTriangle PROC
	
		push dx
		push di
		push cx
		push lengthOfHorizontal
		
		DrawInclined:
			CALL DrawHorizontal
			inc dx
			add di, TriangleDir
			mov cx, lengthOfHorizontal
			sub cx, 0002h
			mov lengthOfHorizontal, cx
			cmp cx, 0000h
			jg DrawInclined
		
		pop lengthOfHorizontal
		pop cx
		pop di
		pop dx
		
		RET
	DrawTriangle ENDP
	
	CreateDevil PROC
	
		mov color, 4
		CALL DrawDevil
		
		RET
	CreateDevil ENDP
	
	VanishDevil PROC
	
		mov color, 0
		CALL DrawDevil
		
		RET
	VanishDevil ENDP

;;;;;;;;;;;;;;;;;;;;dx has the left top column no and di has the left top row no;;;;;;;;;;;;;;;;;;;;;	
	
	DrawDevil PROC
	
		push di
		push dx
		push ax
		push bx
		
		CALL FindIndex
		
		mov ax, 0000h
		mov ax, di
		mov DevilColPositions[bx], dl
		mov DevilRowPositions[bx], al
		
		add dx, 0006h
		add di, 0002h
		mov RectangleHeight, 0002h
		mov RectangleWidth, 0004h
		CALL DrawRectangle
		
		add di, 0002h
		sub dx, 0004h
		mov RectangleWidth, 000ch
		CALL DrawRectangle
		
		add di, 0002h
		sub dx, 0002h
		mov RectangleWidth, 0010h
		CALL DrawRectangle
		
		add di, 0002h
		mov RectangleWidth, 0004h
		CALL DrawRectangle
		add dx, 0007h
		mov RectangleWidth, 0002h
		CALL DrawRectangle
		add dx, 0005h
		mov RectangleWidth, 0004h
		CALL DrawRectangle
		
		add di, 0002h
		sub dx, 000ch
		mov RectangleWidth, 0010h
		CALL DrawRectangle
		
		add dx, 0004h
		add di, 0002h
		mov RectangleWidth, 0003h
		CALL DrawRectangle
		add dx, 0005h
		CALL DrawRectangle
		
		add di, 0002h
		sub dx, 0006h
		CALL DrawRectangle
		add dx, 0007h
		CALL DrawRectangle
		
		add dx, 0003h
		add di, 0002h
		CALL DrawRectangle
		sub dx, 000dh
		CALL DrawRectangle
		
		sub di, 0002h
		add dx, 0007h
		mov RectangleWidth, 0002h
		CALL DrawRectangle
				
		pop bx
		pop ax
		pop dx
		pop di
		RET
	DrawDevil ENDP
	
	;;;;;;;;;;;;;;;;dx has the left bottom column and di has the left bottom row number;;;;;;;;;;;;;;;;;;;

	DrawRectangle PROC
	
		push di
		push dx
		push cx
		push bx
		
		mov cx, RectangleHeight
		mov bx, RectangleWidth
		mov lengthOfHorizontal, bx
		Drwline:
			CALL DrawHorizontal
			dec di
			loop Drwline
				
		pop bx
		pop cx
		pop dx
		pop di
		
		RET
	DrawRectangle ENDP
	
;;;;;;;;;;;;;;;dx has the bottom column and di has the bottom Row and MajorDia decides the angle : 1 for Minor Diagonal and -1 for Major Diagonal;;;;;;;;;;;;

	DrawInclinedLine PROC
	
		push di
		push dx
		push cx
		
		mov cx, InclinedLength
		inc cx
		loopInc:
			ColorPixel di, dx
			dec di
			add dx, MajorDia
			loop loopInc
		
		pop cx	
		pop dx
		pop di
		RET
	DrawInclinedLine ENDP
	
;;;;;;;;;;;;;;;;dx is the Initial Column number  di is the Initial Row Number ;;;;;;;;;;;;;;;;;;;;;;;
		
	DrawHorizontal PROC
		push dx
		push cx
		
		mov cx, dx
		add cx, lengthOfHorizontal
		colorHorizontal:
			ColorPixel di, dx
			add dx, 1
			cmp dx, cx
			jl colorHorizontal
		
		pop cx
		pop dx    
		RET
	DrawHorizontal ENDP
	
	DrawVertical PROC	      
		push di
		push cx
		
		mov cx, di
		add cx, lengthOfVertical

		colorVertical:
			ColorPixel di, dx
			add di, 0001h
			cmp di, cx
			jl colorVertical
		
		pop cx
		pop di
		
		RET
	DrawVertical ENDP
	
	ClearLine PROC
		
		push ax
		push cx
		push dx
		
		SetCursor rowToclear, 0, 0
		mov cx, 39
		Clear:
			mov dx, 0020h
			mov ah, 02h
			int 21h
			loop Clear
		
		SetCursor rowToclear, 0, 0
		pop dx
		pop cx
		pop ax
		
		RET
	ClearLine ENDP
	
	Delay PROC
	
		push cx
		push dx
		
		mov dx, 0000h
		delay1:
			mov cx, 0000h
			delay2:
				inc cx
				cmp cx, 900
				jnz delay2
			inc dx
			cmp dx, 15
			jnz delay1
			
		pop dx
		pop cx
		
		RET
		
	Delay ENDP
	
	FindIndex PROC
	
		push ax
		push dx
		
		mov bx, 0000h
		
		mov ax, dx
		mov dl, 0028h
		div dl
		
		mov bl, al
		dec bl
		
		pop dx
		pop ax
		RET
	FindIndex ENDP
	
;;;;;;;;;;;;;;;;;;I didnt change anything after this.. It got struck for me once.. Check once;;;;;;;;;;;;;;;;;;;;;;;;

	;;;;;;;;;;;;;;;;;End of Main Code;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;PROCEDURE FOR CLEARING POWER BAR 
	clearPower PROC
		push bx
		push di
		push dx
		mov color,00h
		mov lengthOfHorizontal,122
		mov bx,102
		mov di,188
		ClearLoop:
		mov dx,bx
		call DrawHorizontal
		inc di
		mov dx,bx
		call DrawHorizontal
		cmp di,192
		jl ClearLoop
		
		pop dx
		pop di
		pop bx
	RET
	clearPower ENDP
	;;;;;;;;;;;PROCEDURE FOR FILLING POWER BAR 
	powerFill PROC
		push ax
		push bx
		push cx
		push dx
		push dlay
		
		mov lengthOfVertical,5
		add di,1
		mov color,0ah
		mov bx,powerbar
		
		cmp bx,224
		jge fill
		add bx,1
		
			mov dx,bx
			call DrawVertical
		;delay11:	     ;;CHANGE VALUES OF CX DX TO CHANGE DELAY IN TIME
			;mov cx,07h     ;;;(cx dx)-&gt;(000f 4240) -&gt; 1,000,000 for 1 sec delay
			;mov dx,41248  ;;;;HERE EVERY LOOP ADDS 30SEC EXTRA
			;mov ah,86h
			;int 15h
			;inc dlay
			;cmp dlay,6
			;jl delay11
			pop dlay
			push dlay
			add bx,1
			;cmp bx,224
			;jl fill
		
		mov powerbar,bx	
		jmp filled
		fill:
			cmp powerstatus,5
			je dontclearbar
			call clearPower
			
			dontclearbar:
			
			call drawgod
			mov bx,40
			add godrow,bx
			inc powerstatus
			mov powerbar,100
		filled :
		pop dlay
		pop dx
		pop cx
		pop bx
		pop ax
	RET
	powerFill ENDP
	
	
	;; takes as input : powerstatus to determine which god to draw
	;; row, column to determine where to draw the god
	;; opens file and  draws according to that
	drawgod PROC
		push dx
		push  bx
		push ax
		mov bx,011dh
		mov top_x,bx
		
		mov bx,powerstatus
		mov ax,40
		mul bx
		mov top_y,ax
		
		cmp powerstatus,0001
		je god1
		
		cmp powerstatus,0002
		je god2
		
		cmp powerstatus,0003
		je god3
		
		cmp powerstatus,0004
		je god4
		
		jmp donewiththis
		
		god4:
		lea dx,filename4
		mov Power4avail,01h
		mov color,0076h
		CALL singleColorDraw
		jmp donewiththis
		
		god1:
			lea dx,filename1
			mov Power1avail,01h
			mov color,004eh
		CALL singleColorDraw
		jmp donewiththis
		
		god2:
			lea dx,filename2
			mov Power2avail,01h
			mov color,003dh
		CALL singleColorDraw
		jmp donewiththis
		
		god3:
			lea dx,filename3
			mov Power3avail,01h
			mov color,0073h
		CALL singleColorDraw
		
		donewiththis:
		pop ax
		pop bx
		pop dx
		RET
	drawgod ENDP
	
	
;	comment/*
 ;   Reads from file dx and draws from (top_x,top_y)
  ;  Requires color to be set to the pixel color to be drawn
;/*
	singleColorDraw proc near
		mov cx,top_x
		mov pixel_col,cx
		
		inc pixel_col
		mov cx, top_y
		mov pixel_row,cx
				
		mov al,0        
		mov ah,3dh
		int 21h
			
		jc ret_
		mov file_handle,ax
			
		read:
		mov bx,file_handle    
		mov dx,offset buffer
		mov al,0
		mov cx,1
		mov ah,3Fh
		int 21h

		mov dx,buffer 
		cmp dx,'1'
		jne newline
				
		CALL DrawPixel
		jmp cont
		newline:
		cmp dx,10
		jne cont
					
		mov dx,top_x
		mov pixel_col,dx
		inc pixel_row

		cont:
		inc pixel_col
		cmp ax,0
		jne read
		
		ret_:
		mov al,0
		mov ah,3Eh
		int 21h
		
		ret
	singleColorDraw endp

	DrawPixel PROC
		push ax
		push bx
		push cx
		push dx

		mov al, color
		mov cx, pixel_col
		mov dx, pixel_row
		mov ah, 0ch
		int 10h

		pop dx
		pop cx
		pop bx
		pop ax

	RET
	DrawPixel ENDP
	
;;;;;;;Freezing all the devils for some time;;;;;;;;;;;;;;;	

	GodPower1 PROC
	
		cmp Power1avail, 00h
		je DontCheat1
		cmp Power1avail, 02h
		je DontCheat1
		mov Power1avail, 02h
		mov BigGodDelay, 00ffh
		DontCheat1:
			RET
	GodPower1 ENDP

	GodPower2 PROC
		
		push bx
		push cx
		push dx
		push di
		push ax
		
		cmp Power2avail, 00h
		je DontCheat2
		cmp Power2avail, 02h
		je DontCheat2
		mov Power2avail, 02h
		mov SmallGodDelay, 002fh
		mov bx, 0000h
		mov dx, bx
		mov di, dx
		mov ax, di
		mov cx, 0005h
		ClearDevil:
			cmp DevilRowPositions[bx], 00h
			je NoPoint
			cmp FourTimes, 0000h
			je NoFour
			push cx
			mov ax, HitPoint
			mov cx, 0003h
			mul cx
			add Points, ax
			pop cx
			NoFour:
			mov ax, HitPoint
			add Points, ax
			mov ax, 0000h
			mov al, DevilRowPositions[bx]
			mov di, ax
			mov dl, DevilColPositions[bx]
			CALL putsound
			CALL VanishDevil
			NoPoint:
			mov DevilRowPositions[bx], 00h
			mov DevilColPositions[bx], 00h
			inc bx
			loop ClearDevil
			
		DontCheat2:
		
		pop ax
		pop di
		pop dx
		pop cx
		pop bx
		RET
	GodPower2 ENDP
	
	GodPower3 PROC
		
		cmp Power3avail, 00h
		je DontCheat3
		cmp Power3avail, 02h
		je DontCheat3
		mov Power3avail, 02h
		mov FourTimes, 03ffh
		DontCheat3:
		RET
	GodPower3 ENDP
	
	GodPower4 PROC
		
		cmp Power4avail, 00h
		je DontCheat4
		cmp Power4avail, 02h
		je DontCheat4		
		mov top_x,011dh		
		mov Power4avail, 02h
		
		mov top_y,40
		lea dx,filename1
		mov color,004eh
		CALL singleColorDraw
		mov Power1avail, 01h
		
		mov top_y,80
		lea dx,filename2
		mov color,003dh
		CALL singleColorDraw
		mov Power2avail, 01h
		
		mov top_y,120
		lea dx,filename3
		mov color,0073h
		CALL singleColorDraw
		mov Power3avail, 01h
		
		DontCheat4:
		RET
	GodPower4 ENDP

END START
