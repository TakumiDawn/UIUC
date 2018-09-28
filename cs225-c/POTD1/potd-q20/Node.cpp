#include "Node.h"

using namespace std;

Node *listUnion(Node *first, Node *second)
{

  if (first == NULL && second == NULL)
  {
    return NULL;
  }
  Node * Union = new Node();
  Node * temp = NULL;
  if (first == NULL)
  {
    Union = second;
    return Union;
  }
  if (second == NULL)
  {
    Union = first;
    return Union;
  }
  if (first->getNumNodes() == 1 && second->getNumNodes() == 1)
  {
     Union->data_ = first->data_;
     Union->next_ = second;
     return Union;
  }


  Node * curr2 = Union;

  int flag = 0;
  //first list
  Node * curr = first;
  while (curr != NULL)
  {
    flag = 0;
    curr2 = Union;
    while (curr2 != NULL)
    {
      if (curr->data_ == curr2->data_)
      {
        flag++;
      }
      curr2 = curr2->next_;
    }
    if (flag == 0)
    {
      if (Union->getNumNodes() == 0)
      {
        temp = new Node();
        temp->data_ = curr->data_;
        temp->next_ = NULL;
        Union = temp;
      }
      else
      {
        temp = Union;
        while (temp != NULL)
        {
          if (temp->next_ == NULL)
          {
            temp->next_ = new Node();
            temp->next_->data_ = curr->data_;
            temp->next_->next_ = NULL;
            break;
          }
          temp = temp->next_;
        }
      }
    }
    curr = curr->next_;
  }
  //second list
  curr = second;
  while (curr != NULL)
  {
    flag = 0;
    curr2 = Union;
    while (curr2!= NULL)
    {
      if (curr->data_ == curr2->data_)
      {
        flag++;
      }
      curr2 = curr2->next_;
    }
    if (flag == 0)
    {
      if (Union->getNumNodes() == 0)
      {
        temp = new Node();
        temp->data_ = curr->data_;
        temp->next_ = NULL;
        Union = temp;
      }
      else
      {
        temp = Union;
        while (temp != NULL)
        {
          if (temp->next_ == NULL)
          {
            temp->next_ = new Node();
            temp->next_->data_ = curr->data_;
            temp->next_->next_ = NULL;
            break;
          }
          temp = temp->next_;
        }
      }
    }
    curr = curr->next_;
  }


  return Union;
}

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
