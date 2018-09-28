#include  <iostream>
using namespace std;


class Test
{
public:
   int fun() const {cout << score << '\n';  return 1; }
private:
  double score = 9.0;
};
class Midterm: public Test{
public:
  int game();
};


int main()
{
  Test* b = new Test;
  //delete b;
  b->fun();

}
