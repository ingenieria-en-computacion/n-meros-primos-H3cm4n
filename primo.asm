; primo.asm - Programa que verifica si un número es primo
; Requiere la biblioteca io.asm (con las correcciones mencionadas)

section .data
    prompt      db  "Ingrese un numero: ", 0
    primo_msg   db  " es primo.", 10, 0
    no_primo_msg db " no es primo.", 10, 0

section .text
    global _start

_start:
    ; Pedir al usuario que ingrese un número
    mov esi, prompt
    call print_str
    call scan_num       ; El número queda en EAX

    ; Verificar si es primo
    call es_primo

    ; Mostrar el resultado
    push eax            ; Guardar el número original
    call print_num      ; Imprimir el número ingresado
    pop eax             ; Recuperar el número

    ; Mostrar el mensaje adecuado
    cmp ebx, 1          ; ebx=1 si es primo, 0 si no
    je .es_primo
    mov esi, no_primo_msg
    jmp .mostrar_resultado

.es_primo:
    mov esi, primo_msg

.mostrar_resultado:
    call print_str

    ; Salir del programa
    mov eax, 1          ; sys_exit
    xor ebx, ebx        ; código de salida 0
    int 0x80

; ----------------------------------------------------------
; es_primo - Verifica si un número es primo
; Entrada: EAX = número a verificar (n > 1)
; Salida: EBX = 1 si es primo, 0 si no es primo
; Modifica: EBX, ECX, EDX
; ----------------------------------------------------------
es_primo:
    ; Casos especiales
    cmp eax, 1
    jle .no_primo       ; Números <= 1 no son primos

    cmp eax, 2
    je .si_primo        ; 2 es primo

    test eax, 1
    jz .no_primo        ; Números pares > 2 no son primos

    ; Verificar divisores desde 3 hasta sqrt(n)
    mov ecx, 3          ; i = 3

.bucle_verificacion:
    ; Calcular i*i y comparar con n
    mov ebx, ecx
    imul ebx, ebx       ; ebx = i*i
    cmp ebx, eax
    ja .si_primo        ; Si i*i > n, es primo

    ; Verificar si n es divisible por i
    xor edx, edx
    mov ebx, eax
    div ecx             ; edx = n % i
    test edx, edx
    jz .no_primo        ; Si divisible, no es primo

    add ecx, 2          ; i += 2 (solo probar divisores impares)
    jmp .bucle_verificacion

.si_primo:
    mov ebx, 1
    ret

.no_primo:
    xor ebx, ebx
    ret
