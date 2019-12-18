//Assignment3
//Author: Sijia Yin
//Date: May 30th,2019
//Goals:Create an ARMv8 assembly language program. Create space on the stack to store all local variables.
		
		SIZE = 50
		ia_size = 4*SIZE
		ia_base = 16
		i_size = 4
		j_size = 4
		temp_size =4
		i_s = 16
		j_s = 20
		temp_s = 24
		ia_s = 28

ALLOC	= -(16 + ia_size + i_size + j_size + temp_size) & -16
DEALLOC	= -ALLOC

				define(i_r, w19)
				define(ia_r, w20)
				define(j_r, w21)
				define(temp_r, w22)
				
	
fp		.req	x29
lr		.req	x30		
		
format1:        .string "v[%d]: %d\n"
format2:        .string "\nSorted array:\n"
format3:        .string "v[%d]: %d\n"

		.balign 4								//make word aligned
		.global main							//Make "main" visible to the OS

main:   stp 	fp, lr, [sp, ALLOC]!	        //allocate stack space
		mov 	fp, sp							//update fp
		mov     x28, fp							//
		add		x28, x28, ia_s                  //
//-------------------------------------------------------------------------------------------------------------------------
		mov 	i_r, 0                          //set i to 0
		str 	i_r, [fp, i_s]                  //store i to the stack memory
		b		test1                           //go to test1

loop1:	bl 		rand                          	//call random function
		and 	ia_r, w0, 0xFF                  //store random number and let them maximum less than 256
		str 	ia_r, [x28, i_r, SXTW 2]        //store the array to stack memory
		
		ldr     i_r, [fp, i_s]
		ldr		ia_r, [x28, i_r, SXTW 2]        //load the array from stack memory
		adrp	x0, format1                     //print the first format
		add 	x0, x0, : lo12: format1
		mov		w1, i_r
		mov		w2, ia_r
		bl		printf
			
		ldr		i_r, [fp, i_s]                  //load i from the stack memory
		add		i_r, i_r, 1                     //let i++
		str 	i_r, [fp, i_s]                  //store i to the stack memory

test1:	ldr     i_r, [fp, i_s]
		cmp		i_r, SIZE                       //compare i with size
		b.lt	loop1                           //if i less than size then go to loop1
//------------------------------------------------------------------------------------------------------------------------
		mov		i_r, 1                          //let i=1
		str 	i_r, [fp, i_s]                  //store i to the stack memory
		b		test2                           //go to test2

loop2:	ldr		ia_r, [x28, i_r, SXTW 2]        //load the array from stack memory
		
		mov		temp_r, ia_r               		//temp = v[i]
		str		temp_r, [fp, temp_s]            //store temp to the stack memory
			
		ldr 	i_r, [fp, i_s]                  //load i from the stack memory
		str 	i_r, [fp, j_s]                  //j=i
		b		test3                           //go to test3
			
loop3:	ldr     j_r, [fp, j_s]					//load j from the stack memory
		sub		w25, j_r, 1                     //j-1               
		ldr 	w26, [x28, w25, SXTW 2]			//v[j-1]
		str 	w26, [x28, j_r, SXTW 2]			//v[j]=v[j-1]
		str     w25, [fp, j_s]					//store j to the stack memory
			
test3:	ldr     j_r, [fp, j_s]					//load j from the stack memory
		cmp		j_r, 0							//compare j with 0
		b.le	endloop3						//if j less than or equal to 0 then go to endloop3
			
		ldr     j_r, [fp, j_s]					//load j from the stack memory
		sub 	w23, j_r, 1						//j-1
		ldr		w24, [x28, w23, SXTW 2]			//v[j-1]
		
		ldr		temp_r, [fp, temp_s]			//load temp from the stack memory
		cmp		temp_r,	w24						//compare temp with v[j-1]
		b.lt	loop3							//if temp less than v[j-1] then go to loop3
		b		endloop3						//else go to endloop3
					
endloop3:
		ldr		j_r, [fp, j_s]					//load j from the stack memory
		ldr     temp_r, [fp, temp_s]			//load temp from the stack memory
		str 	temp_r, [x28, j_r, SXTW 2]		//v[j]=temp
		ldr     i_r, [fp, i_s]					//load i from the stack memory
		add		i_r, i_r, 1						//i++
		str     i_r, [fp, i_s]					//store i to the stack memory

test2:	ldr		i_r, [fp, i_s]					//load i from the stack memory
		cmp		i_r, SIZE						//compare i with size
		b.lt	loop2							//if i less than size then go to loop2

//------------------------------------------------------------------------------------------------------------------------
		adrp	x0, format2						//print format2
		add 	x0, x0, : lo12: format2
		bl		printf
//---------------------------------------------------------------------------------------------------------------------		mov		i_r, 0							//i=0
		str 	i_r, [fp, i_s]					//store i to the stack memory
		b		test4							//go to test4
			
loop4:	ldr     i_r, [fp, i_s]					//load i from the stack memory
		ldr     ia_r, [x28, i_r, SXTW 2]		//load v[i] from the stack memory
			
		adrp	x0, format3						//print format3
		add 	x0, x0, : lo12: format3
		mov		w1, i_r
		mov		w2, ia_r
		bl		printf

		ldr 	i_r, [fp, i_s]					//load i from the stack memory
		add		i_r, i_r, 1						//i++
		str 	i_r, [fp, i_s]					//store i to the stack memory
			
test4:	ldr		i_r, [fp, i_s]					//load i from the stack memory
		cmp		i_r, SIZE						//compare i with size
		b.lt	loop4							//if i less than size then go to loop4
//----------------------------------------------------------------------------------------------------------------------------------------			
done:	ldp 	fp, lr, [sp], DEALLOC			//restore FP and LR from stack, post-increment SP
		ret										//return to caller
			
