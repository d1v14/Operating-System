org 0x7c00

start:
    cli ; Отключаем прервывания на время установки регистров
    xor ax, ax ; Обнуляем аккумулятор
    mov ds, ax ; Обнуляем датасегмент для правильной адресации
    mov ss, ax ; Обнуляем стек сегмент
    mov sp, 0x7c00 ; Устанавливаем сегмент на адрес по которому нас загрузили ( будем расти вниз)
    sti ; Включаем прерывания обратно

    mov si, introduction_message
    call print_message

    mov si, a20_enabling_message
    call print_message

    call fast_a20_unlocking
    call check_a20_enabled


fast_a20_unlocking:
    in ax, 0x92
    or ax, 0x02
    out 0x92, ax
    ret

; ---------------------------------------Функция, которая проверят, включилась ли линия а20, записывая в 1 мегабайт значение 0xAF -------------------------
check_a20_enabled:
    mov ax, 0xFFFF
    mov es, ax

    mov ax, [0x500]
    push ax

    not ax
    mov [es:0x510], ax

    cmp word [0x500], ax

    pop ax
    mov [0x500], ax

    je a20_enabling_fail
    mov si, a20_enabled_message
    call print_message
    jmp end

a20_enabling_fail:
    mov si, a20_enabling_failure_message
    call print_message
    jmp end
; -------------------------------------------------------------------------------------------------------------------------------


; ---------------------------------------Функция печати любого сообщения, которое передали нам в si--------------------------
print_message:
    mov ah, 0x0e ; Уставнавливаем в регистр значение для прерывания по которому оно поймет, что мы будем выводить символы

print_message_loop_start: ; Метка внутри функции в которую мы будем возвращаться при печати каждого символа
    lodsb
    test al, al
    jz print_message_end
    int 0x10
    jmp print_message_loop_start

print_message_end:
    ret
; -------------------------------------------------------------------------------------------------------------------------------

end:
    jmp $

message_keyboard_busy:
    db 'Keyboard is busy', 13, 10, 0

introduction_message:
    db 'Welcome to d1v14 bootloader!!!', 13, 10, 0

a20_enabling_message:
    db 'Starting enabling A20 line....', 13, 10, 0

a20_enabled_message:
    db 'A20 line enabled!!!', 13, 10, 0

a20_enabling_failure_message:
    db 'A20 line enabling failure:(', 13, 10, 0

times 510 - ($ - $$) db 0
dw 0xaa55