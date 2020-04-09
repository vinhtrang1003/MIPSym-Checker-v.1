# Vinh Trang HW 9.3
	.data
space:	.asciiz " "
askrow:	.asciiz "Please enter row 1 number: "
askrow2:	.asciiz "Please enter row 2 number: "
askcol:	.asciiz "Please enter column 1 number: "
askcol2:	.asciiz "Please enter column 2 number: "
askval:	.asciiz "Please enter value number(1=r/3=w/5=R/7=W/0=remove): "
legal:	.asciiz "legal move "
legalj:	.asciiz "legal jump "
illegal:	.asciiz "illegal move "
illegalj:	.asciiz "illegal jump "
redturn:	.asciiz "This is Red Turn ! "
redwin:	.asciiz "RED TEAM WON! "
whiteturn:	.asciiz "This is White Turn ! "
whitewin:	.asciiz "WHITE TEAM WON! "
r:	.asciiz "r "
R:	.asciiz "R "
w:	.asciiz "w "
W:	.asciiz "W "
newln:	.asciiz "\n"
	.globl main
	.code
	
# Board has 6*6 = 36 squares
# 36 squares = 36 * 4 = 144 bytes
# allocate 144 bytes for the board
main:
	
	addi	$sp,$sp,-144
	mov		$s0,$sp
	
# while loop to make board all 0
	li	$t6,5			#let rcount = 5, r>=0, r--
	li	$t7,0			#let ccount = 0, c<6, c++
	
whiler:

whilec:
	mov	$sp,$s0
	li	$t0,0
	mul	$t0,$t6,6			# idx = $t0 = r*6+c
	add	$t0,$t0,$t7		#   "
	mul	$t0,$t0,4			# offset = idx *4 bytes
	subu	$sp,$sp,$t0		# "
	sw	$0,($sp)			# "
	
	addi	$t7,1	#c++
ccheck:
	blt	$t7,6,whilec
	addi	$t6,-1
	li		$t7,0
rcheck:
	bge	$t6,0,whiler
	
# End of allocate 0 to all squares on the board
																# Allocate red piece
	li	$t6,0			#let rcount = 0, r<=1, r++
	li	$t7,0			#let ccount = 0, c<6, c++
	
redwhiler:

redwhilec:
	mov	$sp,$s0
	li	$t0,0
	mul	$t0,$t6,6			# idx = $t0 = r*6+c
	add	$t0,$t0,$t7		#   "
	mul	$t0,$t0,4			# offset = idx *4 bytes
	subu	$sp,$sp,$t0		# "
	
	li	$t9,0
	add	$t9,$t6,$t7		# sum row and column
	andi	$t9,$t9,1	# And their sum with 1 to have 1 or 0, 1 = odd (white), 0 = even (black)
	
	beq	$t9,0,redskip
	# Else
	li	$t0,1
	sw	$t0,($sp)			# "
redskip:
	addi	$t7,1	#c++
redccheck:
	blt	$t7,6,redwhilec
	addi	$t6,1
	li		$t7,0
redrcheck:
	ble	$t6,1,redwhiler
																# End allocate red piece
																
																# Allocate white piece
	li	$t6,4			#let rcount = 4, r<=5, r++
	li	$t7,0			#let ccount = 0, c<6, c++
	
whitewhiler:

whitewhilec:
	mov	$sp,$s0
	li	$t0,0
	mul	$t0,$t6,6			# idx = $t0 = r*6+c
	add	$t0,$t0,$t7		#   "
	mul	$t0,$t0,4			# offset = idx *4 bytes
	subu	$sp,$sp,$t0		# "
	
	li	$t9,0
	add	$t9,$t6,$t7		# sum row and column
	andi	$t9,$t9,1	# And their sum with 1 to have 1 or 0, 1 = odd (white), 0 = even (black)
	
	beq	$t9,0,whiteskip
	# Else
	li	$t0,3
	sw	$t0,($sp)			# "
