//Auther: Sijia Yin
//Date: May 17, 2019
//Desc: Find the maximum of y = - 5x^3 - 31x^2 + 4x + 31 in the range -6 <= x <= 5.By stepping through the range one by one in a loop and testing.Use only long integers for x, and do not factor the expression.Use the printf() function to display to the screen the values of x, y and the current maximum on wach iteration of loop.
//version two

		define(a0, x19)		//the first coeficient of polynimial
		define(a1, x20)		//the second coeficient of polynimial
		define(a2, x21)		//the third coeficient
		define(a3, x22)		//the constant
		define(X_r, x23)	//the value of x
		define(Y_r, x24)	//the value of y
		define(M_r, x25)	//the maximum value 
		define(fp, x29)		//frame pointer
		define(lr, x30)		//link register

format1:	.string "x = %d , y = %d , current maximum = %d\n" //the output sentence for x value and y value and current maximum value
format2:	.string "MAX: y = %d\n" //the output sentence for the final maximum value

		.balign 4		//make word aligned
		.global main
main:	stp fp,lr,[sp,-16]!	
		mov fp,sp
		mov X_r,-6		//x = -6
		
		b test			//branch to loop test at bottom 

loop:	mul x26,X_r,X_r        //calculate x^2
		mul x26,x26,X_r        //calculate x^3
		mov a0,-5              //the first coeficient of the polynomial
		mul x26,x26,a0         //multiply -5 and x^3, get the result of the first part of the polynomial

		mul x27,X_r,X_r        //calculate x^2
		mov a1,-31             //the second coeficient of the polynomial
		mul x27,x27,a1         //multiply -31 and x^2, get the result of the second part of the polynomial

		mov a2,4		//the third coeficient of the polynomial
		mov a3,31		//the constant to 31
		madd x28,a2,X_r,a3	//make x28 to have 4x+31
		
		add Y_r,x26,x27		//add -5x^3 and -31x^2 together
		add Y_r,Y_r,x28		//add -5x^3-31x^2 and 4x+31 together
		
		cmp X_r,-6
		b.eq give
		b comp
give:	mov M_r,Y_r
		b prin
		
comp:	cmp Y_r,M_r             //compare y value and current maximum value
		b.le prin
		mov M_r,Y_r             //if y > current maximum move y to current maximum value

prin:	adrp x0,format1          //set the first arg(hight order bits)
		add x0,x0, :lo12:format1 //set the first arg(lower 12 bits)
		mov x1,X_r              //set the second arg as x value
		mov x2,Y_r              //set the third arg as y value
		mov x3,M_r              //set the fourth arg as the current maximum value

		bl printf               //call the printf() function
		add X_r,X_r,1          //make x+1 in every loop
		
test:	cmp X_r,5		//compare x value with 5
		b.le loop

done:	adrp x0,format2		//set the first arg(hight order bits)
		add x0,x0, :lo12:format2//set the first arg(lower 12 bits)
		mov x1,M_r		//set the second arg as the current maximum value
		bl printf		//call the printf() function
		mov w0,0
		ldp fp,lr,[sp],16	//restore stack
		ret			//return to OS
		

