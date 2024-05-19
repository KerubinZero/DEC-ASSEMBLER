_EXIT  equ 1
_READ  equ 3
_WRITE equ 4
STDIN  equ 0
STDOUT equ 1

section .data
    msg1 db "Ingrese el dividendo: ", 0xA, 0xD
    len1 equ $ - msg1

    msg2 db "Ingrese el divisor: ", 0xA, 0xD
    len2 equ $ - msg2

    msg3 db "El cociente es: ", 0xA, 0xD
    len3 equ $ - msg3

    newline db 0xA, 0xD

section .bss
    dividend resd 1
    divisor  resd 1
    quotient resd 1
    quotient_str resb 11  ; Reservamos espacio para almacenar el cociente como una cadena de hasta 10 dígitos y un carácter nulo

section .text
    global _start

_start:
    ; Escribir mensaje para ingresar el dividendo
    mov eax, _WRITE
    mov ebx, STDOUT
    mov ecx, msg1
    mov edx, len1
    int 0x80

    ; Leer el dividendo
    mov eax, _READ
    mov ebx, STDIN
    mov ecx, dividend
    mov edx, 4
    int 0x80

    ; Escribir mensaje para ingresar el divisor
    mov eax, _WRITE
    mov ebx, STDOUT
    mov ecx, msg2
    mov edx, len2
    int 0x80

    ; Leer el divisor
    mov eax, _READ
    mov ebx, STDIN
    mov ecx, divisor
    mov edx, 4
    int 0x80

    ; Convertir los números ingresados a enteros
    mov eax, dword [dividend]
    mov ebx, dword [divisor]

    ; Verificar si el divisor es cero
    cmp ebx, 0
    je divisor_cero

    ; Realizar la división
    cdq          ; Se extiende el signo de eax a edx para tener un número de 64 bits (EDX:EAX)
    idiv ebx     ; Divide EDX:EAX entre EBX, el cociente se almacena en EAX y el residuo en EDX

    ; Convertir el cociente de entero a una cadena de caracteres
    mov edi, quotient_str + 10  ; Apuntar a la última posición de la cadena (final)
    mov esi, edi

    mov eax, dword [quotient]   ; Cargar el cociente
    mov ebx, 10                  ; Divisor para la división por 10 (obtener el dígito menos significativo)

cociente_loop:
    xor edx, edx                ; Limpiar el registro de residuo
    div ebx                     ; Dividir el cociente entre 10, el residuo se almacena en EDX
    add dl, '0'                 ; Convertir el residuo en dígito ASCII
    dec edi                     ; Mover el puntero a la izquierda
    mov [edi], dl               ; Almacenar el dígito en la cadena
    test eax, eax               ; ¿El cociente es cero?
    jnz cociente_loop           ; Si no, continuar dividiendo

    ; Almacenar el signo de terminación de cadena nula
    mov byte [edi - 1], 0

    ; Escribir mensaje para mostrar el cociente
    mov eax, _WRITE
    mov ebx, STDOUT
    mov ecx, msg3
    mov edx, len3
    int 0x80

    ; Escribir el cociente desde la cadena de caracteres
    mov eax, _WRITE
    mov ebx, STDOUT
    mov ecx, esi        ; Apuntar al inicio de la cadena
    mov edx, 11         ; Longitud máxima de la cadena (incluido el carácter nulo)
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

divisor_cero:
    ; Manejar el caso de división por cero
    mov eax, _WRITE
    mov ebx, STDOUT
    mov ecx, divisor_error_msg
    mov edx, divisor_error_msg_len
    int 0x80

    ; Salir del programa
    mov eax, _EXIT
    xor ebx, ebx
    int 0x80

section .data
    divisor_error_msg db "Error: No se puede dividir por cero.", 0xA, 0xD
    divisor_error_msg_len equ $ - divisor_error_msg