whiteskip:
	addi	$t7,1	#c++
whiteccheck:
	blt	$t7,6,whitewhilec
	addi	$t6,1
	li		$t7,0
whitercheck:
	ble	$t6,5,whitewhiler
																# End allocate white piece
	


																# User loop
																# Print the board first 

	li	$s5,0	# Red = 0 move first
	li	$s6,6	# Red pieces on the board begin with 6 pieces
	li	$s7,6	# White pieces on the board begin with 6 pieces
	j	ploopr
	
	
Mainloop:
	beq	$s6,0,congratwhite
	beq	$s7,0,congratred
	beq	$s5,0,displayredturn
	#Else display white turn
	la	$a0,whiteturn
	syscall	$print_string

	la	$a0,newln
	syscall	$print_string
	j	continue
displayredturn:
	la	$a0,redturn
	syscall	$print_string

	la	$a0,newln
	syscall	$print_string
continue:
	
# Ask for row 1
	la	$a0,askrow
	syscall	$print_string
	
	syscall	$read_int			#read row into $t6
	mov	$t6,$v0		
	
	beq	$t6,9,exit				#If user enter 9 exit program
	
# Ask for column 1
	la	$a0,askcol
	syscall	$print_string
	
	syscall	$read_int			#read col into $t7
	mov	$t7,$v0		

# Ask for row 2
	la	$a0,askrow2
	syscall	$print_string
	
	syscall	$read_int			#read row2 into $t4
	mov	$t4,$v0		
# Ask for column 2	
	la	$a0,askcol2
	syscall	$print_string
	
	syscall	$read_int			#read col2 into $t5
	mov	$t5,$v0		
	
	j	islegalmove		# check legal move

congratwhite:
	la	$a0,whitewin
	syscall	$print_string
	addi	$sp,$sp,144
	syscall	$exit
	
congratred:
	la	$a0,redwin
	syscall	$print_string
	addi	$sp,$sp,144
	syscall	$exit

movenow:
	mov		$sp,$s0
	li	$t0,0
	mul	$t0,$t6,6			# idx = $t0 = r*6+c
	add	$t0,$t0,$t7			#   "
	mul	$t0,$t0,4			# offset = idx *4 bytes
	subu	$sp,$sp,$t0
	lw	$t1,($sp)
	sw	$0,($sp)
	mov		$sp,$s0
	li	$t0,0
	mul	$t0,$t4,6			# idx = $t0 = r*6+c
	add	$t0,$t0,$t5			#   "
	mul	$t0,$t0,4			# offset = idx *4 bytes
	subu	$sp,$sp,$t0
	
	#Find your king
	beq	$s5,0,kingred
	beq	$s5,1,kingwhite

nomking:	
	sw	$t1,($sp)

endmove:	
	beq	$s5,0,s5plus
	#Else s5 = 1
	li	$s5,0
	j	ploopr	
s5plus:
	li	$s5,1
	j	ploopr	

kingwhite:
	beq	$t4,0,KingWhite
	j	nomking
KingWhite:
	li	$t1,7
	sw	$t1,($sp)
	j	endmove	

kingred:
	beq	$t4,5,KingRed
	j	nomking
KingRed:
	li	$t1,5
	sw	$t1,($sp)
	j	endmove	
	
	
