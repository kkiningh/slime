cc_binary(
    name = "verilator.so",
    srcs = ["verilator.cpp"],
    deps = [
        "@slime//slime/rtl:Ram",
        "@slime//slime/rtl:AdderGen",
        "@verilator//:libverilator",
        "@pybind11",
    ],
    linkshared = 1, # required
    visibility = ["//visibility:public"],
)

