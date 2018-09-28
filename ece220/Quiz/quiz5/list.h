typedef struct ListNode node;
struct ListNode{
    int data;
    node *next;
};

node *add_node(node* head, int new_data);
void remove_node(node *head);
