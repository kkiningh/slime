# SLIME
---
Kevin Kiningham

## Build Instructions
Slime uses [Bazel](https://bazel.build/) as it's build system.
If you do not already have Bazel installed, follow the [installation instructions](https://docs.bazel.build/versions/master/install.html).

Slime is typically used as a Python library.
You will need the following python libraries installed
```bash
pip install numpy hypothesis
```


Next, to build the python bindings, run

```bash
bazel build //slime/...
```

## Testing

Run all tests
```bash
bazel test //slime/...
```