jumpnow:

	mov		$sp,$s0
	li	$t0,0
	mul	$t0,$t6,6			# idx = $t0 = r*6+c
	add	$t0,$t0,$t7			#   "
	mul	$t0,$t0,4			# offset = idx *4 bytes
	subu	$sp,$sp,$t0
	lw	$t1,($sp)
	sw	$0,($sp)
	
	li	$t2,0
	li	$t3,0
	li	$t8,2
	
	add	$t2,$t6,$t4
	add	$t3,$t7,$t5
	div	$t2,$t2,$t8
	div	$t3,$t3,$t8
	
	mov		$sp,$s0
	li	$t0,0
	mul	$t0,$t2,6			# idx = $t0 = r*6+c
	add	$t0,$t0,$t3			#   "
	mul	$t0,$t0,4			# offset = idx *4 bytes
	subu	$sp,$sp,$t0
	sw	$0,($sp)			# Mid piece value remove
	
	
	mov		$sp,$s0
	li	$t0,0
	mul	$t0,$t4,6			# idx = $t0 = r*6+c
	add	$t0,$t0,$t5			#   "
	mul	$t0,$t0,4			# offset = idx *4 bytes
	subu	$sp,$sp,$t0

	#Find your king and kill the enemy
	beq	$s5,0,kingredj
	beq	$s5,1,kingwhitej

nomkingj:	
	sw	$t1,($sp)

endmovej:	
	beq	$s5,0,s5plusj
	#Else s5 = 1
	li	$s5,0
	j	ploopr	
s5plusj:
	li	$s5,1
	j	ploopr	

kingwhitej:
	addi	$s6,-1
	beq	$t4,0,KingWhitej
	j	nomkingj
KingWhitej:
	li	$t1,7
	sw	$t1,($sp)
	j	endmovej

kingredj:
	addi	$s7,-1
	beq	$t4,5,KingRedj
	j	nomkingj
KingRedj:
	li	$t1,5
	sw	$t1,($sp)
	j	endmovej
	
	
#	Print the board again	
	j	ploopr
															# Now print out the values of the board
ploopr:
	li	$t6,5			#let rcount = 5, r>=0, r++
	li	$t7,0			#let ccount = 0, c<6, c++
ploopc:

	mov	$sp,$s0
	li	$t0,0
	mul	$t0,$t6,6			# idx = $t0 = r*6+c
	add	$t0,$t0,$t7		#   "
	mul	$t0,$t0,4			# offset = idx *4 bytes
	subu	$sp,$sp,$t0		# "
	
															#	put code Below for problem 4	#

	li	$t9,0
	add	$t9,$t6,$t7		# sum row and column
	andi	$t9,$t9,1	# And their sum with 1 to have 1 or 0, 1 = odd (white), 0 = even (black)
	beq	$t9,0,black		# Print black if $t9 = 0
	
	lw	$t8,($sp)
	beq	$t8,1,redpiece
	beq	$t8,3,whitepiece
	beq	$t8,5,redking
	beq	$t8,7,whiteking
	#otherwise empty white space
	li	$a0,32			# Else print white space
	syscall	$print_char
	mov		$sp,$s0
	li	$a0,32			# Make it look square rather than rectangle
	syscall	$print_char
	mov		$sp,$s0
	addi	$t7,1	#c++
	j	pccheck
black:
	li	$a0,219			# Else print black square
	syscall	$print_char
	li	$a0,219			# Make it look square rather than rectangle
	syscall	$print_char
	mov		$sp,$s0
	addi	$t7,1	#c++
	j	pccheck
redpiece:
	la	$a0,r		
	syscall	$print_string
	mov		$sp,$s0
	addi	$t7,1	#c++
	j	pccheck
whitepiece:
	la	$a0,w		
	syscall	$print_string
	mov		$sp,$s0
	addi	$t7,1	#c++
	j	pccheck
redking:
	la	$a0,R		
	syscall	$print_string
	mov		$sp,$s0
	addi	$t7,1	#c++
	j	pccheck
whiteking:
	la	$a0,W		
	syscall	$print_string
	mov		$sp,$s0
	addi	$t7,1	#c++
	j	pccheck

															#	 put code Above for problem 4	#		

pccheck:
	blt	$t7,6,ploopc
	addi	$t6,-1	#r--
	li		$t7,0
	
	la	$a0,newln
	syscall	$print_string
	
