;rdi contains input pointer (start)

;return
; rax: end_address (result.end_address)
; rdx: data (result.data)
section .text
global parse_arithmetic

align 16
parse_arithmetic:
;save the stack
mov r10, rsp
push 0;terminate the op stack 

number_mode:
mov r8, 1 ;sign
test byte [rdi], ' ' ;skip spaces
jnz maybe_neg
inc rdi 
jmp number_mode

maybe_neg:
test byte [rdi], '-'
jne first_digit
mov r8, -1
inc rdi 

first_digit: 
movzx rdx, byte [rdi] 
sub rdx, '0' ;try converting asci/utf8 to digit value

cmp rdx, rdx
jb exit_error
cmp rdx, 9
ja exit_error

gather_digits:
inc rdi
movzx rax, byte [rdi] 
sub rax,'0' ;try converting asci/utf8 to digit value

cmp rax, 0
jb end_number
cmp rax,9
ja end_number

;rdx = 10rdx + rax (rax = garbage)
lea rax, [rax +2*rdx]
shl rdx, 3
lea rdx, [rax + rdx]

jmp gather_digits

end_number:
imul rdx, r8;add sign information
push rdx ;done parsing the curent number

inc rdi

operator_mode:
test byte [rdi], ' ' ;skip spaces
jnz test_op
inc rdi 
jmp operator_mode

push_op:
movzx rax, byte[rdi]
push rax
inc rdi
jmp number_mode

test_op:
test byte [rdi], '-'
je push_op
test byte [rdi], '+'
je push_op
test byte [rdi], '*'
je push_op
test byte [rdi], '/'
je push_op

; jmp done_reading_input

done_reading_input:
pop r9

op_loop:
pop r8 ;op
test r8, '+'
je case_plus
test r8, '-'
je case_minus
test r8, '*'
je case_mul
test r8, '/'
je case_div
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

case_mul:
xor rdx, rdx;prepare for mul call
pop rax
imul r9
mov r9, rax
jmp op_loop


case_div:
xor rdx, rdx;prepare for div call
pop rax
idiv r9
mov r9, rax
jmp op_loop


return_good:
mov rdx, r9
mov rax, rdi 
;jmp wrap_up

wrap_up:
mov rsp, r10
ret

exit_error:
mov rax, 0
mov rdx, rdi
jmp wrap_up