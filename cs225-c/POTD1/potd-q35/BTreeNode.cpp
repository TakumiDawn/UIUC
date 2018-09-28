#include <vector>
#include "BTreeNode.h"


BTreeNode* find(BTreeNode* root, int key) {
    // Your Code Here
    if(root->is_leaf_ == true)
    {
      for(int i : root->elements_)
      {
        if (i == key)
        {
          return root;
        }
      }
      return NULL;
    }
    else
    {
      for(int i : root->elements_)
      {
        if (i == key)
        {
          return root;
        }
      }
      for (BTreeNode* j : root->children_)
      {
        if (find(j, key) != NULL)
        {
          return find(j, key);
        }
      }
      return NULL;
    }

}
