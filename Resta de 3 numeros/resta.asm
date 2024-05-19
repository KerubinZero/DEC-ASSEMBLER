_EXIT  equ 1
_READ  equ 3
_WRITE equ 4
STDIN  equ 0
STDOUT equ 1

section .data
    msg1 db "Ingrese el primer numero: ", 0xA, 0xD
    len1 equ $ - msg1

    msg2 db "Ingrese el segundo numero: ", 0xA, 0xD
    len2 equ $ - msg2

    msg3 db "Ingrese el tercer numero: ", 0xA, 0xD
    len3 equ $ - msg3

    msg4 db "El resultado de la resta es: ", 0xA, 0xD
    len4 equ $ - msg4

    newline db 0xA, 0xD

section .bss
    num1 resb 2
    num2 resb 2
    num3 resb 2
    res  resb 2

section .text
    global _start

_start:
    ; Escribir mensaje para ingresar el primer número
    mov eax, _WRITE
    mov ebx, STDOUT
    mov ecx, msg1
    mov edx, len1
    int 0x80

    ; Leer el primer número
    mov eax, _READ
    mov ebx, STDIN
    mov ecx, num1
    mov edx, 2
    int 0x80

    ; Escribir mensaje para ingresar el segundo número
    mov eax, _WRITE
    mov ebx, STDOUT
    mov ecx, msg2
    mov edx, len2
    int 0x80

    ; Leer el segundo número
    mov eax, _READ
    mov ebx, STDIN
    mov ecx, num2
    mov edx, 2
    int 0x80

    ; Escribir mensaje para ingresar el tercer número
    mov eax, _WRITE
    mov ebx, STDOUT
    mov ecx, msg3
    mov edx, len3
    int 0x80

    ; Leer el tercer número
    mov eax, _READ
    mov ebx, STDIN
    mov ecx, num3
    mov edx, 2
    int 0x80

    ; Convertir los números ingresados a enteros
    movzx eax, byte [num1]
    sub eax, '0'

    movzx ebx, byte [num2]
    sub ebx, '0'

    movzx ecx, byte [num3]
    sub ecx, '0'

    ; Realizar la resta de los números
    sub eax, ebx
    sub eax, ecx

    ; Convertir el resultado de entero a carácter
    add eax, '0'

    ; Guardar el resultado en la memoria reservada 'res'
    mov [res], al

    ; Escribir mensaje para mostrar el resultado de la resta
    mov eax, _WRITE
    mov ebx, STDOUT
    mov ecx, msg4
    mov edx, len4
    int 0x80

    ; Escribir el resultado de la resta desde la memoria reservada 'res'
    mov eax, _WRITE
    mov ebx, STDOUT
    mov ecx, res
    mov edx, 1
    int 0x80

    ; Escribir un salto de línea
    mov eax, _WRITE
    mov ebx, STDOUT
    mov ecx, newline
    mov edx, 2
    int 0x80

    ; Salir del programa
    mov eax, _EXIT
    xor ebx, ebx
    int 0x80

