#include "TreeNode.h"
#include <algorithm>
#include <cmath>

TreeNode* findLastUnbalanced(TreeNode* root)
{
  if (root == NULL)
  {
    return NULL;
  }
  if (root->left_ == NULL && root->right_== NULL)
  {
    return NULL;
  }

    if (findLastUnbalanced(root->left_)==NULL && findLastUnbalanced(root->right_)==NULL )
    { if (isHeightBalanced(root) == false)
      {
        return root;
      }
      else
        return NULL;
    }
    else if (findLastUnbalanced(root->left_)==NULL && findLastUnbalanced(root->right_)!=NULL )
    {
      return findLastUnbalanced(root->right_);
    }
    else if (findLastUnbalanced(root->left_)!=NULL && findLastUnbalanced(root->right_)==NULL )
    {
      return findLastUnbalanced(root->left_);
    }
    else if (height(findLastUnbalanced(root->left_)) <=  height(findLastUnbalanced(root->right_)))
    {
      return findLastUnbalanced(root->left_);
    }
    else
    {
      return findLastUnbalanced(root->right_);
    }
}


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
