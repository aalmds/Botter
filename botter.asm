org 0x8600
jmp 0x0000:start

%macro screen 1
    call clean
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
    mov dl, 5
	mov bh, 0
	mov ah, 02h
	int 10h
    mov si, %1
    call printc
%endmacro

%macro readans 1
    call getc
    cmp al, %1
    call check
%endmacro

data:
    q1 db '1) O QUE TEM EM COMUM ENTRE AS VARINHAS DE HARRY POTTER E VOLDEMORT?',0
    a1 db 'a) Nucleo', 0
    b1 db 'b) Madeira', 0
    c1 db 'c) Formato', 0

    q2 db '2) QUAL ANIMAL SO EH VISTO POR QUEM JA VIU E ENTENDEU A MORTE?',0
    a2 db 'a) Hipogrifo', 0
    b2 db 'b) Tronquilho', 0
    c2 db 'c) Testralios', 0

    q3 db '3) QUAL O PATRONO DE HARRY POTTER?',0
    a3 db 'a) Cervo', 0
    b3 db 'b) Fenix', 0
    c3 db 'c) Coruja', 0

    q4 db '4) QUAL FOI A ULTIMA HORCRUX A SER DESTRUIDA?',0
    a4 db 'a) A tiara de Rowena Ravenclaw', 0
    b4 db 'b) Nagini', 0
    c4 db 'c) O anel de Marvolo Gaunt', 0

    q5 db '5) QUAL COMIDA PERMITE RESPIRAR DEBAIXO DA AGUA?',0
    a5 db 'a) Mandragoras', 0
    b5 db 'b) Guelricho', 0
    c5 db 'c) Hidromel', 0

    q6 db '6) QUAL PERSONAGEM ERA UM METAMORFOGOMAGO(A)?',0
    a6 db 'a) Ninfadora Tonks', 0
    b6 db 'b) Remo Lupin', 0
    c6 db 'c) Pedro Pettigrew', 0

    q7 db '7) QUAL TECNICA HARRY APRIMOROU PARA SE PROTEGER MENTALMENTE DE VOLDEMORT?',0
    a7 db 'a) Legilimencia', 0
    b7 db 'b) Accio', 0
    c7 db 'c) Oclumencia', 0


start:
    xor ax, ax
    xor bx, bx
    xor cx, cx
    xor dx, dx

    jmp question

question:
    screen 12
	mov si, q1
    call printc       
    options a1
    options b1
    options c1
    readans 'a'

    screen 13
	mov si, q2
    call printc       
    options a2
    options b2
    options c2
    readans 'c'

    screen 8
	mov si, q3
    call printc       
    options a3
    options b3
    options c3
    readans 'a'

    screen 1
	mov si, q4
    call printc       
    options a4
    options b4
    options c4
    readans 'b'

    screen 2
	mov si, q5
    call printc       
    options a5
    options b5
    options c5
    readans 'b'
    
    screen 5
	mov si, q6
    call printc       
    options a6
    options b6
    options c6
    readans 'a'
    
    screen 9
	mov si, q7
    call printc       
    options a7
    options b7
    options c7
    readans 'c'
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

getc:
  mov ah, 0x00
  int 16h
ret

check:
    je .right

    .right:
    ret
ret

jmp 0x7E00