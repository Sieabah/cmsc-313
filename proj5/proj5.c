/*
	Name: Christopher Sidell
	Class: CMSC 313
	Section: 01
	File: Project5
	Desc: Project5 practice with C
*/

#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>

/********************************
 *  myStrLen
 *  Returns length of string minus the null
 ********************************/
int myStrlen(char * s)
{
	int count = 0;
  //Wihle pointer isn't null '\0'
	while(*(s++)) 
		count++; //increment
	return count; //return counter
}

/********************************
 *  sameString
 *  Determines if the strings given are the same
 ********************************/
bool sameString(char *s1, char * s2)
{
	int i;
  int length = myStrlen(s1);

  //If they're not the same length then they're not the same
	if(myStrlen(s1) != myStrlen(s2))
	{
		return false;
	}

  //Same length, check each character
	for (i = 0; i < length; ++i)
	{
    //Check character and increment pointer
		if(*(s1++) != *(s2++))
		{
			return false;
		}
	}

  //Same string
	return true;
}

/********************************
 *  makeCopy
 *  Copy string to dynamically allocated string
 ********************************/
char * makeCopy(char * s)
{
  //Create size of character - '/0'
  char *ptr = (char*) malloc(myStrlen(s) *sizeof(char) +1);
  //Get pointer to first string
  char* s1 = s;
  //Get pointer to new string
  char* s2 = ptr;


  int i;
  //Loop through length
  for (i = 0; i < myStrlen(s); ++i)
  {
    //Copy character
    *s2 = *s1;
    //Increment both strings
    s1++;
    s2++;
  }

  //Handle null character
  s2++;
  *s2 = '\0';

  //Return pointer to new string
  return ptr;
}

/********************************
 *  mySort
 *  Alphabetically sort the string
 ********************************/
void mySort(char * s)
{
  //Delcare all the swapping variables
  int s1, s2 = 0, length,i;
  char* ptr, *ptr2, car;

  //Get the length
  length = myStrlen(s);

  //Delcare some memory for us to use
  ptr2 = (char*)malloc(length+1);

  //copy the pointer
  ptr = s;

  //Start going through the alphabet
  for(car = 'a' ; car <= 'z'; car++)
  {
    //For entire string 
    for(s1 = 0; s1 < length; s1++)
    {
      //Check character against alphabet
      if(*ptr == car)
      {
        //Put value in result pointer
        *(ptr2+s2) = *ptr;
        s2++;
      }
      //increment check
      ptr++;
    }
    //Copy pointer back to beginning
    ptr = s;
  }
  //Add null to end of string
  *(ptr2+s2) = '\0';

  //Get a copy of start of pointer
  ptr = ptr2;

  //Copy the string to given string
  for (i = 0; i < length; ++i)
  {
    //Copy character
    *s = *ptr;
    //Increment characters
    s++;
    ptr++;
  }

  //Free the string
  free(ptr2);
}

/********************************
 *  makeArray
 *  Dynamically allocate an array of doubles as per project
 *    description
 ********************************/
double * makeArray(int x, int size)
{
  //Allocate size * size of double
  double *ptr = (double*) malloc(size *sizeof(double));
  //Keep a pointer for us to manipulate
  double *sub = ptr;
  //Variable for double division
  double num = x;

  int i;

  //Loop through the size
  for (i = 0; i < size; ++i)
  {
    //Divide first
    num = num / 2;
    //Put it into the pointer
    *sub = num;    
    //Next element
    sub++;
  }

  //Return
  return ptr;
}

/********************************
 *  showArray
 *  Print array of doubles and their memory location
 ********************************/
void showArray(double * ptr, int size)
{
	int i;

  //Loop through ptr
	for (i = 0; i < size; ++i)
	{
    printf("The value is %f at address %p \n",*ptr,ptr);
		ptr++;
	}
  
}

/********************************
 *  swapHex
 *  Swap bytes in memory and print hex of integer value
 ********************************/
void swapHex(int x, int byte1, int byte2)
{
  //Print out information
  printf("%d in hex is %x\n",x,x);
  printf("swapping byte %d byte %d\n",byte1,byte2);

  //create char pointer
  char* n = &x;
  //Create temp char
  char temp;

  //keep copy of first byte
  temp = *(n+byte1);
  //Copy byte2 to byte 1
  *(n+byte1) = *(n+byte2);
  //copy byte1(temp) to byte2
  *(n+byte2) = temp;

  //Print new value
  printf("%d in hex is %x\n",x,x);
}

//Main function
int main(int argc, char * argv[])
{

  char * copyOfArg1;
  char * copyOfArg2;
  double * myArr[2];

  printf("myStrlen Function\n");
  printf("The number of characters in %s is %d\n", argv[1], myStrlen(argv[1]));
  printf("The number of characters in %s is %d\n", argv[2], myStrlen(argv[2]));
  printf("--------------------------\n");
  printf("sameString Function\n");
  if (sameString(argv[1], argv[2]))
    printf("%s and %s are the same string\n", argv[1], argv[2]);
  else
    printf("%s and %s are not the same string\n", argv[1], argv[2]);
  printf("--------------------------\n");
  printf("makeCopy Function\n");
  copyOfArg1 = makeCopy(argv[1]);
  printf("argv[1] is %s and copy is %s\n", argv[1], copyOfArg1);
  copyOfArg2 = makeCopy(argv[2]);
  printf("argv[2] is %s and copy is %s\n", argv[2], copyOfArg2);
  printf("--------------------------\n");
  printf("mySort Function--Based on ASCII Codes\n");
  mySort(copyOfArg1);
  printf("argv[1] is %s and copy is %s\n", argv[1], copyOfArg1);
  mySort(copyOfArg2);
  printf("argv[2] is %s and copy is %s\n", argv[2], copyOfArg2);
  printf("--------------------------\n");
  printf("swapHex Function\n");
  swapHex(atoi(argv[3]),0,1);
  swapHex(atoi(argv[3]),0,2);
  swapHex(atoi(argv[3]),0,3);
  swapHex(atoi(argv[3]),1,2);
  swapHex(atoi(argv[3]),1,3);
  swapHex(atoi(argv[3]),2,3);
  printf("--------------------------\n");
  printf("makeArray Function\n");
  myArr[0] = makeArray(atoi(argv[3]), myStrlen(argv[1]));
  myArr[1] = makeArray(atoi(argv[3]), myStrlen(argv[2]));
  printf("--------------------------\n");
  printf("showArray Function for argv[1]\n");
  showArray(myArr[0], myStrlen(argv[1]));
  printf("--------------------------\n");
  printf("showArray Function for argv[2]\n");
  showArray(myArr[1], myStrlen(argv[2]));
  printf("--------------------------\n");
  printf("End of Demo\n");
  free(copyOfArg1);
  free(copyOfArg2);
  free(myArr[0]);
  free(myArr[1]);

  return 0;
}