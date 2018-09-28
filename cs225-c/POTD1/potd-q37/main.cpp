#include <iostream>
#include "functions.h"
using namespace std;

int main() {
  cout << samesies(4, 4) << endl;

  cout << "Func 0 TFFT"<< endl;
  cout<< validUsername("feiyang3")<< endl;
  cout<< validUsername("feiyang")<< endl;
  cout<< validUsername("3fe3")<< endl;
  cout<< validUsername("554fei3")<< endl;

  // cout << "Func 2 "<< endl;
  // cout<< countPrimes(1)<< endl;
  // cout<< countPrimes(50)<< endl;
  // cout<< countPrimes(100)<< endl;

  cout << "Func 6 "<< endl;
  cout<< magnaCalca(-100, 100)<< endl;
  cout<< magnaCalca(100, 100)<< endl;
  cout<< magnaCalca(-100, -100)<< endl;
  cout<< magnaCalca(100, 100)<< endl;
  cout<< magnaCalca(50, 100)<< endl;
  return 0;
}
