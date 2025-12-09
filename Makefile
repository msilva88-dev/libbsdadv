# SPDX-License-Identifier: CC0-1.0

# This file is dedicated to the public domain under CC0 1.0.
#
# To the extent possible under law, the author(s) have waived all
# copyright and related or neighboring rights to this file.
#
# You may use, copy, modify, and distribute this file without restriction.
#
# See: https://creativecommons.org/publicdomain/zero/1.0/


## Settings

# Configurations
AR ?= $(AR_CMD)
ARFLAGS ?= rcs
BUILDDIR ?= build
CARCH ?= $(CARCH_CMD)
CHOST ?= $(CHOST_CMD)
CTHREADS ?= $(CTHREADS_CMD)
CPPFLAGS ?= $(CPPFLAGS_CMD)
CC ?= $(CC_CMD)
CFLAGS ?= $(CFLAGS_CMD)
CVER ?= gnu17
DEBUG ?= false
DESTDIR ?= /
ENABLE_BLF ?= false
ENABLE_BSDDB ?= false
ENABLE_SHARED ?= true
ENABLE_DYNAMIC ?= false
ENABLE_YP ?= false
GRPOWN ?= root
LD ?= $(LD_CMD)
LDHSTYLE ?= both
LDHSTYLE_LEG ?= gnu
LIBDIR ?= $(PREFIX)lib/
MARCH ?= $(MARCH_CMD)
PREFIX ?= $(DESTDIR)
USROWN ?= root
USE_MUSL_WITH_BSD ?= true

# Number of CPU threads for parallel compilation
CTHREADS_CMD != sh -c '\
getconf _NPROCESSORS_ONLN 2>/dev/null || printf "%d" 1 \
' 2>/dev/null

# Target architecture flags
CARCH_CMD != sh -c 'uname -m 2>/dev/null || printf "%s" "x86_64"' 2>/dev/null
COS_CMD != sh -c '\
uname -s 2>/dev/null || printf "%s" "Linux" \
' 2>/dev/null
CHOST_CMD != sh -c '\
case "$(COS_CMD)" in \
    HyperbolaBSD) \
        printf "%s-pc-%s" "$(CARCH)" "hyperbolabsd" \
        ;; \
    *Linux|*) \
        printf "%s-pc-%s" "$(CARCH)" "linux-gnu" \
        ;; \
esac \
' 2>/dev/null
MARCH_CMD != sh -c '\
uname -m 2>/dev/null | sed "s/_/-/" 2>/dev/null || printf "%s" "x86-64" \
' 2>/dev/null
MALIGNF_CMD != sh -c '\
case "$(CARCH)" in \
    i686) \
        printf "%d" 16 \
        ;; \
    x86_64|*) \
        printf "%d" 32 \
        ;; \
esac \
' 2>/dev/null
MALIGNL_CMD != sh -c '\
case "$(CARCH)" in \
    i686) \
        printf "%d" 8 \
        ;; \
    x86_64|*) \
        printf "%d" 16 \
        ;; \
esac \
' 2>/dev/null
MCF_PROTECT_CMD != sh -c '\
case "$(CARCH)" in \
    i686) \
        printf "%s" "branch" \
        ;; \
    x86_64|*) \
        printf "%s" "full" \
        ;; \
esac \
' 2>/dev/null

# Target libc flags
BUILD_PORTABLE_CMD != sh -c '\
case "$(USE_MUSL_WITH_BSD)" in \
    true) \
        printf "%s" "false" \
        ;; \
    false|*) \
        printf "%s" "true" \
        ;; \
esac \
' 2>/dev/null
BUILD_PORTABLE ::= $(BUILD_PORTABLE_CMD)

# Target library flags
BUILD_LIBRARY_CMD != sh -c '\
_DYNAMIC=""; \
_STATIC=""; \
_SP=""; \
[ "$(ENABLE_DYNAMIC)" = "true" ] && _DYNAMIC="libbsd4_dynamic"; \
[ "$(ENABLE_STATIC)" = "true" ] && _STATIC="libbsd4_static"; \
if [ -z "$${_DYNAMIC}" ] && [ -z "$${_STATIC}" ]; then \
    _DYNAMIC="libbsd4_dynamic"; \
fi; \
[ -n "$${_DYNAMIC}" ] && _SP=" "; \
printf "%s%s%s" "$${_DYNAMIC}" "$${_SP}" "$${_STATIC}" \
' 2>/dev/null
BUILD_LIBRARY ::= $(BUILD_LIBRARY_CMD)

