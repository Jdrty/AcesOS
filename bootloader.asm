[BITS 16]           ; 16-bit real mode
[ORG 0x7C00]        ; BIOS load point

jmp start

start:
    cli                 
    xor ax, ax          
    mov ds, ax          
    mov es, ax          
    mov ss, ax          
    mov sp, 0x7C00      
    sti                 

    jmp $

times 510-($-$$) db 0   
dw 0xAA55