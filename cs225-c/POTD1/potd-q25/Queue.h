#ifndef _QUEUE_H
#define _QUEUE_H

#include <cstddef>
#include <list>
using namespace std;

class Queue {
    public:
        int size() const;
        bool isEmpty() const;
        void enqueue(int value);
        int dequeue();

        Queue();
        ~Queue();
    private:
        list<int> q;

};

#endif
