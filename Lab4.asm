###################################################################################################################
# Created by: Jones, Shweta
#	      shsujone
#	      30 November, 2020
# Assignment: Search HEX
#	      CMPE 012, Computer Systems and Assembly Language
#             UC Santa Cruz, Falll 2020
# Description: Lab print the user arguements, converts/prints them into decimal form, and prints the max decimal
# Notes: This program is meant to run on MARS IDE and requires a java download as well.
###################################################################################################################
							#PSEUDOCODE#
#Saves number of arguements into register
#Saves pointer address
#Print prompt 1
#for (i = 0; i < argument count; i++)
	#Print argument
	#Print space
#Print prompt 2
#Initializes max running sum to 0
#Reinitializes all values that will be used in following loop
#for  (i = 0; i < argument count; i++)
	#Initializes running sum
	#While byte != 0
		#Load byte to register
#Counts number of times to raise by 16
		#If byte == 0
			#Leave while looop
	#Loads first word into register
	#Shifts byte right by 2
	#Loads 3rd value into a register
	#for (i = 0; i < number of times to raise by 16 (letters in word) ; i ++)
		#If character is a letter/char
			#Calculates the decimal value
		#If character is a integer
			#Calculates the decimal value
		#Adds to running sum
	#Print running sum
	#Print space 
	#If running sum > max running sum 
		#Saves current running sum as max running sum
#Print prompt 3
#Print value max running sum
###################################################################################################################
.text
move $s0 $a0		# saves # of arg to s0
move $t8 $a1
move $s1 $a1		# saves address to s1

li $v0 4		# loads return value register $v0 as a print string
la $a0 prompt1		# loads prompt1
syscall			# calls system call

li $s2, 0		# initialized i == 0
li $t5 0		# initializes max number to 0

argLoop:	# Loop prints arguements 
	lw $s4 ($s1)		# loads s1 into s4
        li $v0 4		# arguement in enter string
	la $a0 ($s4)		# loads string into a0
	syscall			# calls system call
	
	li $v0 11		# argument to enter char
	la $a0 0x20		# enters a space
	syscall			# calls system call
		
	li $s3 4		# initializes constant variable holding 4
	add $s2 $s2 1		# i++
	multu $s3 $s2		# 4*i saves in $LO
	mflo $s3		# save offset value in s3
	add $s1 $a1, $s3	# adds offset to register address and saves into s1
	
	beq $s2 $s0 decLoopInit	# i == # of arg --> EXIT ### send to exit where P2, buffer, P3, and max are printed
	b argLoop		# repeats loop

decLoopInit:		# initializes values and prints prompts, goes striaght to decLoop after
	li $v0 4		# loads return value register $v0 as a print string
	la $a0 prompt3		# loads prompt3
	syscall			# calls system call
	
	li $s2 0		# reinitializes values
	li $s4 0		# reinitializes values
	
decLoop:		# loops through each argument and eventually exits when end of arguement is reached
	lw $s4 ($t8)		# loads s1 into s4
	
	li $t7 0 		# initialized running counter to 0
	li $t3 16		# decimal representative of 16
	lw $t0 ($t8)		# loads t8 to t0
	jal power		#sends to power where convert2 process starts	
		
	li $s3 4		# initializes constant variable holding 4
	add $s2 $s2 1		# i++
	multu $s3 $s2		# 4*i saves in $LO
	mflo $s3		# save offset value in s3
	add $t8 $a1, $s3	# adds offset to register address and saves into s1
	
	beq $s2 $s0 exit	# i == # of arg --> EXIT ### send to exit where P2, buffer, P3, and max are printed
	b decLoop			# repeats loop
	
power:			# calculates 16th power
	add $t0 $t0 3		# moves it by 3, so it moves to position after "x"
	li $t6 1		# initializes number to tell how much to raise 16
lengthCheck:		# checks number of times power needs to be raised
	lb $t3 ($t0)		# loads t0 to t3
	beq $t3 $zero convert1	# t3 == 0 goes to convert1
	add $t0 $t0 1		# t0++, basically moves to next position
	sll $t6 $t6 4		# shifts left by 4
	b lengthCheck		# repeats loop

convert1:		#  goes directly to convert2
	move $t3 $t6		# moves information in t6 to t3
	lw $t0 ($t8)		# loads first word address to $t0 (reinitializes for each word)
	add $t0 $t0 2		# moves two btyes over, so third position
convert2:		# converts the arguement to decimal, if value is not a letter goes directly
	lb $t1 ($t0)		# loads 3rd letter to $t1
	beq $t1 $zero findMax	# for loop: runs number of letters in arguement else goes to findMax
	blt $t1 0x3A number	# when the value is greater than 3A(:) then it goes to letter, else number
	
letter:			# converts letter to decimal value and adds to sum
	subi $t1 $t1 55		# converts to int value
	mul $t4 $t1 $t3		# convert int using base16
	div $t3 $t3 16		# divide by 16
	add $t7 $t7 $t4		# adds value to running sum
	add $t0 $t0 1		# adds 1 to pointer counter
	add $t9 $t9 1		# adds 1 to loop counter
	b convert2		# goes to convert2 branch

number:			# converts number to decimal value and adds to sum
	subi $t1 $t1 48		# convert to int value
	mul $t4 $t1 $t3		# convert int using base16
	div $t3 $t3 16		# divide by 16
	add $t7 $t7 $t4		# adds value to running sum
	add $t0 $t0 1		# adds 1 to pointer counter
	add $t9 $t9 1		# adds 1 to loop counter
	b convert2		# goes to convert2 branch
	
findMax: 		# if $t5 >> than go to decimalString
	bgt $t7 $t5 setMax		# check if new number is greater than old, if so goes to setMax
	b decimalString			# goes to decimalString 

setMax:			# since new decimal is greater, t5 is set as max, goes directly to decimalString
	move $t5 $t7		# replaces $t5 with $t7 to set new maximum
	
decimalString:			# adds decimal to stack
	li $v0 1		# prints number
	la $a0 ($t7)		# loads t7 into a0
	syscall			# calls system call
	
	li $v0 11		# argument to enter char
	la $a0 0x20		# enters a space
	syscall			# calls system call
	
	jr $ra			# jumps to jal within decLoop

exit:	
	li $v0 4		# loads return value register $v0 as a print string
	la $a0 prompt4		# loads prompt4
	syscall	
	
	li $v0 1		# prints max
	la $a0 ($t5)
	syscall
	
	li $v0 4		#newline is printed
	la $a0 newLine
	syscall
	
	li $v0 10		# ends program
	syscall
 
 .data
	prompt1:	.asciiz "Program arguments: \n"
	prompt3:	.asciiz "\n\nInteger values: \n"
	prompt4:	.asciiz "\n\nMaximum value: \n"
	newLine: .asciiz "\n" 