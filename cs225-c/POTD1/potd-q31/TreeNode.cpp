#include "TreeNode.h"
#include <algorithm>
#include <cmath>
using namespace std;

bool isHeightBalanced(TreeNode* root) {
  if (abs(height(root->left_)-height(root->right_)) <= 1)
  {
    return true;
  }
  else
    return false;
}

int height(TreeNode * subroot)
{
  if (subroot == NULL)
  {
    return -1;
  }
  if (subroot->left_ == NULL && subroot->right_ == NULL)
  {
    return 0;
  }
  else if (subroot->left_ == NULL && subroot->right_ != NULL)
  {
    return 1 + height(subroot->right_);
  }
  else if (subroot->left_ != NULL && subroot->right_ == NULL)
  {
    return 1 + height(subroot->left_);
  }
  return 1+fmax(height(subroot->left_),height(subroot->right_));
}


void deleteTree(TreeNode* root)
{
  if (root == NULL) return;
  deleteTree(root->left_);
  deleteTree(root->right_);
  delete root;
  root = NULL;
}
