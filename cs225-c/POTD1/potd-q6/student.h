#include <string>
#ifndef _STUDENT_H
#define _STUDENT_H
using namespace std;

namespace potd
{
class student
{
  public:
    string get_name();
    void set_name(string n);
    int get_grade();
    void set_grade(int g);
    student();
  private:
    string name_;
    int grade_;
};
}

#endif
