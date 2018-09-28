/* malloc example: random string generator*/
#include <stdio.h>      /* printf, scanf, NULL */
#include <stdlib.h>     /* malloc, free, rand */

void removeDuplicates(node* head)
{
  node* current = head;
  node* temp;
  while (current!=NULL && current->next!=NULL)
  {
    if (current->data == current->next->data)
    {
      temp = current->next->next;
      free(current->next);
      current->next = temp;
    }
    else
      current = current->next;
  }
}
void reverse(node** head)
{
  node* prev = NULL;
  node* current = *head;
  node* next;

  while (current!=NULL)
  {
    next=current->next;
    current->next=prev;
    prev = current;
    current = next;
  }
  *head = prev;
}
