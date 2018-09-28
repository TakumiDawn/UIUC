#include "potd.h"
#include <vector>
#include <iostream>
using namespace std;

int main() {
	// test your code here!
	auto x = topThree("in1.txt");

	for (auto it = x.begin(); it != x.end(); it++)
	{
		cout << *it << "\n";
	}
	return 0;
}
