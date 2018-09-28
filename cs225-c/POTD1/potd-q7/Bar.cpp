#include "Bar.h"

using namespace potd;

Bar::Bar(string name)
{
  f_ = new Foo(name);
}

Bar::Bar(const Bar &that)
{
  f_ = new Foo(that.f_->get_name());
}

Bar::~Bar()
{
  delete f_;
}

Bar & Bar::operator=(const potd::Bar &that)
{
  delete f_;
  this->f_ = new Foo(that.f_->get_name());
  //f_ = that.f_;

  return *this;
}

string Bar::get_name()
{
  return f_->get_name();
}
