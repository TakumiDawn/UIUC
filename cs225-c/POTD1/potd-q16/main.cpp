#include "potd.h"
#include <iostream>
using namespace std;

int main() {
  // Test 1: An empty list
  Node * head = NULL;
  cout << stringList(head) << endl;

  // Test 2: A list with exactly one node
  Node two;
  two.data_ = 2;
  two.next_ = NULL;
  head = &two;
  cout << stringList(head) << endl;
//  stringList();


  // Test 3: A list with more than one node
  Node three;
  three.data_ = 3;
  three.next_ = NULL;
  two.next_ = &three;
  cout << stringList(head) << endl;

  return 0;
}
