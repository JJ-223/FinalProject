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

player1Move: .asciiz "\nPlayer 1, please enter the slot you would like to take: "
player2Move: .asciiz "\nPlayer 2, please enter the slot you would like to take: "


invalidSlotNumber: .asciiz "\nInvalid slot number, try again please."


.text
jal askForMoves

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
	li $v0, 4		
	la $a0, rules1
	syscall
	li $v0, 4		
	la $a0, rules2
	syscall
	li $v0, 4		
	la $a0, rules3
	syscall
	li $v0, 4		
	la $a0, rules4
	syscall


	jal askForMove1 #jumps to ask players thier moves

askForMove1:

	#///FIX/// jumping to printBeg doesn't work? initial board build?
	#begin game
	#jal printBeg #assuming this prints only board with only numbers
	#//trying to print board with what has already been played

	li $v0, 4		#ask player 1 for their move
	la $a0, player1Move
	syscall
	
	li $v0, 5		#save integer imput to S0
	syscall
	move $s0, $v0

	#branch if less than 1 or less than 9 to re-prompt for correct user input from Player 1
	blt $s0, 1, invalidSlotPrompt1
	bgt $s0, 9, invalidSlotPrompt1


	#//branch
	#branch to replace number with 'X', then branch back to askForMove2


askForMove2:

	#//print board with all previous moves
	
	li $v0, 4		#ask player 2 for their move
	la $a0, player2Move
	syscall
	
	li $v0, 5		#save integer input to S0
	syscall
	move $s0, $v0

	#//branch
	#branch to replace number with 'O', then branch back to askForMove1


	#branch if less than 1 or less than 9 to re-prompt for correct user input from Player 2
	blt $s0, 1, invalidSlotPrompt2
	bgt $s0, 9, invalidSlotPrompt2



invalidSlotPrompt1:

	#re-prompts for correct input
	li $v0, 4		
	la $a0, invalidSlotNumber
	syscall

	jal askForMove1


invalidSlotPrompt2:

	#re-prompts for correct input
	li $v0, 4		
	la $a0, invalidSlotNumber
	syscall

	jal askForMove2











exit:
	li $v0, 10
	syscall
