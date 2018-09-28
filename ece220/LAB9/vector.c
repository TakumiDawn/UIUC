#include "vector.h"
#include <stdlib.h>


vector_t * createVector(int initialSize)
{
  vector_t* vector = (vector_t*) malloc(sizeof(vector_t));
  vector->size = 0;
  vector->maxSize = initialSize;
  vector->array = (int*)malloc(initialSize*sizeof(int));
  return vector;
}

void destroyVector(vector_t * vector)
{
  free(vector->array); //order matters, otherwise the "key" to the array will lose
  free(vector);
}

void resize(vector_t * vector)
{
  vector->array = (int*) realloc(vector->array, vector-> maxSize*2*sizeof(int));
  vector->maxSize *= 2;
}

void push_back(vector_t * vector, int element)
{
  if (vector->size >= vector->maxSize)
    resize(vector);
  vector->array[vector->size] = element;
  vector->size++;
}

int pop_back(vector_t * vector)
{
  if (vector->size <= 0)
    return 0;
  vector->size--;
  int temp = vector->array[vector->size];
  return temp;
}

int access(vector_t * vector, int index)
{
  if (index>=vector->size) 
    return 0;
  return vector->array[index];
}
