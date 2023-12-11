# CS 2640, November 23, 2023
# test 
##Group DRJT - Diego Orendain, Robert Tabares, Jessalin Jiangkhov, Tom Nguyen

# TTT = setup, rules = player gives program int, changes int into O or X, continually updates until winner (O or X three in a row)
# different winner combos = 147, 258, 369, 123, 456, 789, 159, 357 (either in order or reverse also works)?
# macros = prints setup, updates setup, identify the winner, (menu?)


.macro printStr(%string)
	li $v0, 4
	la $a0, %string
	syscall
.end_macro

.macro getInt
    li $v0, 5		#save integer imput to $s0
	syscall
	move $s0, $v0
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

rules1: .asciiz "\nThis is Tic-Tac-Toe! There will be a board of numbers in each of the 9 slots.\n"
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
#jal askForMoves (needed?)

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
	#once the counter reaches 5, we should exit (still testing, get it right = will use to change slot to user input)
	beq $t1, 4, printEnd
	beq $t1, 7, printEnd
	beq $t1, 10, intro
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

	jal main				#print board before asking user move

	printStr(player1Move)	#prompt to get move from Player 1
	getInt					#integer saved to $s0

	#branch if less than 1 or more than 9 to re-prompt for correct user input from Player 1
	blt $s0, 1, invalidSlotPrompt1
	bgt $s0, 9, invalidSlotPrompt1


	#//branch
	#branch to replace number with 'X', then branch back to askForMove2


askForMove2:

	jal main				#//print board with all previous moves
	
	printStr(player2Move)	#prompt to get move from Player 2
	getInt					#save integer input to $s0

	#branch if less than 1 or more than 9 to re-prompt for correct user input from Player 2
	blt $s0, 1, invalidSlotPrompt2
	bgt $s0, 9, invalidSlotPrompt2

	#//branch
	#branch to replace number with 'O', then branch back to askForMove1

invalidSlotPrompt1:

	#re-prompts for correct input
	printStr(invalidSlotNumber)

	jal askForMove1


invalidSlotPrompt2:

	#re-prompts for correct input
	printStr(invalidSlotNumber)

	jal askForMove2

displayMenu:
        # Display menu options
        li $v0, 4               # Load the syscall code for printing a string
        la $a0, menuOptions     # Load the address of the menuOptions string
        syscall

        # Read user choice
        li $v0, 5               # Load the syscall code for reading an integer
        syscall
        move $s0, $v0  # Store user choice in $s0 for later use

        # Conditional jump based on choice
        beq $s0, 1, startGame  # If choice is 1, start game
        beq $s0, 2, exit       # If choice is 2, exit program

        # Add a jump back to menu in case of invalid choice
        j displayMenu

startGame:
       # Reset the game board to initial state (1-9)
       li $t0, 1          # Counter for initializing array values
       la $t1, array      # Pointer to the start of the array

reset_board_loop:
       sw $t0, 0($t1)     # Store counter value in the array
       addi $t0, $t0, 1   # Increment counter
       addi $t1, $t1, 4   # Move to the next array slot
       li $t2, 9
       blt $t0, $t2, reset_board_loop # Loop until all slots are initialized

       # Jump to the main game loop or handle player input here
       j main

askForReplay: # Display replay options
        li $v0, 4
        la $a0, replayOptions
        syscall

        # Read user choice
        li $v0, 5
        syscall
        move $s1, $v0  # Store choice in $s1

        # Conditional logic to either restart game or exit
        beq $s1, 1, main    # If choice is 1, restart game
        beq $s1, 2, exit    # If choice is 2, exit program

        # In case of invalid choice, ask again
        j askForReplay




exit:
	li $v0, 10
	syscall
