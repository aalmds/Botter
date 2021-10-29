org 0x500
jmp 0x000:start

%macro setter 3
	mov ah, 02h
	mov bh, 00
	mov dh, %1
	mov dl, %2
	int 10h
    mov bl, %3
%endmacro

data:
string db 'Juro solenemente que nao pretendo fazer nada de bom...', 13

delay:
;Setting a delay for printing 
	mov bp, 100
	mov dx, 400 ;Speed associated to each letter 

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
    int 0x10
    
    call resetc
ret

pstr:
;Printing the string loader from the memory
	lodsb
	mov ah, 0xe
	mov bh, 0
	int 10h
	call delay
	cmp al, 13
	jne pstr
ret

start:
    begin:
	mov ah, 0 ;Video mode
	mov al, 12h ;VGA mode
	int 10h ;

    setter 0, 0, 15
	mov si, string
	call pstr
    call clean
	
    end:
	xor ax, ax
	mov ds, ax

reset:
;Reseting floppy disk
	mov ah,0		
	mov dl,0		
	int 13h			
	jc reset		;If ERROR, tries again

load:
	mov ax,0x7E0	;0x7E0<<1 + 0 = 0x7E00
	mov es, ax
	xor bx, bx

    ;Setting ROM position
	mov ah, 0x02
	mov al, 4	
	mov dl, 0	

    ;Setting memory positions
	mov ch,0
	mov cl,3
	mov dh,0	
	int 13h
    
	jc load			;If ERROR, tries again
    jmp 0x7e00
 
times 510-($-$$) db 0
dw 0xaa55