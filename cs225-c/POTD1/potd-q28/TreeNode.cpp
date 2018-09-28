#include "TreeNode.h"
#include <iostream>

#include <utility>

TreeNode * deleteNode(TreeNode* root, int key)
{


  if (root == NULL)
  {
    return root;
  }
  if (root->val_ < key)
  {
    root->right_ = deleteNode(root->right_, key);
  }
  else if (root->val_ > key)
  {
    root->left_ = deleteNode(root->left_, key);
  }
  else
  {
   TreeNode * curr = root;
  //leaf
  if (root->left_ == NULL && root->right_ == NULL)
  {
    delete root;
    root = NULL;
  }

  //one child
  else if (root->left_ != NULL && root->right_ == NULL)
  {
    root = root->left_;
    delete curr;
    curr = NULL;
  }
  else if (root->left_ == NULL && root->right_ != NULL)
  {
    root = root->right_;
    delete curr;
    curr = NULL;
  }
  //two children
  else
  {
    TreeNode * temp = root->right_;
    while (temp->left_ != NULL)
    {
      temp = temp->left_;
    }

    //swap
    root->val_ = temp->val_;
    root->right_ = deleteNode(root->right_, temp->val_);
  }

  }
  return root;
}

void inorderPrint(TreeNode* node)
{
    if (!node)  return;
    inorderPrint(node->left_);
    std::cout << node->val_ << " ";
    inorderPrint(node->right_);
}

void deleteTree(TreeNode* root)
{
  if (root == NULL) return;
  deleteTree(root->left_);
  deleteTree(root->right_);
  delete root;
  root = NULL;
}
