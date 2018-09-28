#include "Hash.h"
#include <string>
#include <iostream>

unsigned long bernstein(std::string str, int M)
{
	unsigned long b_hash = 5381;
	for(std::string::iterator it = str.begin(); it != str.end(); it++)
	{
		//std::cout << "*it :"<< *it  % M<<"\n";
		b_hash *= 33;
		b_hash += *it;
	}

	return b_hash % M;
}

std::string reverse(std::string str)
{
    std::string output = "";
		for(std::string::iterator it = (str.end()-1); it != (str.begin()-1); it--)
		{
			output+= *it;
		}

	return output;
}
