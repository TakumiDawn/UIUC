#include "potd.h"
#include <iostream>

using namespace std;

void insertSorted(Node **head, Node *insert)
{
  if (*head == NULL)
  {
    *head = insert;
    insert->next_ = NULL;
  }
  else
  {
    Node * prev = NULL;
    Node * current = *head;
    while (current != NULL)
    {
      if (insert->data_ < current->data_)
      {
        if (prev != NULL)
          {prev->next_ = insert;
          }
        else
          *head = insert;
        insert->next_ = current;
        break;
      }
      prev = current;
      current = current->next_;
    }
    if (current == NULL && prev != NULL)
    {
      prev->next_ = insert;
      insert->next_ = NULL;
    }
  }
}
