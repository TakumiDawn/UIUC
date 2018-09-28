#include<stdio.h>
#include<math.h>
#include<stdlib.h>

#define W 400
#define H 300

void writefile(int image[H][W], char * filename);
void createblank(int image[H][W]);
void    pattern(int image[H][W], int b);


int main(int argc, char **argv)
{
  int image[H][W];
  createblank(image);
  pattern(image,7);
  //// 
  writefile(image, "lecture.pgm");
 
   
}

void createblank(int image[H][W])
{
  int i, j;
  for(i=0;i<W;i++)
      for(j=0;j<H;j++)
	image[j][i] = 255;
  
  for (i = 0; i < H; i = i + 20)
    for(j = 0; j < W; j++)
      	image[i][j] = 180;

  for (i = 0; i < W; i = i + 20)
    for(j = 0; j < H; j++)
      	image[j][i] = 180;

  return;
}

void    pattern(int image[H][W], int b)
{
  float x, y;
  int i, j;
    for(i=0;i<W;i++)
      {
	x = 0.1*i;
	y = 2*x*sin(x);
	j = (int)y + 150;
	image[j][i] = 0;
      }

    return ;
}



void writefile(int image[H][W], char * filename)
{
    int i, j;    
    /* Print header */
    stdout = fopen(filename, "w");
    fprintf(stdout, "P2\n%d %d\n%d\n", W, H, 255);
    /* Print pixels */
    for(i = 0; i < H; ++i){
      for(j = 0; j < W; ++j){
	fprintf(stdout, " %d ", image[i][j]);
		}
		fprintf(stdout, "\n");
	}
    return;
}
