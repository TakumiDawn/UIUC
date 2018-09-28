#ifndef BASE_H
#define BASE_H

#include <iostream>
#include <string>
using namespace std;

class Base
{
public:
  string foo();
  virtual string bar();
  virtual ~Base();
};



#endif
