#include "sliding.h"
/*  Slide all values of array up*/
void slide_up(int* my_array, int rows, int cols)
{
    int i, j;
    int target_row;
    for (j = 0; j < cols; j++)
    {
      target_row =0;
      for (i = 1; i < rows; i++)
      {
        if (my_array[i*cols+j] != -1)
        {
          while (my_array[target_row*cols+j] != -1 && target_row < i)
          {
            target_row++;
          }
          if (target_row<i)
          {
            my_array[target_row*cols+j] = my_array[i*cols+j];
            my_array[i*cols+j] = -1;
          }
        }
      }
    }
    return;
}
