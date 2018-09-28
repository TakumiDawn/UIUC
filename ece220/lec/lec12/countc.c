#include<stdio.h>
// check number of occurrences of a char

int main()
{
  char string[15] = "hello  !!";
  char c;
  int i = 0;
  int count = 0;
  gets(string);
  printf("\n The string: %s", string);
  scanf("%c",&c);
  printf("\n The char: %c", c);
  while(string[i] != '\0')
    {
      if(string[i] == c)
	count++;
      i++;
    }
  printf("\n The number of occurrences of %c in  %s = %d", c, string, count);
  return 0;

}
