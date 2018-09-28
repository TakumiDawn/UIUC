#include "potd.h"
#include <iostream>

using namespace std;

string stringList(Node *head)
{
  if (head == NULL)
  {
    return "Empty list";
  }
  string st = "";
  int count = 0;
  Node * temp = head;
  while (temp != NULL)
  {
      if (count == 0)
      {
        st = "Node " + to_string(count) + ": " + to_string(temp->data_);
      }
      else
        st = " -> Node " + to_string(count) + ": " + to_string(temp->data_);
      temp = temp->next_;
      count++;
  }

  return st;
}
