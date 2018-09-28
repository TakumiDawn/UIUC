#include "Base.h"
#ifndef DERIVED_H
#define DERIVED_H

class Derived: public Base
{
public:
  string foo();
  virtual string bar();
  virtual ~Derived();
};



#endif
