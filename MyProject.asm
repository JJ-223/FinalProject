

.macro printStr(%string)
	li $v0, 4
	la $a0, %string
	syscall
.end_macro

.macro printInts
	beq $t0, 10, print0
	beq $t0, 11, printX
	
	li $v0, 1
	move $a0, $t0
	syscall
	
	
	
.end_macro



.data

rules1: .asciiz "This is Tic-Tac-Toe! There will be a board of numbers in each of the 9 slots.\n"
rules2: .asciiz "Each player will enter the integer of the slot they would like to choose.\n"
rules3: .asciiz "Player 1 will be assigned 'X', and Player 2 will be assigned 'O'\n"
rules4: .asciiz "Once the player picks a slot, that slot will be replaced with their respective 'X' or 'O'.\n"


line: .asciiz "\n-----------------"
newline: .asciiz "\n"
spacer: .asciiz "  |  "
endspacer: .asciiz "  "
array: .word 1, 2, 3, 4, 5, 6, 7, 8, 9 


O: .asciiz "O"
X: .asciiz "X"
allInputs: .word 0, 0, 0, 0, 0, 0, 0, 0, 0
Oinputs: .word 0, 0, 0, 0, 0
Xinputs: .word 0, 0, 0, 0, 0

player1Move: .asciiz "\nPlayer 1, please enter the slot you would like to take: "
player2Move: .asciiz "\nPlayer 2, please enter the slot you would like to take: "

.text
main:	
	
	move $s3, $sp
	addi $sp, $sp, 76
	la $a0, 20($sp) # Oinput
	#move $s5, 40($sp) # 
	#move $s6, 76($sp)
	
	printStr(rules1)
	printStr(rules2)
	printStr(rules3)
	printStr(rules4)
	j askForMove1
	
	

printTable:
	
	
	#load current element into $t0
	lw $t0, 0($s0)
	
	#increment base address by 4
	addi $s0, $s0, 4
	#increment counter by 1
	addi $t1, $t1, 1
	
	#new
	
	
	
	#new
	#beq $t1, 10, print0
	
	printInts
	
	
	
	
	#implement conditional to break out of the loop
	#once the counter reaches 5, we should exit
	beq $t1, 3, printEnd
	beq $t1, 6, printEnd
	beq $t1, 9, checkTurn
	
	
	printStr(spacer)
	
	
	
	
	j printTable
	
prepareArray:
	la $s0, array
	printStr(endspacer)
	#loop counter
	move $t1, $zero
	j printTable
	
askForMove1:

	#///FIX/// jumping to printBeg doesn't work? initial board build?
	#begin game
	#jal printBeg #assuming this prints only board with only numbers
	#//trying to print board with what has already been played

	li $v0, 4		#ask player 1 for their move
	la $a0, player1Move
	syscall
	
	li $v0, 5		#save integer imput to $s0
	syscall
	#move $s7, $v0
	move $s4, $v0
	
    	
	li $t2, 12
	move $s6, $t2
	
	jal XchangeArray
	
	#j prepareArray
	
	#branch if less than 1 or less than 9 to re-prompt for correct user input from Player 1
	#blt $s0, 1, invalidSlotPrompt1
	#bgt $s0, 9, invalidSlotPrompt1

	#jal printBeg
	#//branch
	#branch to replace number with 'X', then branch back to askForMove2
	
askForMove2:

	#//print board with all previous moves
	
	li $v0, 4		#ask player 2 for their move
	la $a0, player2Move
	syscall
	
	#li $v0, 5		#save integer input to $s0
	#syscall
	#move $s7, $v0
	
	li $v0, 5
	syscall
	move $s4, $v0
	
	#jal OchangeArray
	
    	#sw $v0, Oinputs($s1)
	#increment base addresss by 4
    	
	
	li $t2, 11
	move $s6, $t2
	
	jal OchangeArray
	
	#j prepareArray

	#branch if less than 1 or less than 9 to re-prompt for correct user input from Player 2
	#blt $s0, 1, invalidSlotPrompt2
	#bgt $s0, 9, invalidSlotPrompt2

	#//branch
	#branch to replace number with 'O', then branch back to askForMove1

OchangeArray:
#new
	la $s0, array
	
	#load current element into $t0
	lw $t0, ($s0)
	la $a2,($s0)
	subi $s4, $s4, 1
	mul $s5, $s4, 4
	add $s0, $s0, $s5
	
	li $t5, 10
	
	sw $t5, ($s0)
	#incremeent base adress
	#addi $s1, $s1, 4
	
	j prepareArray


#new

XchangeArray:
#new
	la $s0, array
	
	#load current element into $t0
	lw $t0, ($s0)
	la $a2,($s0)
	subi $s4, $s4, 1
	mul $s5, $s4, 4
	add $s0, $s0, $s5
	
	li $t5, 11
	
	sw $t5, ($s0)
	#incremeent base adress
	#addi $s1, $s1, 4
	
	j prepareArray


#new


checkTurn:

	beq $t2, 11, askForMove1
	beq $t2, 12, askForMove2

print0:
	
	
	li $v0, 4
	la $a0, O
	syscall
	
	#increment base address by 4
	#addi $s0, $s0, 4
	#increment counter by 1
	#addi $t1, $t1, 1
	
	beq $t1, 9,checkTurn
	
	
	beq $t1, 3, printEnd
	beq $t1, 6, printEnd
	
	printStr(spacer)
	
	j printTable
	
#new
printX:
	
	
	li $v0, 4
	la $a0, X
	syscall
	
	#increment base address by 4
	#addi $s0, $s0, 4
	#increment counter by 1
	#addi $t1, $t1, 1
	
	beq $t1, 9,checkTurn
	
	
	beq $t1, 3, printEnd
	beq $t1, 6, printEnd
	
	printStr(spacer)
	
	j printTable
#new

printBeg:
	printStr(newline)
	printStr(endspacer)
	j printTable
	
printEnd:
	printStr(endspacer)
	printStr(line)
	printStr(newline)
	printStr(endspacer)
	j printTable


	
	
exit:
	li $v0, 10
	syscall
	
	
