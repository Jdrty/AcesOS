[BITS 16]           
[ORG 0x7C00]        

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

    call load_kernel    

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

load_kernel:
    mov ax, 0x1000      
    mov es, ax          
    xor bx, bx          
    mov ah, 0x02        
    mov al, 20          
    mov ch, 0           
    mov cl, 2           
    mov dh, 0           
    mov dl, [DriveNumber] 
    int 0x13            
    jc disk_error       
    cmp al, 20          
    jne disk_error      
    ret

disk_error:
    mov si, MSG_DISK_ERROR
    call print_string
    jmp $               

MSG_BOOT db "Bootloader running...", 0x0D, 0x0A, 0
MSG_DISK_ERROR db "Disk read error!", 0x0D, 0x0A, 0

DriveNumber db 0        

times 510-($-$$) db 0   
dw 0xAA55               