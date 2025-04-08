section .data
    prompt db "Array antes do Bubble Sort:", 0
    new_line db 10, 0
    message db "Array após Bubble Sort:", 0
    comparacoes_message db "Número de comparações: ", 0
    trocas_message db "Número de trocas: ", 0
    arr db 5, 3, 8, 4, 2, 7, 1, 6, 0  ; Vetor de 9 elementos
    arr_size db 9  ; Tamanho do vetor (número de elementos)

section .bss
    swap_count resb 1  ; Contador de trocas
    compare_count resb 1  ; Contador de comparações

section .text
    global _start

_start:
    ; Exibir a mensagem inicial
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt
    mov edx, 25
    int 0x80

    ; Exibir o vetor antes do Bubble Sort
    call print_array

    ; Inicializar contadores de comparações e trocas
    mov byte [swap_count], 0
    mov byte [compare_count], 0

    ; Iniciar o Bubble Sort
    call bubble_sort

    ; Exibir a mensagem após o Bubble Sort
    mov eax, 4
    mov ebx, 1
    mov ecx, message
    mov edx, 24
    int 0x80

    ; Exibir o vetor após o Bubble Sort
    call print_array

    ; Exibir número de comparações
    mov eax, 4
    mov ebx, 1
    mov ecx, comparacoes_message
    mov edx, 28
    int 0x80
    call print_compare_count

    ; Exibir número de trocas
    mov eax, 4
    mov ebx, 1
    mov ecx, trocas_message
    mov edx, 22
    int 0x80
    call print_swap_count

    ; Finalizar o programa
    mov eax, 1
    xor ebx, ebx
    int 0x80

; Função para imprimir o vetor (array)
print_array:
    mov ecx, arr_size
    mov ebx, 0  ; Índice inicial

print_loop:
    mov al, [arr + ebx]  ; Carregar valor do array
    add al, 30h  ; Converter para ASCII
    mov dl, al
    mov eax, 4
    mov ebx, 1
    mov edx, 1
    int 0x80  ; Chamada do sistema para imprimir o caractere

    ; Exibir nova linha após imprimir todos os elementos
    inc ebx
    loop print_loop

    ; Exibir nova linha após imprimir o array
    mov eax, 4
    mov ebx, 1
    mov ecx, new_line
    mov edx, 1
    int 0x80
    ret

; Função Bubble Sort
bubble_sort:
    ; Obter o tamanho do array
    mov al, [arr_size]
    mov bl, al
    dec bl  ; Último índice (tamanho - 1)

    ; Loop externo (iterando sobre o array)
outer_loop:
    mov si, 0  ; Inicializar o índice para o loop interno
    xor dx, dx  ; Reseta o flag de troca

    ; Definir um indicador de troca
    xor cx, cx  ; Reseta o indicador de troca

inner_loop:
    ; Comparar arr[si] e arr[si+1]
    mov al, [arr + si]
    mov dl, [arr + si + 1]
    cmp al, dl  ; Comparar
    jg swap_elements  ; Se arr[si] > arr[si+1], troque os elementos

    ; Incrementar contador de comparações
    inc byte [compare_count]

    ; Não houve troca, continuar comparando
    inc si
    loop inner_loop
    dec bl
    jnz outer_loop
    ret

swap_elements:
    ; Realizar a troca entre arr[si] e arr[si+1]
    mov al, [arr + si]
    mov dl, [arr + si + 1]
    mov [arr + si], dl
    mov [arr + si + 1], al

    ; Incrementar contador de trocas
    inc byte [swap_count]

    ; Incrementar contador de comparações
    inc byte [compare_count]

    ; Continuar o loop interno
    inc si
    loop inner_loop
    dec bl
    jnz outer_loop
    ret

; Função para imprimir o número de trocas
print_swap_count:
    mov al, [swap_count]
    add al, '0'
    mov dl, al
    mov eax, 4
    mov ebx, 1
    mov ecx, dl
    mov edx, 1
    int 0x80
    ret

; Função para imprimir o número de comparações
print_compare_count:
    mov al, [compare_count]
    add al, '0'
    mov dl, al
    mov eax, 4
    mov ebx, 1
    mov ecx, dl
    mov edx, 1
    int 0x80
    ret
