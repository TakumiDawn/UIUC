#include <stdio.h>

int RemoveDuplicates(int *arr, int n)
{
  int lastUnique = 0;
  int i = 0;
  for (i = 0; i < n; i++)
  {
    if (arr[i+1]>arr[i] || (i==0))
  //  if (arr[i]!=arr[lastUnique])
    {
    //  arr[lastUnique+1] == arr[i];
      lastUnique++;
      arr[i]=arr[lastUnique-1];
    }
  }
  return lastUnique;
}

int main()
{
  int arr[]={1,2,2,3,4,5,6,6,8,9};
  int n = sizeof(arr)/sizeof(arr[0]);
  int m;
//  BubbleSort(arr, n);
  m= RemoveDuplicates(arr, n);
   int j;
   for ( j = 0; j < n; j++)
{
  printf("%d\n",arr[j]);
}

  printf("The array had %d unique elements\n",m);

}
