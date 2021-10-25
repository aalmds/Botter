org 0x500 ; Endereço linear de memória do boot2.asm
jmp 0x0000:start

runK db 'Rodando o kernel...', 0

printStr:
	lodsb
	cmp al,0
	je end

	mov ah, 0eh
	mov bl, 15
	int 10h

	mov dx, 0

	.delayPrint:
	inc dx
	mov cx, 0
		.time:
			inc cx
			cmp cx, 10000
			jne .time
	cmp dx, 1000

	jne .delayPrint

	jmp printStr

	end:
		mov ah, 0eh
		mov al, 0xd
		int 10h
		mov al, 0xa
		int 10h
		ret

start:
    xor ax, ax
    mov ds, ax
    mov es, ax

    mov si, runK
    call printStr

    reset:
        mov ah, 00h ; Resetando o controlador de disco
        mov dl, 0
        int 13h

        jc reset    ; Se o acesso falhar, tenta novamente

        jmp loadK

    loadK:
        mov ax, 0x7E0	; Setando a posição do disco onde kernel.asm foi armazenado
        mov es, ax
        xor bx, bx

        mov ah, 0x02 ; Lendo um setor do disco
        mov al, 20  ; Quantidade de setores ocupados pelo kernel.asm
        mov ch, 0   ; Track 0
        mov cl, 3   ; Setor 3
        mov dh, 0   ; Head 0
        mov dl, 0   ; Drive 0
        int 13h

        jc loadK ; Se o acesso falhar, tenta novamente

        jmp 0x7e00  ; Pulando para o endereço do kernel.asm

times 510-($-$$) db 0 ; 512 bytes
dw 0xaa55	; Assinatura do disco