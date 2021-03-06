#ifndef _QUEUE_H
#define _QUEUE_H

#include <cstddef>

class Queue {
    public:
        int size() const;
        bool isEmpty() const;
        void enqueue(int value);
        int dequeue();
    private:
        int count;
      struct Node{
        int data;
        struct Node * next;
      };

      Node* head_;
      Node* tail_;
};

#endif
