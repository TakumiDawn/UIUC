//Therer are three functions in this file.
//The first on is countLiveeighbor, which takes the matrix, the size of the matrix and the current coordinate.
//The function will count how many live neighbors the current entry has.
//There are several situations: the current point in a corner point(3 neighbor), a edge point(5 neighbor) and a point in the middle(8 neighbor).
//The function divide these situations into different braches and count the live neighbor seperately.

//The updateBoard function update the game board. It takes the materxi and its size as its input.
//It uses another matrix copy as the intermidiate variable and calls the countLiveNeighbor function.
//Based on the rules, this function updates the matrix.

//The last function, aliveStable, compare the current state and the next state.
//If the current and the next state are the same, it will return 1. Otherwise, it returns 0.
//Same as the second function, it uses copy as a intermidiate variable.
//The next state will be calculated and stored in copy and then compared with the original matrix.




/*
 * countLiveNeighbor
 * Inputs:
 * board: 1-D array of the current game board. 1 represents a live cell.
 * 0 represents a dead cell
 * boardRowSize: the number of rows on the game board.
 * boardColSize: the number of cols on the game board.
 * row: the row of the cell that needs to count alive neighbors.
 * col: the col of the cell that needs to count alive neighbors.
 * Output:
 * return the number of alive neighbors. There are at most eight neighbors.
 * Pay attention for the edge and corner cells, they have less neighbors.
 */
int countLiveNeighbor(int* board, int boardRowSize, int boardColSize, int row, int col){

	int rowsize=boardRowSize-1;  //Define the largest row number.
	int colsize=boardColSize-1;  //Define the largest column number.
	int count=0; //initiate the count for live neighbors

	if((row>0)&&(row<rowsize)&&(col>0)&&(col<colsize))
	{
		count=board[row*boardColSize+col-1]+board[row*boardColSize+col+1]+board[(row-1)*boardColSize+col-1]+board[(row-1)*boardColSize+col]+board[(row-1)*boardColSize+col+1]+board[(row+1)*boardColSize+col-1]+board[(row+1)*boardColSize+col]+board[(row+1)*boardColSize+col+1];
	}  //If the current entry is in the middle of the board.
	else if((col>0)&&(col<colsize)&&(row==0))
	{
		count=board[row*boardColSize+col-1]+board[row*boardColSize+col+1]+board[(row+1)*boardColSize+col-1]+board[(row+1)*boardColSize+col]+board[(row+1)*boardColSize+col+1];
	}  //If the current entry is in the top (exclude corners).
	else if((col>0)&&(col<colsize)&&(row==rowsize))
	{
		count=board[row*boardColSize+col-1]+board[row*boardColSize+col+1]+board[(row-1)*boardColSize+col-1]+board[(row-1)*boardColSize+col]+board[(row-1)*boardColSize+col+1];
	}  //If the current entry is in the bottom (exclude corners).
	else if((col==0)&&(row>0)&&(row<rowsize))
	{
		count=board[row*boardColSize+col+1]+board[(row-1)*boardColSize+col]+board[(row-1)*boardColSize+col+1]+board[(row+1)*boardColSize+col]+board[(row+1)*boardColSize+col+1];
	}  //If the current entry is in the left (exclude corners).
	else if((col==0)&&(row==0))
	{
		count=board[row*boardColSize+col+1]+board[(row+1)*boardColSize+col]+board[(row+1)*boardColSize+col+1];
	}  //The top left corner.
	else if((row==0)&&(col==colsize))
	{
		count=board[row*boardColSize+col-1]+board[(row+1)*boardColSize+col]+board[(row+1)*boardColSize+col-1];
	}  //The top right corner.
	else if((col==0)&&(row==rowsize))
	{
		count=board[row*boardColSize+col+1]+board[(row-1)*boardColSize+col]+board[(row-1)*boardColSize+col+1];
	}  //The bottom left corner.
	else if((col==colsize)&&(row==rowsize))
	{
		count=board[row*boardColSize+col+1]+board[(row-1)*boardColSize+col]+board[(row-1)*boardColSize+col+1];
	}  //The bottom right corner.

  return count;
}


/*
 * Update the game board to the next step.
 * Input:
 * board: 1-D array of the current game board. 1 represents a live cell.
 * 0 represents a dead cell
 * boardRowSize: the number of rows on the game board.
 * boardColSize: the number of cols on the game board.
 * Output: board is updated with new values for next step.
 */
void updateBoard(int* board, int boardRowSize, int boardColSize)
{
  int copy[boardRowSize*boardColSize];
	int i, j;
	for (i = 0; i < boardRowSize; i++)
	{
		for (j = 0; j < boardColSize; j++)
		{
			int N; /*set N as the number of live neighbors*/
			N = countLiveNeighbor(board, boardRowSize, boardColSize, i, j);
			if (board[i*boardColSize+j] == 0)
			{
				if (N==3) /*a dead cell with exactly three live neighbours becomes a live cell.*/
				{
					copy[i*boardColSize+j] = 1;
				}
				else
				copy[i*boardColSize+j] = 0;
			}
			else if(board[i*boardColSize+j] == 1)
			{
				if ((N==2)||(N==3)) /*if a live cell doesn't have 2 or 3 live neighbors, it dies.*/
				{
					copy[i*boardColSize+j] = 1;
				}
				else
				copy[i*boardColSize+j] = 0;
			}
		}
	}
/*done updatting the copy, move th copy to board*/
  int p;
  for (p = 0; p < boardRowSize*boardColSize; p++)
  {
	  board[p] = copy[p]; /*copy the copy of board back to board*/
  }
}



/*
 * aliveStable
 * Checks if the alive cells stay the same for next step
 * board: 1-D array of the current game board. 1 represents a live cell.
 * 0 represents a dead cell
 * boardRowSize: the number of rows on the game board.
 * boardColSize: the number of cols on the game board.
 * Output: return 1 if the alive cells for next step is exactly the same with
 * current step or there is no alive cells at all.
 * return 0 if the alive cells change for the next step.
 */
int aliveStable(int* board, int boardRowSize, int boardColSize)
{
  int flag=0;  //Flag keeps track of whether there is any change in the next step.
	int check=0;  //The return value of this function.
  int copy[boardRowSize*boardColSize];

//below checks if the board will change
	int i, j;
	for (i = 0; i < boardRowSize; i++)
	{
		for (j = 0; j < boardColSize; j++)
		{
			int N;
			N = countLiveNeighbor(board, boardRowSize, boardColSize, i, j);
			if (board[i*boardColSize+j] == 0)
			{
				if (N==3)
				{
					copy[i*boardColSize+j] = 1; /*a dead cell with exactly three live neighbours becomes a live cell.*/
				}
				else
				copy[i*boardColSize+j] = 0;
			}
			else if(board[i*boardColSize+j] == 1)
			{
				if ((N==2)||(N==3)) /*if a live cell doesn't have 2 or 3 live neighbors, it dies.*/
				{
					copy[i*boardColSize+j] = 1;
				}
				else
				copy[i*boardColSize+j] = 0;
			}
		}
	} //done generating the board of next step at copy[]

	for(i=0;i<boardRowSize;i++){
		for(j=0;j<boardColSize;j++){
			if(copy[i*boardColSize+j]!=board[i*boardColSize+j])
			{
				flag++;  //Compare each entry in the matrix of board and checkboard. If they are different increment flag.
			}
		}
	}
	if(flag==0){
		check=1;  //If flag=0, checkboard and board are the same. If flag>0, they are different at least by one entry.
	}
	return check;
}
