#include<iostream>
using namespace std;

int main(){
   int var = 5;
   int & ref_var = var;

   ref_var = 10;
   cout << "var = " << var << endl;

   var = 15;
   cout << "ref_var = " << ref_var << endl;

   return 0;
}
