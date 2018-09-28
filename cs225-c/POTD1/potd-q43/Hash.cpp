#include <vector>
#include "Hash.h"

void doubleHashInput(std::vector<int> &v, int elem)
{
	//your code here
  //v[elem] = -1;
  int idx = firstHash(elem, v.size());
  if (v[idx] == -1)
  {
    v[idx] = elem;
    return;
  }
  //int step = secondHash(elem)%v.size();
  while(v[idx] != -1)
  {
    int step = secondHash(elem);
    idx = (idx+step) % v.size();
  }
  //if (v[idx] == -1) {
    v[idx] = elem;
  //}
}

//make a hash function called firstHash
//make a second function called secondHash
int firstHash(int elem, int length)
{
  return elem*4 % length;
}

int secondHash(int elem)
{
  return 3 - elem % 3;
}
