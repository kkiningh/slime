load("@slime//tools:mirrors.bzl", "DEFAULT_MIRRORS")
load("@slime//tools:bitbucket.bzl", "bitbucket_archive")
load("@slime//tools:github.bzl", "github_archive")
load("@slime//tools:python.bzl", "python_repository")
load("@slime//tools:numpy.bzl", "numpy_repository")
load("@slime//tools:verilator.bzl", "verilator_repository")

def default_workspace(mirrors = DEFAULT_MIRRORS):
    """Declares workspace repositories for all externals needed by slime (other
    than those built into Bazel, of course).  This is intended to be loaded and
    called from a WORKSPACE file.
    """

    bitbucket_archive(
        name = "eigen",
        repository = "eigen/eigen",
        commit = "3.3.3",
        sha256 = "94878cbfa27b0d0fbc64c00d4aafa137f678d5315ae62ba4aecddbd4269ae75f",
        strip_prefix = "eigen-eigen-67e894c6cd8f",
        build_file = "@slime//third_party:eigen.BUILD",
        mirrors = mirrors,
    )

    github_archive(
        name = "gtest",
        repository = "google/googletest",
        commit = "release-1.8.0",
        sha256 = "58a6f4277ca2bc8565222b3bbd58a177609e9c488e8a72649359ba51450db7d8",
        build_file = "@slime//third_party:gtest.BUILD",
        mirrors = mirrors,
    )

    github_archive(
        name = "pybind11",
        repository = "pybind/pybind11",
        commit = "v2.2",
        sha256 = "6d5bc5d4d3fdcf75dbbf98acf234e3c1946a710176e35e3220db14110aa7a134",
        build_file = "@slime//third_party:pybind11.BUILD",
        mirrors = mirrors,
    )

    python_repository(name = "python")
    numpy_repository(name = "numpy")
    verilator_repository(name = "verilator")

