org 0x500				;Endereço linear de memória do boot2.asm.
jmp 0x000:start

%macro screen 3
	mov ah, 02h
	mov bh, 00
	mov dh, %1
	mov dl, %2
	int 10h
    mov bl, %3
%endmacro

data:
	openg db 'Juro solenemente que nao pretendo fazer nada de bom...', 0

start:
	mov ah, 0 			;Modo vídeo.
	mov al, 12h 		;Modo VGA.
	int 10h

    screen 0, 0, 15
	mov si, openg
	call pstrslow
    call clean
	
	mov ax, 0x7E0		;Seta a posição do disco onde kernel.asm foi armazenado.
	mov es, ax
	xor bx, bx

	jmp reset

delay:
;Configura um delay.
	mov bp, 500
	mov dx, 500

	delay2:
		dec bp
		jnz delay2

	dec dx
	jnz delay2
ret

resetc:
;Seta o cursor para o canto mais esquerdo superior da tela.
	mov dx, 0 
    mov bh, 0      
    mov ah, 0x2
    int 0x10
ret

clean:
;Limpa o conteúdo da tela anterior.  
    call resetc

    delete:
    ;Printa 2000 caracteres na tela.
    mov cx, 2000 
    mov bh, 0
    mov al, 0x20
    mov ah, 0x9
    int 10h
    
    call resetc
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

reset:
	mov ah, 0		
	mov dl, 0		
	int 13h			
	jc reset			;Se o acesso falhar, tenta novamente.
	jmp load

load:
	mov ah, 0x02		;Lê um setor do disco.
    mov al, 20  		;Porção de setores ocupados pelo kernel.asm.
    mov ch, 0   		;Track 0
    mov cl, 3   		;Sector 3.
    mov dh, 0   		;Head 0.
    mov dl, 0   		;Drive 0.
    int 13h
    
    jc load             ;Se o acesso falhar, tenta novamente.
    jmp 0x7e00
 
times 510-($-$$) db 0   ;512 bytes.
dw 0xaa55