###########################################################
#	Program 4
#	
#	Name: Michelle Wojta
#	Date: 11/08/2018
#	
#	Program Description:
#		This program creates and fills an array based on user input.
#	After displaying the array, the user will be asked to pride a stride number, N.
#	A second array will then be displayed, comprised of every Nth value from the initial 
#	array. Finally, the average and sum of the array will be processed.
#	
#	References:
#		Discussion notes, previous labs, previous programs, D2L downloads,  
#			course textbook, TA - Sia, .edu websites such as one below:
#			http://pages.cs.wisc.edu/~markhill/cs354/Fall2008/notes/MAL.instructions.html
#
###########################################################
#		Register Usage
#	$t0 array base address
#	$t1	array length
#	$t2 stride, N
#	$t3 sum of array's elements
#	$t4
#	$t5
#	$t6
#	$t7
#	$t8
#	$t9
###########################################################
		.data
greetings: 		.asciiz	"Hello!"
N_value: 		.asciiz	"\nPlease enter a stride value, N: "
array_dynamic:	.word	0
array_length:	.word 	0
array_sum:		.word	0
###########################################################
		.text
main:
####create_array
	li $v0, 4						#greets user
	la $a0, greetings
	syscall
	
	addi $sp, $sp, -4				#$sp <- $sp - 4 (1 word)
	sw $ra, 0($sp)					#stack[0] <- $ra (backup)

	addi $sp, $sp, -8				#$sp <- $sp - 8 (2 words: 0 IN, 2 OUT)
	
	jal create_array				#goes to subprogram to create array
	
	lw $t0, 0($sp)					#$t0 <- base address (OUT)
	lw $t1, 4($sp)					#$t1 <- array length (OUT)
	addi $sp, $sp, 8				#$sp <- $sp + 8 (2 words)

	lw $ra, 0($sp)					#$ra <- return address (restore)
	addi $sp, $sp, 4				#$sp <- $sp + 4 (1 word)
	
	la $t3, array_dynamic			#load array_dynamic into $t3
	sw $t0, 0($t3)					#stores array base address into static memory
	
	la $t3, array_length			#load array_length into $t3
	sw $t1, 0($t3)					#stores array length into static memory
	
####print_array
	addi $sp, $sp, -4				#$sp <- $sp - 4 (1 word)
	sw $ra, 0($sp)					#stack[0] <- $ra (backup)

	addi $sp, $sp, -8				#Backup
	sw $t0, 0($sp)					
	sw $t1, 4($sp)					
	
	addi $sp, $sp, -8				#$sp <- $sp - 8 (2 words: 2 IN, 0 OUT)
	sw $t0, 0($sp)					#stack[0] <- array base address
	sw $t1, 4($sp)					#stack[4] <- array length
	
	jal print_array					#goes to subprogram to print array
	
	addi $sp, $sp, 8				#$sp <- $sp + 8 (2 words)	
	
	lw $t0, 0($sp)					#$t0 <- base address (OUT)
	lw $t1, 4($sp)					#$t1 <- array length (OUT)
	addi $sp, $sp, 8				#$sp <- $sp + 8 (2 words)

	lw $ra, 0($sp)					#$ra <- return address (restore)
	addi $sp, $sp, 4				#$sp <- $sp + 4 (1 word)
	
####print_every_nth
	li $v0, 4						#prompt user for stide length, N
	la $a0, N_value
	syscall
	
	li $v0, 5						#user input
	syscall
	
	addi $sp, $sp, -4				#$sp <- $sp - 4 (1 word)
	sw $ra, 0($sp)					#stack[0] <- $ra (backup)

	addi $sp, $sp, -8				#Backup
	sw $t0, 0($sp)					
	sw $t1, 4($sp)					
	
	addi $sp, $sp, -12				#$sp <- $sp - 12 (3 words: 3 IN, 0 OUT)
	sw $t0, 0($sp)					#stack[0] <- array base address
	sw $t1, 4($sp)					#stack[4] <- array length
	sw $v0, 8($sp)					#stack[8] <- N

	jal print_every_nth				#goes to subprogram to print every nth value
	
	addi $sp, $sp, 12				#$sp <- $sp + 12 (3 words)	
	
	lw $t0, 0($sp)					#$t0 <- base address
	lw $t1, 4($sp)					#$t1 <- array length
	addi $sp, $sp, 8				#$sp <- $sp + 12 (2 words)

	lw $ra, 0($sp)					#$ra <- return address (restore)
	addi $sp, $sp, 4				#$sp <- $sp + 4 (1 word)
	
