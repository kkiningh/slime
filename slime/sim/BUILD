package(default_visibility = ["//visibility:public"])

load("@slime//tools:verilator.bzl", "cc_verilator_library")

cc_verilator_library(
    name = "tb",
    srcs = [
        "tb.sv",
        "//slime/rtl:Ram.sv",
        "//slime/rtl:AdderGen.sv",
    ],
    top = "TBWrapper",
    modules = [
        "__024unit", # Unnamed top level module
        #"AXI_Ram__A11_D40",
    ],
    trace = True,
    dpi = True,
    vopts = ["-O3"],
)

cc_library(
    name = "libtb",
    srcs = [
        "tb.cpp",
        "tb.h",
        "tb_dpi.cpp",
        "tb_dpi.h",
    ],
    deps = [
        "@slime//slime/sim:tb",
        "@verilator//:libverilator_dpi",
    ],
)

cc_binary(
    name = "sim",
    srcs = ["sim.cpp"],
    deps = [":libtb"],
)