# Default C compiler command flags
AR_PATH_CMD != sh -c '\
command -v binutils-ar 2>/dev/null || command -v llvm-ar 2>/dev/null \
  || command -v ar 2>/dev/null || printf "%s" "ar" \
' 2>/dev/null
AR_CMD != printf "%s" "$(AR_PATH_CMD)" | sed "s|.*/||" 2>/dev/null

# Default C compiler command flags
CC_PATH_CMD != sh -c '\
command -v clang 2>/dev/null || command -v gcc 2>/dev/null \
  || printf "%s" "cc" \
' 2>/dev/null
CC_CMD != printf "%s" "$(CC_PATH_CMD)" | sed "s|.*/||" 2>/dev/null

# Default Linker compiler command flags
LD_PATH_CMD != sh -c '\
command -v mold 2>/dev/null || command -v lld 2>/dev/null \
  || command -v ld.gold 2>/dev/null || command -v ld.bfd 2>/dev/null \
  || command -v ld 2>/dev/null  || printf "%s" "ld.bfd" \
' 2>/dev/null
LD_CMD != printf "%s" "$(LD_PATH_CMD)" | sed "s|.*/||" 2>/dev/null

## Compiler

# Optional Feature Flags
OPTFLAG_BLF_CMD != sh -c '\
[ "$(ENABLE_BLF)" = "true" ] && printf "%s%s" '-D' "BLF"; \
' 2>/dev/null
OPTFLAG_BLF ::= $(OPTFLAG_BLF_CMD)
OPTFLAG_BSDDB_CMD != sh -c '\
[ "$(ENABLE_BSDDB)" = "true" ] && printf "%s%s" '-D' "BSDDB"; \
' 2>/dev/null
OPTFLAG_BSDDB ::= $(OPTFLAG_BSDDB_CMD)
OPTFLAG_YP_CMD != sh -c '\
[ "$(ENABLE_YP)" = "true" ] && printf "%s%s" '-D' "YP"; \
' 2>/dev/null
OPTFLAG_YP ::= $(OPTFLAG_YP_CMD)
DFT_OPTFLAGS ::= $(OPTFLAG_BLF) $(OPTFLAG_BSDDB) $(OPTFLAG_YP)

# Set appropriate flags in clang v11, GCC v8 and Binutils as v2.34
# (any language)
# -march: builds exclusively for an architecture
DFT_GENFLAGS_CMD != sh -c '\
case "$(DEBUG)" in \
    true) \
        printf "%s%s=%s %s %s" "-m" "arch" "$(MARCH)" "-pipe" "-g"; \
        ;; \
    false|*) \
        printf "%s%s=%s %s" "-m" "arch" "$(MARCH)" "-pipe"; \
        ;; \
esac \
' 2>/dev/null

# Set appropriate flags in clang v11, GCC v8 and Binutils as v2.34
# -fno-plt: (GCC-only) does not support clang v11 and bellow
# -mtune: (GCC-only) optimizes for an architecture,
#   but builds for whole processor family
LD_GENFLAGS_LLVM_CMD != sh -c '\
case "$(LD)" in \
    lld) \
        printf "%s" "-flto=thin" \
        ;; \
    *) \
        printf "%s" "" \
        ;; \
esac \
' 2>/dev/null
LD_GENFLAGS_GCC_CMD != sh -c '\
case "$(LD)" in \
    ld.gold) \
        printf "%s" "" \
        ;; \
    ld.bfd|ld|*) \
        printf "%s=%s %s" "-flto" "$(CTHREADS)" "-flto-partition=max" \
        ;; \
esac \
' 2>/dev/null
DFT_GENFLAGS_LLVM ::= $(DFT_GENFLAGS_CMD) $(LD_GENFLAGS_LLVM_CMD)
DFT_GENFLAGS_GCC ::= $(DFT_GENFLAGS_CMD)
DFT_GENFLAGS_GCC += -mtune=generic
DFT_GENFLAGS_GCC += $(LD_GENFLAGS_GCC_CMD)
DFT_GENFLAGS_GCC += -fno-plt
DFT_GENFLAGS_GCC += -falign-functions=$(MALIGNF_CMD)
DFT_GENFLAGS_GCC += -falign-loops=$(MALIGNL_CMD)
DFT_GENFLAGS_GCC += -falign-jumps=$(MALIGNF_CMD)
DFT_GENFLAGS_GCC += -fno-semantic-interposition
DFT_GENFLAGS_GCC += -fstack-clash-protection

