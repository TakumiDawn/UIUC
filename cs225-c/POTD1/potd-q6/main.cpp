#include <iostream>
#include "student.h"
#include "q6.h"

using namespace std;
using namespace potd;

int main()
{
  student sb;
  sb.set_name("Haowei");
  sb.set_grade(3);

  cout<<sb.get_name()<<" is in grade "<<sb.get_grade()<<endl;
  graduate(sb);
  cout<<sb.get_name()<<" is in grade "<<sb.get_grade()<<endl;
  return 0;
}
