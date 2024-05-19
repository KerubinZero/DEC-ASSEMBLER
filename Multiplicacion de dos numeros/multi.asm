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

    msg3 db "El resultado de la multiplicacion es: ", 0xA, 0xD
    len3 equ $ - msg3

    newline db 0xA, 0xD

section .bss
    num1 resb 2
    num2 resb 2
    result resb 3  ; Usaremos 3 bytes para almacenar el resultado (máximo 2 dígitos)

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

    ; Convertir los números ingresados a enteros
    movzx eax, byte [num1]
    sub eax, '0'

    movzx ebx, byte [num2]
    sub ebx, '0'

    ; Multiplicar los números
    mul bl  ; Multiplica AL por BL

    ; Convertir el resultado de entero a carácter
    add ax, '0'  ; Suma '0' para convertir el resultado en carácter ASCII

    ; Guardar el resultado en la memoria reservada 'result'
    mov [result], ax

    ; Escribir mensaje para mostrar el resultado de la multiplicación
    mov eax, _WRITE
    mov ebx, STDOUT
    mov ecx, msg3
    mov edx, len3
    int 0x80

    ; Escribir el resultado de la multiplicación desde la memoria reservada 'result'
    mov eax, _WRITE
    mov ebx, STDOUT
    mov ecx, result
    mov edx, 2  ; Longitud del resultado es 2 bytes (máximo 2 dígitos)
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
