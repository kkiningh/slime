package(default_visibility = ["//visibility:private"])

sh_binary(
    name = "astgen",
    srcs = ["src/astgen"],
)

sh_binary(
    name = "flexfix",
    srcs = ["src/flexfix"],
)

sh_binary(
    name = "bisonpre",
    srcs = ["src/bisonpre"],
)

genrule(
    name = "verilator_astgen",
    srcs = [
        "src/V3Ast.h",
        "src/V3AstNodes.h",
        "src/Verilator.cpp",
    ],
    outs = [
        "V3Ast__gen_classes.h",
        "V3Ast__gen_impl.h",
        "V3Ast__gen_interface.h",
        "V3Ast__gen_report.txt",
        "V3Ast__gen_types.h",
        "V3Ast__gen_visitor.h",
    ],
    cmd = """
    $(location :astgen) -I$$(dirname $(location src/V3Ast.h)) --classes
    cp V3Ast__gen_classes.h $(@D)
    cp V3Ast__gen_impl.h $(@D)
    cp V3Ast__gen_interface.h $(@D)
    cp V3Ast__gen_report.txt $(@D)
    cp V3Ast__gen_types.h $(@D)
    cp V3Ast__gen_visitor.h $(@D)
    """,
    tools = [":astgen"],
)

genrule(
    name = "verilator_astgen_const",
    srcs = [
        "src/V3Ast.h",
        "src/V3AstNodes.h",
        "src/V3Const.cpp",
        "src/Verilator.cpp",
    ],
    outs = ["V3Const__gen.cpp"],
    cmd = """
    $(location :astgen) -I$$(dirname $(location src/V3Const.cpp)) V3Const.cpp
    cp V3Const__gen.cpp $(@D)
    """,
    tools = [":astgen"],
)

genrule(
    name = "verilator_lex_pregen",
    srcs = ["src/verilog.l"],
    outs = ["V3Lexer_pregen.yy.cpp"],
    cmd = "flex -d -o$(@) $(<)",
)

genrule(
    name = "verilator_lex_flexfix",
    srcs = [":V3Lexer_pregen.yy.cpp"],
    outs = ["V3Lexer.yy.cpp"],
    cmd = "./$(location :flexfix) V3Lexer < $(<) > $(@)",
    tools = [":flexfix"],
)

genrule(
    name = "verilator_prelex_pregen",
    srcs = ["src/V3PreLex.l"],
    outs = ["V3PreLex_pregen.yy.cpp"],
    cmd = "flex -d -o$(@) $(<)",
)

genrule(
    name = "verilator_prelex_flexfix",
    srcs = [":V3PreLex_pregen.yy.cpp"],
    outs = ["V3PreLex.yy.cpp"],
    cmd = "./$(location :flexfix) V3PreLex < $(<) > $(@)",
    tools = [":flexfix"],
)

genrule(
    name = "verilator_gen_config",
    outs = ["src/config_build.h"],
    cmd = """cat <<END > $(@)
#include <sys/types.h>
//**********************************************************************
//**** Version and host name

// Autoconf substitutes this with the strings from AC_INIT.
#define PACKAGE_STRING "Verilator 3.924 2018-06-12"

#define DTVERSION PACKAGE_STRING

//**********************************************************************
//**** Functions

//**********************************************************************
//**** Headers

//**********************************************************************
//**** Default environment

// Set defines to defaults for environment variables
// If set to "", this default is ignored and the user is expected
// to set them at Verilator runtime.

#ifndef DEFENV_SYSTEMC
# define DEFENV_SYSTEMC ""
#endif
#ifndef DEFENV_SYSTEMC_ARCH
# define DEFENV_SYSTEMC_ARCH ""
#endif
#ifndef DEFENV_SYSTEMC_INCLUDE
# define DEFENV_SYSTEMC_INCLUDE ""
#endif
#ifndef DEFENV_SYSTEMC_LIBDIR
# define DEFENV_SYSTEMC_LIBDIR ""
#endif
#ifndef DEFENV_VERILATOR_ROOT
# define DEFENV_VERILATOR_ROOT ""
#endif

//**********************************************************************
//**** Compile options

#include <sys/types.h>
#include <iostream>
#include <cstdlib>
#include <cstdio>
#include <cstring>

using namespace std;

#include "verilatedos.h"
END""",
)

genrule(
    name = "verilator_bison",
    srcs = ["src/verilog.y"],
    outs = [
        "V3ParseBison.c",
        "V3ParseBison.h",
    ],
    cmd = "./$(location :bisonpre) --yacc bison -d -v -o $(location V3ParseBison.c) $(<)",
    tools = [":bisonpre"],
)

# TODO(kkiningh): Verilator also supports multithreading, should we enable it?
cc_library(
    name = "verilator_libV3",
    srcs = glob(
        ["src/V3*.cpp"],
        exclude = [
            "src/V3*_test.cpp",
            "src/V3Const.cpp",
        ],
    ) + [
        ":V3Ast__gen_classes.h",
        ":V3Ast__gen_impl.h",
        ":V3Ast__gen_interface.h",
        ":V3Ast__gen_types.h",
        ":V3Ast__gen_visitor.h",
        ":V3Const__gen.cpp",
        ":V3ParseBison.h",
    ],
    hdrs = glob(["src/V3*.h"]) + [
        "src/config_build.h",
        ":src/config_rev.h",
    ],
    copts = [
      "-DDEFENV_VERILATOR_ROOT=\\\"@invalid@\\\"", # TODO: We should probably set this later
      # TODO: Remove these once upstream fixes these warnings
      "-Wno-undefined-bool-conversion",
      "-Wno-format",
      "-Wno-unneeded-internal-declaration",
      "-Wno-deprecated-register",
      "-Wno-invalid-noreturn",
    ],
    defines = ["YYDEBUG"],
    strip_include_prefix = "src/",
    textual_hdrs = [
        # These are included directly by other C++ files
        # See https://github.com/bazelbuild/bazel/issues/680
        ":V3Lexer.yy.cpp",
        ":V3PreLex.yy.cpp",
        ":V3ParseBison.c",
    ],
    deps = [":libverilator"],
)

cc_library(
    name = "libverilator",
    srcs = [
        "include/verilated.cpp",
        "include/verilated_heavy.h",
        "include/verilated_imp.h",
        "include/verilated_syms.h",
        "include/verilated_sym_props.h",
    ],
    hdrs = [
        "include/verilated.h",
        "include/verilated_config.h",
        "include/verilatedos.h",
    ],
    strip_include_prefix = "include/",
    visibility = ["//visibility:public"],
)

cc_binary(
    name = "verilator_bin",
    srcs = ["src/Verilator.cpp"],
    visibility = ["//visibility:public"],
    deps = [
        ":libverilator",
        ":verilator_libV3",
    ],
)