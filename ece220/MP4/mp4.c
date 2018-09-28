#include <stdlib.h>
#include <stdio.h>
/*This is a program that will print out the semiprimes from the given range from a to b. */

int is_prime(int number);
int print_semiprimes(int a, int b);


int main(){
   int a, b;
   printf("Input two numbers: ");
   scanf("%d %d", &a, &b);
   if( a <= 0 || b <= 0 ){ /*check if the input is positive numbers*/
     printf("Inputs should be positive integers\n");
     return 1;
   }

   if( a > b ){ /*check if the former number is smaller or equal to the latter one.*/
     printf("The first number should be smaller than or equal to the second number\n");
     return 1;
   }
   // TODO: call the print_semiprimes function to print semiprimes in [a,b] (including a and b)
   print_semiprimes(a,b);  /*call the print_semiprimes function in the main program*/
   return 0;
}


/*
 * this function checks the number is prime or not.
 * Input    : a number
 * Return   : 0 if the number is not prime, else 1
 */
int is_prime(int n)
{int i1;
if (n==2)
{
  return 1;
}
else
{
for (i1=2; i1<=n-1; i1++)
  {
  if (n%i1==0)
    return 0;
  }return 1;
}
}


/*
 * this function prints all semiprimes in [a,b] (including a, b).
 * Input   : a, b (a should be smaller than or equal to b)
 * Return  : 0 if there is no semiprime in [a,b], else 1
 */
 int print_semiprimes(int a, int b){
 int i, result =0;
 for (i = a; i <= b; i++) {
   int k;
   for (k = 2; k <= i-1; k++) {
     int isp = is_prime(k);
     int isf = i%k;
     int isp2 = is_prime(i/k);
     int isf2 = i%(i/k);
     if ( (isp==1)&&(isf==0)&&(isp2==1)&&(isf2==0) ) /*if k is a prime factor of n and (n/k) is also a prime number*/
  {
    printf("%d ", i); /*print n*/
    result = 1;
    break;
  }
}}
 printf("\n");
 return result;
 }
