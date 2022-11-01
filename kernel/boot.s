[org 0x7c00]

KERNEL equ 0x7e00		; Define kernel offset
CODE equ code - null	; Calculating code segment
DATA equ data - null	; Data segment

load:					; Load kernel and switch to 32-bit
	mov ah, 0x2			; BIOS read sector function
	mov al, 0x2			; Read 2 sectors (excluding boot)
	mov ch, 0x0			; Select cylinder 0
	mov cl, 0x2			; Start reading from 2nd sector (in order to skip boot)
	mov dh, 0x0			; Select head 0 (dl was already set to boot drive by the BIOS)
	mov bx, KERNEL		; Store disk data in 0x1000

	int 0x13			; Run BIOS disk interrupt

    cli					; Disable all interrupts
    lgdt [exit]			; Load the GDT

    mov eax, cr0		; Copy the value of cr0
    or eax, 0x1			; Set the first bit
    mov cr0, eax		; Tell the CPU to switch

    jmp CODE:switch		; Long jump to force the end of all tasks

[bits 32]

switch:					; 32-bit adjustments and jumping to kernel code
    mov ax, DATA		; Point all the old segment registers to our data segment
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov ss, ax

    mov ebp, 0x9fc00	; Initialize base and stack pointer (this gives us 638 kb)
    mov esp, ebp

	call KERNEL			; Hand control over to kernel

null:					; Defining GDT
    dq 0x0

code: 
    dw 0xffff
    dw 0x0
    db 0x0
    db 0x9a
    db 0xcf
    db 0x0

data:
    dw 0xffff
    dw 0x0
    db 0x0
    db 0x92
    db 0xcf
    db 0x0

exit:
    dw exit - null - 0x1
    dd null

times 510-($-$$) db 0x0	; Boot sector padding
dw 0xaa55				; Magic bytes just in case
