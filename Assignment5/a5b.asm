//Assignment5
//Author: Sijia Yin
//Date: June 14, 2019
//Goals: Create an ARMv8 assembly language program to accept as command line arguments two strings representing a date in the format mm dd. Your program will print the name of month, the day (with the appropriate suffix), and the season for this date.

define(month_r,w19)                         //let w19 as month_r
define(day_r,x20)							//let x20 as day_r
define(i_r, w23)

define(argc_r, w21)							//let w21 as argc
define(argv_r, x22)							//let x22 as argv

			.text							//format
format1: 	.string "%s %dst is %s\n"
format2: 	.string "%s %dnd is %s\n"
format3: 	.string "%s %drd is %s\n"
format4: 	.string "%s %dth is %s\n"

Jan:		.string "January"
Feb:		.string "February"
Mar:		.string "March"
Apr:		.string "April"
May:		.string "May"
Jun:		.string "June"
Jul:		.string "July"
Aug:		.string "August"
Sep:		.string "September"
Oct:		.string "October"
Nov:		.string "November"
Dec:		.string "December"

Winter:		.string "Winter"
Spring:		.string "Spring"
Summer:		.string "Summer"
Fall:		.string "Fall"

error: 		.string "usage: a5b mm dd\n"
		
			.data							//initializing global variables
month_m: 	.dword Jan, Feb, Mar, Apr, May, Jun, Jul, Aug, Sep, Oct, Nov, Dec				// month array
season_m: 	.dword Winter, Spring, Summer, Fall			
											//season array

			.text
			.balign 4						//make word aligned
			.global main					//main is global
main: 		stp 	x29, x30, [sp, -16]!	//allocate stack space
			mov 	x29, sp					//update fp
			
			mov 	argc_r, w0				//copy argc
			mov 	argv_r, x1				//copy argv
			
			cmp 	argc_r, 3				//compare argc with 3
			b.lt 	Error					//if argc != 3 branch to Error
			
			mov 	i_r, 1
			ldr 	x0, [argv_r, i_r, SXTW 3] 	//load 1st arg 
			bl 		atoi						//convert strings to numbers
			mov 	month_r, w0					//let x0 as month_r
			
			cmp	 	month_r, 0				//compare month_r with 0
			b.le 	Error					//if month_r<=0 branch to Error
			
			cmp 	month_r, 12				//compare month_r with 12
			b.gt 	Error					//if month_r>12 branch to Error
			
			mov 	i_r, 2
			ldr 	x0, [argv_r, i_r, SXTW 3] //load 1st arg
			bl 		atoi					//convert strings to numbers
			mov 	day_r, x0				//let x0 as day_r
			
			cmp 	day_r, 0				//compare day_r with 0
			b.le 	Error					//if day_r<=0 branch to Error
			
			cmp 	day_r, 31				//compare day_r with 31
			b.gt 	Error					//if day_r>31 branch to Error

			adrp 	x25, month_m				//load x25 as month_m
			add 	x25, x25, :lo12:month_m		//load to lower 12 bits
			sub 	month_r, month_r, 1			//month-1 month_m[i-1]
			ldr 	x1, [x25, month_r, SXTW 3]	//set 1st arg as month_m
			
			add		month_r, month_r, 1			//month+1
			mov 	x2, day_r					//set 2nd arg as day_r
			
			cmp 	day_r, 1				//compare day_r with 1
			b.eq 	suffix1					//if day_r==1 branch suffix1
			cmp 	day_r, 21				//compare day_r with 21
			b.eq 	suffix1					//if day_r==21 branch suffix1
			cmp 	day_r, 31				//compare day_r with 31
			b.eq 	suffix1					//if day_r==31 branch suffix1
			
			cmp 	day_r, 2				//compare day_r with 2
			b.eq 	suffix2					//if day_r==2 branch suffix2
			cmp 	day_r, 22				//compare day_r with 22
			b.eq 	suffix2					//if day_r==22 branch suffix2
			
			cmp 	day_r, 3				//compare day_r with 3
			b.eq 	suffix3					//if day_r==3 branch suffix3
			cmp 	day_r, 23				//compare day_r with 23
			b.eq 	suffix3					//if day_r==33 branch suffix3
			
			adrp 	x0, format4				//if the suffix is not 123
			add 	x0, x0, :lo12:format4	//load to lower 12 bits
			b 		Season					//branch to Season

