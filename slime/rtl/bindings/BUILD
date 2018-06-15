cc_binary(
    name = "verilator.so",
    srcs = ["verilator.cpp"],
    deps = [
        "@slime//slime/rtl:ram",
        "@verilator//:libverilator",
        "@pybind11",
    ],
    linkshared = 1, # required
    visibility = ["//visibility:public"],
)