prcheck:
	bge	$t6,0,ploopc
	j	Mainloop
	
	
	
# Assign function:
afunc:						# $t6 = row variable, $t7 = column variable
	li	$t0,0
	mul	$t0,$t6,6			# idx = $t0 = r*6+c
	add	$t0,$t0,$t7			#   "
	mul	$t0,$t0,4			# offset = idx *4 bytes
	subu	$sp,$sp,$t0
	sw	$t1,($sp)
	
	mov		$sp,$s0
	
	jr $ra
	
exit:
	syscall	$exit
																		# Check Legal Move
islegalmove:
	
	#Check if the first piece is empty or not
	
	mov		$sp,$s0
	li	$t0,0
	mul	$t0,$t6,6			# idx = $t0 = r*6+c
	add	$t0,$t0,$t7			#   "
	mul	$t0,$t0,4			# offset = idx *4 bytes
	subu	$sp,$sp,$t0
	lw	$t1,($sp)			# First piece value in $t1
	
	
	beq	$t1,0,invalidmove
	beq	$t1,1,rmove
	beq	$t1,3,wmove
	beq	$t1,5,rkmove
	beq	$t1,7,wkmove
	
	
invalidmove:
	li	$v0,0			# Illegal out of board return 0
	
	la	$a0,illegal
	syscall	$print_string
	
	li	$a0,0
	syscall	$print_int
	
	la	$a0,newln
	syscall	$print_string
	
	j	islegaljump

rmove:
	beq	$s5,1,invalidmove	# White turn
	li	$t0,0
	sub	$t0,$t6,$t4
	li	$t1,0
	sub	$t1,$t7,$t5
	abs	$t1,$t1
	bne	$t0,-1,invalidmove
	bne	$t1,1,invalidmove
	
	addi $sp,$sp,-4
	sw	$ra,0($sp)
	
	jal	islegalposition	
	
	li	$t2,0
	mov	$t2,$v1
	beq	$t2,0,invalidmove
	
	lw	$ra,0($sp)
	addi $sp,$sp,4
	

		  
	li	$v0,1			# elseLegal return 1
	la	$a0,legal
	syscall	$print_string
	
	li	$a0,1
	syscall	$print_int
	
	la	$a0,newln
	syscall	$print_string
	
	j	movenow
	
wmove:
	beq	$s5,0,invalidmove	# Red turn
	li	$t0,0
	sub	$t0,$t6,$t4
	li	$t1,0
	sub	$t1,$t7,$t5
	abs	$t1,$t1
	bne	$t0,1,invalidmove
	bne	$t1,1,invalidmove
	
	addi $sp,$sp,-4
	sw	$ra,0($sp)
	jal	islegalposition	
	lw	$ra,0($sp)
	addi $sp,$sp,4
	
	li	$t2,0
	mov	$t2,$v1
	beq	$t2,0,invalidmove
	
	li	$v0,1			# elseLegal return 1
	la	$a0,legal
	syscall	$print_string
	
	li	$a0,1
	syscall	$print_int
	
	la	$a0,newln
	syscall	$print_string
	
	j	movenow
	
rkmove:
	beq	$s5,1,invalidmove	# White turn
	li	$t0,0
	sub	$t0,$t6,$t4
	abs	$t0,$t0
	li	$t1,0
	sub	$t1,$t7,$t5
	abs	$t1,$t1
	bne	$t0,1,invalidmove
	bne	$t1,1,invalidmove
	
	addi $sp,$sp,-4
	sw	$ra,0($sp)
	jal	islegalposition	
	lw	$ra,0($sp)
	addi $sp,$sp,4
	
	li	$t2,0
	mov	$t2,$v1
	beq	$t2,0,invalidmove
	
	li	$v0,1			# elseLegal return 1
	la	$a0,legal
	syscall	$print_string
	
	li	$a0,1
	syscall	$print_int
	
	la	$a0,newln
	syscall	$print_string
	
	j	movenow
	
