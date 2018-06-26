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