####get_average
	addi $sp, $sp, -4				#$sp <- $sp - 4 (1 word)
	sw $ra, 0($sp)					#stack[0] <- $ra (backup)

	addi $sp, $sp, -8				#$sp <- $sp - 12 (2 words: 2 IN, 0 OUT)
	sw $t0, 0($sp)					#stack[0] <- array length
	sw $t1, 4($sp)					#stack[4] <- array base address
	
	jal get_average					#goes to subprogram to print average of array's elements
	
	addi $sp, $sp, 8				#$sp <- $sp + 8 (2 words)
	
	lw $ra, 0($sp)					#$ra <- return address (restore)
	addi $sp, $sp, 4				#$sp <- $sp + 4 (1 word)
	
exit:
	li $v0, 10						#End Program
	syscall
	
###########################################################
###########################################################
#	create_array 
#
#	This subprogram has 0 arguments IN and 2 arguments OUT:
#		-	array base address
#		-	array length
#
#	This subprogram will call allocate_array to allocate a dynamic 
#	array of double precision floating point numbers. Then read_array 
#	to fill the array. 
###########################################################
#		Arguments In and Out of subprogram
#	$sp+0	array base address
#	$sp+4	array length
#	$sp+8	
#	$sp+12
###########################################################
#		Register Usage
#	$t0	array base address
#	$t1	array length
#	$t2 
#	$t3
#	$t4
#	$t5
#	$t6
#	$t7
#	$t8
#	$t9
###########################################################
		.data
###########################################################
		.text
create_array:
####allocate_array
	addi $sp, $sp, -4				#$sp <- $sp - 4 (1 word)
	sw $ra, 0($sp)					#stack[0] <- $ra (backup)

	addi $sp, $sp, -8				#$sp <- $sp - 8 (2 words: 0 IN, 2 OUT)
	
	jal allocate_array				#goes to subprogram to create array
	
	lw $t0, 0($sp)					#$t0 <- base address
	lw $t1, 4($sp)					#$t1 <- array length
	addi $sp, $sp, 8				#$sp <- $sp + 8 (2 words)

	lw $ra, 0($sp)					#$ra <- return address (restore)
	addi $sp, $sp, 4				#$sp <- $sp + 4 (1 words)
	
####read_array
	addi $sp, $sp, -4				#$sp <- $sp - 4 (1 word)
	sw $ra, 0($sp)					#stack[0] <- $ra (backup)	
	
	addi $sp, $sp, -8				#Backup
	sw $t0, 0($sp)					
	sw $t1, 4($sp)					

	addi $sp, $sp, -8				#$sp <- $sp - 8 (2 words: 2 IN, 0 OUT)
	sw $t0, 0($sp)					#stack[0] <- array base address
	sw $t1, 4($sp)					#stack[4] <- array length
	
	jal read_array					#goes to subprogram to fill array
	
	addi $sp, $sp, 8				#$sp <- $sp + 8 (2 words)	
	
	lw $t0, 0($sp)					#$t0 <- base address (OUT)
	lw $t1, 4($sp)					#$t1 <- array length (OUT)
	addi $sp, $sp, 8				#$sp <- $sp + 8 (2 words)
	
	lw $ra, 0($sp)					#$ra <- return address (restore)
	addi $sp, $sp, 4				#$sp <- $sp + 4 (1 words)

leave_create:
	sw $t0, 0($sp)					#stack[0] <- array base address
	sw $t1, 4($sp)					#stack[4] <- array length

	jr $ra							#return to calling location
	
###########################################################
###########################################################
#	allocate_array 
#
#	This subprogram has 0 arguments IN and 2 arguments OUT:
#		-	array base address
#		-	array length
#
#	This subprogram will dynamically allocate an array with length an odd
#	numbered length > 7.
###########################################################
#		Arguments In and Out of subprogram
#	$sp+0 array base address
#	$sp+4 array length
#	$sp+8
#	$sp+12
###########################################################
#		Register Usage
#	$t0	
#	$t1	
#	$t2 - constant value: 7
#	$t3 - constant value: 2
#	$t4 - Temporary Holder
#	$t5
#	$t6
#	$t7
#	$t8
#	$t9
###########################################################
		.data
length_prompt:	.asciiz	"\nPlease enter array length (odd valued & > 7): "
length_error:	.asciiz	"Error! Size of array must be odd and > 7!\n"
###########################################################
		.text
allocate_array:
	li $t2, 7						#initialize to constant value, array min length, 8
	li $t3, 2						#initialize to constant value, even/odd check, 2

	li $v0, 4						#prompt user for array length
	la $a0, length_prompt
	syscall
	
	li $v0, 5						#user input
	syscall
	
	ble $v0, $t2, invalid_length	#Check: n <= 7
	
	rem $t4, $v0, $t3				#remainder 1 == odd
	beqz $t4, invalid_length		#Check: n%2 == 1
	
	sw $v0, 4($sp)					#stack[4] <- input length (OUT)

	sll $a0, $v0, 3					#$a0 <- input length * 2^3 (8 bytes)
	li $v0, 9                       #$v0 <- base address of dynamic array
	syscall

	sw $v0, 0($sp)					#stack[0] <- base address (OUT)
	
	b leave_allocate

