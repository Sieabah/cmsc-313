/*
  Name: Christopher Sidell
  Class: CMSC 313
  Section: 01
  File: Project7
  Desc: Project7 even more pointer fun
*/

#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>
#include <string.h>

typedef struct student
{
  int id;
  double gpa;
} STUDENT;

//Prints double
void printDouble(void * d)
{
  printf("Value: %.1f,",*((double*)d));
}

//Prints student
void printStudent(void * s)
{
  printf("id: %d, gpa: %.1f,",((STUDENT*)s)->id,((STUDENT*)s)->gpa);
}

//Prints pointer to a student
void printStudentPtr(void  *s)
{
  printStudent(*((STUDENT**)s));
}

//Prints array of values
void showValues(void * base, int nElem, int sizeofEachElem, void (*fptr)(void *))
{
  int i = 0;
  for (i = 0; i < nElem; ++i)
  {
    fptr(base+(i*sizeofEachElem));
    if((i+1) % 5 == 0)
    {
      printf("\n");
    }
  }
  printf("\n");
}

//Compare v1 > v2
bool cmpDouble (void *v1, void *v2)
{
  return *((double*)v1) > *((double*)v2) ? true : false;
}

//Compare student id v1 > v2
bool cmpStudent (void *v1, void *v2)
{
  return ((STUDENT*)v1)->id > ((STUDENT*)v2)->id ? true : false;
}

//Compare student pointers
bool cmpStudentPtr (void *v1, void *v2)
{
  cmpStudent(*((STUDENT**)v1),*((STUDENT**)v2));
}

//Sort using selection
void selectionSort(void * base, int nElem, int sizeofEachElem, bool (*cmp)(void *, void *), void (*fptr)(void *))
{
  int i,j,pos;
  int n;
  //For all positions
  for ( i = 0 ; i < ( nElem - 1 ) ; i++ )
   {
      pos = i;
 
      //For all positions after initial
      for ( j = i + 1 ; j < nElem ; j++ )
      {
        //Determine pointers
        void* base1 = base+pos*sizeofEachElem;
        void* base2 = base+j*sizeofEachElem;
        //Compare them
        if ( cmp(base1,base2) )
        {
          //Update position if base2 < base1
          pos = j;
        }
        
      }
      //If position changed means there's a swap
      if ( pos != i )
      {
        //Determine swaps
        void* base1 = base+i*sizeofEachElem;
        void* base2 = base+pos*sizeofEachElem;

        //For all bytes in the size
        for (n = 0; n < sizeofEachElem; ++n)
        {
          void* temp;
          //Copy to temp
          memcpy(temp,base1,1);
          //Swap
          memcpy(base1,base2,1);
          //Finish swapping
          memcpy(base2,temp,1);

          //Increment pointers
          base1++;
          base2++;
        }

        //Display array
        showValues(base, nElem, sizeofEachElem, fptr);
      }
   }
}

//Free student array
void freeHeapMem(STUDENT ** ptr, int size)
{
  int i;
  //Start from end of array
  for (i = size-1; i >= 0 ; i--)
  {
    //Free dereferenced student
    free(*(ptr+i));
  }
}


int main(int argC, char * argV[])
{

  // seed value provided as command-line arg.
  srand(atoi(argV[1]));

  // rand % 8 just evaluates to an int from 0 to 7, gets added to num < 1 to get a "random" double

  double myDouble []={ rand()%8 + .2, rand()%8 +  .3, rand()%8 +  .7, rand()%8 +  .5, rand()%8 +  .6,
                       rand()%8 + .4, rand()%8 +  .1, rand()%8 +  .2, rand()%8 +  .3, rand()%8 +  .4};




  // produce "random" student info
  STUDENT sArray [] ={ {rand()%1000, rand()%4 + .3}, {rand()%1000, rand()%4 + .9}, {rand()%1000, rand()%4 + .5}, {rand()%1000, rand()%4 + .7},
                       {rand()%1000, rand()%4 + .1}, {rand()%1000, rand()%4 + .8}, {rand()%1000, rand()%4 + .5}, {rand()%1000, rand()%4 + .9},
                       {rand()%1000, rand()%4 + .3}, {rand()%1000, rand()%4 + .7}};



 
  STUDENT * ptrArray[10];

  int i;
  for(i =0; i <10; i++)
    {
      ptrArray[i] = (STUDENT *)malloc(sizeof(STUDENT));
      ptrArray[i]-> id = sArray[i].id  + 1;
      ptrArray[i]->gpa = sArray[i].gpa + .1;

    }

  printf("---------------------------------------\n");
  printf("Print index 5 of each array\n");
  printDouble(&myDouble[5]);
  printStudent(&sArray[5]);
  printStudentPtr(&ptrArray[5]);

  printf("\n---------------------------------------\n");
  printf("Print all elements by calling the showValues on myDouble\n");
  showValues(myDouble, 10, sizeof(double), &printDouble);
  printf("\n---------------------------------------\n");
  printf("Print all elements by calling the showValues on printStudent\n");
  showValues(sArray, 10, sizeof(STUDENT), &printStudent);
  printf("\n---------------------------------------\n");
  printf("Print all elements by calling the showValues on printStudentPtr\n");
  showValues(ptrArray, 10, sizeof(STUDENT *), &printStudentPtr);

  printf("\n---------------------------------------\n");
  printf("Selection Sort on myDouble\n");
  selectionSort(myDouble, 10, sizeof(double), &cmpDouble, &printDouble);


  printf("\n---------------------------------------\n");
  printf("Selection Sort on sArray\n");
  selectionSort(sArray, 10, sizeof(STUDENT), &cmpStudent, &printStudent);


  printf("\n---------------------------------------\n");
  printf("Selection Sort on ptrArray\n");
  selectionSort(ptrArray, 10, sizeof(STUDENT *), &cmpStudentPtr, &printStudentPtr);




  freeHeapMem(ptrArray, 10);

  return 0;

}