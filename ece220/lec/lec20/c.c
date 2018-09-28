//find the record with matching UIN
//if record is not found, return out
//if record is the first node, update head pointer
//if record is the last note, set the previous node point to NULL
//record found is in the middle of the list
void remove(Record **head, int old_UIN)
{
  Record *prev;
  Record *current = *head;

  while (current != NULL)
  {
    if (current->UIN == old_UIN)
    {
      break;
    }
    prev = current;//*****
    current = current->next;
  }
  if (current == NULL)
  {
    return;
  }
  if (current == *head)
  {
    *head = current->next;
  }
  else if (current->next == NULL)
  {
    prev->next = NULL;
  }
  else
  {
    prec->next = current->next;
  }
  free(current);
}