# Optimize Flags in clang v11 and GCC v8 (any language)
DFT_OPTMFLAGS_CMD != sh -c '\
case "$(DEBUG)" in \
    true) \
        printf "%s%d" "-O" 0 \
        ;; \
    false|*) \
        printf "%s%d" "-O" 2 \
        ;; \
esac \
' 2>/dev/null

# Compiler Flags in clang v11 and GCC v8 (any language)
DFT_COMPFLAGS ::= $(DFT_OPTMFLAGS_CMD)
DFT_COMPFLAGS += -fno-common
DFT_COMPFLAGS += -fstack-protector-strong
DFT_COMPFLAGS += -ffunction-sections
DFT_COMPFLAGS += -fdata-sections
DFT_COMPFLAGS += -fcf-protection=$(MCF_PROTECT_CMD)
#-feliminate-unused-debug-types
DFT_COMPFLAGS_CMD != sh -c '\
case "$(DEBUG)" in \
    true) \
        printf "%s -f%s -g%s -g%s -f%s" \
        "$(DFT_COMPFLAGS)" "no-lto" "dwarf-4" "split-dwarf" \
        "no-omit-frame-pointer" \
        ;; \
    false|*) \
        printf "%s" "$(DFT_COMPFLAGS)" \
        ;; \
esac \
' 2>/dev/null

# Compiler Flags for shared library
DFT_LIBFLAGS ::= -fPIC

# Compiler Flags in clang v11 and GCC v8 (C family language)
DFT_CFMLFLAGS_CMD != sh -c '\
case "$(DEBUG)" in \
    true) \
        printf "%s" "" \
        ;; \
    false|*) \
        printf "%s%s" "-f" "pch-preprocess" \
        ;; \
esac \
' 2>/dev/null

# C compiler flags
VER_CFLAGS_CMD != sh -c '\
case "$(CVER)" in \
    *) \
        printf "%s" "-fexceptions"; \
        ;; \
esac \
' 2>/dev/null
DFT_CFLAGS ::= -fno-exceptions

# C Preprocessor Flags in clang v11, GCC v8 and Binutils as v2.34
# (C family language)
CPPFLAGS_CMD != sh -c '\
case "$(DEBUG)" in \
    true) \
        printf "-D%s=%d -D%s" "_FORTIFY_SOURCE" 2 "DEBUG"; \
        ;; \
    false|*) \
        printf "-D%s=%d -D%s" "_FORTIFY_SOURCE" 2 "NDEBUG"; \
        ;; \
esac \
' 2>/dev/null

# Warning Flags
DFT_WFLAGS ::= -Wall
DFT_WFLAGS += -Wextra
DFT_WFLAGS += -Wimplicit-fallthrough
DFT_WFLAGS += -Wpedantic

# Compiler Flags
CFLAGS_CMD != sh -c '\
case "$(CC)" in \
    clang*) \
        printf "%s %s %s -std=%s %s %s %s" \
          "$(DFT_GENFLAGS_LLVM)" "$(DFT_COMPFLAGS_CMD)" \
          "$(DFT_CFMLFLAGS_CMD)" \
          "$(CVER)" "$(DFT_CFLAGS)" "$(DFT_WFLAGS)" "$(DFT_OPTFLAGS)" \
        ;; \
    gcc*) \
        printf "%s %s %s -std=%s %s %s %s" \
          "$(DFT_GENFLAGS_GCC)" "$(DFT_COMPFLAGS_CMD)" \
          "$(DFT_CFMLFLAGS_CMD)" \
          "$(CVER)" "$(DFT_CFLAGS)" "$(DFT_WFLAGS)" "$(DFT_OPTFLAGS)" \
        ;; \
    *) \
        printf "%s %s %s -std=%s %s %s %s" \
          "$(DFT_GENFLAGS)" "$(DFT_COMPFLAGS_CMD)" \
          "$(DFT_CFMLFLAGS_CMD)" \
          "$(CVER)" "$(DFT_CFLAGS)" "$(DFT_WFLAGS)" "$(DFT_OPTFLAGS)" \
        ;; \
esac \
' 2>/dev/null

