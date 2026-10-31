# Makefile for fortran-tutorial. Requires gfortran + GNU make.
#
# Windows (MSYS2 UCRT64 on PATH): the make binary is `mingw32-make`.
#   mingw32-make m1      build + run module 1's checker against YOUR exercise
#   mingw32-make m1-sol  same, but against the reference solution
#   mingw32-make test    run every module checker against the solutions
#   mingw32-make clean
#
# Linux / macOS / MSYS shell: use `make` instead of `mingw32-make`.

FC     = gfortran
FFLAGS = -O2 -fwrapv -Wall -std=f2008 -J build
SRC    = src
MODDIR = modules
BUILD  = build

ifeq ($(OS),Windows_NT)
  MKDIR    = if not exist $(BUILD) mkdir $(BUILD)
  RMDIR    = if exist $(BUILD) rmdir /s /q $(BUILD)
  CLEANEXE = del /q /f *.exe 2>nul & del /q /f $(MODDIR)\*\check.exe 2>nul
  EXE      = .exe
  SEP      = $(strip \)
else
  MKDIR    = mkdir -p $(BUILD)
  RMDIR    = rm -rf $(BUILD)
  CLEANEXE = rm -f $(MODDIR)/*/check *.exe
  EXE      =
  SEP      = /
endif

# module id -> directory
DIR_m1 = $(MODDIR)/m1_hello
DIR_m2 = $(MODDIR)/m2_control
DIR_m3 = $(MODDIR)/m3_arrays
DIR_m4 = $(MODDIR)/m4_procedures
DIR_m5 = $(MODDIR)/m5_elementary_ca
DIR_m6 = $(MODDIR)/m6_grids
DIR_m7 = $(MODDIR)/m7_life
DIR_m8 = $(MODDIR)/m8_capstone

# Extra module files a module depends on (compiled before it).
# m7 and m8 use m6's neighbor_counts.
DEP_m1 =
DEP_m2 =
DEP_m3 =
DEP_m4 =
DEP_m5 =
DEP_m6 =
DEP_m7 = $(MODDIR)/m6_grids/solution.f90
DEP_m8 = $(MODDIR)/m6_grids/solution.f90

MODULES = m1 m2 m3 m4 m5 m6 m7 m8

.PHONY: all test clean $(MODULES) $(addsuffix -sol,$(MODULES))

all: test

# Build+run one module against the student exercise (and against solution).
define RUN_template
$(1): | mkbuild
	$$(FC) $$(FFLAGS) $$(SRC)/testing.f90 $$(DEP_$(1)) $$(DIR_$(1))/exercise.f90 $$(DIR_$(1))/check.f90 -o $$(DIR_$(1))$$(SEP)check
	$$(DIR_$(1))$$(SEP)check$$(EXE)

$(1)-sol: | mkbuild
	$$(FC) $$(FFLAGS) $$(SRC)/testing.f90 $$(DEP_$(1)) $$(DIR_$(1))/solution.f90 $$(DIR_$(1))/check.f90 -o $$(DIR_$(1))$$(SEP)check
	$$(DIR_$(1))$$(SEP)check$$(EXE)
endef

$(foreach m,$(MODULES),$(eval $(call RUN_template,$(m))))

mkbuild:
	$(MKDIR)

# Verify the whole course by running every checker against the solutions.
test: $(addsuffix -sol,$(MODULES))
	@echo ""
	@echo "All module solutions pass."

clean:
	-$(RMDIR)
	-$(CLEANEXE)
