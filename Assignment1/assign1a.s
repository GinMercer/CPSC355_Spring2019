//Auther: Sijia Yin
//Date: May 14, 2019
//Desc: Find the maximum of y = - 5x^3 - 31x^2 + 4x + 31 in the range -6 <= x <= 5.By stepping through the range one by one in a loop and testing.Use only long integers for x, and do not factor the expression.Use the printf() function to display to the screen the values of x, y and the current maximum on wach iteration of loop.
//version one

	//x19: the value of x
	//x27: the value of y
	//x28: the maximum value
	//x29: fp
	//x30: lr

format:	.string "x = %d , y = %d , current maximum = %d\n "	//the output sentence for x value and y value and current maximum value
fmt:	.string "MAX: y = %d\n"	//the output sentence for the final maximum value

	.balign 4		//make instructions be word aligned
	.global main		//make "main" visible to the OSm

main:	stp x29,x30,[sp,-16]!	//allocate stack space
	mov x29,sp		//update fp
	mov x19,-6		//initialize x for -6

loop:	cmp x19,5		//pre-test loop compare x to 5
	b.gt done		//if x > 5 then go to done
	
	mul x20,x19,x19		//calculate x^2
	mul x20,x20,x19		//calculate x^3
	mov x21,-5		//the first coeficient of the polynomial
	mul x20,x20,x21		//multiply -5 and x^3, get the result of the first part of the polynomial

	mul x22,x19,x19		//calculate x^2
	mov x23,-31		//the second coeficient of the polynomial
	mul x22,x22,x23		//multiply -31 and x^2, get the result of the second part of the polynomial

	mov x24,4		//the third coeficient of the polynomial
	mul x25,x19,x24		//multiply 4 and x, get the result of the third part of the polynomial

	add x27,x20,x22		//add -5x^3 and -31x^2 together
	add x27,x27,x25		//add -5x^3-31x^2 and 4x together
	add x27,x27,31		//add -5x^3-31x^2+4x and 31 together

	cmp x19,-6		//compare x and -6
	b.eq give		//if x equal to -6 then go to give line
	b comp			//if x not equal to -6 then go to comp line

comp:	cmp x27,x28		//compare y value and current maximum value
	b.le test		//if y <= current maximum then go to test
give:	mov x28,x27		//if y > current maximum move y to current maximum value

test:	adrp x0,format		//set the first arg(hight order bits)
	add x0,x0, :lo12:format	//set the first arg(lower 12 bits)
	mov x1,x19		//set the second arg as x value
	mov x2,x27		//set the third arg as y value
	mov x3,x28		//set the fourth arg as the current maximum value

	bl printf		//call the printf() function
	add x19,x19,1		//make x+1 in every loop
	b loop			//go to the top of the loop test

done:	adrp x0,fmt		//set the first arg(hight order bits)
	add x0,x0, :lo12:fmt	//set the first arg(lower 12 bits)
	mov x1,x28		//set the second arg as the current maximum value
	bl printf		//call the printf() function

	mov w0,0		//set up return value of zero from main
	ldp x29,x30,[sp],16	//restore fp and lr from stack, post-increment sp
	ret			//return to the caller

