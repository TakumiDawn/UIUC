#include "Stack.h"


// Stack::Stack()
// {
//   stackSize = 0;
// }

int Stack::stackSize = 0;
// `int size()` - returns the number of elements in the stack (0 if empty)
int Stack::size() const
{
  return stackSize;
}

// `bool isEmpty()` - returns if the list has no elements, else false
bool Stack::isEmpty() const
{
  if (stackSize == 0)
  {
    return true;
  }
  else
    return false;
}

// `void push(int val)` - pushes an item to the stack in O(1) time
void Stack::push(int value)
{
  arr[stackSize] = value;
  stackSize++;
}

// `int pop()` - removes an item off the stack and returns the value in O(1) time
int Stack::pop() {
  int n = arr[stackSize-1];
  stackSize--;
  return n;
}
