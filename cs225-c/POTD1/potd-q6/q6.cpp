#include "student.h"
using namespace potd;

void graduate(student &s)
{
  int temp = s.get_grade();
  s.set_grade(temp+1);
}
