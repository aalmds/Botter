org 0x7E00
jmp 0x0000:start

%macro level 1
;Configura a tela de exibição do nível e printa o nível do jogador.
    screen 9, 10, 35    ;Configura a tela.
    mov bl, 15          ;Configura a cor da letra da string.
    mov si, %1          ;Seta qual string será printada.
    call pstrslow       ;Printa a string letra por letra.
    call getc           ;Recebe um caractere do teclado.
    cmp al, 0x0D        ;Compara o caractere com "enter".
%endmacro

%macro screen 3
;Configura a tela de vídeo, limpando o conteúdo anterior, setando a cor de fundo e 
    ;posicionando o cursor no local onde a string deverá ser printada.
    call clean          ;Limpa o conteúdo da tela anterior.

    mov ah, 0xb         ;Chamada para escolher a cor da tela.
    mov bh, 0           ;Número da página.
    mov bl, %1          ;Configura cor da tela.
    int 10h	            ;Interrupção para print.

    mov ah, 2           ;Chamada para setar a posição do cursor.
    mov bh, 0           ;Número da página.
    mov dh, %2          ;Offset vertical.
    mov dl, %3          ;Offset horizontal.
    int 10h             ;Interrupção para print.
%endmacro

%macro question 4
;Configura o print das questões.
    mov bl, 15          ;Configura a cor da letra da string.
    mov si, %1          ;Seta qual string será printada.
    call pstr           ;Printa a questão.
    options %2          ;Printa a letra 'a' da questão.
    options %3          ;Printa a letra 'b' da questão.
    options %4          ;Printa a letra 'c' da questão. 
%endmacro

%macro options 1
;Configura o print das opções de cada questão.
    mov ah, 2           ;Chamada para setar a posição do cursor.
    mov bh, 0           ;Número da página.
    add dh, 2           ;Offset vertical.
    mov dl, 5           ;Offset horizontal.
    int 10h             ;Interrupção para print.

    mov si, %1          ;Seta qual string será printada.
    call pstr           ;Printa a letra correspondente.
%endmacro

%macro readans 1
;Recebe a resposta do jogador e compara com a resposta certa.
    call getc           ;Recebe um caractere do teclado.
    cmp al, %1          ;Compara o caractere com a resposta correta.
    jne over            ;Pula para a tela de game over, caso a resposta tenha sido errada.
%endmacro

%macro result 4
;Configura a tela de resultado: ganhar ou perder.
    screen 0, 10, %1    ;Configura a tela.
    mov bl, %2          ;Configura a cor da letra da string.
    mov si, %3          ;Seta qual string será printada.
    call pstr           ;Printa o resultado.

    mov  ah, 02h        ;Chamada para setar a posição do cursor.  
    mov  bh, 0          ;Número da página.
    mov  dh, 15         ;Offset vertical.
    mov  dl, 22         ;Offset horizontal.
    int  10h            ;Interrupção para print.
    mov si, %4          ;Seta qual string será printada.
    call pstr           ;Printa o resultado

    call getc           ;Recebe um caractere do teclado.
    cmp al, 0x0D        ;Compara o caractere com "enter".
    je menu             ;Pula para a tela de menu, caso o jogador pressione "enter".

    jmp end             ;Encerra o jogo, caso o jogador pressione uma tecla diferente de "enter".
%endmacro

