#include <stdio.h>

void printMatrix(int * Arr, int Nrows, int Ncols);
void transpose(int A[3][4], int B[4][3], int Nrows, int Ncols);


int main()
{
  int A[3][4] = {{1,2,3,4},{5,6,7,8},{9,10,11,12}};
  int B[4][3] = {0,0,0,0,0,0,0,0,0,0,0,0};
  printf("\n A= \n");
  printMatrix(&A[0][0], 3, 4);
  printf("\n B= \n");
  printMatrix(&B[0][0], 4, 3);
  transpose(A,B,3,4);
  printf("\n B= \n");
  printMatrix(&B[0][0], 4, 3);


  return 0;

}


void printMatrix(int* Arr, int Nrows, int Ncols)
{
  int i=0;
  int j = 0;
  for (i=0;i<Nrows;i++)
    {
    for(j=0;j<Ncols;j++)
      printf(" %4d ", *(Arr + (i * Ncols + j)));
    printf("\n");
    }
  return;
}

void transpose(int A[3][4], int B[4][3], int Nrows, int Ncols)
{
  int i=0;
  int j = 0;
  for (i=0;i<Nrows;i++)
    {
    for(j=0;j<Ncols;j++)
      B[j][i] = A[i][j];
    }
  return;
}

