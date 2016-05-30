/*
  Name: Christopher Sidell
  Class: CMSC 313
  Section: 01
  File: Project6
  Desc: Project6 pointers with C
*/

#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <stdbool.h>


typedef struct fraction{
  int num;   //numerator
  int denom; //denominator
} FRACTION;

typedef struct myVector{
  FRACTION * ptr;
  int numAllocated;  //number of elements actually allocated
  int numUsed;  //the logical length

} MYVECTOR;

//makeVector
//Constructs a vector that originally has 2 elements allocated
void makeVector(MYVECTOR* vec);

//disposeVector
//has code to make sure there is no memory leak if a MYVECTOR goes out of scope
void disposeVector(MYVECTOR* vec);

//size
//Returns the side of the vector
int size(MYVECTOR *vec);

//capacity
//returns the capacity of the vector
int capacity(MYVECTOR *vec);

//printFraction
//Prints one fraction, not called directly in main. You will have to decide
//  when to call it from your own functions
void printFraction(FRACTION *fract);

//displayVector
//Displays the vector. see sample run for the format
void displayVector(MYVECTOR* vec);

//grow
//Grow vector
void grow(MYVECTOR* vec);

//append
//will append one value to the end of the vector
void append(MYVECTOR* vec, FRACTION frac);

//isLarger
//Which fraction is larger
int isLarger(FRACTION* f1, FRACTION* f2);

//sortVector
//Will sort the values in the vector
void sortVector(MYVECTOR* vec, int (*fptr1)(FRACTION*,FRACTION*));

//insertAt
//insert element at index
void insertAt(MYVECTOR* vec, int index, FRACTION fract);

//removeAt
//Remove element at index
void removeAt(MYVECTOR* vec, int index);

//copyVector
//Will make a copy of the vector
void copyVector(MYVECTOR* vec, MYVECTOR* cpy);

int main()
{
  FRACTION fracArray [10] ={ {1,2},{2,3},{3,4},{7,8},{22,7},
                               {1,3},{1,4},{1,8},{2,5},{3,5}};

  int n, d;
  printf("Enter n/d: ");
  scanf("%d/%d", &n, &d);

  FRACTION f1= {n,d};
  FRACTION f2 = {d,n};


  int i =0;
  MYVECTOR myV;
  MYVECTOR copyMyV;


  makeVector(&myV);

  for (i =0; i<10; i++)
  {
      append(&myV, fracArray[i]);
      printf("%d/%d appended to the vector.  ", fracArray[i].num,
                                              fracArray[i].denom);
      printf("Size is: %d, ", size(&myV));
      printf("Cap is: %d\n", capacity(&myV));
  }

  printf("----------------------\n");
  printf("Here are the values: \n");
  displayVector(&myV);

  printf("----------------------\n");
  sortVector(&myV, &isLarger);
  printf("Here are the values after sort: \n");
  displayVector(&myV);

  printf("----------------------\n");
  printf("Inserting %d/%d at index %d\n", n,d,n % 10);
  insertAt(&myV, n % 10 , f1);
  printf("After inserts, values are: \n");
  displayVector(&myV);
  printf("Size is: %d, and Cap is: %d\n ", size(&myV), capacity(&myV));


  printf("----------------------\n");
  printf("Inserting %d/%d at index %d\n", d,n,d % 10);
  insertAt(&myV, d % 10 , f2);
  printf("After inserts, values are: \n");
  displayVector(&myV);
  printf("Size is: %d, and Cap is: %d\n ", size(&myV), capacity(&myV));

  printf("----------------------\n");
  printf("Inserting %d/%d at index %d\n", n , d,-(n % 10));
  insertAt(&myV, -(n % 10), f1);


  printf("----------------------\n");
  printf("Inserting %d/%d at index %d\n", d,n, size(&myV) + (d % 10));
  insertAt(&myV, size(&myV) + (d % 10), f2);

  printf("----------------------\n");
  printf("Call copyVector\n");
  copyVector(&myV, &copyMyV);

  printf("----------------------\n");
  printf("Here is the original: \n");
  displayVector(&myV);

  printf("----------------------\n");
  printf("Here is the copy: \n");
  displayVector(&copyMyV);

  printf("----------------------\n");
  printf("Adding many new values to the copy\n");

  for (i =0; i<10; i++)
    {
      append(&copyMyV, fracArray[i]);
      printf("%d/%d appended to the vector.  ", fracArray[i].num,
             fracArray[i].denom);
      printf("Size is: %d, ", size(&copyMyV));
      printf("Cap is: %d\n", capacity(&copyMyV));
    }

  printf("----------------------\n");
  printf("Here is the copy after adding 10 new fractions: \n");
  displayVector(&copyMyV);

  printf("----------------------\n");
  sortVector(&copyMyV, &isLarger);
  printf("Here is the copy after sorting: \n");
  displayVector(&copyMyV);

  printf("----------------------\n");
  printf("Here is the original vector: \n");
  displayVector(&myV);

  printf("----------------------\n");
  printf("Removing value at index %d.", n % 10);
  removeAt(&copyMyV, n % 10);
  printf("Size is: %d, ", size(&copyMyV));
  printf("Cap is: %d\n", capacity(&copyMyV));
  printf("Here is the copy after removing the value at %d: \n", n % 10);
  displayVector(&copyMyV);

  printf("----------------------\n");
  printf("Removing value at index %d.", d % 10);
  removeAt(&copyMyV, d % 10);
  printf("Size is: %d, ", size(&copyMyV));
  printf("Cap is: %d\n", capacity(&copyMyV));
  printf("Here is the copy after removing the value at %d: \n", d % 10);
  displayVector(&copyMyV);


  printf("----------------------\n");
  printf("Calling disposeVector\n");
  disposeVector(&myV);
  disposeVector(&copyMyV);


  return 0;
}

