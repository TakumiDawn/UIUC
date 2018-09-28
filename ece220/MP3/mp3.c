#include <stdio.h>
#include <stdlib.h>
#include <math.h>

int main()
{
  unsigned long n;

  printf("Enter a row index: ");
  scanf("%lu", &n);

  unsigned long i;
  unsigned long x =1;
  int k=0;
  for (k=0; k<=n; k++){
      for (i=1; i<=k; i++)
        {
          if (i==1)
          {
            x = (n+1-i)/i;
          }
          else
            {
              x = (x * (n+1-i))/i;
            }
        }

      printf("%lu ", x);
  }
  return 0;
}
