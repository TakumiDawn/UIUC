#include <stdio.h>
/*
 * Recursive Fibonacci with look-up table.
 */

int table[100];

int fib(int n)
{
	if(table[n]!= -1)
		return table[n];

	if(n == 0)
		table[n] = 0;
	else if(n == 1)
		table[n] = 1;
	else
		table[n] = fib(n-1)+fib(n-2);

	return table[n];
}

int main()
{
	int i,num;
	for(i=0;i<100;i++)
		table[i] = -1;

	num = fib(6);
	printf("Print Table: %d, %d, %d, %d, %d, %d, %d \n", table[0], table[1], table[2],table[3],table[4],table[5],table[6]);
	return 0;
}
