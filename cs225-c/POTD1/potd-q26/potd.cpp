#include "potd.h"

string getFortune(const string &s)
{
  int argc = s.size();
  if (argc == 2)
  {
    return "s";
  }
  if (argc == 3)
  {
    return "ss";
  }
  if (argc == 4)
  {
    return "sgg";
  }
  if (argc == 5)
  {
    return "ssssd";
  }
  if (argc > 6)
  {
    return "good";
  }
  return "nothing";

}
