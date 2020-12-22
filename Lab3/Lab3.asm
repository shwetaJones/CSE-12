.text 
main: 
	li $v0, 4 #prompt is printed
	la $a0, prompt
	syscall
	li $v0, 5 #input is saved
	syscall
	move $s0, $v0 #s0 is height
	blt $s0, 1, error #checks if number is valid or not
	li $t0, 1 #num
forLoop1:
	beq $s0, $t2, exit #exits when height == i
	addi $t2, $t2, 1 #i++
	li $v0, 4 #newline is printed
	la $a0, newLine
	syscall
	li $t3, 0 #j is initialized with 0; j=0
	seq $5, $t0, 1 #checks to see if $t0 == 1
	beq $5, $0, Else #if not, program goes to else label
	jal addTab  #Adds tab and the first number
	j forLoop1 #Goes back to beginning of forLoop1
Else: 
	jal addTab  #Adds tab and the first number
	addi $t1, $t1, 2 #numstar + 2
	li $t5, 0 #initializes m
	jal printStar #goes to printStar
addTab:
	sub $t4, $s0, $t2 #height - i
	beq $t4, $t3, printNumber
	li $v0, 4 #prints a tab
	la $a0, tab
	syscall
	addi $t3, $t3, 1 #j++
	j addTab #goes to beginning of addTab
printNumber:
	li $v0, 1 #prints num   
	move $a0, $t0      
	syscall
	li $v0, 4 #prints a tab
	la $a0, tab
	syscall
	addi $t0, $t0, 1 #num++
	div $t7, $t0, 2 #divides value by 2 and saves into $t7
	mfhi $s1 #remainder is saved in $s1
	seq $5, $s1, 0 #checks to see if remainder is/is not equivalent to 0
	beq, $5, $0, Else2 #if the remainder is 0, then goes to Else2 label
	j forLoop1 #if remainder if 1, then goes to forLoop1
Else2:
	jr $ra #allows to go back to jal addTab in Else
printStar:
	sub $t6, $t1, 1 #numStar-1 and saves into $t6
	beq $t5, $t6, printNumber #checks to see if m and numStar-1 are equal or not, if so sends to printNumber
	li $v0, 4 #prints star
	la $a0, star
	syscall
	addi $t5, $t5, 1 #m++
	j printStar #goes to beginning of printStar
error: #https://github.com/DikshaSach/MIPS/blob/master/Sach_h1_3.s
	li $v0, 4 #prints that the entry is invalid
	la $a0, invalid
	syscall
	li $v0,4 #prints a new line
	la $a0, newLine
	syscall
	j main #goes back to main program
exit:
	li $v0, 10 #exits the program
	syscall
.data 
prompt: .asciiz "Enter a height greater than 0:	" 
invalid: .asciiz "Invalid entry!" 
newLine: .asciiz "\n" 
star:	.asciiz	"*	" 
tab:	.asciiz"	"