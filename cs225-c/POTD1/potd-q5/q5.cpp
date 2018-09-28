#include "q5.h"

void increase_quantity(Food *f)
{
  int temp = f->get_quantity();
  f->set_quantity(temp+1);
}
