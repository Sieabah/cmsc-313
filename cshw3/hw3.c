/*
	Name: Christopher Sidell
	Class: CMSC 313
	Section: 01
	Desc: This program calculates PI and writes it to the 
		screen or to a file
*/
#define NEGATIVE_CUTOFF 0
#define FRACTIONS_PER_LINE 5
#include <stdio.h>
#include <stdlib.h>

/*
	Odd
	Determines if a value given is odd
*/
int Odd(int value);

/*
	CalculatePI
	Calculate PI up the value given
*/
double CalculatePI(int value);

/*
	CalculatePIF
	Calculates PI to a File
*/
double CalculatePIF(int value, FILE *fp);

int main()
{
	//Variables to hold value and write boolean
	int val = 0;
	int write = 0;

	//Value of PI
	double pi = 0;

	//File redirection
	FILE *ifp;
	char name[10];

	//Get a good positive odd integer
	do
	{	
		printf("Enter a positive odd integer: ");
		scanf("%d",&val);

	//While not negative or not odd
	} while(val < NEGATIVE_CUTOFF || !Odd(val));

	//Get how we're writing out the calculation
	do
	{
		printf("\nEnter 1 to write to a file\n");
		printf("Enter 2 to write to the screen: ");
		scanf("%d",&write);

		//Check limits
		if(write > 2 || write < 1)
		{
			//Reset write
			write = 0;
			printf("You did not enter 1 or 2\n");
		}

	//While write is 0
	} while(write == 0);

	//Switch for how we're writing
	switch(write)
	{
		case 1 :
			//Get the filename
			printf("Enter the name of a file (9 char or less): ");
			scanf("%9s",name);

			//Open the file
			ifp = fopen(name,"w");

			//Start calculating PI
			fprintf(ifp,"OK, I will calculate ...\n");
			pi = CalculatePIF(val,ifp);

			//Display calculation
			fprintf(ifp,"\n...which is equal to %f\n",pi);

			//Close the file
			fclose(ifp);
			break;
		case 2 :
			//Start calculating PI
			printf("\nOK, I will calculate ...\n");
			pi = CalculatePI(val);

			//Display value
			printf("\n...which is equal to %f\n",pi);
			break;
	}
	return 0;
}

//Odd
//Determine odd number
int Odd(int Value)
{
	return (Value % 2 != 0);
}

//CalculatePI
//Calculate PI and print to screen
double CalculatePI(int value)
{
	double PI = 1;
	int i = 0;
	int j = 1;
	int lineCount = 1;

	printf(" 4 X ( 1");
	//For values between 3 and value
	for(i = 3; i <= value; i += 2)
	{
		//Pretty printing
		if(lineCount++ % FRACTIONS_PER_LINE == 0)
		{
			printf("\n\t");
		}

		//Pretty printing
		if(Odd(j))
			printf(" - ");
		else
			printf(" + ");

		//Calculate for this iteration
		PI += Odd(j++) ? -(1.0/i) : 1.0/i;

		//Print fraction
		printf("1/%d",i);
	}
	printf(" )");

	//Return expanded value
	return PI*4;
}

//CalculatePIF
//Calculate PI and print to file
double CalculatePIF(int value, FILE *fp)
{
	double PI = 1;
	int i = 0;
	int j = 1;
	int lineCount = 1;

	fprintf(fp," 4 X ( 1");

	//For all odd values between 3 and value
	for(i = 3; i <= value; i += 2)
	{
		//Pretty printing
		if(lineCount++ % FRACTIONS_PER_LINE == 0)
		{
			fprintf(fp,"\n\t");
		}

		//Print modifyer
		if(Odd(j))
			fprintf(fp," - ");
		else
			fprintf(fp," + ");

		//Calculate for this iteration
		PI += Odd(j++) ? -(1.0/i) : 1.0/i;

		//Print fraction
		fprintf(fp,"1/%d",i);
	}
	fprintf(fp," )");

	//Return expanded value
	return PI*4;
}