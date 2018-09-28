#include<stdio.h>
int update(int* arr, int size);

int main()
{
  int mynums[10] = {1,2,3,4,5,6,7,8,9,10};
  int i;
  int total = 0;
  for(i=0;i<10;i++)
    total += mynums[i];
  printf("\n Total before = %d \n",total);

  update(mynums,10);

  total = 0;
  for(i=0;i<10;i++)
    total += mynums[i];
  printf("\n Total after = %d \n",total);
 
  return 0;
	
}

int update(int* arr, int size)
{
  int i;
  for(i=0;i<size;i++)
    arr[i] *= 2;
  return 0;  
}
