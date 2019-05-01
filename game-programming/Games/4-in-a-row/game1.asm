.model small
.stack 1000h
assume ds: data1,cs:code1
data1 segment
        play db "enter your move : $"
        play_len  equ ($ - play)
        enter db 0ah, '$'
        welcome db "welcome to the best game!! $"
        row dw 0
        row1 db 0
        column1 db 0
        column dw 0
        enter1 db 0ah,'$'
        input db 10,0,10 dup('$')
        player_flag dw 1                        ; 1 denotes player 1 and 2 denotes player 2
        col_play dw 0                           ; column number entered by user at each turn
        flag dw 0
                
data1 ends

code1 segment
vertical_line macro row1,col,length                              ;; macro which draws a vertical line
        local label
        
        push cx
        mov bx,length
        mov cx, col                                             ; int 10h requires cx to have the column which you want to paint
	
	label:
	        mov al, 02h                                   ; al stores the colour
		mov dx,row1
		dec dx                                          ; starts at 39 so that it draws from pixel 40 to 59
	        add dx ,bx                                      ; int 10h requires dx to have the row which you want to paint
	        mov ah, 0ch
	        int 10h                                          ;set pixel. 
	        dec bx
	        cmp bx,0
	jne label
        pop cx
        
    
endm

horz_line macro row1,col,length                              ;; macro which draws a vertical line
        local label
        push cx
        mov bx,length
        mov dx, row1                                             ; int 10h requires dx to have the row which you want to paint
	
	label:
	        mov al, 02h                                   ; al stores the colour
		mov cx,col
		dec cx                                         ; starts at 39 so that it draws from pixel 40 to 59
	        add cx ,bx                                      ; int 10h requires cx to have the column which you want to paint
	        mov ah, 0ch
	        int 10h                                          ;set pixel. 
	        dec bx
	        cmp bx,0
	jne label
    
        pop cx
endm




