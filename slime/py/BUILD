py_binary(
    name = "ram",
    srcs = ["ram.py"],
    data = ["//slime/rtl/bindings:verilator.so"],
)

py_test(
    name = "ram_test",
    srcs = ["ram_test.py"],
    deps = [":ram"],
    size = "enormous",
)
