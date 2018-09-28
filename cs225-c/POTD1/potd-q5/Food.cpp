#include "Food.h"

string Food::get_name()
{
   return name_;
}
void Food::set_name(string n)
{
  name_ = n;
}
int Food::get_quantity()
{
  return quantity_;
}
void Food::set_quantity(int q)
{
  quantity_ = q;
}

Food::Food()
{
  name_ = "nothing";
  quantity_ = 0;
}