start:mov ax,seg data1
        mov ds,ax
        mov al,13h                                     ;13h for graphics mode and 03h is text mode
	mov ah, 0
	int 10h 
	
	;; cells each 20*20. totally 36 cells.
	;; starting coordinate is 40,40
	;; ending is 159,159
	
	
	mov cx,7
	mov si,40
	grid1 :
	               
	        vertical_line 40,si,120
	        horz_line si,40,120
	        add si,20
	        
	loop grid1
	
	mov row1,2
	mov column1,3
	call move_cursor 
	    
	lea dx,welcome                            ; display string
        mov ah,09h
        int 21h
	;;welcome string put
	
	mov row1,22
	mov column1,4
	call move_cursor 
	    
	lea dx,play                            ; display string
        mov ah,09h
        int 21h
	;;user prompt string put
	
	;;take user input
	mov row1,22
	mov column1,22
	call move_cursor
	
	lea dx,input
	mov ah,0ah
	int 21h
	
	
	call parse                                    ;;parse the input
	;;;make move
	;;; check winning condition
	
	
	mov row,4
	mov column,5
	call cross1
	
	mov row,2
	mov column,3
	call cross2
	
	
	
	mov ah, 1h
	int 21h

        mov ah,4ch                              ; to exit from program
        int 21h
        


        
        
       
        
         cross1 proc                              ;; procedure to put a cross at cell(row,column)
                        push cx
                        push bx
                        push ax
                        push dx
                        ;; column cell starts at pixel 20 + 20*c
                        mov cx,20                                             ; int 10h requires cx to have the column which you want to paint
	                mov ax,column
	                mov bx,20
	                mul bx
	                add cx,ax
	                
	                ;; row cell starts at pixel 40 + 20*r
                        mov dx,40                                             ; int 10h requires dx to have the row which you want to paint
	                mov ax,row
	                inc ax
	                mov bx,20
	                mul bx
	                add dx,ax
	                         
	                mov bx,0                                
	                label4:
	                        mov al, 09h                                   ; al stores the colour
		                inc dx
		                inc cx                                      ; int 10h requires dx to have the row which you want to paint
	                        mov ah, 0ch
	                        int 10h                                          ;set pixel. 
	                        inc bx
	                        cmp bx,20
	                jne label4
                        
                        
                        
                        ;; column cell starts at pixel 20 + 20*c
                        mov cx,40                                             ; int 10h requires cx to have the column which you want to paint
	                mov ax,column
	                mov bx,20
	                mul bx
	                add cx,ax
	                
	                ;; row cell starts at pixel 40 + 20*r
                        mov dx,40                                             ; int 10h requires dx to have the row which you want to paint
	                mov ax,row
	                inc ax
	                mov bx,20
	                mul bx
	                add dx,ax
	                         
	                mov bx,0                                
	                label5:
	                        mov al, 09h                                   ; al stores the colour
		                inc dx
		                dec cx                                      ; int 10h requires dx to have the row which you want to paint
	                        mov ah, 0ch
	                        int 10h                                          ;set pixel. 
	                        inc bx
	                        cmp bx,20
	                jne label5
                        
                        
                        pop dx
                        pop ax
                        pop bx
                        pop cx
        
        ret
        cross1 endp
        
        
        cross2 proc                              ;; procedure to put a cross at cell(row,column)
                        push cx
                        push bx
                        push ax
                        push dx
                        ;; column cell starts at pixel 20 + 20*c
                        mov cx,20                                             ; int 10h requires cx to have the column which you want to paint
	                mov ax,column
	                mov bx,20
	                mul bx
	                add cx,ax
	                
	                ;; row cell starts at pixel 40 + 20*r
                        mov dx,40                                             ; int 10h requires dx to have the row which you want to paint
	                mov ax,row
	                inc ax
	                mov bx,20
	                mul bx
	                add dx,ax
	                         
	                mov bx,0                                
	                label6:
	                        mov al, 04h                                   ; al stores the colour
		                inc dx
		                inc cx                                      ; int 10h requires dx to have the row which you want to paint
	                        mov ah, 0ch
	                        int 10h                                          ;set pixel. 
	                        inc bx
	                        cmp bx,20
	                jne label6
                        
                        
                        
                        ;; column cell starts at pixel 20 + 20*c
                        mov cx,40                                             ; int 10h requires cx to have the column which you want to paint
	                mov ax,column
	                mov bx,20
	                mul bx
	                add cx,ax
	                
	                ;; row cell starts at pixel 40 + 20*r
                        mov dx,40                                             ; int 10h requires dx to have the row which you want to paint
	                mov ax,row
	                inc ax
	                mov bx,20
	                mul bx
	                add dx,ax
	                         
	                mov bx,0                                
	                label7:
	                        mov al, 04h                                   ; al stores the colour
		                inc dx
		                dec cx                                      ; int 10h requires dx to have the row which you want to paint
	                        mov ah, 0ch
	                        int 10h                                          ;set pixel. 
	                        inc bx
	                        cmp bx,20
	                jne label7
                        
                        
                        pop dx
                        pop ax
                        pop bx
                        pop cx
        
        ret
        cross2 endp
        
        
        move_cursor proc
         
                        push ax
                        push bx
                        push dx
                        mov dh, row1                                     ; row number
                        mov dl, column1                                  ; column numnber
                        mov bh, 0                                       ; page number
                        mov ah, 2
                        int 10h
        
                        
                        pop dx
                        pop bx
                        pop ax
    
        ret
        move_cursor endp
        
        
        
        parse proc
                        push ax
                        push bx
                        push cx
                        push dx
                        ;;while not ($ or 13h) find length                        
                        mov cx,1;                       ;; cx has current character number
                        lea si,input                    ;; si has pointer to current character
                        mov flag,0
                        check :
                                        mov bx,13h
                                        cmp [si],bx
                                        je over
                                        
                                        mov bx,'$'
                                        cmp [si],bx
                                        je over          
                                        
                                        call isvalid
                                        inc cx
                                        inc si
                        jmp check
                        
                        over :
                                        cmp flag,0
                                        jne over1                
                                
                                        mov row,5
                                        mov bx,col_play
                                        mov column,bx
                                        call cross1
                        
                        over1:
                        
        
        
                        pop dx
                        pop cx
                        pop bx
                        pop ax
        ret
        parse endp
        
        isvalid proc
                        push ax
                        push bx
                        
                        cmp cx,5
                        jg invalid
                        
                        
                        cmp cx,1                        ;; checks condition for first character
                        jne check2
                        
                        mov bx,'p'
                        cmp [si],bx
                        jne invalid
                        
                        jmp valid
                        
                        
                 check2:
                        cmp cx,2                        ;; checks condition for second character
                        jne check3
                        
                        mov bx,2
                        cmp [si],bx
                        jg invalid
                        
                        mov bx,0
                        cmp [si],bx
                        jl invalid
                        
                        mov bx,player_flag
                        cmp [si],bx
                        je invalid
                        
                        mov bx,[si]
                        mov player_flag,bx
                        
                        jmp valid
                   
                        
                        
                   
                 check3:
                        cmp cx,3                        ;; checks condition for third character
                        jne check4
                        
                        mov bx,' '
                        cmp [si],bx
                        jne invalid
                                 
                        jmp valid                   
                 
                 
                 check4:  
                        cmp cx,4                        ;; checks condition for fourth character
                        jne check5
                        
                        mov bx,'c'
                        cmp [si],bx
                        jne invalid
                          
                        jmp valid
                 
                 check5:
                                                ;; checks condition for first character
                        mov bx,6                       
                        cmp [si],bx
                        jg invalid
                   
                        mov bx,0
                        cmp [si],bx
                        jl invalid
                        
                        mov bx,[si]
                        mov col_play,bx
                        jmp valid
                        
                        
                        
                        
                        
                        invalid :       mov flag,1                      ; 1 denotes invalid
                        
                        
                        valid :         
                        
                        pop bx
                        pop ax
        ret
        isvalid endp        
        
        
        
        code1 ends
        end start	
