#include <stdio.h>

void printlist(int * list, int size);

int main()
{
  int unsorted; 
  int sorted; 
  int unsortedItem;

  int numbers[10] = {5,1, 2,6, -10, 100, 12,42,7, 96};
  printf ("Sorting \n");
  printlist(numbers,10);
  for (unsorted = 1; unsorted< 10; unsorted++)
    {
      unsortedItem = numbers[unsorted];
      printf ("\n Inserting %d in sorted part ", unsortedItem);
      printlist(numbers, unsorted);
 
      for (sorted = unsorted - 1; sorted >= 0; sorted -- )
	{
	  if(numbers[sorted] > unsortedItem)
	    numbers[sorted + 1] = numbers[sorted];
	  else
	    break;
	}
      numbers[sorted+1] = unsortedItem;
      printf ("\n After insertion: ");
      printlist(numbers,10);

    }


  return 0;
}

void printlist(int * list, int size)
{
  int i;
  for(i=0;i<size;i++)
    printf(" %d ", *(list +i));
  printf(" \n ");
  return ;
}
