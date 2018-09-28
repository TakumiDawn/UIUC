/**
 * @file
 * Contains the implementation of the extractMessage function.
 */

#include <iostream> // might be useful for debugging
#include <assert.h>
#include "extractMessage.h"

using namespace std;

char *extractMessage(const char *message_in, int length) {
   // length must be a multiple of 8
   assert((length % 8) == 0);

   // allocate an array for the output
   char *message_out = new char[length];

  for (int P = 0; P < length/8; P++) //loop for blocks
  {
      for (int x = 0; x < 8; x++)//loop for every output char
      {
        for (int i = 0; i < 8; i++)//loop for reading from Input
        {
          char temp = 0; //temp stores the bit we got from input
          temp = (message_in[8*P+i] & (1<<x))>>x;
          message_out[8*P+x] = message_out[8*P+x] + (temp << i);
        }
      }
  }


	return message_out;
}