//makeVector
//Constructs a vector that originally has 2 elements allocated
void makeVector(MYVECTOR* vec)
{
  vec->numUsed = 0;
  vec->numAllocated = 2;
  FRACTION* frac = malloc(sizeof(FRACTION)*2);
  vec->ptr = frac;
}
//disposeVector
//has code to make sure there is no memory leak if a MYVECTOR goes out of scope
void disposeVector(MYVECTOR* vec)
{
  vec->numUsed = vec->numAllocated = 0;
  free(vec->ptr);
  vec->ptr = NULL;
}

//size
//Returns the side of the vector
int size(MYVECTOR *vec)
{
  return vec->numUsed;
}

//capacity
//returns the capacity of the vector
int capacity(MYVECTOR *vec)
{
  return vec->numAllocated;
}

//printFraction
//Prints one fraction, not called directly in main. You will have to decide
//  when to call it from your own functions
void printFraction(FRACTION *fract)
{
  printf("%d/%d",fract->num,fract->denom);
}

//displayVector
//Displays the vector. see sample run for the format
void displayVector(MYVECTOR* vec)
{
  FRACTION* frac = vec->ptr;

  int i;
  //Loop through
  for (i = 0; i < size(vec); i++)
  {
    //print fraction and increment
    printFraction(frac++);
    
    //Remove || true to remove trailing comma
    if(i + 1 < size(vec) || true)
    {
      printf(", ");
    }

    //Newline every 5 fractions
    if((i+1)%5 == 0)
    {
      printf("\n");
    }
  }

  printf("\n");
}

//grow
//Grows given vector by two
void grow(MYVECTOR* vec)
{
  int newSize = vec->numAllocated + 2;
  //Grow size
  FRACTION* frac = malloc(sizeof(FRACTION)*newSize);
  FRACTION* oldMem = frac;
  FRACTION* old = vec->ptr;
  int i;

  //Loop through both vectors to copy all values
  for(i = 0; i < vec->numUsed; i++)
  {
    frac->num = old->num;
    frac->denom = old->denom;

    frac++;
    old++;
  }

  free(vec->ptr);
  vec->ptr = oldMem;
  vec->numAllocated += 2;
}

