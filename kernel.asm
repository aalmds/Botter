org 0x7E00
jmp 0x0000:start

%macro setter 3
    mov ah, 0xb  
	mov bh, 0     
	mov bl, %1 		;Screen color
	int 10h	

	mov ah, 02h
	mov bh, 00h
	mov dh, 08h
	mov dl, %2
	int 10h

	mov bl, %3 		;Letter color
%endmacro

lumus db 'LUMUS MAXIMA', 0
title db 'BOTTER', 0
begin db 'Pressione enter para iniciar o quiz',13

delay:
	mov bp, 1000
	mov dx, 1000

	delay2:
		dec bp
		;nop
		jnz delay2

	dec dx
	jnz delay2
ret

delay3:
	mov bp, 1000
	mov dx, 1000

	delay4:
		dec bp
		nop
		jnz delay4

	dec dx
	jnz delay4
ret

resetc:
;Setting the cursor to top left-most corner of lumus
	mov dx, 0 
    mov bh, 0      
    mov ah, 0x2
    int 0x10
ret

clean:
;Cleaning the lumus
    call resetc

    delete:
    ;Printing 2000 characteres
    mov cx, 2000 
    mov bh, 0
    mov al, 0x20
    mov ah, 0x9
    int 0x10
    
    call resetc
ret

pscreen:
	lodsb
	mov ah, 0xe
	mov bh, 0
	int 10h
	cmp al, 13
	jne pscreen
ret

pstr: 
	lodsb
	cmp al,0
	je .end

	mov ah, 0xe
	int 10h	

	call delay 
	jmp pstr

	.end:
    	ret

start:
    ;xor ax, ax
    ;mov es, ax
    ;mov ds, ax
    ;mov ah, 0
	;mov al, 12h
	;int 10h
	
	setter 0, 34, 14
	mov si, lumus
	call pstr
    call clean

    setter 6, 34, 5 
	call delay

    setter 4, 34, 14
	call delay

    setter 12, 34, 15
    call delay

	setter 14, 34, 15
    call delay

	setter 0, 34, 15
    call delay

    setter 9, 35, 15
    mov si, title
    call pstr
    call delay

    mov  dl, 22
    mov  dh, 15
	mov  bh, 0
	mov  ah, 02h
	int  10h
    mov si, begin
    call pscreen

cmpendl:
  	mov ah, 0x00
  	int 16h
	cmp al, 0x0d
	je .end
	jmp cmpendl

	.end:  
		call delay3

load:
	mov ax, 0x860		;0x860<<1 + 0 = 0x8600
	mov es, ax
	xor bx, bx

	;Setting RAM position
	mov ah, 0x02
	mov al, 8	
	mov dl, 0	

	;Setting memory positions
	mov ch, 0
	mov cl, 7
	mov dh, 0	
	int 13h
	jc load			;If ERROR, tries again
	jmp 0x8600 