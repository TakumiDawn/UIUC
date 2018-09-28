#include "list.h"
#include <stdlib.h>

node *add_node(node* head, int new_data){
    head->next = (node *)malloc(sizeof(node));
    head->next->data = new_data;
    head->next->next = NULL;
    return head->next;
}

void remove_node(node *head)
{
  node* current = head;
  node* temp;

  while (current!=NULL && current->next!= NULL)
  {
    if (current->data==current->next->data)
    {
      temp = current->next->next;
      free(current->next);
      current->next = temp;
    }
    else
      current = current->next;
  }

}
