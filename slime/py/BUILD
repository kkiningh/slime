py_binary(
    name = "ram",
    srcs = ["ram.py"],
    data = ["//slime/rtl/bindings:verilator.so"],
)

py_binary(
    name = "addrgen",
    srcs = ["addrgen.py"],
    data = ["//slime/rtl/bindings:verilator.so"],
)

py_test(
    name = "ram_test",
    srcs = ["ram_test.py"],
    deps = [":ram"],
)

py_binary(
    name = "shell",
    srcs = ["shell.py"],
    data = ["//slime/rtl/bindings:verilator.so"],
)
