org 0x500
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
	mov ah, 0 ;Video mode
	mov al, 12h ;VGA mode
	int 10h ;

    screen 0, 0, 15
	mov si, openg
	call pstrslow
    call clean
	
	xor ax, ax
	mov ds, ax

	jmp reset

delay:
;Setting a delay for printing 
	mov bp, 500
	mov dx, 500 ;Speed associated to each letter 

	delay2:
		dec bp
		;nop
		jnz delay2

	dec dx
	jnz delay2
ret

resetc:
;Setting the cursor to top left-most corner of screen
	mov dx, 0 
    mov bh, 0      
    mov ah, 0x2
    int 0x10
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
;Reseting floppy disk
	mov ah,0		
	mov dl,0		
	int 13h			
	jc reset		;If ERROR, tries again
	jmp load

load:
	mov ax, 0x7E0	;0x7E0<<1 + 0 = 0x7E00
	mov es, ax
	xor bx, bx

    ;Setting ROM position
	mov ah, 0x02
    mov al, 20  ;porção de setores ocupados pelo kernel.asm
    mov ch, 0   ;track 0
    mov cl, 3   ;setor 3
    mov dh, 0   ;head 0
    mov dl, 0   ;drive 0
    int 13h
    
	jc load			;If ERROR, tries again
    jmp 0x7e00
 
times 510-($-$$) db 0
dw 0xaa55