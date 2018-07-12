#include <algorithm>
#include <cassert>
#include <cstdint>
#include <iterator>

#include "svdpi.h"
#include "slime/sim/tb.h"
#include "slime/sim/tb_dpi.h"

// Initialize the testbench memory to whatever we have inside of the device
// context
void tb_mem_init(const svOpenArrayHandle mem) {
  auto device_ptr = static_cast<uint64_t*>(svGetArrayPtr(mem));
  assert(device_ptr != nullptr);

  // Copy all elements to device
  auto& tb_mem = Slime::getDeviceContext()->_tb_mem;
  std::copy(std::begin(tb_mem), std::end(tb_mem), device_ptr);
}

// Called by $time in Verilog
uint64_t main_time = 0;
double sc_time_stamp() {
  return main_time; // Note does conversion to real, to match SystemC
}
