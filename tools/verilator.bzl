load("//tools:verilog.bzl", "verilog_library", "get_transitive_sources")

# TODO(kkining): We should have a way for there to configure the version used
# Also, should add support for using the local install
def verilator_repository(name):
    native.new_http_archive(
        name = name,
        strip_prefix = "verilator-3.924",
        sha256 = "7dcb19711b8630ada59f0d3d7409faa9649e37bf4c53a0bbfcad32afb28b5975",
        urls = ["https://www.veripool.org/ftp/verilator-3.924.tgz"],
        build_file = "third_party/verilator.BUILD",
    )

# Produce a set of C++ sources/header files from a Verilog library
# TODO(kkiningh) Add DPI support (generates *__DPI)
def _cc_verilator_library_impl(ctx):
  # List of direct dependencies
  srcs = ctx.files.srcs + ctx.files.hdrs

  # Gather transitive dependencies
  deps = get_transitive_sources(ctx.files.srcs, ctx.attr.deps)

  # Build arguments
  args = ctx.actions.args()
  args.add(["--cc"])
  args.add([f.path for f in deps.to_list()])
  args.add(["--Mdir", ctx.outputs.src.dirname])
  args.add(["--prefix", ctx.attr.prefix + ctx.attr.top_module])
  args.add(["--top-module", ctx.attr.top_module])
  if ctx.attr.trace:
    args.add(["--trace"])

  args.add(ctx.attr.vopts)

  ctx.actions.run(
      inputs = ctx.files.srcs + ctx.files.hdrs,
      outputs = [
          ctx.outputs.src,
          ctx.outputs.hdr,
          ctx.outputs.src_Syms,
          ctx.outputs.hdr_Syms,
      ],
      arguments = [args],
      progress_message = "(Verilator) Compiling %s" % ctx.label,
      executable = ctx.executable._verilator,
  )

gen_cc_verilator = rule(
    attrs = {
        "srcs": attr.label_list(
            mandatory = True,
            allow_files = [".v", ".sv"],
        ),
        "hdrs": attr.label_list(
            mandatory = False,
            allow_files = [".v", ".sv", ".vh", ".svh"],
        ),
        "deps": attr.label_list(),
        "top_module": attr.string(),
        "prefix": attr.string(default="V"),
        "trace": attr.bool(),
        "vopts": attr.string_list(),
        "_verilator": attr.label(
            default = Label("@verilator//:verilator_bin"),
            cfg = "host",
            allow_single_file = True,
            executable = True,
        )
    },
    outputs = {
        "src": "%{prefix}%{top_module}.cpp",
        "hdr": "%{prefix}%{top_module}.h",
        "src_Syms": "%{prefix}%{top_module}__Syms.cpp",
        "hdr_Syms": "%{prefix}%{top_module}__Syms.h",
    },
    implementation = _cc_verilator_library_impl,
)

# TODO(kkiningh) Support debug/optmized verilator builds
def cc_verilator_library(name, srcs, hdrs=None,
                         top_module=None, prefix=None, trace=False, vopts=None, **kwargs):
    if hdrs == None:
      hdrs = []
    if top_module == None:
      top_module = name
    if prefix == None:
      prefix = "V" + top_module

    if vopts == None:
      vopts = []
    if trace == True:
      vopts += ["--trace"]

    # TODO(kkiningh) Should be a seperate rule
    native.genrule(
        name = name + "_vdep",
        srcs = srcs,
        outs = [
            prefix + ".cpp",
            prefix + ".h",
            prefix + "__Syms.cpp",
            prefix + "__Syms.h",
        ],
        tools = ["@verilator//:verilator_bin"],
        cmd = """
        ./$(location @verilator//:verilator_bin) \
            --cc $(SRCS) --Mdir $(@D) --prefix %s --top-module %s %s
        """ % (prefix, top_module, " ".join(vopts)),
        visibility = ['//visibility:private'],
    )

    native.cc_library(
        name = name,
        srcs = [
            ":" + prefix + ".cpp",
            ":" + prefix + "__Syms.cpp",
            ":" + prefix + "__Syms.h",
        ],
        hdrs = hdrs + [
            ":" + prefix + ".h",
        ],
        deps = [
            "@verilator//:libverilator",
        ],
        **kwargs
    )
