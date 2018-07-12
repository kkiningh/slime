#ifndef TB_H_
#define TB_H_

#include <array>

#include <verilated.h>
#include <verilated_vcd_c.h>

#include "slime/sim/VTBWrapper__Dpi.h"
#include "slime/sim/VTBWrapper.h"

namespace Slime::detail {
  class DeviceContextImpl {
    using DeviceMemory = std::array<uint64_t, 131071>;
    using DevicePointer = DeviceMemory::iterator;

    // Backing store of the testbench memory
    DeviceMemory _tb_mem;

    // Pointer to the begining of the "free" portion of memory
    DevicePointer _tb_mem_free;

    // Callback for Verilog DPI
    friend void ::tb_mem_init(const svOpenArrayHandle);

    // Verilator model
    VTBWrapper _top;

    // Tracing support
    VerilatedVcdC _trace;

  public:
    DeviceContextImpl()
      : _tb_mem_free(std::begin(_tb_mem))
    { }

    DevicePointer allocBuffer(size_t size) {
      assert(_tb_mem_free + size < std::end(_tb_mem));
      auto ptr = _tb_mem_free;
      _tb_mem_free += size;
      return ptr;
    }

    // Verilator functions
    void run();
    void run(int argc, char** argv);
    void enableTracing(const char* filename);
  };
}

namespace Slime {
  detail::DeviceContextImpl* getDeviceContext();
}

#endif
