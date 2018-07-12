load("//tools:verilog.bzl", "verilog_library", "get_transitive_sources")

# TODO(kkining): We should have a way for there to configure the version used
# Also, should add support for using the local install
def verilator_repository(name, use_native=False):
    native.new_http_archive(
        name = name,
        strip_prefix = "verilator-3.924",
        sha256 = "7dcb19711b8630ada59f0d3d7409faa9649e37bf4c53a0bbfcad32afb28b5975",
        urls = ["https://www.veripool.org/ftp/verilator-3.924.tgz"],
        build_file = "third_party/verilator.BUILD",
    )

# Produce a set of C++ sources/header files from a Verilog library
def _cc_verilator_library_impl(ctx):
  # List of direct dependencies
  srcs = ctx.files.srcs + ctx.files.hdrs

  # Gather transitive dependencies
  deps = get_transitive_sources(ctx.files.srcs, ctx.attr.deps)

  # Default Verilator output prefix (e.x. "Vtop")
  prefix = ctx.attr.prefix + ctx.attr.top

  # Default outputs
  outputs = []
  for template in ["{prefix}", "{prefix}__Syms"]:
      filename = template.format(prefix=prefix)
      outputs.extend([
          ctx.actions.declare_file(filename + ".cpp"),
          ctx.actions.declare_file(filename + ".h"),
      ])

  # If DPI is enabled, add DPI outputs
  if ctx.attr.dpi:
      filename = "{prefix}__Dpi".format(prefix=prefix)
      outputs.extend([
          ctx.actions.declare_file(filename + ".cpp"),
          ctx.actions.declare_file(filename + ".h"),
      ])

  # add .h and .cpp for each module listed
  for module in ctx.attr.modules:
      filename = "{prefix}_{module}".format(
          prefix=prefix,
          module=module)
      outputs.extend([
          ctx.actions.declare_file(filename + ".cpp"),
          ctx.actions.declare_file(filename + ".h"),
      ])

  # Build arguments
  args = ctx.actions.args()
  args.add(["--cc"])
  args.add([f.path for f in deps.to_list()])
  args.add(["--Mdir", outputs[0].dirname])
  args.add(["--prefix", ctx.attr.prefix + ctx.attr.top])
  args.add(["--top-module", ctx.attr.top])
  if ctx.attr.trace:
    args.add(["--trace"])

  args.add(ctx.attr.vopts)

  # Run Verilator
  ctx.actions.run(
      inputs = ctx.files.srcs + ctx.files.hdrs,
      outputs = outputs,
      arguments = [args],
      progress_message = "(Verilator) Compiling %s" % ctx.label,
      executable = ctx.executable._verilator,
  )

gen_cc_verilator = rule(
    attrs = {
        "srcs": attr.label_list(
            doc = "List of verilog source files",
            mandatory = True,
            allow_files = [".v", ".sv"],
        ),
        "hdrs": attr.label_list(
            doc = "List of verilog header files",
            mandatory = False,
            allow_files = [".v", ".sv", ".vh", ".svh"],
        ),
        "deps": attr.label_list(),
        "top": attr.string(
            doc = "Top level module"),
        "modules": attr.string_list(),
        "prefix": attr.string(default="V"),
        "trace": attr.bool(doc = "Add tracing support"),
        "dpi": attr.bool(doc = "Generate DPI headers"),
        "vopts": attr.string_list(doc = "Additional command line options to pass to Verilator"),
        "_verilator": attr.label(
            default = Label("@verilator//:verilator_bin"),
            cfg = "host",
            allow_single_file = True,
            executable = True,
        ),
    },
    implementation = _cc_verilator_library_impl,
)

# TODO(kkiningh) Support debug/optmized verilator builds
def cc_verilator_library(name, srcs, top, hdrs=[], deps=[], modules=None,
                         prefix=None, trace=False, dpi=False, vopts=None,
                         **kwargs):
    # "real" prefix to use
    if prefix == None:
      prefix = "V" + top

    if modules == None:
      modules = []

    # Default outputs
    couts = []
    houts = []
    for template in ["{prefix}", "{prefix}__Syms"]:
        filename = template.format(prefix=prefix)
        couts.extend([filename + ".cpp"])
        houts.extend([filename + ".h"])

    # If DPI is enabled, add DPI outputs
    if dpi:
        filename = "{prefix}__Dpi".format(prefix=prefix)
        couts.extend([filename + ".cpp"])
        houts.extend([filename + ".h"])

    # If tracing is enabled, add trace outputs
    if trace:
        couts.append("{prefix}__Trace.cpp".format(prefix=prefix))
        couts.append("{prefix}__Trace__Slow.cpp".format(prefix=prefix))

    # add .h and .cpp for each module listed
    for module in modules:
        filename = "{prefix}_{module}".format(prefix=prefix, module=module)
        couts.extend([filename + ".cpp"])
        houts.extend([filename + ".h"])

    # Add options
    if vopts == None:
        vopts = []
    if trace:
        vopts += ["--trace"]

    # TODO(kkiningh) - Hack using genrule instead of a proper rule
    native.genrule(
        name = name + "_vdeps",
        srcs = srcs,
        outs = couts + houts,
        tools = ["@verilator//:verilator_bin"],
        cmd = """
        ./$(location @verilator//:verilator_bin) \
            --cc $(SRCS) --Mdir $(@D) --prefix %s --top-module %s %s
        """ % (prefix, top, " ".join(vopts)),
        visibility = ['//visibility:private'],
    )

    libverilator = "@verilator//:libverilator"
    if dpi:
      libverilator += "_dpi"

    native.cc_library(
        name = name,
        srcs = couts,
        hdrs = houts,
        deps = [libverilator],
        **kwargs
    )