## Linker Flags

# Linker Selection (Fastest available) and set appropriate flags
# in mold v1, LLVM LLD v11 and Binutils ld.bfd/ld.gold v2.34
# Use --hash-style=sysv in HyperbolaBSD (LLD uses by default)
# and --hash-style=gnu in GNU/Linux-libre (LLD doesn't support this flag)
DFT_GENLDFLAGS_CMD != sh -c '\
case "$(LD)" in \
    mold) \
        printf "%s %s,%s=%s,%s,%s,%s=%s" \
          "-fuse-ld=mold" "-Wl" "--hash-style" "$(LDHSTYLE)" \
          "--icf=safe" "--print-icf-sections" "--jobs" "$(CTHREADS)" \
        ;; \
    lld) \
        printf "%s %s,%s=%s,%s,%s" \
          "-fuse-ld=lld" "-Wl" "--hash-style" "$(LDHSTYLE)" \
          "--icf=safe" "--print-icf-sections" \
        ;; \
    ld.gold) \
        printf "%s %s,%s=%s,%s,%s,%s" \
          "-fuse-ld=gold" "-Wl" "--hash-style" "$(LDHSTYLE_LEG)" \
          "--icf=safe" "--print-icf-sections" "--threads" \
        ;; \
    ld.bfd|ld) \
        printf "%s %s,%s=%s" \
          "-fuse-ld=bfd" "-Wl" "--hash-style" "$(LDHSTYLE)" \
        ;; \
    *) \
        printf "%s,%s=%s" \
          "-Wl" "--hash-style" "$(LDHSTYLE)" \
        ;; \
esac \
' 2>/dev/null

# Linker Flags in Binutils ld.bfd/ld.gold v2.34, LLD v11 and mold v1
DFT_LDFLAGS ::= $(DFT_GENLDFLAGS_CMD),$(DFT_OPTMFLAGS_CMD)
DFT_LDFLAGS ::= $(DFT_LDFLAGS),-z,defs
DFT_LDFLAGS ::= $(DFT_LDFLAGS),-z,noexecstack
DFT_LDFLAGS ::= $(DFT_LDFLAGS),-z,now
DFT_LDFLAGS ::= $(DFT_LDFLAGS),-z,relro
DFT_LDFLAGS ::= $(DFT_LDFLAGS),--gc-sections
DFT_LDFLAGS ::= $(DFT_LDFLAGS),--build-id
DFT_LDFLAGS_CMD != sh -c '\
case "$(DEBUG)" in \
    true) \
        printf "%s,%s %s %s" \
          "$(DFT_LDFLAGS)" "--no-as-needed" "-g" "-rdynamic" \
        ;; \
    false|*) \
        printf "%s,%s" "$(DFT_LDFLAGS)" "--as-needed" \
        ;; \
esac \
' 2>/dev/null

# Linker Flags for shared code
DFT_SHAREDLDFLAGS ::= -shared

# Linker Flags
LDFLAGS ::= $(DFT_LDFLAGS_CMD)

## Make macros

LIBS ::= $(BUILD_LIBRARY)

COMMON_SRCS ::=
PORTABLE_SRCS ::= portable/arc4random_int.c portable/bcrypt_int_ptb.c
PORTABLE_SRCS += portable/getcap_int.c portable/passwd_int.c
PORTABLE_SRCS += portable/pw_dup_int.c portable/strtonum_int.c
PORTABLE_SRCS += portable/timingsafe_bcmp_int.c
LIBBSD4_SRCS ::= authenticate.c auth_subr.c bcrypt_int.c blowfish.c
LIBBSD4_SRCS += check_expire.c cryptutil.c fparseln.c getnetgrent.c
LIBBSD4_SRCS += login_cap.c

