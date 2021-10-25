org 0x7e00 ; Endereço linear de memória do kernel.asm
jmp 0x0000:start

data:

start:
    xor ax, ax
    mov ds, ax
    mov es, ax

jmp $