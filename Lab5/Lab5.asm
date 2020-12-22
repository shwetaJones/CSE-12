##########################################################################
# Created by: Jones, Shweta
# CruzID: shsujone
# 11 December, 2020
#
# Assignment: Lab 5: Functions and Graphics
# CMPE 012, Computer Systems and Assembly Language
# UC Santa Cruz, Fall 2020
#
# Description: This program contains subroutines to be run by the test file. 
#	       Clear Bitmap: colors the entire bitmap one color
#	       Draw Pixel: places the color into the given address
#	       Get Pixel: gets the address of the given pixel
#	       Draw Rectabgle: uses the color, width, height and base address in order to illustrate a rectangle
#	       Draw Diamond: uses the color, base address, and height to draw a diamond
# Notes: This program is intended to be run from the MARS IDE.
##########################################################################

## Macro that stores the value in %reg on the stack 
##  and moves the stack pointer.
.macro push(%reg)
	subi $sp $sp 4
	sw %reg 0($sp)
.end_macro 

# Macro takes the value on the top of the stack and 
#  loads it into %reg then moves the stack pointer.
.macro pop(%reg)
	lw %reg 0($sp)
	addi $sp $sp 4	
.end_macro

# Macro that takes as input coordinates in the format
# (0x00XX00YY) and returns 0x000000XX in %x and 
# returns 0x000000YY in %y
.macro getCoordinates(%input %x %y)
	andi %x %input 0x00FF0000 #sets %x to the input values where the FF are 
	andi %y %input 0x000000FF #sets %y to the input values where the FF are 
	srl %x %x 16
.end_macro

# Macro that takes Coordinates in (%x,%y) where
# %x = 0x000000XX and %y= 0x000000YY and
# returns %output = (0x00XX00YY)
.macro formatCoordinates(%output %x %y)
	sll %output %x 16	#sets %output to %x shifted left by 16
	or %output %output %y	#sets %output to bitwise OR of $output and %y
.end_macro 

.data
originAddress: .word 0xFFFF0000
prompt1: .asciiz "Runs through IF\n"
prompt2: .asciiz "Runs through ELSE\n"

.text
j done
    
done: nop
	li $v0 10 
	syscall
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  Subroutines defined below
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#*****************************************************
#Clear_bitmap: Given a color, will fill the bitmap display with that color.
#-----------------------------------------------------
# Pseudocode:
#	calculates highest address position
# 	uses for loop to iterate through each address
#	loads color in that address 
#-----------------------------------------------------
#   Inputs:
#    $a0 = Color in format (0x00RRGGBB) 
#   Outputs:
#    No register outputs
#    Side-Effects: 
#    Colors the Bitmap display all the same color
#*****************************************************
clear_bitmap: nop	# makes enture bitmap one color
	lw $t0, originAddress		# sets originAddress to t0
	mul $t3, $t3, 128
	mul $t3, $t3, 128
	mul $t3, $t3, 4			# sets t3 to highest position value
ClearForLoop:		# run for loop in order to 
	beq $t0, $t3, ClearExitLoop	# exits loop when t3==t0
	sw $a0, ($t0)			# sets $t0 to color
	addi $t0, $t0, 4		# adds 4 to t0, basically moves to next word
	j ClearForLoop			# jumps to beggining of the loop
ClearExitLoop:		# runs loops to end program
 	jr $ra
#*****************************************************
# draw_pixel:
#  Given a coordinate in $a0, sets corresponding value
#  in memory to the color given by $a1	
#-----------------------------------------------------
# Pseudocode:
#	calculates offset
# 	adds to origin to get final address
#	loads color in that address 
#-----------------------------------------------------
#   Inputs:
#    $a0 = coordinates of pixel in format (0x00XX00YY)
#    $a1 = color of pixel in format (0x00RRGGBB)
#   Outputs:
#    No register outputs
#*****************************************************
draw_pixel: nop		# exit to place color in address
	getCoordinates($a0, $t1, $t2)	# saves x-coord to t1 and y-coord to t2
	mul $t4, $t2, 128
	add $t4, $t4, $t1
	mul $t4, $t4, 4			# sets $t4 to offset
	lw $t0, originAddress		# saves originAddress to t0
	add $t0, $t0, $t4		# adds offset to t0
	sw $a1, ($t0)			# loads color to t0
	jr $ra
#*****************************************************
# get_pixel:
#  Given a coordinate, returns the color of that pixel	
#-----------------------------------------------------
# Pseudocode:
#	calculates highest address position
# 	uses for loop to iterate through each address
#	loads color in that address and sends back to test
#-----------------------------------------------------
#   Inputs:
#    $a0 = coordinates of pixel in format (0x00XX00YY)
#   Outputs:
#    Returns pixel color in $v0 in format (0x00RRGGBB)
#*****************************************************
get_pixel: nop		# loop to get address of the pixel
	getCoordinates($a0, $t1, $t2)	# saves x-coord to t1 and y-coord to t2
	mul $t5, $t2, 128
	add $t5, $t5, $t1
	mul $t5, $t5, 4			# sets $t4 to offset
	lw $t0, originAddress		# saves originAddress to t0
	add $t0, $t0, $t5		# adds offset to t0
	lw $v0, ($t0)			# loads the address at t0 and sends to main
	jr $ra 
