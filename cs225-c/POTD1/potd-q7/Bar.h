#include "Foo.h"
#ifndef BAR_H
#define BAR_H

namespace potd
{
  class Bar
  {
    private:
      Foo * f_;
    public:
      //Bar();
      Bar(string name);
      Bar(const Bar &);
      ~Bar();
      Bar & operator=(const Bar &);
      string get_name();
  };
}

#endif
