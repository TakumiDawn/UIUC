#include <vector>
#include <string>
#include "Hash.h"

using namespace std;

int hashFunction(string s, int M) {
   // Your Code Here
   //hash function to sum up the ASCII characters of the letters of the string
   int sum = 0;
   for(unsigned long i = 0; i < s.length(); ++i)
   {
     sum += (int) s.at(i);
   }
   return sum % M;
 }

int countCollisions (int M, vector<string> inputs) {
	int collisions = 0;
	// Your Code Here
  vector<int> table;
  for (int m = 0; m < M; m++)
  {
    table.push_back(-1);
  }
  for (unsigned long i = 0; i < inputs.size(); i++)
  {
    table[hashFunction(inputs.at(i),M)]++;
  }
  for (int j = 0; j < M; j++)
  {
    if (table.at(j)>0)
    {
      collisions += table.at(j);
    }
  }
	return collisions;
}