suffix1:	adrp 	x0, format1				//if the suffix is 1
			add 	x0, x0, :lo12:format1	//load to lower 12 bits
			b 		Season					//branch to Season

suffix2:	adrp 	x0, format2				//if the suffix is 2
			add 	x0, x0, :lo12:format2	//load to lower 12 bits
			b 		Season					//branch to Season
			
suffix3:	adrp 	x0, format3				//if the suffix is 3
			add 	x0, x0, :lo12:format3	//load to lower 12 bits
			b 		Season					//branch to Season
			
Season: 	adrp 	x26, season_m				//load x26 as season_m
			add 	x26, x26, :lo12:season_m	//load to lower 12 bits
			
			cmp		month_r, 1				//compare month_r with 1
			b.eq 	win						//if equal branch to win
			cmp 	month_r, 2				//compare month_r with 2
			b.eq 	win						//if equal branch to win
			cmp 	month_r, 3				//compare month_r with 3
			b.eq 	wands					//if equal branch to wands
			
			cmp		month_r, 4				//compare month_r with 4
			b.eq 	spr						//if equal branch to spr
			cmp 	month_r, 5				//compare month_r with 5
			b.eq 	spr						//if equal branch to spr
			cmp 	month_r, 6				//compare month_r with 6
			b.eq 	sands					//if equal branch to sands
			
			cmp		month_r, 7				//compare month_r with 7
			b.eq 	sum						//if equal branch to sum
			cmp 	month_r, 8				//compare month_r with 8
			b.eq 	sum						//if equal branch to sum
			cmp 	month_r, 9				//compare month_r with 9
			b.eq 	sandf					//if equal branch to sandf
			
			cmp		month_r, 10				//compare month_r with 10
			b.eq 	fal						//if equal branch to fal
			cmp 	month_r, 11				//compare month_r with 11
			b.eq 	fal						//if equal branch to fal
			cmp 	month_r, 12				//compare month_r with 12
			b.eq 	fandw					//if equal branch to fandw
			
wands: 		cmp 	day_r, 20				//compare day_r with 20
			b.le 	win						//if day_r<=20 branch to win
			b 		spr						//if day_r>20 branch to spr

sands: 		cmp 	day_r, 20				//compare day_r with 20
			b.le 	spr						//if day_r<=20 branch to spr
			b 		sum						//if day_r>20 branch to sum

sandf: 		cmp 	day_r, 20				//compare day_r with 20
			b.le 	sum						//if day_r<=20 branch to sum
			b 		fal						//if day_r>20 branch to fal

fandw: 		cmp 	day_r, 20				//compare day_r with 20
			b.le 	fal						//if day_r<=20 branch to fal
			b 		win						//if day_r>20 branch to win
			
win:		mov 	w9, 0					//mov 0 to w9
			ldr 	x3, [x26, w9, SXTW 3]	//load season[0]
			bl  	printf					//call printf
			b 	 	done					//branch to done

spr:		mov 	w9, 1					//mov 1 to w9
			ldr 	x3, [x26, w9, SXTW 3]	//load season[1]
			bl  	printf					//call printf
			b 	 	done					//branch to done

sum:		mov 	w9, 2					//mov 2 to w9
			ldr 	x3, [x26, w9, SXTW 3]	//load season[2]
			bl  	printf					//call printf
			b 	 	done					//branch to done
					
fal:		mov 	w9, 3					//mov 3 to w9
			ldr 	x3, [x26, w9, SXTW 3]	//load season[3]
			bl  	printf					//call printf
			b 	 	done					//branch to done				

done:		ldp 	x29, x30, [sp], 16		//Restoring fp and lr
			ret								//Return function for program

Error: 		adrp 	x0, error				//load error to 1st arg
			add 	x0, x0, :lo12:error		//load to lower 12 bits
			bl 		printf					//call printf
			b 		done					//branch to done
			