#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#define PI 3.14159

int main(){
  int i, n, omega1, omega2=0;
  float x;

  printf("Enter the values of n, omega1, and omega2 in that order\n" );
  scanf("%d %d %d", &n, &omega1, &omega2);

  for (i = 0; i < n; i++)
  { x= i*PI/n;

  printf("(%f,%f)\n", x, sin(omega1*x)+0.5*sin(omega2*x));
  }

  return 0;
}
