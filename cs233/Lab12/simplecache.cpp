#include "simplecache.h"

int SimpleCache::find(int index, int tag, int block_offset) {
  // read handout for implementation details
  for (SimpleCacheBlock &it: _cache[index])
  {
    if ( it.tag() == tag && it.valid() == true)
    {
      return it.get_byte(block_offset);
    }
  }
  return 0xdeadbeef;
}

void SimpleCache::insert(int index, int tag, char data[]) {
  // read handout for implementation details
  // keep in mind what happens when you assign in in C++ (hint: Rule of Three)
  for (SimpleCacheBlock &it: _cache[index])
  {
    if (it.valid() != true)
    {
      it.replace(tag, data);
      return;
    }
  }
  _cache[index][0].replace(tag, data);
  return;
}