wkmove:	
	beq	$s5,0,invalidmove # red turn 
	li	$t0,0
	sub	$t0,$t6,$t4
	abs	$t0,$t0
	li	$t1,0
	sub	$t1,$t7,$t5
	abs	$t1,$t1
	bne	$t0,1,invalidmove
	bne	$t1,1,invalidmove
	
	addi $sp,$sp,-4
	sw	$ra,0($sp)
	jal	islegalposition	
	lw	$ra,0($sp)
	addi $sp,$sp,4
	
	li	$t2,0
	mov	$t2,$v1
	beq	$t2,0,invalidmove
	
	li	$v0,1			# elseLegal return 1
	la	$a0,legal
	syscall	$print_string
	
	li	$a0,1
	syscall	$print_int
	
	la	$a0,newln
	syscall	$print_string
	
	j	movenow
	
#	
islegalposition:

	bgt	$t4,5,outofboard
	bgt	$t5,5,outofboard
	blt	$t4,0,outofboard
	blt	$t5,0,outofboard
	
	li	$t9,0
	add	$t9,$t4,$t5		# sum row and column
	andi	$t9,$t9,1	# And their sum with 1 to have 1 or 0, 1 = odd (white), 0 = even (black)
	beq	$t9,0,blacksquare		# black if $t9 = 0
	beq	$t9,1,whitesquare		# white if $t9 = 1
	
blacksquare:
	li	$v1,0			# Black square is not a legal position return 0
	jr $ra
	
whitesquare:			# White square can be a legal position if there is no piece on it
	mov		$sp,$s0
	li	$t0,0
	li	$t1,0
	mul	$t0,$t4,6			# idx = $t0 = r*6+c
	add	$t0,$t0,$t5			#   "
	mul	$t0,$t0,4			# offset = idx *4 bytes
	subu	$sp,$sp,$t0
	lw	$t1,($sp)
	
	beq	$t1,0,whitelegal
	
	# whitesquare has piece on it return 0 illegal
	
	li	$v1,0
	jr	$ra
	
whitelegal:
	li	$v1,1			# white square is legal position return 1
	jr $ra
	
outofboard:
	li	$v1,0			# Illegal out of board return 0
	jr $ra
	
																		# Check Legal Jump
islegaljump:
	
	#Check if the first piece is empty or not
	
	mov		$sp,$s0
	li	$t0,0
	mul	$t0,$t6,6			# idx = $t0 = r*6+c
	add	$t0,$t0,$t7			#   "
	mul	$t0,$t0,4			# offset = idx *4 bytes
	subu	$sp,$sp,$t0
	lw	$t1,($sp)			# First piece value in $t1
	
	#Find midpoint piece
	li	$t2,0
	li	$t3,0
	li	$t8,2
	
	add	$t2,$t6,$t4
	add	$t3,$t7,$t5
	div	$t2,$t2,$t8
	div	$t3,$t3,$t8
	
	mov		$sp,$s0
	li	$t0,0
	mul	$t0,$t2,6			# idx = $t0 = r*6+c
	add	$t0,$t0,$t3			#   "
	mul	$t0,$t0,4			# offset = idx *4 bytes
	subu	$sp,$sp,$t0
	lw	$t9,($sp)			# Mid piece value in $t9
	
	beq	$t1,0,invalidjump
	beq	$t1,1,rjump
	beq	$t1,3,wjump
	beq	$t1,5,rkjump
	beq	$t1,7,wkjump
	
	

invalidjump:
	li	$v0,0			# Illegal out of board return 0
	
	la	$a0,illegalj
	syscall	$print_string
	
	li	$a0,0
	syscall	$print_int
	
	la	$a0,newln
	syscall	$print_string
	
	j	ploopr	

