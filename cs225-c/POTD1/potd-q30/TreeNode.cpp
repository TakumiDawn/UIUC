#include "TreeNode.h"

int getHeightBalance(TreeNode* root) {
  // your code here
  if (root == NULL)
  {
    return 0;
  }
  return getHeight(root->left_) - getHeight(root->right_); //diff than usual 
}

int getHeight(TreeNode* root)
{
  if (root == NULL)
  {
    return -1;
  }
  int max = (getHeight(root->left_) > getHeight(root->right_)) ? getHeight(root->left_):getHeight(root->right_);
  return 1 + max;
}

void deleteTree(TreeNode* root)
{
  if (root == NULL) return;
  deleteTree(root->left_);
  deleteTree(root->right_);
  delete root;
  root = NULL;
}
