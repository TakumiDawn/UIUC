#include "list.h"
#include <stdio.h>
#include <stdlib.h>

int main(){
    //Allocate head node of the linked list
    node *head = (node *)malloc(sizeof(node));
    head->data = 9;
    head->next = NULL;

    //Add new nodes to the linked list
    node *list = head;
    list = add_node(list,9);
    list = add_node(list,6);
    list = add_node(list,6);
    list = add_node(list,5);
    list = add_node(list,2);
    list = add_node(list,1);
    list = add_node(list,1);
    printf("Given linked list: \n");
    list = head;
    while(list != NULL){
         printf("%d \n", list->data);
         list = list->next;
    }
    remove_node(head);
    list = head;
    printf("After removal: \n");
    while(list != NULL){
        printf("%d \n", list->data);
        list = list->next;
    }
}


