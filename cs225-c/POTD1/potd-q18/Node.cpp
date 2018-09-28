#include "Node.h"

using namespace std;

void sortList(Node **head)
{
  int flag = 0;
  Node * curr = *head;
  Node * prev = NULL;
  Node * next = NULL;
  //check empty list
  if (curr == NULL)
  {
    return;
  }
  //check one element list
  if (curr->next_ == NULL)
  {
    return;
  }

  //find the smallest value to be the head, and set to head
  int size = Node::getNumNodes();
  Node * min = curr;
  for (int i = 0; i < size && curr->next_!= NULL; i++)
  {
    if (min->data_ > curr->next_->data_ )
    {
      prev = curr;
      min = curr->next_;
    }
    curr = curr->next_;
  }

  if (*head != min)
  {
    Node * temp = *head;
    *head = min;
    prev->next_ = min->next_;
    min->next_ = temp;
  }

  do
  {
    flag = 0;
    curr = *head;
    prev = curr;
    next = NULL;

    while (curr->next_ != NULL)
    {
      next = curr->next_;
      if (next == NULL)
      {
        break;
      }
      if (next->data_ < curr->data_)
      {
        prev->next_ = next;
        curr->next_ = next->next_;
        next->next_ = curr;
        flag = 1;
      }
      prev = curr;
      curr = next;
    }
  } while(flag);

}

// int i=0 ,prei=-1;
// while (i != prei)
// {
//   prei = i;
//   Node * next = NULL;
//   Node * curr = *head;
//   Node * prev = NULL;
//
//   while (curr != NULL)
//   {
//     next = curr->next_;
//     if (next == NULL)
//     {
//       break;
//     }
//     if (next->data_ < curr->data_)
//     {
//       prev->next_ = next;
//       curr->next_ = next->next_;
//       next->next_ = curr;
//       i++;
//     }
//     prev = curr;
//     curr = next;
//   }
// }




Node::Node() {
    numNodes++;
}

Node::Node(Node &other) {
    this->data_ = other.data_;
    this->next_ = other.next_;
    numNodes++;
}

Node::~Node() {
    numNodes--;
}

int Node::numNodes = 0;
