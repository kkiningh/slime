#include <verilated.h>

#include "pybind11/pybind11.h"

#include "slime/rtl/VRam_1RW_1C.h"
#include "slime/rtl/VAdderGen.h"

namespace py = pybind11;

PYBIND11_MODULE(verilator, m) {
  py::class_<VRam_1RW_1C>(m, "VRam_1RW_1C")
    .def(py::init<>())
    .def("eval", &VRam_1RW_1C::eval)
    .def("final", &VRam_1RW_1C::final)
    .def_readwrite("clock", &VRam_1RW_1C::clock)
    .def_readwrite("en", &VRam_1RW_1C::en)
    .def_readwrite("wr_en", &VRam_1RW_1C::wr_en)
    .def_readwrite("addr", &VRam_1RW_1C::addr)
    .def_readwrite("data_in", &VRam_1RW_1C::data_in)
    .def_readonly("data_out", &VRam_1RW_1C::data_out);

  py::class_<VAdderGen>(m, "AdderGen")
    .def(py::init<>())
    .def("eval", &VAdderGen::eval)
    .def("final", &VAdderGen::final)
    .def_readwrite("clock", &VAdderGen::clock)
    .def_readwrite("reset", &VAdderGen::reset);
}
