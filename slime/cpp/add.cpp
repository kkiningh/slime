#include <iostream>

#include "Eigen/Core"
#include "pybind11/pybind11.h"
#include "pybind11/eigen.h"

int add(int i, int j) {
    return i + j;
}

PYBIND11_MODULE(adder, m) {
  m.def("add", &add, "Add two numbers");
}
