org 0x7c00              ;Endereço linear de memória do boot1.asm.
jmp 0x0000:start

start:
    mov ax, 0x50        ;Seta a posição do disco onde boot2.asm foi armazenado.
    mov es, ax
    xor bx, bx 

    jmp reset

reset:
    mov ah, 00h         ;Reseta o controlador de disco.
    mov dl, 0 
    int 13h

    jc reset            ;Se o acesso falhar, tenta novamente.

    jmp load

load:
    mov ah, 02h         ;Lendo um setor do disco.
    mov al, 1           ;Quantidade de setores ocupados pelo boot2.asm.
    mov ch, 0           ;Track 0.
    mov cl, 2           ;Sector 2.
    mov dh, 0           ;Head 0.
    mov dl, 0           ;Drive 0.
    int 13h

    jc load             ;Se o acesso falhar, tenta novamente.

    jmp 0x500           ;Pulando para o endereço do boot2.asm.

times 510-($-$$) db 0   ;512 bytes.
dw 0xaa55