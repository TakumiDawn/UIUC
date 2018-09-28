#include <vector>
#include "BTreeNode.h"


std::vector<int> traverse(BTreeNode* root) {
    // your code here
    std::vector<int> v;
    return traverse(root,v);
}

std::vector<int> traverse(BTreeNode* root, std::vector<int> &v)
{
  if (root == NULL)
  {
    return v;
  }
  if (root->is_leaf_ == true)
  {
    for (int x : root->elements_)
    {
      v.push_back(x);
    }
  }
  else
  {
    unsigned long i;
    for(i = 0;i < root->elements_.size();i++)
    {
      traverse(root->children_[i] , v);
      v.push_back(root->elements_[i]);
    }
    traverse(root->children_[i] , v);
  }
  return v;
}
