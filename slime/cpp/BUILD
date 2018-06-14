cc_binary(
    name = "adder.so",
    srcs = ["add.cpp"],
    deps = [
        "@eigen",
        "@pybind11",
    ],
    linkshared = 1, # Required
    visibility = ["//visibility:public"],
)
