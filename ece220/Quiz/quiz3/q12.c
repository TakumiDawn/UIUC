#include <stdlib.h>
#include <stdio.h>

int main()
{
  int n, i;
  printf("Input the size of array : ");
  scanf("%d", &n);

  int arr[n];
  printf("Input %d elements in the array :\n", n);
  for (i = 0; i < n; i++)
  {
    printf("element - %d: ",i);
    scanf("%d", &arr[i]);
  }

  int j, temp;
  for (i = 0; i < n; i++)
  {
    for (j = i+1; j < n; j++) {
      if (arr[j] > arr[i])
      {
        temp = arr[i];
        arr[i] = arr [j];
        arr[j] = temp;
      }
    }
  }

  printf("\nElements of array is sorted in descending order:\n");
    for(i=0; i<n; i++)
    {
        printf("%d  ", arr[i]);
    }
	        printf("\n\n");

  return 0;
}
