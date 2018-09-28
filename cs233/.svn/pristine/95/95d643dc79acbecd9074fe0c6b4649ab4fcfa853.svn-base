#include "cacheblock.h"

uint32_t Cache::Block::get_address() const {
  // TODO
  uint32_t tag = get_tag();
  uint32_t index = _index;
  
  uint32_t idx_length = _cache_config.get_num_index_bits();
  uint32_t offset_length = _cache_config.get_num_block_offset_bits();
  uint32_t address = tag << idx_length;
  address = address | index;
  address = address << offset_length;
  return address;
}