//append
//will append one value to the end of the vector
void append(MYVECTOR* vec, FRACTION frac)
{
  int i;
  FRACTION* ptr;

  //Find out if we need to grow
  if(size(vec) + 1 > capacity(vec))
  {
    grow(vec);
  }

  //Get the pointer to the fractions
  ptr = vec->ptr;
  for (i = 0; i < size(vec); ++i)
  {
    //increment to end
    ptr++;
  }

  //Add numbers
  ptr->num = frac.num;
  ptr->denom = frac.denom;

  //Increase size
  vec->numUsed++;
}

//isLarger
//Returns difference in size, positive f1 is greater, 0 is equal, negative f1 is less
int isLarger(FRACTION* f1, FRACTION* f2)
{
  double val = (((double)f1->num/(double)f1->denom) - ((double)f2->num/(double)f2->denom));

  //Find which way we're leaning
  if(val > 0)
  {
    return 1;
  }
  else if(val < 0)
  {
    return -1;
  }
  else
  {
    return 0;
  }
}

//sortVector
//Will sort the values in the vector
void sortVector(MYVECTOR* vec, int (*fptr1)(FRACTION*,FRACTION*))
{
  FRACTION* one;
  FRACTION* two;
  int i,j;

  //BUBBLE SORT
  for (i = 0; i < size(vec)-1; i++)
  {
    one = two = vec->ptr;

    //Bubble it up
    for (j = 0 ; j < size(vec) - i - 1; j++)
    {
      two = one;
      two++;
      //Call sort function
      if (fptr1(one,two) > 0)
      {
        /* Swapping */
        int num, denom;
        num = one->num;
        denom = one->denom;

        one->num = two->num;
        one->denom = two->denom;
        
        two->num = num;
        two->denom = denom;
      }
      one++;
    }
  }
}

//insertAt
//Will insert a value at the specified index or display an error message if the specified
//  index is outside the logical bounds of the vector. You can only insert a new value if
//  the index is within the logical bounds of the vector
void insertAt(MYVECTOR* vec, int index, FRACTION fract)
{
  if(index > size(vec) || index < 0)
  {
    return;
  }

  FRACTION* one;
  FRACTION* two;
  int i;

  append(vec, fract);

  //Get to the end
  one = two = vec->ptr;
  for (i = 0; i < size(vec)-1; ++i)
  {
    one++;
  }

  //Swap until in position
  for (i = size(vec)-1; i >= index-1; i--)
  {
    two = one;
    two--;

    int num, denom;
    num = one->num;
    denom = one->denom;

    one->num = two->num;
    one->denom = two->denom;
    
    two->num = num;
    two->denom = denom;

    one--;
  }
}

//removeAt
//Will remove a value at the specified index or display an error message if the specified
//  index is outside the logical bounds of the vector. you can only remove a value with 
//  an index in the logical bounds of the vector
void removeAt(MYVECTOR* vec, int index)
{
  FRACTION* one;
  FRACTION* two;
  int i;

  one = two = vec->ptr;

  if(index > size(vec) || index < 0)
  {
    return;
  }

  //Loop through entire vector
  for (i = 0; i < size(vec); ++i)
  {
    one=two;
    two++;

    //If we're at the index, swap with next index
    if(i>index)
    {
      int num, denom;
      num = one->num;
      denom = one->denom;

      one->num = two->num;
      one->denom = two->denom;
      
      two->num = num;
      two->denom = denom;
    }

    one++;    
  }

  //Decrement size
  vec->numUsed--;
}

//copyVector
//Will make a copy of the vector
void copyVector(MYVECTOR* vec, MYVECTOR* cpy)
{
  makeVector(cpy);

  for (;capacity(vec) > capacity(cpy);)
  {
    grow(cpy);
  }

  FRACTION* frac = cpy->ptr;
  FRACTION* old = vec->ptr;
  int i;

  //Loop through both vectors to copy all values
  for(i = 0; i < size(vec); i++)
  {
    frac->num = old->num;
    frac->denom = old->denom;

    frac++;
    old++;
    cpy->numUsed++;
  }
}
