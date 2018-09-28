#include <stdlib.h>
#include <stdio.h>

int maxProfit(int *prices,int n);
int main()
{
  int p[5]= {5,4,3,2,1};
  int n = 5;
  int s = maxProfit(p, n);
  printf("%d\n",s );
  return 0;
}

int maxProfit(int *prices, int n)
{
  int i,j, profit =0;
  for (i = 0; i < n; i++)
  {
    for (j = i; j < n; j++)
    {
      int temp =0;
      temp = prices[j]-prices[i];
      printf("%d\n",temp );
      if (temp>profit)
      {
        profit = temp;
      }
    }
  }
  return profit;
}
