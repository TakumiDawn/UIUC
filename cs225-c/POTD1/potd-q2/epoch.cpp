#include "epoch.h"

int hours(time_t t)
{
  return t/(time_t)3600;
}

int days(time_t t)
{
  return t/(time_t)86400;
}

int years(time_t t)
{
  return t/(time_t)31536000;
}
