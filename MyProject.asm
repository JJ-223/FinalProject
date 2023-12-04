

.macro printStr(%string)
	li $v0, 4
	la $a0, %string
	syscall
.end_macro

.macro printInts
	# if element in array is equal to 10 or 11, it jumos to print0 or printX respectively
	beq $t0, 12, print0
	beq $t0, 11, printX
	
	# print out array element
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

Oinputs: .word 0, 0, 0, 0, 0
Xinputs: .word 0, 0, 0, 0, 0

player1Move: .asciiz "\nPlayer 1, please enter the slot you would like to take: "
player2Move: .asciiz "\nPlayer 2, please enter the slot you would like to take: "

Player1WinText: "Player 1 has WON!!!"
Player2WinText: "Player 2 has WON!!!"

.text
main:	
	
	#move $s3, $sp
	#addi $sp, $sp, 76
	#la $a0, 20($sp) # Oinput
	#move $s5, 40($sp) # 
	#move $s6, 76($sp)
	
	# print out rules
	printStr(rules1)
	printStr(rules2)
	printStr(rules3)
	printStr(rules4)
	
	j askForMove1
	
	

printTable: # prints out the table 
	
	
	#load current element into $t0
	lw $t0, 0($s0)
	
	#increment base address by 4
	addi $s0, $s0, 4
	
	#increment counter by 1
	addi $t1, $t1, 1
	
	# print out integer element/check if X or O in that space
	printInts
	
	#if counter equals 3 call printEnd
	beq $t1, 3, printEnd
	#if counter equals 6 call printEnd
	beq $t1, 6, printEnd
	#if counter equals 9 call checkTurn
	beq $t1, 9, checkTurn
	
	# print out spacer, " | "
	printStr(spacer)
	
	
	j printTable
	
prepareArray: # restart counter and prepares array to be used in printTable

	# load address of array in $s0
	la $s0, array
	printStr(endspacer)
	
	# set loop counter to zero
	move $t1, $zero	
	
	j printTable
	
askForMove1: # prompts user, stores user input, and indicates that its player2s turn next
	
	#ask player 1 for their move
	li $v0, 4		
	la $a0, player1Move
	syscall
	
	#save integer input to $s4
	li $v0, 5		
	syscall
	move $s4, $v0
	
    	# load 12 into $t2 and move it to $s6
    	# Indicates that Player1's turn is complete and that Player2 is next (see checkTurn )
	li $t2, 12
	move $s6, $t2
	
	jal XchangeArray
	

askForMove2: # prompts user, stores user input, and indicates that its player1s turn next

	
	#ask player 2 for their move
	li $v0, 4		
	la $a0, player2Move
	syscall
	
	#save integer input to $s4
	li $v0, 5
	syscall
	move $s4, $v0
    	
	# load 11 into $t2 and move it to $s6
    	# Indicates that Player2's turn is complete and that Player1 is next (see checkTurn )
	li $t2, 11
	move $s6, $t2
	
	jal OchangeArray
	

OchangeArray: # change the value in the array to a 10, which symbolizes a 'O'

	# load address of array in $s0
	la $s0, array
	
	#load current element into $t0
	lw $t0, ($s0)
	
	#la $a2,($s0)
	
	subi $s4, $s4, 1
	
	# multiply $s4(user input) by 4 (bytes) to get the location of the wanted element in array and store in $s5
	mul $s5, $s4, 4
	# add $s5 to array address to get the address of the element we want to change
	add $s0, $s0, $s5
	
	# load the current element into $t3
	lw $t3, ($s0)
	
	# check if $t3, equals 10 and 11 jump to 'askForMove2'
	# the 10 and 11 means that there already is a O or X in that space
	beq $t3, 11, askForMove2
	beq $t3, 12, askForMove2
	
	# load 10,(O), into $t5
	# then store in array
	li $t5, 12 #10
	sw $t5, ($s0)
	
	# check if player has won
	j checkWin
	
	#j prepareArray



XchangeArray: # change the value in the array to a 11, which symbolizes a 'X'

	# load address of array in $s0
	la $s0, array
	
	#load current element into $t0
	lw $t0, ($s0)
	
	#la $a2,($s0)
	
	subi $s4, $s4, 1
	
	# multiply $s4(user input) by 4 (bytes) to get the location of the wanted element in array and store in $s5
	mul $s5, $s4, 4
	# add $s5 to array address to get the address of the element we want to change
	add $s0, $s0, $s5
	
	
	# load the current element into $t3
	lw $t3, ($s0)
	
	# check if $t3, equals 10 and 11 jump to 'askForMove2'
	# the 10 and 11 means that there already is a O or X in that space
	beq $t3, 11, askForMove1
	beq $t3, 12, askForMove1
	

	# load 11,(X), into $t5
	# then store in array
	li $t5, 11
	sw $t5, ($s0)
	
	# check if player has won
	j checkWin
	
	#j prepareArray




checkTurn: # check which players turn it is

	# if $t7 equals 11, call Xwin
	beq $t7, 11, Xwin
	
	# if $t7 equals 11, call Owin
	beq $t7, 12, Owin
	
	# if $t2, equals 11, jump to askForMove1
	beq $t2, 11, askForMove1
	# if $t2, equals 12, jump to askForMove2
	beq $t2, 12, askForMove2

print0: # print out O
	
	# print out O
	li $v0, 4
	la $a0, O
	syscall
	
	# if the $t1(current array element) is 9, we jump to checkTurn
	beq $t1, 9,checkTurn
	
	# if the $t1(current array element) is 3, we jump to printEnd
	beq $t1, 3, printEnd
	# if the $t1(current array element) is 6, we jump to printEnd
	beq $t1, 6, printEnd
	
	# print out space, " | "
	printStr(spacer)
	
	j printTable
	

