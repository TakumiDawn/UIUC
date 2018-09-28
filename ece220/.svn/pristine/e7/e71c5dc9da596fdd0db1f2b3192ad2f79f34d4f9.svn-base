#include <stdio.h>
#include "prime.h"

int main(){
  // Write the code to take a number n from user and print all the prime numbers between 1 and n
  int n1, i, ifp;
  printf("Enter the value of n: ");
  scanf("%d", &n1);
  printf("Printing primes less than or equal to %d:\n", n1);
  for (i=2; i<=n1; i++)
  {
    ifp = is_prime(i);
    if (ifp == 1)
      {
        printf("%d ", i);
      }
  }
  printf("\n");
  return 0;
}
