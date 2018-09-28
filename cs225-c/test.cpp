#include  <iostream>
using namespace std;


class Base
{
public:
   virtual ~Base() {cout<<"Dest Base";}
};
class Derived: public Base{
public:
  virtual ~Derived(){cout<<"Dest Derived";}
};


int main()
{
  Base* b = new Derived;
  delete b;
}
