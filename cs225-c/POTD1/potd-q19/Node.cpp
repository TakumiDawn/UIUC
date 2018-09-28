#include "Node.h"

using namespace std;

void mergeList(Node *first, Node *second)
{
  Node * curr1 = first;
  Node * curr2 = second;
  if (curr1 == NULL)
  {
    first = second;
    return;
  }
  if (curr2 == NULL)
  {
    return;
  }
  if (curr1->next_ == NULL)
  {
    first->next_ = second;
    return;
  }
  if (curr2->next_ == NULL)
  {
    first->next_ = second;
    second->next_ = curr1->next_;
    return;
  }

  Node * next1 = NULL;
  Node * next2 = NULL;
  do
  {
    next1 = curr1->next_;
    curr1->next_ = curr2;
    next2 = curr2->next_;
    curr2->next_ = next1;
    curr1 = next1;
    curr2 = next2;
  } while(curr1->next_ != NULL && curr2->next_!=NULL);

  if (curr1->next_==NULL && curr2->next_!=NULL)
  {
    curr1->next_ = curr2;
  }

  if (curr2->next_==NULL && curr1->next_!=NULL)
  {
    next1 = curr1->next_;
    curr1->next_ = curr2;
    curr2->next_ = next1;
  }


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