data:
;Define todas as strings que serão utilizadas ao longo do jogo na memória.
    lumus db 'LUMUS MAXIMA', 0
    title db 'BOTTER', 0

    l1 db 'NIVEL 1', 0
    l2 db 'NIVEL 2', 0
    l3 db 'NIVEL 3', 0

    begin db 'Pressione enter para iniciar o quiz', 0
    tagain db 'Pressione enter para tentar novamente', 0
    again db 'Pressione enter para jogar novamente', 0
    closeg db 'Malfeito feito...', 0

    slose db 'AVADA KEDAVRA', 0
    swin db 'VOCE CONQUISTOU AS RELIQUIAS DA MORTE', 0
    
    q1 db 'O QUE TEM EM COMUM ENTRE AS VARINHAS DE HARRY POTTER E VOLDEMORT?', 0
    a1 db 'a) Nucleo', 0
    b1 db 'b) Madeira', 0
    c1 db 'c) Formato', 0

    q2 db 'QUAL ANIMAL SO EH VISTO POR QUEM JA VIU E ENTENDEU A MORTE?', 0
    a2 db 'a) Hipogrifo', 0
    b2 db 'b) Tronquilho', 0
    c2 db 'c) Testralios', 0

    q3 db 'QUAL O PATRONO DE HARRY POTTER?',0
    a3 db 'a) Cervo', 0
    b3 db 'b) Fenix', 0
    c3 db 'c) Coruja', 0

    q4 db '4) QUAL FOI A ULTIMA HORCRUX A SER DESTRUIDA?',0
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
    a7 db 'a) Legilimencia', 0
    b7 db 'b) Accio', 0
    c7 db 'c) Oclumencia', 0

    q8 db 'QUAL DOS FEITICOS EH CONSIDERADO UMA MALDICAO IMPERDOAVEL?', 0
    a8 db 'a) Confundo', 0
    b8 db 'b) Accio', 0
    c8 db 'c) Imperius', 0 

    q9 db 'QUAL FRASE ABRE O MAPA DO MAROTO?', 0
    a9 db 'a) Juro solenemente fazer tudo de bom ', 0
    b9 db 'b) Juro solenemente nao fazer nada de bom', 0 
    c9 db 'c) Juro solenemente fazer tudo de ruim', 0

start:
    screen 0, 8, 34     ;Configura a tela.
    mov bl, 14          ;Configura a cor da letra da string.
    mov si, lumus       ;Seta qual string será printada.
    call pstrslow           ;Printa a string letra por letra.

    call clean          ;Limpa o conteúdo da tela anterior.  

    screen 6, 8, 34     ;Configura a tela.
    call delay          ;Chama o delay.

    screen 4, 8, 34     ;Configura a tela.
    call delay          ;Chama o delay.

    screen 12, 8, 34    ;Configura a tela.
    call delay          ;Chama o delay.

    screen 14, 8, 34    ;Configura a tela.
    call delay          ;Chama o delay.

    screen 0, 8, 34     ;Configura a tela.
    call delay          ;Chama o delay.

    jmp menu            ;Pula para a tela de menu.

menu:    
    screen 9, 8, 35     ;Configura a tela
    mov bl, 15
    mov si, title       
    call pstrslow
    call delay

    mov  dl, 22
    mov  dh, 15
    mov  bh, 0
    mov  ah, 02h
    int  10h
    mov si, begin
    call pstr

    call getc
    cmp al, 0x0D
    je botter
	
botter:
    xor ax, ax
    xor bx, bx
    xor cx, cx
    xor dx, dx

    call level1
    call level2
    call level3

    jmp win

level1:
    level l1
    screen 8, 2, 2 
    question q1, a1, b1, c1
    readans 'a'

    screen 8, 2, 2
    question q2, a2, b2, c2
    readans 'c'

    screen 8, 2, 2
    question q3, a3, b3, c3
    readans 'a'
ret

level2:
    level l2
    screen 13, 2, 2
    question q4, a4, b4, c4
    readans 'b'

    screen 13, 2, 2
    question q5, a5, b5, c5
    readans 'b'
    
    screen 13, 2, 2
    question q6, a6, b6, c6
    readans 'a'
ret

level3:
    level l3
    screen 12, 2, 2
    question q7, a7, b7, c7
    readans 'c'

    screen 12, 2, 2
    question q8, a8, b8, c8
    readans 'c'

    screen 12, 2, 2
    question q9, a9, b9, c9
    readans 'b'
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
    int 10h
    
    call resetc
ret

resetc:
;Setting the cursor to top left-most corner of screen
    mov dx, 0 
    mov bh, 0      
    mov ah, 0x2
    int 0x10
ret

delay:
    mov bp, 700
    mov dx, 500

    delay2:
        dec bp
        nop
        jnz delay2

    dec dx
    jnz delay2
ret

getc:
    mov ah, 0x00
    int 16h
ret

pstrslow: 
    lodsb
    cmp al, 0
    je .end

    mov ah, 0xe
    int 10h	

    call delay 
    jmp pstrslow

    .end:
        ret

pstr:
    lodsb 
    cmp al, 0
    je .end
	
    mov ah, 0xe
    int 10h

    jmp pstr
	
    .end:
        ret

win:
    result 22, 9, swin, again

over:
    result 33,2, slose, tagain

end:
    screen 0, 0, 0
    mov bl, 15
    mov si, closeg
    call pstrslow

    jmp $