#include "utils.h"

uint32_t extract_tag(uint32_t address, const CacheConfig& cache_config) {
  // TODO
  if (cache_config.get_num_tag_bits() >= 32)
  {
    return address;
  }
  uint32_t mask = (1 << cache_config.get_num_tag_bits())-1;
  mask = mask << (cache_config.get_num_block_offset_bits() + cache_config.get_num_index_bits());
  return (address & mask) >> (cache_config.get_num_block_offset_bits() + cache_config.get_num_index_bits());
}

uint32_t extract_index(uint32_t address, const CacheConfig& cache_config) {
  // TODO
  if (cache_config.get_num_tag_bits() >= 32)
  {
    return 0;
  }
  uint32_t mask = (1 << cache_config.get_num_index_bits()) -1;
  mask = mask << cache_config.get_num_block_offset_bits();
  return (address & mask) >> (cache_config.get_num_block_offset_bits());
}

uint32_t extract_block_offset(uint32_t address, const CacheConfig& cache_config) {
  // TODO
  if (cache_config.get_num_tag_bits() >= 32)
  {
    return 0;
  }
  uint32_t mask = (1 << cache_config.get_num_block_offset_bits()) -1;
  return address & mask;
}
