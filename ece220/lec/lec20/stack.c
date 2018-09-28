#include <stdio.h>
#include <stdlib.h>


typedef struct nodeStruct node;
struct nodeStruct
{       
        int data;
        node *next;
};

node *top;

void push(int new_data)
{
	//allocate a new node to hold data
	node *new_node = (node *)malloc(sizeof(node));
	new_node->data = new_data;
	//set new node's next pointer to point to current stack top
	new_node->next = top;
	//update stack top pointer
	top = new_node;
}

void pop()
{
	//if stack is empty, exit function
	if(top == NULL) 
		return;
	//use a temp pointer to point to the second node from the stack top
	node *temp = top->next;
	//delete top node
	free(top);
	//update stack top pointer
	top = temp;
}



void print_stack()
{
        node *current = top;
        int i = 0;
        while(current!= NULL)
        {
                printf("Node %d: %d\n", i, current->data);
                i++;
                current = current->next;
        }
}


int main()
{
	top = NULL;
	push(1);
	push(3);
	push(5);
        print_stack();
	pop();
	print_stack();

	return 0;
}
