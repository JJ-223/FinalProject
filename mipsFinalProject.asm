# CS 2640, November 23, 2023
# test 

# TTT = setup, rules = player gives program int, changes int into O or X, continually updates until winner (O or X three in a row)
# different winner combos = 147, 258, 369, 123, 456, 789, 159, 357 (either in order or reverse also works)?
# macros = prints setup, updates setup, identify the winner, (menu?)


.macro printStr(%string)
	li $v0, 4
	la $a0, %string
	syscall
.end_macro

.macro printInt(%int)
	li $v0, 1
	la $a0, %int
	syscall
.end_macro

.macro printInts 
	#load current element into $t0
	lw $t0, 0($s0)
	#print out the current element
	li $v0, 1
	move $a0, $t0
	syscall
.end_macro

.macro updateSlot (%int)
	sub 

.end_macro

.macro printO
	li $v0, 4
	la $a0, O
	syscall
.end_macro


.data

rules1: .asciiz "This is Tic-Tac-Toe! There will be a board of numbers in each of the 9 slots.\n"
rules2: .asciiz "Each player will enter the integer of the slot they would like to choose.\n"
rules3: .asciiz "Player 1 will be assigned 'X', and Player 2 will be assigned 'O'\n"
rules4: .asciiz "Once the player picks a slot, that slot will be replaced with their respective 'X' or 'O'."


line: .asciiz "\n-----------------"
newline: .asciiz "\n"
spacer: .asciiz "  |  "
endspacer: .asciiz "  "
array: .word 1, 2, 3, 4, 5, 6, 7, 8, 9


O: .asciiz "O"
X: .asciiz "X"

player1Move: .asciiz "Player 1, please enter the slot you would like to take: "
player2Move: .asciiz "Player 2, please enter the slot you would like to take: "

.text
main:
	la $s0, array
	#loop counter
	addi $t1, $t1, 1
	j printBeg
	
loop:
	printInts
	
	#increment base address by 4
	addi $s0, $s0, 4
	#increment counter by 1
	addi $t1, $t1, 1
	#implement conditional to break out of the loop
	#once the counter reaches 5, we should exit
	beq $t1, 4, printEnd
	beq $t1, 7, printEnd
	beq $t1, 10, exit
	printStr(spacer)
	
	beq $t1, 5, conditional
	j loop
	
conditional:
	addi $s0, $s0, 4
	#increment counter by 1
	addi $t1, $t1, 1
	
	li $v0, 4
	la $a0, O
	syscall
	
	printStr(spacer)
	beq $t1, 4, printEnd
	beq $t1, 7, printEnd
	j loop	
	
printBeg:
	printStr(newline)
	printStr(endspacer)
	j loop
	
printEnd:
	printStr(endspacer)
	printStr(line)
	printStr(newline)
	printStr(endspacer)
	j loop
	
printO:
	move $t1, $zero
	li $v0, 4
	la $a0, ($t1)
	syscall
	j exit


intro:
	li $v0, 4		#displays rules
	la $a0, rules1
	syscall
	li $v0, 4		#displays rules
	la $a0, rules2
	syscall
	li $v0, 4		#displays rules
	la $a0, rules3
	syscall
	li $v0, 4		#displays rules
	la $a0, rules4
	syscall


	jal askForMoves #jumps to ask players thier moves

askForMoves:
	#begin game, ask player 1 for slot they'd like to replace X with and save that number
	printBeg #assuming this prints only board with only numbers

	li $v0, 4		#ask player 1 for their move
	la $a0, player1Move
	syscall
	
	li $v0, 5		#save integer imput to S0
	syscall
	move $s0, $v0

	#branch to board




	#branch to board to replace slot with X, then reprint board with X in board
	li $v0, 4		#ask player 2 for their move
	la $a0, player2Move
	syscall
	
	li $v0, 5		#save integer input to S0
	syscall
	move $s0, $v0


	#ask player 2 for slot number to replace with O


	#branch to board to replace slot with O

	#loop to askForMove to keep asking for Player 1 and 2 moves
exit:
	li $v0, 10
	syscall
