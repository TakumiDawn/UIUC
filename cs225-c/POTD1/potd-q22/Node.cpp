#include "Node.h"
#include <iostream>

using namespace std;

Node *listSymmetricDifference(Node *first, Node *second)
{
  if (first == NULL && second == NULL)
  {
    return NULL;
  }

  Node * diff = NULL;
  Node * temp = NULL;
  Node * curr = first;
  static Node * here = diff;
  while (curr != NULL)
  {
    int flag = 0;
    temp = second;
    while (temp != NULL)
    {
      if (temp->data_ == curr->data_)
      {
        flag++;
      }
      temp = temp->next_;
    }
    if (flag == 0)
    {
      int flag2 = 0;
      temp = diff;
      while (temp != NULL)
      {
        if (temp->data_ == curr->data_)
        {
          flag2++;
        }
        temp = temp->next_;
      }
      if (flag2 ==0)
      {

        if (diff==NULL)
        {
          diff = new Node();
          diff->data_ = curr->data_;
          diff->next_ = NULL;
          here = diff;
        }
        else
        {
          here->next_ = new Node();
          here = here->next_;
          here->data_ = curr->data_;
          here->next_ = NULL;
        }
      }
    }
    curr = curr->next_;
  }


  curr = second;
  while (curr != NULL)
  {
    int flag = 0;
    temp = first;
    while (temp != NULL)
    {
      if (temp->data_ == curr->data_)
      {
        flag++;
      }
      temp = temp->next_;
    }
    if (flag == 0)
    {
      int flag2 = 0;
      temp = diff;
      while (temp != NULL)
      {
        if (temp->data_ == curr->data_)
        {
          flag2++;
        }
        temp = temp->next_;
      }
      if (flag2 ==0)
      {
        if (diff==NULL)
        {
          diff = new Node();
          diff->data_ = curr->data_;
          diff->next_ = NULL;
          here = diff;
        }
        else
        {
          here->next_ = new Node();
          here = here->next_;
          here->data_ = curr->data_;
          here->next_ = NULL;
        }
      }
    }
    curr = curr->next_;
  }

  return diff;
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
