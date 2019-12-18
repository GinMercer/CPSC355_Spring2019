//Assignment5
//Author: Sijia Yin
//Date: June 12, 2019
//Goals: Translate all functions except main() into ARMv8 assembly language and put them into a separate assembly source code file called a5a.asm. These functions will be called from the main() function given above, which will be in its own C source code file called a5aMain.c. Also move the global variables into a5a.asm. Your assembly functions will call the printf() library routine. Be sure to handle the global variables and format strings in the appropriate way. Input will come from standard input. Run the program to show that it is working as expected, capturing its output using the script UNIX command, and name the output file script1.txt.

#include <stdio.h>
#include <stdlib.h>

void enqueue(int value);
int dequeue();
int queueFull();
int queueEmpty();
void display();

int main() {
	int operation, value;
	
	do {
		system("clear");
		printf("### Queue Operations ###\n\n");
		printf("Press 1 - Enqueue, 2 - Dequeue, 3 - Display, 4 - Exit\n");
		printf("Your option? ");
		scanf("%d", &operation);
		
		switch (operation) {
		case 1:
			printf("\nEnter the positive integer value to be enqueued: ");
			scanf("%d", &value);
			enqueue(value);
			break;
		case 2:
			value = dequeue();
			if (value != -1){
				printf("\nDequeued value is %d\n", value);
			}	
			break;
		case 3:
			display();
			break;
		case 4:
			printf("\nTerminating program\n");
			exit(0);
		default:
			printf("\nInvalid option! Try again.\n");
			break;
		}
		printf("\nPress the return key to continue . . . ");
		getchar();
		getchar();
	} while (operation != 4);
	return 0; 
}
