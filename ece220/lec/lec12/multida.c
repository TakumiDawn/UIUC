#include<stdio.h>
// check number of occurrences of a char

int transpose(int a[3][4], int b[4][3]);
void printMatrix(int * a, int Nrow, int Ncol);
int multiply(int a[3][4], int b[4][3], int c[3][3]);


int main()
{
  int a[3][4]= {{1,2,3,4},{5,6,7,8},{9, 10, 11, 12}};
  int b[4][3]= {0,0,0,0,0,0,0,0,0,0,0,0};
  int c[3][3]= {0,0,0,0,0,0,0,0,0};

  printf("A =\n");
  printMatrix(&a[0][0],3,4);
  printf("B =\n");
  printMatrix(&b[0][0],4,3);
  transpose(a,b);
  printf("B =\n");
  printMatrix(&b[0][0],4,3);
  multiply(a,b,c);
  printf("C =\n");
  printMatrix(&c[0][0],3,3);

  return 0;

}

int transpose(int a[3][4], int b[4][3])
{
  int i = 0;
  int j = 0;
  for (i=0;i<3;i++)
    {
    for(j = 0; j<4; j++)
      b[j][i] = a[i][j];
    printf("\n");
    }
  
  return 0;

}

int multiply(int a[3][4], int b[4][3], int c[3][3])
{
  int i = 0;
  int j = 0;
  int k = 0;
 
  for (i=0;i<3;i++)
    {
      for(j = 0; j<3; j++)
	{
	  for (k=0; k<4; k++)
	    c[i][j] += (a[i][k] * b[k][j]);
	  printf("%d", c[i][j]);
	}
    }
  
  return 0;
}

void printMatrix(int* a, int Nrow, int Ncol)
{
  int i = 0;
  int j = 0;
  printf(" \n ");
  for (i=0;i<Nrow;i++)
    {
    for(j = 0; j<Ncol; j++)
      printf(" %3d ", *( a + Ncol*i + j));
    printf("\n");
    }
  
  return ;
}
