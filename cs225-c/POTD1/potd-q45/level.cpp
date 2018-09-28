#include "MinHeap.h"

vector<int> lastLevel(MinHeap & heap)
{
  vector<int> leaves;
  int h = (int) log2(heap.elements.size());
  int idx = pow(2, h);
  for (size_t i = idx; i < heap.elements.size(); i++)
  {
      leaves.push_back(heap.elements[i]);
  }
  return leaves;
}