COMMON_OBJS ::=
PORTABLE_OBJS ::= $(BUILDDIR)/portable/arc4random_int.o
PORTABLE_OBJS += $(BUILDDIR)/portable/bcrypt_int_ptb.o
PORTABLE_OBJS += $(BUILDDIR)/portable/getcap_int.o
PORTABLE_OBJS += $(BUILDDIR)/portable/passwd_int.o
PORTABLE_OBJS += $(BUILDDIR)/portable/pw_dup_int.o
PORTABLE_OBJS += $(BUILDDIR)/portable/strtonum_int.o
PORTABLE_OBJS += $(BUILDDIR)/portable/timingsafe_bcmp_int.o
LIBBSD4_OBJS ::= $(BUILDDIR)/authenticate.o $(BUILDDIR)/auth_subr.o
LIBBSD4_OBJS += $(BUILDDIR)/bcrypt_int.o $(BUILDDIR)/blowfish.o
LIBBSD4_OBJS += $(BUILDDIR)/check_expire.o $(BUILDDIR)/cryptutil.o
LIBBSD4_OBJS += $(BUILDDIR)/fparseln.o $(BUILDDIR)/getnetgrent.o
LIBBSD4_OBJS += $(BUILDDIR)/login_cap.o

## build

all: $(LIBS)

libbsd4_dynamic: $(LIBBSD4_OBJS) $(COMMON_OBJS) $(PORTABLE_OBJS)
	if [ "$(BUILD_PORTABLE)" = "true" ]; then \
	    $(CC) $(LDFLAGS) $(DFT_LIBFLAGS) $(DFT_SHAREDLDFLAGS) \
	      -o $(BUILDDIR)/libbsd4.so $^; \
	else \
	    $(CC) $(LDFLAGS) $(DFT_LIBFLAGS) $(DFT_SHAREDLDFLAGS) \
	      -o $(BUILDDIR)/libbsd4.so $(LIBBSD4_OBJS) $(COMMON_OBJS); \
	fi

libbsd4_static: $(LIBBSD4_OBJS) $(COMMON_OBJS) $(PORTABLE_OBJS)
	if [ "$(BUILD_PORTABLE)" = "true" ]; then \
		$(AR) $(ARFLAGS) $(BUILDDIR)/libbsd4.a $^; \
	else \
		$(AR) $(ARFLAGS) $(BUILDDIR)/libbsd4.a $(LIBBSD4_OBJS) $(COMMON_OBJS); \
	fi

$(BUILDDIR):
	mkdir -p $(BUILDDIR)

$(BUILDDIR)/%.o: %.c | $(BUILDDIR)
	$(CC) $(CFLAGS) $(DFT_LIBFLAGS) -c $< -o $@

$(BUILDDIR)/portable:
	mkdir -p $(BUILDDIR)/portable

$(BUILDDIR)/portable/%.o: portable/%.c | $(BUILDDIR)/portable
	$(CC) $(CFLAGS) $(DFT_LIBFLAGS) -c $< -o $@

## Install

install:
	[ -d "$(LIBDIR)" ] || mkdir -pm 2755 "$(LIBDIR)"

	USRGRP=$$(ls -ld "$(LIBDIR)" 2>/dev/null | awk '{print $$3, $$4}'); \
	set -- $$USRGRP; \
	[ "$$1" = "$(USROWN)" ] || chown "$(USROWN)" "$(LIBDIR)"; \
	[ "$$2" = "$(GRPOWN)" ] || chgrp "$(GRPOWN)" "$(LIBDIR)"

	LSPERMS="ls -ld \"$(LIBDIR)\" 2>/dev/null"; \
	PERMS=$($LSPERMS | awk '{print $1}' | cut -c6); \
	[ "$(PERMS)" = "s" ] || chmod g+s "$(LIBDIR)"

	cp -p libbsd4 "$(LIBDIR)"
	chmod 0644 "$(BINDIR)"/*
	chown "$(USROWN):$(GRPOWN)" "$(LIBDIR)"/*

## Clean

clean:
	rm -frv $(BUILDDIR)

.PHONY: all clean install $(BINS)