invalid_length:
	li $v0, 4						#informs user of invalid array length
	la $a0, length_error
	syscall
	
	b allocate_array
	
leave_allocate:
	jr $ra							#return to calling location
	
###########################################################
###########################################################
#	read_array 
#
#	This subprogram has 2 arguments IN and 0 arguments OUT:
#		-	array base address
#		-	array length
#
#	This subprogram will ask user to input elements for entire array
#	Inputs are double-precision.
###########################################################
#		Arguments In and Out of subprogram
#	$sp+0 array base address
#	$sp+4 array length
#	$sp+8
#	$sp+12
###########################################################
#		Register Usage
#   $t0         Holds array index address
#   $t1         Holds array length/loop countdown
#   $f0|$f1     Holds array entry
###########################################################
		.data
array_element:	.asciiz	"Enter a double-precision value: "
###########################################################
		.text
read_array:
	lw $t0, 0($sp)					#$t0 <- base address
	lw $t1, 4($sp)					#$t1 <- array length

get_elements:
	li $v0, 4						#prompt user for array element
	la $a0, array_element
	syscall
	
	li $v0, 7						#user input
	syscall
	
	s.d $f0, 0($t0)					#read

	addi $t1, $t1, -1				#update counter
	blez $t1, leave_read			#compares counter to array length, if full go to leave_read
	
	addi $t0, $t0, 8				#update array pointer
	
	b get_elements					#loops back to get_elements until array filled
	
leave_read:
	jr $ra							#return to calling location
	
###########################################################
###########################################################
#	print_array
#
#	This subprogram will take 2 arguments IN and 0 arguments OUT:
#		-	array length
#		-	array base address
#
#	This subprogram prints out array with each value separated by a space.
#	Newline character after entire array is printed.
##########################################################
#		Arguments In and Out of subprogram
#	$sp+0 base array length
#	$sp+4 array base address
#	$sp+8
#	$sp+12
###########################################################
#		Register Usage
#	$t0 array length
#	$t1 array base address
#   $f12|$f13   Holds array value
###########################################################
		.data
print_text:	.asciiz	"\nDynamic Array:\t["
divider:	.asciiz	", "
newline:	.asciiz	"]\n"
###########################################################
		.text
print_array:
	lw $t0, 0($sp)					#$t0 <- array base address
	lw $t1, 4($sp)					#$t1 <- array length

	li $v0, 4						#displays text, print_text
	la $a0, print_text
	syscall
	
print_loop:
	li $v0, 3						#print (Code in $v0 = 3)
	l.d $f12, 0($t0)				#loads element @index $t0
	syscall
	
	addi $t1, $t1, -1				#update counter/array length
	beqz $t1, leave_print			#counter = 0 - no more elements, go to all_done
	
	addi $t0, $t0, 8				#update to next element to be printed
	
	li $v0, 4						#displays text, divider
	la $a0, divider
	syscall
	
	b print_loop					#keep looping until all elements printed
	
leave_print:
	li $v0, 4						#creates a newline after the array has been printed
	la $a0, newline
	syscall

	jr $ra							#return to calling location
	
###########################################################
###########################################################
#	print_every_nth
#
#	This subprogram will take 3 arguments IN and 0 arguments OUT:
#		-	array length
#		-	array base address
#		-	stride, N
#
#	This subprogram prints out every nth value from the array.
##########################################################
#		Arguments In and Out of subprogram
#	$sp+0 base array length
#	$sp+4 array base address
#	$sp+8 stride N
#	$sp+12
###########################################################
#		Register Usage
#	$t0 array length
#	$t1 array base address
#	$t2 stride, N
#	$t7 counter
#	$t8 8bytes
#	$t9 Temporary Holder for next element
#   $f12|$f13   Holds array value
###########################################################
		.data
print_every_text:	.asciiz	"\nArray of Every nth Value:\t["
print_every_error:	.asciiz	"\nError! [ N <= 0 "
divider_n:			.asciiz	", "
newline_n:			.asciiz	"]\n"
###########################################################
		.text
print_every_nth:
	lw $t0, 0($sp)					#$t0 <- array base address
	lw $t1, 4($sp)					#$t1 <- array length
	lw $t2, 8($sp)					#$t2 <- stride, N
	li $t7, 0						#Initialize, 0, counter
	li $t8, 8						#Initialize, 8bytes

	blez $t2, nth_error				#stride, N <= 0

	li $v0, 4						#displays text
	la $a0, print_every_text
	syscall
	
