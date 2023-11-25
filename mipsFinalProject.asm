# CS 2640, November 23, 2023
# test 

.data
prompt: .asciiz "hello"
.text
main:
	li $v0, 4
	la $a0, prompt
	syscall
	li $v0, 10
	syscall

# EDIT TEST
# Hi
