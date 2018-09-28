#include "thing.h"

using namespace potd;

Thing::Thing(int n)
{
  props_ct_ = 0;
  props_max_ = n;
  properties_ = new std::string[props_max_];
  values_ = new std::string[props_max_];
}

Thing::Thing(const Thing & that){
  _copy(that);
}
Thing & Thing::operator=(const Thing &that){
  if (this != &that) {
      _destroy();
      _copy(that);
  }
  return *this;
}
Thing::~Thing(){
  _destroy();
}

int Thing::set_property(std::string name,std::string value)
{
  for (int i = 0; i < props_ct_; i++)
  {
    if (properties_[i] == name)
    {
      values_[i] = value;
      return i;
    }
  }

  if (props_ct_ < props_max_)
  {
    properties_[props_ct_] = name;
    values_[props_ct_] = value;
    props_ct_++;
    return props_ct_-1;
  }
  else
    return -1;
}

std::string Thing::get_property(std::string name){
  for (int i = 0; i < props_ct_; i++)
  {
     if (properties_[i]== name)
       return values_[i];
  }
    return "";
}

void Thing::_copy(const Thing &that){
  props_ct_ = that.props_ct_;
  props_max_ = that.props_max_;
  properties_ = new std::string[props_max_];
  values_ = new std::string[props_max_];
  for (int i = 0; i < props_ct_; i++)
  {
    properties_[i] = that.properties_[i];
    values_[i] = that.values_[i];
    //*(properties_+i) = *(that.properties_+i);
    //*(values_+i) = *(that.values_+i);
  }

}

void Thing::_destroy(){
  if (values_ != NULL)
    delete[] values_;
    values_ = NULL;
  if (properties_ != NULL)
    delete[] properties_;
    properties_ = NULL;
}
