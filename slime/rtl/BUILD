package(default_visibility = ["//visibility:public"])

load("@slime//tools:verilator.bzl", "cc_verilator_library")

cc_verilator_library(
    name = "ram",
    srcs = ["ram.sv"],
    vopts = ["--language 1800-2012"],
    top_module = "Ram_1RW_1C",
)
