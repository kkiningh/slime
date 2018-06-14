DEFAULT_MIRRORS = {
    "bitbucket": [
        "https://bitbucket.org/{repository}/get/{commit}.tar.gz",
    ],
    "buildifier": [
        "https://github.com/bazelbuild/buildtools/releases/download/{version}/{filename}",
    ],
    "github": [
        "https://github.com/{repository}/archive/{commit}.tar.gz",
    ],
    "pypi": [
        "https://files.pythonhosted.org/packages/source/{p}/{package}/{package}-{version}.tar.gz",
    ],
}
