#include <string>
#ifndef _Food_H
#define _Food_H

using namespace std;
class Food
{
  public:
    string get_name();
    void set_name(string n);
    int get_quantity();
    void set_quantity(int q);
    Food();
  private:
    string name_;
    int quantity_;
};

#endif
