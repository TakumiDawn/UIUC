/**
 * @file
 * Contains the implementation of the countOnes function.
 */

unsigned countOnes(unsigned input)
{
  unsigned right = input & 0x55555555;
  unsigned left = (input & 0xAAAAAAAA)>>1;

  unsigned sixteen = left + right;
	right = sixteen & 0x33333333;
  left = (sixteen & 0xCCCCCCCC)>>2;

	unsigned eight = left + right;
	right = eight & 0x0F0F0F0F;
  left  = (eight & 0xF0F0F0F0)>>4;


	unsigned four = left + right;
	right = four & 0x00FF00FF;
  left  = (four & 0xFF00FF00)>>8;

	unsigned two = left + right;
	right = two & 0x0000FFFF;
  left  = (two & 0xFFFF0000)>>16;

	return right + left;
}
