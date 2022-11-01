[bits 32]
[extern main]			; Define calling point

call main				; Calls kernel's main function

jmp $					; Hang if kernel returns
