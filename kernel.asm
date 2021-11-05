org 0x7E00              ;Endereço linear de memória do kernel.asm.
jmp 0x0000:start

%macro level 1
;Configura a tela de exibição do nível e printa o nível do jogador.
    screen 9, 10, 35    ;Configura a tela.
    mov bl, 15          ;Seta a cor da letra para branco.

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

    setcur %2, %3       ;Seta a posição do cursor na tela.
%endmacro

%macro question 4
;Configura o print das questões.
    mov bl, 15          ;Seta a cor da letra da string para branco.
    mov si, %1          ;Seta qual string será printada.
    call pstr           ;Printa a questão.    
    options %2          ;Printa a letra 'a' da questão.
    options %3          ;Printa a letra 'b' da questão.
    options %4          ;Printa a letra 'c' da questão. 
%endmacro

%macro options 1
;Configura o print das opções de cada questão.
    add dh, 2           ;Offset vertical.
    setcur dh, 2        ;Seta o cursor na tela.
    mov si, %1          ;Seta qual string será printada.
    call pstr           ;Printa a letra correspondente.
%endmacro

%macro readans 1
;Recebe a resposta do jogador e compara com a resposta certa.
    call getc           ;Recebe um caractere do teclado.
    cmp al, %1          ;Compara o caractere com a resposta correta.
    jne over            ;Pula para a tela de derrota, caso a resposta tenha sido errada.
%endmacro

%macro result 4
;Configura a tela de resultado: ganhar ou perder.
    screen 0, 10, %1    ;Configura a tela.
    mov bl, %2          ;Seta a cor da letra da string.
    mov si, %3          ;Seta qual string será printada.
    call pstr           ;Printa o resultado.

    setcur 15, 22       ;Seta o cursor na tela.
    mov si, %4          ;Seta qual string será printada.
    call pstr           ;Printa o resultado

    call getc           ;Recebe um caractere do teclado.
    cmp al, 0x0D        ;Compara o caractere com "enter".
    je menu             ;Pula para a tela inicial, caso o jogador pressione "enter".

    jmp end             ;Encerra o jogo, caso o jogador pressione uma tecla diferente de "enter".
%endmacro

%macro setcur 2
;Configura a posição do cursor na tela.
    mov ah, 2           ;Chamada para setar a posição do setcur.
    mov bh, 0           ;Número da página.
    mov dh, %1          ;Offset vertical.
    mov dl, %2          ;Offset horizontal.
    int 10h             ;Interrupção para print.
%endmacro

data:
;Define na memória todas as strings que serão utilizadas ao longo do jogo.
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

    q4 db 'QUAL FOI A ULTIMA HORCRUX A SER DESTRUIDA?',0
    a4 db 'a) A tiara de Rowena Ravenclaw', 0
    b4 db 'b) Nagini', 0
    c4 db 'c) O anel de Marvolo Gaunt', 0

    q5 db 'QUAL COMIDA PERMITE RESPIRAR DEBAIXO DA AGUA?',0
    a5 db 'a) Mandragoras', 0
    b5 db 'b) Guelricho', 0
    c5 db 'c) Hidromel', 0

    q6 db 'QUAL PERSONAGEM ERA UM METAMORFOGOMAGO(A)?', 0
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
    screen 0, 8, 34     ;Configura a tela - cor preta.
    mov bl, 14          ;Configura a cor da letra da string para amarelo.
    mov si, lumus
    call pstrslow

    call clean

    screen 6, 8, 34     ;Configura a tela - cor marrom.
    call delay

    screen 4, 8, 34     ;Configura a tela -  cor vermelha.
    call delay

    screen 12, 8, 34    ;Configura a tela - cor vermelho claro.
    call delay

    screen 14, 8, 34    ;Configura a tela - cor amarela.
    call delay          

    jmp menu            ;Pula para a tela inicial.

menu:    
    screen 9, 8, 35     ;Configura a tela - cor azul claro.
    mov bl, 15          ;Seta a cor da letra para branco.
    mov si, title
    call pstrslow
    call delay

    setcur 15, 22  
    mov si, begin
    call pstr           

    call getc           
    cmp al, 0x0D
    je botter
	
botter:
;Configura todas as chamadas necessárias para o fluxo do jogo.
    xor ax, ax
    xor bx, bx
    xor cx, cx
    xor dx, dx

    call level1         
    call level2
    call level3

    jmp win             ;Pula para a tela de vitória, caso o jogador tenha acertado todas as perguntas.

level1:
;Configura o nível 1 do jogo.
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
;Configura o nível 2 do jogo.
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
;Configura o nível 3 do jogo.
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
;Limpa o conteúdo da tela anterior.  
    setcur 0, 0

    delete:
    ;Printa 2000 caracteres na tela.
    mov cx, 2000
    mov bh, 0         
    mov al, 0x20
    mov ah, 0x9
    int 10h
    
    setcur 0, 0
ret

delay:
;Configura um delay.
    mov bp, 700         
    mov dx, 500

    delay2:
    ;Auxilia na função de delay.
        dec bp
        jnz delay2

    dec dx
    jnz delay2
ret

getc:
;Captura um caractere do teclado.
    mov ah, 0x00    
    int 16h
ret

pstrslow:
;Printa uma string letra por letra.
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
;Printa uma string.
    lodsb
    cmp al, 0
    je .end
	
    mov ah, 0xe
    int 10h

    jmp pstr
	
    .end:
        ret

win:
;Configura a tela de vitória.
    result 22, 9, swin, again

over:
;Configura a tela de derrota,
    result 33, 2, slose, tagain

end:
;Configura o final do jogo.
    screen 0, 0, 0      ;Configura a tela - cor preta.
    mov bl, 15          ;Seta a cor da letra para branco.
    mov si, closeg
    call pstrslow

    jmp $