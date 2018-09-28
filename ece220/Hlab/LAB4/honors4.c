#include "honors4.h"
// reads in the two preference files and populates the preference matrices.
// INPUT:
// menPrefs: men preference file name
// womenPrefs: women preference file name
// size: The number of men or women
// men: empty men preference array
// women: empty women preference array
// SIDE EFFECTS:
// men: populated men preference array where men[i][j] is the jth preference of the ith man
// women: populated women preference array where women[i][j] is the jth preference of the jth woman

void readPrefFiles(char *menPrefs, char *womenPrefs, int size, int **men, int **women)
{
  FILE *fp1 = fopen(menPrefs, "r");
  FILE *fp2 = fopen(womenPrefs, "r");
  int i, j;
  for (i = 0; i < size; i++)
  {
    fscanf(fp1, "\n");
    fscanf(fp2, "\n");
    for (j = 0; j < size; j++)
    {
      //men[i][j] = *(menPrefs+(size*i+j));
      //women[i][j] = *(womenPrefs+(size*i+j));
      fscanf(fp1,"%d",&men[i][j]);
      fscanf(fp2,"%d",&women[i][j]);
    }
  }

}


//This function solves the stable marriage problem for with males as suitors
//INPUTS:
//men- populated preference array for men
//women- populated preference array for women
//solution- the 1-dimensional solution array where solution[i] is the wife of man i
void maleOptimalSolution(int **men, int **women, int *solution, int size)
{
  int mFree[size];//two arrays indicating the marriage status of men and women

  int wPartner[size]; //array stores the partners of women
  int x;
  for (x = 0; x < size; x++)
  {
    mFree[x] = 0;
    wPartner[x] = -1; // the value of -1 indicates free
    solution[x] = -1;
  }


  int freemCount = size; //initiate the countor for the number of free men
  while (freemCount > 0) // While there are free men
  {
    int m; //start from the first free men
    for (m = 0; m < size; m++)
    {
      if (mFree[m]==0)
        break;
    }

    int i;
    for (i = 0; i < size && mFree[m] == 0; i++) //go thru all women by the "m"th man's preferences
    {
      int w = men[m][i]; /*first woman on m’s list to whom m has not yet proposed*/
      if (wPartner[w]==-1)
      {
        wPartner[w] = m;
        solution [m] = w;
        mFree[m] = 1;
        freemCount--;
      }
      else
      {
        int m1 = wPartner[w]; //m1 is the current engagement of women "w"
        int j, flag=0; // the following checks if m is a better choice than m1, flag == 1 means m is better, 0 means m1 is better
        for (j=0; j<size; j++)
        {
          if (women[w][j]==m1)
          {
            flag = 0;
            break;
          }
          if (women[w][j]==m)
          {
            flag = 1;
            break;
          }
        }
        if (flag == 1)  //if w prefers m over m1, break and engage with m
        {
           wPartner[w] = m;
           solution [m] = w;
           mFree[m] = 1;
           mFree[m1] = 0;
        }
      }
    }
  }

}
