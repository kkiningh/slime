#include "tb.h"

int main(int argc, char** argv) {
  /* Set the memory to something */
  auto device = Slime::getDeviceContext();
  auto buff = device->allocBuffer(131071);
  for (int i = 0; i < 131071; i++) {
    buff[i] = i;
  }

  device->enableTracing("trace.vcd");
  device->run(argc, argv);
}