#*****************************************************
#draw_rect: Draws a rectangle on the bitmap display.
#-----------------------------------------------------
# Pseudocode:
# draw_diamond(height, base_point_x, base_point_y)
# 	initializes i and j
#	for (i=0; i<height; i++)
# 		for (j=0; j<width; j++)
#			loads color into address
# 	exits program
#-----------------------------------------------------
#	Inputs:
#		$a0 = coordinates of top left pixel in format (0x00XX00YY)
#		$a1 = width and height of rectangle in format (0x00WW00HH)
#		$a2 = color in format (0x00RRGGBB) 
#	Outputs:
#		No register outputs
#*****************************************************
draw_rect: nop		# program draws rectangles
	getCoordinates($a0, $t1, $t2)	# t1 == x-coord t2 == y-coord
	getCoordinates($a1, $t6, $t7)	# t6 == width t7 == height
	li $t9, 0			# sets i (t9) to 0
	li $t8, 0			# sets j (t8) to 0
	
	mul $t3, $t2, 128
	add $t3, $t3, $t1
	mul $t3, $t3, 4
	lw $t0, originAddress		# saves originAddress to t0
	add $t0, $t0, $t3		# adds offset to t0

rectForLoop1:		# outer FOR loop that jumps to next y-coord
	beq $t7, $t9, rectExitLoop	# i == height, exits program

rectForLoop2:		# inner FOR loop jumps to next x-coord
	beq $t6, $t8,rectForLoop1Update	# j == width, exits loop
	
	sw $a2, ($t0)			# loads color into t0
	addi $t0, $t0, 4		# adds 4 to t0, basically moves to next word
	add $t8, $t8, 1			# j++
	
	j rectForLoop2			# jumps to beggining of this loop

rectForLoop1Update:	# updates the values for the first FOR loop
	add $t2, $t2, 1			# adds 1 to y-coord value
	
	mul $t3, $t2, 128
	add $t3, $t3, $t1
	mul $t3, $t3, 4
	lw $t0, originAddress		# saves originAddress to t0
	add $t0, $t0, $t3		# adds offset to t0
	
	li $t8, 0			# sets j (t8) to 0
	add $t9, $t9, 1			# i++
	j rectForLoop1			# jumps to forLoop1

rectExitLoop:		# loop to exit function
 	jr $ra
 #***********************************************
# draw_diamond:
#  Draw diamond of given height peaking at given point.
#  Note: Assume given height is odd.
#-----------------------------------------------------
# Pseudocode:
# draw_diamond(height, base_point_x, base_point_y)
# 	for (dy = 0; dy <= h; dy++)
# 		y = base_point_y + dy
#
# 		if dy <= h/2
# 			x_min = base_point_x - dy
# 			x_max = base_point_x + dy
# 		else
# 			x_min = base_point_x - h + dy
# 			x_max = base_point_x + h - dy
#   	for (x=x_min; x<=x_max; x++) 
# 			draw_diamond_pixels(x, y)
#-----------------------------------------------------
#   Inputs:
#    $a0 = coordinates of top point of diamond in format (0x00XX00YY)
#    $a1 = height of the diamond (must be odd integer)
#    $a2 = color in format (0x00RRGGBB)
#   Outputs:
#    No register outputs
#***************************************************
draw_diamond: nop
	getCoordinates($a0, $t1, $t2)	# t1 == x-coord t2 == y-coord
	li $t3, 0
	li $t8, 0
diamondForLoop1:	# first loop
	bgt $t3, $a1, diamondExitLoop	# dy > h, exit loop
	add $t4, $t2, $t3		# y (t4) = y-basepoint (t2) + dy (t3)
	div $t5, $a1, 2			# t5 = h (a1) / 2
	ble $t3, $t5, diamondIfLoop	# if dy (t3) <= t5, go to if
diamondElseLoop:	# else loop
	sub $t6, $t1, $a1		
	add $t6, $t6, $t3		# calculates x-min
	sub $t7, $t1, $t3
	add $t7, $t7, $a1		# calculates x-max
	move $t8, $t6			# x (t8) = x-min (t6)
	j diamondForLoop2		# jumps to second FOR loop
	
diamondIfLoop:		# if loop
	sub $t6, $t1, $t3		# calculates x-min
	add $t7, $t1, $t3		# calculates x-max
	move $t8, $t6			# x (t8) = x-min (t6)
		
diamondForLoop2:	# second FOR loop to place color within address
	bgt $t8, $t7, diamondFor1Update	# x (t8) > x-max (t7), goes to first FOR loop
	mul $t9, $t4, 128
	add $t9, $t9, $t8
	mul $t9, $t9, 4			# calculates offset 
	lw $t0, originAddress		# saves originAddress to t0
	add $t0, $t0, $t9		# adds offset to origin
	sw $a2, ($t0)			# places color within the offsetted address

	add $t8, $t8, 1			# x++
	j diamondForLoop2		# repeats second FOR loop
diamondFor1Update:	# updates the values in order to go back to first FOR loop
	add $t3, $t3, 1			# dy++
	j diamondForLoop1		# jumps to first FOR loop 

diamondExitLoop:	# loop to exit program
	jr $ra
	
