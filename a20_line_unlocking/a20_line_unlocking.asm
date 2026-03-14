org 0x7c00

start:
    cli ; Отключаем прервывания на время установки регистров
    xor ax, ax ; Обнуляем аккумулятор
    mov ds, ax ; Обнуляем датасегмент для правильной адресации
    mov ss, ax ; Обнуляем стек сегмент
    mov sp, 0x7c00 ; Устанавливаем сегмент на адрес по которому нас загрузили ( будем расти вверз)
    sti ; Включаем прерывания обратно

    mov si, introduction_message
    call print_message

    mov si, a20_enabling_message
    call print_message

    call keyboard_wait_for_input

; ---------------------------------------Функция ожидания когда с порта клаватуры вернется ответ о том, что контроллер клавиатуры освободился--------------------------
keyboard_wait_for_input:
    in al, 0x64
    test al, 0x10
    jnz print_keyboard_busy
    ret

print_keyboard_busy:
    mov si, message_keyboard_busy
    call print_message
    jmp keyboard_wait_for_input

; -------------------------------------------------------------------------------------------------------------------------------


keyboard_wait_for_output:
    in al, 0x64
    test al, 0b1
    jz keyboard_wait_for_output
    ret



; ---------------------------------------Функция печати любого сообщения, которое передали нам в si--------------------------
print_message:
    mov ah, 0x0e ; Уставнавливаем в регистр значение для прерывания по которому оно поймет, что мы будем выводить символы

print_message_loop_start: ; Метка внутри функции в которую мы будем возвращаться при печати каждого символа
    loadsb
    test al, al
    jz print_message_endоеув
    int 0x10
    jmp print_message_loop_start

print_message_end:
    ret

; -------------------------------------------------------------------------------------------------------------------------------

message_keyboard_busy:
    db 'Keyboard is busy', 0

introduction_message:
    db 'Welcome to d1v14 bootloader!!!', 0

a20_enabling_message:
    db 'Starting enabling A20 line....', 0

times 510 - ($ - $$) db 0
dw 0xaa55