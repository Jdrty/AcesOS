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

    mov si, MSG_BOOT    
    call print_string

    jmp 0x1000          

print_string:
    lodsb               
    test al, al         
    jz .done            
    mov ah, 0x0E        
    int 0x10            
    jmp print_string    
.done:
    ret

MSG_BOOT db "Bootloader running...", 0x0D, 0x0A, 0

times 510-($-$$) db 0   
dw 0xAA55               
