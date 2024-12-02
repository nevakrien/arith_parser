;rdi contains input pointer (start)

;return
; rax: end_address (result.end_address)
; rdx: data (result.data)
section .text
global parse_arithmetic

align 16
parse_arithmetic:
;save the stack
push rbp
mov rbp,rsp
push 0;terminate the op stack 
mov r10, 0


number_mode:
mov r8, 1 ;sign
cmp byte [rdi], ' ' ;skip spaces
jne maybe_neg
inc rdi 
jmp number_mode

maybe_neg:
cmp byte [rdi], '-'
jne first_digit
mov r8, -1
inc rdi 

first_digit: 
movzx r9, byte [rdi] 
sub r9, '0' ;try converting asci/utf8 to digit value

cmp r9, 0
jb exit_error
cmp r9, 9
ja exit_error

inc rdi

gather_digits:
movzx rax, byte [rdi] 
sub rax,'0' ;try converting asci/utf8 to digit value

cmp rax, 0
jb end_number
cmp rax,9
ja end_number

;r9 = 10r9 + rax (rax = garbage)
lea rax, [rax +2*r9]
shl r9, 3
lea r9, [rax + r9]

inc rdi
jmp gather_digits

end_number:
imul r9, r8;add sign information
cmp r10, '*'
je early_mul
cmp r10, '\'
je early_div

push r9 ;done parsing the curent number
jmp operator_mode

early_mul:
pop rax
imul r9
push rax
jmp operator_mode

early_div:
xor rdx, rdx;prepare for div call
pop rax
idiv r9
push rax
jmp operator_mode

operator_mode:
cmp byte [rdi], ' ' ;skip spaces
jne test_op
inc rdi 
jmp operator_mode

push_op:
movzx rax, byte[rdi]
push rax
inc rdi
mov r10,0
jmp number_mode

early_resolve_op:
movzx r10, byte[rdi]
inc rdi
jmp number_mode

test_op:
cmp byte [rdi], '-'
je push_op
cmp byte [rdi], '+'
je push_op
cmp byte [rdi], '*'
je early_resolve_op
cmp byte [rdi], '/'
je early_resolve_op

; jmp done_reading_input

done_reading_input:
pop r9

op_loop:
pop r8 ;op
cmp r8, '+'
je case_plus
cmp r8, '-'
je case_minus
; cmp r8, '*'
; je case_mul
; cmp r8, '/'
; je case_div
;terminator case
jmp return_good

case_plus:
pop rcx
add r9, rcx
jmp op_loop

case_minus:
;r9 var-r9
mov rcx,r9 
pop r9
sub r9, rcx
jmp op_loop

; case_mul:
; xor rdx, rdx;prepare for mul call
; pop rax
; imul r9
; mov r9, rax
; jmp op_loop


; case_div:
; xor rdx, rdx;prepare for div call
; pop rax
; idiv r9
; mov r9, rax
; jmp op_loop


return_good:
mov rdx, r9
mov rax, rdi 
;jmp wrap_up

wrap_up:
mov rsp,rbp
pop rbp
ret

exit_error:
mov rax, 0
mov rdx, rdi
jmp wrap_up