nth_loop:
	li $v0, 3						#print (Code in $v0 = 3)
	l.d $f12, 0($t0)				#loads element @index $t0
	syscall
	
	add $t7, $t7, $t2				#counter += stride
	bge $t7, $t1, leave_nth		#Check: counter < length
	
	mul $t9, $t2, $t8				#next element = N * 8bytes
	add $t0, $t0, $t9				#update to next element to be printed
	
	li $v0, 4						#displays text, divider
	la $a0, divider_n
	syscall
	
	b nth_loop						#keep looping until all elements printed
	
nth_error:
	li $v0, 4						#displays text
	la $a0, print_every_error
	syscall	
	
leave_nth:
	li $v0, 4						#creates a newline after the array has been printed
	la $a0, newline_n
	syscall

	jr $ra							#return to calling location
	
###########################################################
###########################################################
#	get_sum
#
#	This subprogram will take 2 arguments IN:
#		-	array length
#		-	array base address
#	 and 1 arguments OUT:
#		-	sum, double-precision
#
#	This subprogram calculates the double-precision sum of all values in the array.
##########################################################
#		Arguments In and Out of subprogram
#	$sp+0 array length
#	$sp+4 array base address
#	$sp+8 sum of the array (OUT)
#	$sp+12
###########################################################
#		Register Usage
#	$t0 array base address 
#	$t1 array length
#   $f4|$f5 array sum
#   $f12|$f13   Temporary
###########################################################
		.data
###########################################################
		.text
get_sum:	
	lw $t0, 0($sp)					#$t0 <- array base address
	lw $t1, 4($sp)					#$t1 <- array length
	li.d $f4, 0.0					#initialize sum to 0
	
sum_loop:
	l.d $f12, 0($t0)				#loads element @index $t0
	
	add.d $f4, $f4, $f12			#sum += element
	
	addi $t1, $t1, -1				#update counter	
	beqz $t1, leave_sum				#Check: $t1 > 0
	
	addi $t0, $t0, 8				#update pointer
	
	b sum_loop						#keep looping until through all elements

leave_sum:
	s.d $f4, 8($sp)					#stack[8] <- sum of the array (OUT)

	jr $ra							#return to calling location
	
###########################################################
###########################################################
#	get_average
#
#	This subprogram will take 2 arguments IN and 0 arguments OUT:
#		-	array length
#		-	array base address
#
#	This subprogram calculates and prints the integer average of
#	the array by calling subprogram get_sum.
##########################################################
#		Arguments In and Out of subprogram
#	$sp+0 array length
#	$sp+4 array base address
#	$sp+8 sum of the array (IN via get_sum)
#	$sp+12
###########################################################
#		Register Usage
#	$t0 array base address 
#	$t1 array length
#   $f4|$f5 array sum
#   $f6|$f7 array average
#   $f8|$f9 array size in double
#   $f12|$f13   Temporary Holds Conversion
###########################################################
		.data
avg_text:		.asciiz	"\nAverage of Array's Elements: "
###########################################################
		.text
get_average:	
	lw $t0, 0($sp)					#$t0 <- array base address
	lw $t1, 4($sp)					#$t1 <- array length
	
####get_sum
	addi $sp, $sp, -4				#$sp <- $sp - 4 (1 word)
	sw $ra, 0($sp)					#stack[0] <- $ra (backup)	
	
	addi $sp, $sp, -8				#Backup
	sw $t0, 0($sp)					
	sw $t1, 4($sp)					

	addi $sp, $sp, -16				#$sp <- $sp - 16 (2 words: 2 IN, 1 OUT)
	sw $t0, 0($sp)					#stack[0] <- array base address
	sw $t1, 4($sp)					#stack[4] <- array length
	
	jal get_sum						#goes to subprogram to get sum
	
	l.d $f4, 8($sp)					#$f4 <- array sum
	addi $sp, $sp, 16				#$sp <- $sp + 8 (2 words)	
	
	lw $t0, 0($sp)					#$t0 <- base address (OUT)
	lw $t1, 4($sp)					#$t1 <- array length (OUT)
	addi $sp, $sp, 8				#$sp <- $sp + 8 (2 words)
	
	lw $ra, 0($sp)					#$ra <- return address (restore)
	addi $sp, $sp, 4				#$sp <- $sp + 4 (1 words)
	
####average
	mtc1 $t1, $f8					#length to CP1
	cvt.d.w $f8, $f8				#int to double
	
	div.d $f6, $f4, $f8				#average = sum / array length 

	li $v0, 4						#displays average_text
	la $a0, avg_text
	syscall
	
	li $v0, 3						#print (Code in $v0 = 3)
	mov.d $f12, $f6
	syscall
	
leave_avg:
	jr $ra							#return to calling location
	
###########################################################