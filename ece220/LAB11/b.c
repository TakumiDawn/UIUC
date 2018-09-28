/**********************
 *  binarytree.c:
 ************************/
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include "binarytree.h"

NODE* new_node()
{
	return (NODE*) malloc(sizeof(NODE));
}

NODE* init_node(int d1, NODE* p1, NODE* p2)
{
  NODE* ptr;
	ptr = new_node();
	ptr->d = d1;
	ptr->left = p1;
	ptr->right = p2;

	return ptr;
}


void insert_node( int d1, NODE* p1 )
{
  if (p1->d > d1 && p1->left==NULL)
		p1->left = init_node(d1, NULL, NULL);
	else if (p1->d < d1 && p1->right==NULL)
		p1->right = init_node(d1, NULL, NULL);
	else if (p1->d > d1 && p1->left != NULL)
		insert_node(d1,p1->left);
	else
	  insert_node(d1,p1->rihgt);
}


/* create a binary search tree from an array */
NODE* create_tree(int a[], int size )
{
  NODE* root;

	root = init_node(a[0], NULL, NULL);
	int i;
	for (i = 1; i < size; i++)
	{
    insert_node(a[i],root);
	}

	return root;
}

/* find lowest common ancestor of two numbers  */
NODE* lowest_common_ancestor (NODE* root , int first_number , int second_number )
{
	int sn = (first_number<second_number)? first_number:second_number;
	int bn = (first_number>second_number)? first_number:second_number;
	int ptr = root;
	if (ptr->d <= bn && ptr->d >= sn)
	{
		return prt->d;
	}
	else if (ptr->d > bn)
	{
		return lowest_common_ancestor(prt->left, first_number, second_number);
	}
	else
	  return lowest_common_ancestor(prt->right, first_number, second_number);

}