printX: # print out X
	
	# print out X
	li $v0, 4
	la $a0, X
	syscall
	
	# if the $t1(current array element) is 9, we jump to checkTurn
	beq $t1, 9,checkTurn
	
	# if the $t1(current array element) is 3, we jump to printEnd
	beq $t1, 3, printEnd
	# if the $t1(current array element) is 6, we jump to printEnd
	beq $t1, 6, printEnd
	
	# print out space, " | "
	printStr(spacer)
	
	
	j printTable
	
checkWin: # check if player has won
	j winRow1
	
	
winRow1:  # check if player has won, in row 1

	# load address of array in $s0
	la $s0, array
	 
	# load elements in row 1, into registers
	lw $s1, ($s0)
	lw $s2, 4($s0)
	lw $s3, 8($s0)
	 
	# check that all three elements qre equal
	and $t6, $s1, $s2
	and $t7, $t6, $s3
	
	# if $t7 equals 11, call Xwin
	beq $t7, 11, prepareArray
	
	# if $t7 equals 11, call Owin
	beq $t7, 12, prepareArray
	
	j winRow2

winRow2:# check if player has won, in row 2

	# load address of array in $s0
	la $s0, array
	
	# load elements in row 2, into registers
	lw $s1, 12($s0)
	lw $s2, 16($s0)
	lw $s3, 20($s0)
	
	# check that all three elements qre equal
	and $t6, $s1, $s2
	and $t7, $t6, $s3
	
	# if $t7 equals 11, call Xwin
	beq $t7, 11, prepareArray
	
	# if $t7 equals 11, call Owin
	beq $t7, 12, prepareArray
	
	j winRow3
	
winRow3:# check if player has won, in row 3

	# load address of array in $s0
	la $s0, array
	
	# load elements in row 3, into registers
	lw $s1, 24($s0)
	lw $s2, 28($s0)
	lw $s3, 32($s0)
	
	# check that all three elements qre equal
	and $t6, $s1, $s2
	and $t7, $t6, $s3
	
	# if $t7 equals 11, call Xwin
	beq $t7, 11, prepareArray
	
	# if $t7 equals 11, call Owin
	beq $t7, 12, prepareArray
	
	j winCol1
	
winCol1: # check if player has won, in column 1

	# load address of array in $s0
	la $s0, array
	 
	# load elements in column 1, into registers
	lw $s1, ($s0)
	lw $s2, 12($s0)
	lw $s3, 24($s0)
	 
	# check that all three elements qre equal
	and $t6, $s1, $s2
	and $t7, $t6, $s3
	
	# if $t7 equals 11, call Xwin
	beq $t7, 11, prepareArray
	
	# if $t7 equals 11, call Owin
	beq $t7, 12, prepareArray
	
	j winCol2
	
	
winCol2:# check if player has won, in column 2

	# load address of array in $s0
	la $s0, array
	
	# load elements in column 2, into registers
	lw $s1, 4($s0)
	lw $s2, 16($s0)
	lw $s3, 28($s0)
	 
	# check that all three elements qre equal
	and $t6, $s1, $s2
	and $t7, $t6, $s3
	
	# if $t7 equals 11, call Xwin
	beq $t7, 11, prepareArray
	
	# if $t7 equals 11, call Owin
	beq $t7, 12, prepareArray
	
	j winCol3
	
	
winCol3:# check if player has won, in column 3

	# load address of array in $s0
	la $s0, array
	
	# load elements in column 3, into registers
	lw $s1, 8($s0)
	lw $s2, 20($s0)
	lw $s3, 32($s0)
	 
	# check that all three elements qre equal
	and $t6, $s1, $s2
	and $t7, $t6, $s3
	
	# if $t7 equals 11, call Xwin
	beq $t7, 11, prepareArray
	
	# if $t7 equals 11, call Owin
	beq $t7, 12, prepareArray
	
	j winDiag1

	
winDiag1: # check if player has won, in diagonal 1


	# load address of array in $s0
	la $s0, array
	
	# load elements in diagonal 1, into registers
	lw $s1, ($s0)
	lw $s2, 16($s0)
	lw $s3, 32($s0)
	
	# check that all three elements qre equal
	and $t6, $s1, $s2
	and $t7, $t6, $s3
	
	# if $t7 equals 11, call Xwin
	beq $t7, 11, prepareArray
	
	# if $t7 equals 11, call Owin
	beq $t7, 12, prepareArray
	
	j winDiag2
	
	
winDiag2: # check if player has won, in diagonal 2

	# load address of array in $s0
	la $s0, array
	
	# load elements in diagonal 2, into registers
	lw $s1, 8($s0)
	lw $s2, 16($s0)
	lw $s3, 24($s0)
	
	# check that all three elements qre equal
	and $t6, $s1, $s2
	and $t7, $t6, $s3
	
	# if $t7 equals 11, call Xwin
	beq $t7, 11, prepareArray
	
	# if $t7 equals 11, call Owin
	beq $t7, 12, prepareArray
	
	j prepareArray

	

Xwin: # prints out Player1WinText
	
	printStr(newline)
	printStr(Player1WinText)
	
	j exit

Owin: # prints out Player2WinText
	
	printStr(newline)
	printStr(Player2WinText)
	
	j exit
	

printBeg: # print at the beginning of line when printing table

	printStr(newline)
	printStr(endspacer)
	
	
	j printTable
	
printEnd: # print at the end of line when printing table

	printStr(endspacer)
	printStr(line)
	printStr(newline)
	printStr(endspacer)	
	
	
	j printTable

	
	
exit: # exit program
	li $v0, 10
	syscall
	
