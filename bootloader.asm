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
    mov ah, 0x02        ; BIOS read sector
    mov al, 20          ; Read 20 sectors (adjustable)
    mov ch, 0           ; Cylinder 0
    mov cl, 2           ; Start at sector 2
    mov dh, 0           ; Head 0
    mov dl, [DriveNumber] ; Drive number (0 = floppy, 0x80 = hard disk)
    mov bx, 0x1000      ; Destination address (0x1000)
    int 0x13            ; Call BIOS interrupt to read sectors
    jc disk_error       ; Jump to error if carry flag is set
    cmp al, 20          ; Verify the sector count
    jne disk_error      
    ret

disk_error:
    mov si, MSG_DISK_ERROR
    call print_string
    jmp $               ; Infinite loop

MSG_BOOT db "Bootloader running...", 0x0D, 0x0A, 0
MSG_DISK_ERROR db "Disk read error!", 0x0D, 0x0A, 0

times 510-($-$$) db 0   
dw 0xAA55               