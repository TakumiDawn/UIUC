#include "student.h"
using namespace potd;

string student::get_name()
{
  return name_;
}

void student::set_name(string n)
{
  name_ = n;
}

int student::get_grade()
{
  return grade_;
}

void student::set_grade(int g)
{
  grade_ = g;
}

student::student()
{
  name_ = "someone";
  grade_ = 1;
}
