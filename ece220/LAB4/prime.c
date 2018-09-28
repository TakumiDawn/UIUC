#include "prime.h"

int is_prime(int n)
{ // Return 1 if n is a prime, and 0 if it is not
  int i1;
  if (n==2)
  {
    return 1;
  }
  else
  {
  for (i1=2; i1<=n-1; i1++){
    if (n%i1==0)
      return 0;
    }return 1;
  }
}