rjump:
	beq	$s5,1,invalidjump	# White turn
	beq	$t9,1,invalidjump	#Midpoint
	beq	$t9,5,invalidjump
	beq	$t9,0,invalidjump
	
	li	$t0,0
	sub	$t0,$t6,$t4
	li	$t1,0
	sub	$t1,$t7,$t5
	abs	$t1,$t1
	bne	$t0,-2,invalidjump
	bne	$t1,2,invalidjump
	
	
	addi $sp,$sp,-4
	sw	$ra,0($sp)
	
	jal	islegalposition	
	
	li	$t2,0
	mov	$t2,$v1
	beq	$t2,0,invalidjump
	
	lw	$ra,0($sp)
	addi $sp,$sp,4
		  
	li	$v0,1			# elseLegal return 1
	la	$a0,legalj
	syscall	$print_string
	
	li	$a0,1
	syscall	$print_int
	
	la	$a0,newln
	syscall	$print_string
	
	j	jumpnow
	
wjump:
	beq	$s5,0,invalidjump	# Red turn
	beq	$t9,3,invalidjump	#Midpoint
	beq	$t9,7,invalidjump
	beq	$t9,0,invalidjump

	li	$t0,0
	sub	$t0,$t6,$t4
	li	$t1,0
	sub	$t1,$t7,$t5
	abs	$t1,$t1
	bne	$t0,2,invalidjump
	bne	$t1,2,invalidjump

	
	addi $sp,$sp,-4
	sw	$ra,0($sp)
	jal	islegalposition	
	lw	$ra,0($sp)
	addi $sp,$sp,4
	
	li	$t2,0
	mov	$t2,$v1
	beq	$t2,0,invalidjump
	
	li	$v0,1			# elseLegal return 1
	la	$a0,legalj
	syscall	$print_string
	
	li	$a0,1
	syscall	$print_int
	
	la	$a0,newln
	syscall	$print_string
	
	j	jumpnow
	
rkjump:
	beq	$s5,1,invalidjump	# White turn
	beq	$t9,1,invalidjump	#Midpoint
	beq	$t9,5,invalidjump
	beq	$t9,0,invalidjump

	li	$t0,0
	sub	$t0,$t6,$t4
	abs	$t0,$t0
	li	$t1,0
	sub	$t1,$t7,$t5
	abs	$t1,$t1
	bne	$t0,2,invalidjump
	bne	$t1,2,invalidjump
	
	
	addi $sp,$sp,-4
	sw	$ra,0($sp)
	jal	islegalposition	
	lw	$ra,0($sp)
	addi $sp,$sp,4
	
	li	$t2,0
	mov	$t2,$v1
	beq	$t2,0,invalidjump
	
	li	$v0,1			# elseLegal return 1
	la	$a0,legalj
	syscall	$print_string
	
	li	$a0,1
	syscall	$print_int
	
	la	$a0,newln
	syscall	$print_string
	
	j	jumpnow
	
wkjump:	
	beq	$s5,0,invalidjump	# Red turn
	beq	$t9,3,invalidjump	#Midpoint
	beq	$t9,7,invalidjump
	beq	$t9,0,invalidjump
	
	li	$t0,0
	sub	$t0,$t6,$t4
	abs	$t0,$t0
	li	$t1,0
	sub	$t1,$t7,$t5
	abs	$t1,$t1
	bne	$t0,2,invalidjump
	bne	$t1,2,invalidjump
	
	
	addi $sp,$sp,-4
	sw	$ra,0($sp)
	jal	islegalposition	
	lw	$ra,0($sp)
	addi $sp,$sp,4
	
	li	$t2,0
	mov	$t2,$v1
	beq	$t2,0,invalidjump
	
	li	$v0,1			# elseLegal return 1
	la	$a0,legalj
	syscall	$print_string
	
	li	$a0,1
	syscall	$print_int
	
	la	$a0,newln
	syscall	$print_string
	
	j	jumpnow
	
	
	
	
	
	
	
	
	
	
	