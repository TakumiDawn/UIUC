#include <stdio.h>
#include <stdlib.h>


typedef struct nodeStruct node;
struct nodeStruct
{
	int data;
	node *next;
};


node *front, *end;


void enqueue(int new_data) //insert new node at the end of the queue{
	node *new_node = (node *)malloc(sizeof(node));
	new_node->data = new_data;
	new_node->next = NULL;

	if(front == NULL) //this is the first node{
		front = new_node; 
		end = new_node;
	}
	else{
		end->next = new_node; //set current end node's next pointer to new_node
		end = new_node;	//update end pointer
	}
}


void dequeue() //delete head node of the queue{
	if(front == NULL) //queue is empty
		return;
	node *temp = front->next;
	if(front == end) //queue only has 1 item
	{	end = NULL;}
	free(front);
	front = temp;
}

void print_queue(){
	node *current = front;
	int i = 0;
	while(current!= NULL){
		printf("Node %d: %d\n", i, current->data);
		i++;
		current = current->next;
	}
}

int main(){
	front = end = NULL;

	enqueue(1);
	enqueue(3);
	enqueue(5);
	print_queue();
	dequeue();
	print_queue();

	return 0;
}

