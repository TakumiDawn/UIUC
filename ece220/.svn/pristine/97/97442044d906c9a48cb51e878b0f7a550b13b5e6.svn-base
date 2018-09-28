//Intro paragraph:
//This file is compiled with main.c, solving the Sudoku puzzle using recursive backtracking.
//A standard Sudoku puzzle contains 81 cells, in a 9 by 9 grid, and has 9 zones.
//Each zone is the intersection of 3 rows and 3 columns (e.g. size 3x3).
//Each cell may contain a number from 1 to 9 and each number can only occur once in each 3x3 zone,
// row, and column of the grid. At the beginning of the game, several cells begin with numbers,
// and the goal is to fill in the remaining cells with numbers satisfying the puzzle rule.

//"is_val_in_row", "is_val_in_col", and "is_val_in_3x3_zone" are three functions used in "is_val_valid",
//in order to test if a number is valid to fill into a specific cell.
//"solve_sudoku" implements the recursive backtracking algorithm to find the solution to the Sudoku puzzle.

#include "sudoku.h"

// Function: is_val_in_row
// Return true if "val" already existed in ith row of array sudoku.
int is_val_in_row(const int val, const int i, const int sudoku[9][9])
{
  assert(i>=0 && i<9);

  int check = 0; //check is the value to be returned, if the "val" already existed, check = 1
  int x;
  for (x = 0; x < 9; x++)
  {
    if (sudoku[i][x]==val) //if the given number val has already been filled in the row i, return 1
    {
      check = 1;
      break;
    }
  }
  return check;
}

// Function: is_val_in_col
// Return true if "val" already existed in jth column of array sudoku.
int is_val_in_col(const int val, const int j, const int sudoku[9][9])
{
  assert(j>=0 && j<9);

  int check =0; //check is the value to be returned, if the "val" already existed, check = 1
  int x;
  for (x = 0; x < 9; x++)
  {
    if (sudoku[x][j]==val) //if the given number val has already been filled in the col j, return 1
    {
      check = 1;
      break;
    }
  }
  return check;
}

// Function: is_val_in_3x3_zone
// Return true if val already existed in the 3x3 zone corresponding to (i, j)
int is_val_in_3x3_zone(const int val, const int i, const int j, const int sudoku[9][9])
{

  assert(i>=0 && i<9);

  int a,b;
  a = i/3; //a is the row number of 3*3 zones
  b = j/3; //b is the clo number of 3*3 zones

  int check=0; //check is the value to be returned, if the "val" already existed, check = 1
  int x,y, flag=0; //flag helps to break twice from the for loops, if check = 1
  for (x = 0; x < 3; x++)
  {
    for (y = 0; y < 3; y++)
    {
      if (sudoku[3*a+x][3*b+y]==val)
      {
        check = 1; //if find the existed value, return 1 and break twice from the for loops
        flag = 1;
        break;
      }
    }
    if (flag==1)
    {
      break;
    }
  }
  return check;

}

// Function: is_val_valid
// Return true if the val is can be filled in the given entry.
int is_val_valid(const int val, const int i, const int j, const int sudoku[9][9])
{
  assert(i>=0 && i<9 && j>=0 && j<9);

  int a, b, c; //a,b,c helps to check the availability at sudoku[i][j]
  a = is_val_in_row(val,i,sudoku);
  b = is_val_in_col(val,j,sudoku);
  c = is_val_in_3x3_zone(val,i,j,sudoku);

  if (a==1 || b==1 || c==1)
  {
    return 0;
  }
  else
  {
    return 1; // if all tests passed, then return 1 to indicate the number is valid to fill in the cell
  }

}

// Procedure: solve_sudoku
// Solve the given sudoku instance.
int solve_sudoku(int sudoku[9][9])
{
  int i, j; //the currebt i,j are used to find the empty cell
  int s = 0, flag = 0;
  for (i = 0; i < 9; i++)
  {
    for (j = 0; j < 9; j++)
    {
      if (sudoku[i][j]==0)
      {
        s++;
        flag = 1; //flag helps to break twice from for loops
        break;
      }
    }
    if (flag==1)
    {
      break;
    }
  }
  if (s==0)
  {
    return 1; // if all cells are assigned by numbers, return 1
  }

  for (int num = 1; num <= 9; num++)
  {
    if (is_val_valid(num,i,j,sudoku)) // if cell (i, j) can be filled with num
    {
      sudoku[i][j] = num;
      if (solve_sudoku(sudoku))
      {
        return 1;
      }
      sudoku[i][j] = 0; //sudoku[i][j] <- non-filled
    }
  }
  return 0;
}


// Procedure: print_sudoku
void print_sudoku(int sudoku[9][9])
{
  int i, j;
  for(i=0; i<9; i++) {
    for(j=0; j<9; j++) {
      printf("%2d", sudoku[i][j]);
    }
    printf("\n");
  }
}

// Procedure: parse_sudoku
void parse_sudoku(const char fpath[], int sudoku[9][9]) {
  FILE *reader = fopen(fpath, "r");
  assert(reader != NULL);
  int i, j;
  for(i=0; i<9; i++) {
    for(j=0; j<9; j++) {
      fscanf(reader, "%d", &sudoku[i][j]);
    }
  }
  fclose(reader);
}
