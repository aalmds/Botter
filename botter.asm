org 0x8600
jmp 0x0000:start

%macro screen 1
    mov ah, 0xb  
	mov bh, 0     
	mov bl, %1      ;Screen color
	int 10h	

	mov ah, 02h
	mov bh, 00h
	mov dh, 2       ;Vertical offset
	mov dl, 2
	int 10h

	mov bl, 15      ;Letter color
%endmacro

%macro options 1
    add dh, 2
    mov  dl, 5
	mov  bh, 0
	mov  ah, 02h
	int  10h
    mov si, %1
    call printc
%endmacro

data:
    q1 db 'O QUE TEM EM COMUM ENTRE AS VARINHAS DE HARRY POTTER E VOLDEMORT?',0
    a1 db 'a) Nucleo', 0
    b1 db 'b) Madeira', 0
    c1 db 'c) Formato', 0

    q2 db 'QUAL ANIMAL SO EH VISTO POR QUEM JA VIU E ENTENDEU A MORTE?',0
    a2 db 'a) Hipogrifo', 0
    b2 db 'b) Tronquilho', 0
    c2 db 'c) Testralios', 0

    q3 db 'QUAL O PATRONO DE HARRY POTTER?',0
    a3 db 'a) Cervo', 0
    b3 db 'b) Fênix', 0
    c3 db 'c) Coruja', 0

    q4 db 'QUAL FOI A ÚLTIMA HORCRUX A SER DESTRUIDA?',0
    a4 db 'a) A tiara de Rowena Ravenclaw', 0
    b4 db 'b) Nagini', 0
    c4 db 'c) O anel de Marvolo Gaunt', 0

    q5 db 'QUAL COMIDA PERMITE RESPIRAR DEBAIXO DA AGUA?',0
    a5 db 'a) Mandragoras', 0
    b5 db 'b) Guelricho', 0
    c5 db 'c) Hidromel', 0

    q6 db 'QUAL PERSONAGEM ERA UM METAMORFOGOMAGO(A)?',0
    a6 db 'a) Ninfadora Tonks', 0
    b6 db 'b) Remo Lupin', 0
    c6 db 'c) Pedro Pettigrew', 0

    q7 db 'QUAL TECNICA HARRY APRIMOROU PARA SE PROTEGER MENTALMENTE DE VOLDEMORT?',0
    a7 db 'a) Legilimência', 0
    b7 db 'b) Accio', 0
    c7 db 'c) Oclumência', 0

start:
    xor ax,ax
    xor bx,bx
    push bx

    jmp question

question:
    call clean

    screen 12
	mov si, q1
    call printc       
    
    options a1
    options b1
    options c1
ret

clean:
;Cleaning the screen
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

resetc:
;Setting the cursor to top left-most corner of screen
	mov dx, 0 
    mov bh, 0      
    mov ah, 0x2
    int 0x10
ret

printc:
	lodsb
	mov cl, 0
	cmp cl, al
	je .done
	
	mov ah, 0xe
	int 0x10

	jmp printc
	
	.done:
    ret

jmp 0x7E00