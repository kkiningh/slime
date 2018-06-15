# A provider with a single field, transitive sources
VerilogFiles = provider()

def get_transitive_sources(srcs, deps):
  """Obtain the underlying source files for a target and it's transitive
  dependencies.

  Args:
    srcs: a list of source files
    deps: a list of targets that are the direct dependencies
  Returns:
    a collection of the transitive sources
  """
  return depset(
      srcs,
      transitive = [dep[VerilogFiles].transitive_sources for dep in deps])

def _verilog_library_impl(ctx):
  transitive_sources = get_transitive_sources(ctx.files.srcs, ctx.attr.deps)
  return [VerilogFiles(transitive_sources=transitive_sources)]

verilog_library = rule(
    implementation = _verilog_library_impl,
    attrs = {
        "srcs": attr.label_list(
            allow_files = [".v", ".sv"],
        ),
        "deps": attr.label_list(),
    },
)

