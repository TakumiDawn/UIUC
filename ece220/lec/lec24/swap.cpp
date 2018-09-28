#include<iostream>
using namespace std;

void swap(int& x, int& y){
   int temp = x;
   x = y;
   y = temp;
}

int main(){
   int a = 1;
   int b = 3;
   swap(a,b);
   cout << "value of a = " << a << ", value of b = " << b << endl;
   return 0;
}
