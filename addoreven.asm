section .data
    prompt db "Enter a number: ", 0
    even_msg db "The number is Even.", 0
    odd_msg db "The number is Odd.", 0
    newline db 0xA, 0

section .bss
    num resb 10 ; Reserve space for the input number

section .text
    global _start

_start:
    ; Prompt user for input
    mov eax, 4          ; syscall: sys_write
    mov ebx, 1          ; file descriptor: stdout
    mov ecx, prompt     ; message to display
    mov edx, 14         ; message length
    int 0x80            ; make syscall

    ; Read user input
    mov eax, 3          ; syscall: sys_read
    mov ebx, 0          ; file descriptor: stdin
    mov ecx, num        ; buffer for input
    mov edx, 10         ; max bytes to read
    int 0x80            ; make syscall

    ; Convert ASCII to integer
    mov esi, num        ; pointer to input string
    xor eax, eax        ; clear eax (result)
    xor ebx, ebx        ; clear ebx (multiplier)

next_digit:
    mov bl, byte [esi]  ; load next byte
    cmp bl, 0xA         ; check for newline (ASCII 10)
    je check_even_odd   ; if newline, input complete
    sub bl, '0'         ; convert ASCII to digit
    imul eax, eax, 10   ; multiply result by 10
    add eax, ebx        ; add digit to result
    inc esi             ; move to next character
    jmp next_digit      ; repeat

check_even_odd:
    test eax, 1         ; check LSB (Least Significant Bit)
    jz print_even       ; if zero, number is even

print_odd:
    ; Print odd message
    mov eax, 4          ; syscall: sys_write
    mov ebx, 1          ; file descriptor: stdout
    mov ecx, odd_msg    ; message to display
    mov edx, 17         ; message length
    int 0x80            ; make syscall
    jmp exit            ; exit program

print_even:
    ; Print even message
    mov eax, 4          ; syscall: sys_write
    mov ebx, 1          ; file descriptor: stdout
    mov ecx, even_msg   ; message to display
    mov edx, 18         ; message length
    int 0x80            ; make syscall

exit:
    ; Exit program
    mov eax, 1          ; syscall: sys_exit
    xor ebx, ebx        ; exit code 0
    int 0x80            ; make syscall
