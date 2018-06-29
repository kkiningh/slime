package(default_visibility = ["//visibility:public"])

load("@slime//tools:verilator.bzl", "gen_cc_verilator", "cc_verilator_library")

cc_verilator_library(
    name = "Ram",
    srcs = ["Ram.sv"],
    top = "Ram_1RW_1C",
)

cc_verilator_library(
    name = "addrgen",
    srcs = ["addrgen.sv"],
    top = "AdderGen",
    modules = [
        "__024unit", # Unnamed top level module
        "AdderGenPkg",
    ],
)
