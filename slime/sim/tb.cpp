#include <verilated.h>
#include <verilated_vcd_c.h>
#include "svdpi.h"

#include "slime/sim/tb.h"

namespace Slime::detail {

// Set verilator arguments
void DeviceContextImpl::run(int argc, char** argv) {
  Verilated::commandArgs(argc, argv);
  run();
}

// Run the device
void DeviceContextImpl::run() {
  /* Run reset for one clock */
  _top.resetn = 0;
  _top.clock  = 0;
  _top.eval();
  _top.clock  = 1;
  _top.eval();

  /* Release reset */
  _top.resetn = 1;
  _top.clock  = 0;
  _top.eval();
  _top.clock  = 1;
  _top.eval();

  while (!Verilated::gotFinish()) {
      _top.clock = ~_top.clock;
      _top.eval();
  }

  _top.final();
}

void DeviceContextImpl::enableTracing(const char* filename) {
  Verilated::traceEverOn(true);
  _top.trace(&_trace, 99); // 99 levels of hierarchy
  _trace.open(filename);
}

/* Singlton device context */
static DeviceContextImpl deviceContextImpl;
}

namespace Slime {
  // Getter for singlton
  detail::DeviceContextImpl* getDeviceContext() {
    return &detail::deviceContextImpl;
  }
}

