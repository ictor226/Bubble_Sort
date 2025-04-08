section .data
    ; Definindo um array de números inteiros
    array db 10, 7, 3, 8, 5, 2, 9, 4, 6, 1
    array_size db 10              ; Tamanho do array

section .bss
    ; Reservando espaço para temporário durante a ordenação
    temp resb 1                    ; Para armazenar um byte temporário

section .text
    global _start

_start:
    ; Carrega o tamanho do array em al
    mov al, [array_size]           ; Carrega o tamanho do array
    dec al                         ; Decrementa 1 porque as posições começam do 0
    mov bl, al                     ; bl vai ser o índice do loop externo (controlador de passes)

outer_loop:
    ; Se o índice for menor que 1, a ordenação foi concluída
    mov al, bl
    cmp al, 1                      ; Se al (tamanho - 1) for <= 1, a ordenação está concluída
    jbe end_sort

    ; Inicializando o índice do loop interno para percorrer os elementos
    mov si, 0                      ; SI = 0 (início do array)
    mov di, bl                     ; DI = bl (limite do loop externo)

inner_loop:
    ; Compara os elementos adjacentes array[si] e array[si+1]
    mov al, [array + si]           ; Carrega array[si] em al
    mov dl, [array + si + 1]       ; Carrega array[si+1] em dl
    cmp al, dl                      ; Compara array[si] com array[si+1]
    jle no_swap                     ; Se array[si] <= array[si+1], não há troca

    ; Se array[si] > array[si+1], troca os elementos
    mov [temp], al                 ; Salva array[si] em temp
    mov [array + si], dl           ; Coloca array[si+1] em array[si]
    mov [array + si + 1], [temp]   ; Coloca array[si] (salvo em temp) em array[si+1]

no_swap:
    inc si                          ; Incrementa si (avança para o próximo par)
    dec di                          ; Decrementa o contador do loop interno
    jnz inner_loop                  ; Se ainda houver elementos para comparar, continua o loop

    ; Decrementa o número de passes e repete o loop externo
    dec bl
    jmp outer_loop                  ; Volta ao loop externo

end_sort:
    ; Aqui o array está ordenado
    ; Exibindo os elementos ordenados (apenas para depuração/saída)
    mov eax, 4                      ; sys_write
    mov ebx, 1                      ; escrevendo no stdout
    mov ecx, array                  ; endereço do array
    mov edx, 10                     ; número de bytes a serem escritos
    int 0x80                        ; chamada de sistema para escrever na tela

    ; Encerra o programa
    mov eax, 1                      ; sys_exit
    xor ebx, ebx                    ; código de saída 0
    int 0x80                        ; chamada de sistema
