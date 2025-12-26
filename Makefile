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
CBUILD ?= $(CBUILD_CMD)
CHOST ?= $(CBUILD)
CTHREADS ?= $(CTHREADS_CMD)
CPPFLAGS ?= $(CPPFLAGS_CMD)
CC ?= $(CC_CMD)
CFLAGS ?= $(CFLAGS_CMD)
CVER ?= gnu17
DEBUG ?= false
DESTDIR ?=
DIRGRP ?= root
DIROWN ?= root
DIRPERM ?= 0755
DIRPGRP ?= false
ENABLE_BLF ?= false
ENABLE_BSDDB ?= false
ENABLE_GETPW ?= false
ENABLE_SHARED ?= true
ENABLE_DYNAMIC ?= false
ENABLE_YP ?= false
FILEGRP ?= root
FILEOWN ?= root
FILEPERM ?= 0644
INCLUDEDIR ?= $(PREFIX)/include
INCDGRP ?= $(DIRGRP)
INCDOWN ?= $(DIROWN)
INCDPERM ?= $(DIRPERM)
INCFGRP ?= $(FILEGRP)
INCFOWN ?= $(FILEOWN)
INCFPERM ?= $(FILEPERM)
LD ?= $(LD_CMD)
LDHSTYLE ?= both
LDHSTYLE_LEG ?= gnu
LIBDIR ?= lib
LIBDGRP ?= $(DIRGRP)
LIBDOWN ?= $(DIROWN)
LIBDPERM ?= $(DIRPERM)
LIBFGRP ?= $(FILEGRP)
LIBFOWN ?= $(FILEOWN)
LIBFPERM ?= $(FILEPERM)
MANDIR ?= $(SHAREDIR)/man
MANDGRP ?= $(DIRGRP)
MANDOWN ?= $(DIROWN)
MANDPERM ?= $(DIRPERM)
MANFGRP ?= $(FILEGRP)
MANFOWN ?= $(FILEOWN)
MANFPERM ?= $(FILEPERM)
MARCH ?= $(MARCH_CMD)
PREFIX ?= usr
PFIXOWN ?= $(DIRGRP)
PFIXGRP ?= $(DIROWN)
PFIXPERM ?= $(DIRPERM)
PKG_CONFIG ?= $(PKG_CONFIG_CMD)
SHAREDIR ?= $(PREFIX)/share
SHRDOWN ?= $(DIRGRP)
SHRDGRP ?= $(DIROWN)
SHRDPERM ?= $(DIRPERM)
USE_LIBC_WITH_BSDLIB ?= $(USE_LIBC_WITH_BSDLIB_CMD)

# Number of CPU threads for parallel compilation
CTHREADS_CMD != sh -c '\
getconf _NPROCESSORS_ONLN 2>/dev/null || printf "%d" 1 \
' 2>/dev/null

# Target architecture flags
CARCH_CMD != sh -c 'uname -m 2>/dev/null || printf "%s" "x86_64"' 2>/dev/null
COS_CMD != sh -c '\
uname -s 2>/dev/null || printf "%s" "Linux" \
' 2>/dev/null
CBUILD_CMD != sh -c '\
case "$(COS_CMD)" in \
    OpenBSD) \
        printf "%s-pc-%s" "$(CARCH)" "openbsd" \
        ;; \
    HyperbolaBSD) \
        printf "%s-pc-%s" "$(CARCH)" "hyperbolabsd" \
        ;; \
    *Linux|*) \
        _G=$(ldd --version 2>&1 | head -n 1 | cut -d"(" -f2 | cut -d")" -f1) \
        if [ "${_G}" = "GNU libc" ]; then \
            printf "%s-pc-%s" "$(CARCH)" "linux-gnu"; \
        else \
            printf "%s-pc-%s" "$(CARCH)" "linux-musl"; \
        fi \
        ;; \
esac \
' 2>/dev/null || true
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
USE_LIBC_WITH_BSDLIB_CMD != sh -c '\
case "$(CHOST)" in \
    *-hyperbolabsd*|*-openbsd*) \
        printf "%s" "true" \
        ;; \
    *-linux-gnu*|*-linux-musl*|*) \
        printf "%s" "false" \
        ;; \
esac \
' 2>/dev/null
BUILD_PORTABLE_CMD != sh -c '\
case "$(USE_LIBC_WITH_BSDLIB)" in \
    true) \
        printf "%s" "false" \
        ;; \
    false|*) \
        printf "%s" "true" \
        ;; \
esac \
' 2>/dev/null

# Target library flags
BUILD_LIBRARY_CMD != sh -c '\
_DYNAMIC=""; \
_STATIC=""; \
_SP=""; \
[ "$(ENABLE_DYNAMIC)" = "true" ] && _DYNAMIC="$(BUILDDIR)/libbsd4.so"; \
[ "$(ENABLE_STATIC)" = "true" ] && _STATIC="$(BUILDDIR)/libbsd4.a"; \
if [ -z "$${_DYNAMIC}" ] && [ -z "$${_STATIC}" ]; then \
    _DYNAMIC="$(BUILDDIR)/libbsd4.so"; \
fi; \
[ -n "$${_DYNAMIC}" ] && _SP=" "; \
printf "%s%s%s" "$${_DYNAMIC}" "$${_SP}" "$${_STATIC}" \
' 2>/dev/null

# Default static archiver command flags
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

# Default linker command flags
LD_PATH_CMD != sh -c '\
command -v mold 2>/dev/null || command -v lld 2>/dev/null \
  || command -v ld.gold 2>/dev/null || command -v ld.bfd 2>/dev/null \
  || command -v ld 2>/dev/null  || printf "%s" "ld.bfd" \
' 2>/dev/null
LD_CMD != printf "%s" "$(LD_PATH_CMD)" | sed "s|.*/||" 2>/dev/null

# Default package configurator command flags
PKG_CONFIG_PATH_CMD != sh -c '\
command -v pkg-config 2>/dev/null || printf "%s" "pkg-config" \
' 2>/dev/null
PKG_CONFIG_CMD != printf "%s" "$(PKG_CONFIG_PATH_CMD)" | sed "s|.*/||" 2>/dev/null


## Compiler

# Optional Feature Flags
OPTFLAG_BLF_CMD != sh -c '\
case "$(ENABLE_BLF)" in \
    true) \
        printf "%s%s" "-D" "BLF" \
        ;; \
    false|*) \
        printf "%s%s" "" "" \
        ;; \
esac \
' 2>/dev/null
OPTFLAG_BSDDB_CMD != sh -c '\
case "$(ENABLE_BSDDB)" in \
    true) \
        printf "%s%s" "-D" "BSDDB" \
        ;; \
    false|*) \
        printf "%s%s" "" "" \
        ;; \
esac \
' 2>/dev/null
OPTFLAG_LIBCBSD_CMD != sh -c '\
case "$(USE_LIBC_WITH_BSDLIB)" in \
    true) \
        printf "%s%s" "-D" "LIBC_WITH_BSD" \
        ;; \
    false|*) \
        printf "%s%s" "" "" \
        ;; \
esac \
' 2>/dev/null
OPTFLAG_YP_CMD != sh -c '\
case "$(ENABLE_YP)" in \
    true) \
        printf "%s%s" "-D" "YP" \
        ;; \
    false|*) \
        printf "%s%s" "" "" \
        ;; \
esac \
' 2>/dev/null
OPTFLAG_RPC_HDR_CMD != sh -c '\
case "$(ENABLE_YP)" in \
    true) \
        $(PKG_CONFIG) --cflags libtirpc \
        ;; \
    false|*) \
        printf "%s" "" \
        ;; \
esac \
' 2>/dev/null

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
DFT_GENFLAGS_LLVM := $(DFT_GENFLAGS_CMD) $(LD_GENFLAGS_LLVM_CMD)
DFT_GENFLAGS_GCC := $(DFT_GENFLAGS_CMD)
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
DFT_COMPFLAGS := $(DFT_OPTMFLAGS_CMD)
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
DFT_LIBFLAGS_CMD != sh -c '\
if [ "$(ENABLE_DYNAMIC)" != "true" ] \
  || [ "$(ENABLE_STATIC)" = "true" ]; \
then \
    printf "%s" ""; \
else \
    printf "%s%s" "-f" "PIC"; \
fi \
' 2>/dev/null

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
DFT_CFLAGS := -fno-exceptions

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
' 2>/dev/null || true

# Warning Flags
DFT_WFLAGS := -Wall
DFT_WFLAGS += -Wextra
DFT_WFLAGS += -Wimplicit-fallthrough
DFT_WFLAGS += -Wpedantic

# Compiler Flags
CFLAGS_CMD != sh -c '\
case "$(CC)" in \
    clang*) \
        printf "%s %s %s -std=%s %s %s %s" \
          "$(DFT_GENFLAGS_LLVM)" "$(DFT_COMPFLAGS_CMD)" \
          "$(DFT_CFMLFLAGS_CMD)" "$(CVER)" "$(DFT_CFLAGS)" "$(DFT_WFLAGS)" \
        ;; \
    gcc*) \
        printf "%s %s %s -std=%s %s %s %s" \
          "$(DFT_GENFLAGS_GCC)" "$(DFT_COMPFLAGS_CMD)" \
          "$(DFT_CFMLFLAGS_CMD)" "$(CVER)" "$(DFT_CFLAGS)" "$(DFT_WFLAGS)" \
        ;; \
    *) \
        printf "%s %s %s -std=%s %s %s %s" \
          "$(DFT_GENFLAGS)" "$(DFT_COMPFLAGS_CMD)" \
          "$(DFT_CFMLFLAGS_CMD)" "$(CVER)" "$(DFT_CFLAGS)" "$(DFT_WFLAGS)" \
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
DFT_LDFLAGS := $(DFT_GENLDFLAGS_CMD),$(DFT_OPTMFLAGS_CMD)
DFT_LDFLAGS := $(DFT_LDFLAGS),-z,defs
DFT_LDFLAGS := $(DFT_LDFLAGS),-z,noexecstack
DFT_LDFLAGS := $(DFT_LDFLAGS),-z,now
DFT_LDFLAGS := $(DFT_LDFLAGS),-z,relro
DFT_LDFLAGS := $(DFT_LDFLAGS),--gc-sections
DFT_LDFLAGS := $(DFT_LDFLAGS),--build-id
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

# Linker Flags for optional libraries
LNK_LDFLAG_YP_CMD != sh -c '\
case "$(ENABLE_YP)" in \
    true) \
        printf "%s%s %s%s" "-l" "tirpc" "-l" "nsl" \
        ;; \
    false|*) \
        printf "%s%s" "" "" \
        ;; \
esac \
' 2>/dev/null
LNK_LDFLAGS := $(LNK_LDFLAG_YP_CMD)

# Linker Flags for shared code
DFT_SHAREDLDFLAGS := -shared

# Linker Flags
LDFLAGS := $(DFT_LDFLAGS_CMD)

## Make macros

LIBS := $(BUILD_LIBRARY_CMD)

COMMON_OBJS :=
PORTABLE_SHA2_INT_OBJ_CMD != sh -c '\
case "$(ENABLE_BLF)" in \
    true) \
        printf "%s" "$(BUILDDIR)/portable/sha2_int.o" \
        ;; \
    false|*) \
        printf "%s" "" \
        ;; \
esac \
' 2>/dev/null
PORTABLE_OBJS := $(BUILDDIR)/portable/arc4random_int.o
PORTABLE_OBJS += $(BUILDDIR)/portable/bcrypt_int_ptb.o
PORTABLE_OBJS += $(BUILDDIR)/portable/getcap_int.o
PORTABLE_OBJS += $(BUILDDIR)/portable/passwd_int.o
PORTABLE_OBJS += $(BUILDDIR)/portable/pw_dup_int.o
PORTABLE_OBJS += $(PORTABLE_SHA2_INT_OBJ_CMD)
PORTABLE_OBJS += $(BUILDDIR)/portable/strtonum_int.o
PORTABLE_OBJS += $(BUILDDIR)/portable/timingsafe_bcmp_int.o
LIBBSD4_BCRYPT_PBKDF_OBJ_CMD != sh -c '\
case "$(ENABLE_BLF)" in \
    true) \
        printf "%s" "$(BUILDDIR)/bcrypt_pbkdf.o" \
        ;; \
    false|*) \
        printf "%s" "" \
        ;; \
esac \
' 2>/dev/null
LIBBSD4_GETPWENT_OBJ_CMD != sh -c '\
case "$(ENABLE_GETPW)" in \
    true) \
        printf "%s" "$(BUILDDIR)/getpwent.o" \
        ;; \
    false|*) \
        printf "%s" "" \
        ;; \
esac \
' 2>/dev/null
LIBBSD4_YP_CHECK_INT_OBJ_CMD != sh -c '\
case "$(ENABLE_GETPW)" in \
    true) \
        case "$(ENABLE_YP)" in \
            true) \
                printf "%s" "$(BUILDDIR)/yp_check_int.o" \
                ;; \
            false|*) \
                printf "%s" "" \
                ;; \
        esac \
        ;; \
    false|*) \
        printf "%s" "" \
        ;; \
esac \
' 2>/dev/null
LIBBSD4_YPEXCLUDE_INT_OBJ_CMD != sh -c '\
case "$(ENABLE_GETPW)" in \
    true) \
        case "$(ENABLE_YP)" in \
            true) \
                printf "%s" "$(BUILDDIR)/ypexclude_int.o" \
                ;; \
            false|*) \
                printf "%s" "" \
                ;; \
        esac \
        ;; \
    false|*) \
        printf "%s" "" \
        ;; \
esac \
' 2>/dev/null
LIBBSD4_OBJS := $(BUILDDIR)/authenticate.o $(BUILDDIR)/auth_subr.o
LIBBSD4_OBJS += $(BUILDDIR)/bcrypt_int.o $(LIBBSD4_BCRYPT_PBKDF_OBJ_CMD)
LIBBSD4_OBJS += $(BUILDDIR)/blowfish.o $(BUILDDIR)/check_expire.o
LIBBSD4_OBJS += $(BUILDDIR)/cryptutil.o $(BUILDDIR)/fparseln.o
LIBBSD4_OBJS += $(BUILDDIR)/getnetgrent.o $(LIBBSD4_GETPWENT_OBJ_CMD)
LIBBSD4_OBJS += $(BUILDDIR)/login_cap.o $(LIBBSD4_YP_CHECK_INT_OBJ_CMD)
LIBBSD4_OBJS += $(LIBBSD4_YPEXCLUDE_INT_OBJ_CMD)

LIBBSD4_BLF_HDR_CMD != sh -c '\
case "$(ENABLE_BLF)" in \
    true) \
        printf "%s" "blf.h" \
        ;; \
    false|*) \
        printf "%s" "" \
        ;; \
esac \
' 2>/dev/null
LIBBSD4_PWD_HDR_CMD != sh -c '\
case "$(ENABLE_GETPW)" in \
    true) \
        case "$(ENABLE_BSDDB)" in \
            true) \
                printf "%s" "pwd_bsd4.h" \
                ;; \
            false|*) \
                printf "%s" "pwd_bsd4_without_bsddb.h" \
                ;; \
        esac \
        ;; \
    false|*) \
        printf "%s" "" \
        ;; \
esac \
' 2>/dev/null
LIBBSD4_UTIL_HDR_CMD != sh -c '\
case "$(ENABLE_BLF)" in \
    true) \
        printf "%s" "util_bsd4_with_blf.h" \
        ;; \
    false|*) \
        printf "%s" "util_bsd4.h" \
        ;; \
esac \
' 2>/dev/null
LIBBSD4_HDRS := $(LIBBSD4_BLF_HDR_CMD) bsd_auth.h netgroup.h login_cap.h
LIBBSD4_HDRS += $(LIBBSD4_PWD_HDR_CMD) unistd_bsd4.h $(LIBBSD4_UTIL_HDR_CMD)

LIBBSD4_BLF_MAN_CMD != sh -c '\
case "$(ENABLE_BLF)" in \
    true) \
        printf "%s" "bcrypt_pbkdf.3 blowfish.3" \
        ;; \
    false|*) \
        printf "%s" "" \
        ;; \
esac \
' 2>/dev/null
LIBBSD4_GETPW_MAN_CMD != sh -c '\
case "$(ENABLE_GETPW)" in \
    true) \
        printf "%s" "getpwent.3 getpwnam.3" \
        ;; \
    false|*) \
        printf "%s" "" \
        ;; \
esac \
' 2>/dev/null
LIBBSD4_MANS := authenticate.3 auth_subr.3 $(LIBBSD4_BLF_MAN_CMD)
LIBBSD4_MANS += check_expire.3 crypt_checkpass.3 fparseln.3 getnetgrent.3
LIBBSD4_MANS += $(LIBBSD4_GETPW_MAN_CMD) login_cap.3

## build

all: $(BUILDDIR) $(BUILDDIR)/portable $(LIBS)

$(BUILDDIR):
	mkdir -p "$(BUILDDIR)"
$(BUILDDIR)/portable:
	mkdir -p "$(BUILDDIR)/portable"
$(BUILDDIR)/authenticate.o: authenticate.c
	$(CC) $(CFLAGS) $(OPTFLAG_LIBCBSD_CMD) $(DFT_LIBFLAGS_CMD) -c $? -o $@
$(BUILDDIR)/auth_subr.o: auth_subr.c
	$(CC) $(CFLAGS) $(OPTFLAG_LIBCBSD_CMD) $(DFT_LIBFLAGS_CMD) -c $? -o $@
$(BUILDDIR)/bcrypt_int.o: bcrypt_int.c
	$(CC) $(CFLAGS) $(OPTFLAG_LIBCBSD_CMD) $(DFT_LIBFLAGS_CMD) -c $? -o $@
$(BUILDDIR)/blowfish.o: blowfish.c
	$(CC) $(CFLAGS) \
	  $(OPTFLAG_BLF_CMD) $(OPTFLAG_LIBCBSD_CMD) $(DFT_LIBFLAGS_CMD) \
	  -c $? -o $@
$(BUILDDIR)/bcrypt_pbkdf.o: bcrypt_pbkdf.c
	$(CC) $(CFLAGS) $(OPTFLAG_LIBCBSD_CMD) $(DFT_LIBFLAGS_CMD) -c $? -o $@
$(BUILDDIR)/check_expire.o: check_expire.c
	$(CC) $(CFLAGS) $(OPTFLAG_LIBCBSD_CMD) $(DFT_LIBFLAGS_CMD) -c $? -o $@
$(BUILDDIR)/cryptutil.o: cryptutil.c
	$(CC) $(CFLAGS) $(OPTFLAG_LIBCBSD_CMD) $(DFT_LIBFLAGS_CMD) -c $? -o $@
$(BUILDDIR)/fparseln.o: fparseln.c
	$(CC) $(CFLAGS) $(DFT_LIBFLAGS_CMD) -c $? -o $@
$(BUILDDIR)/getnetgrent.o: getnetgrent.c
	$(CC) $(CFLAGS) \
	  $(OPTFLAG_BSDDB_CMD) $(OPTFLAG_YP_CMD) $(DFT_LIBFLAGS_CMD) -c $? -o $@
$(BUILDDIR)/getpwent.o: getpwent.c
	$(CC) $(CFLAGS) \
	  $(OPTFLAG_BSDDB_CMD) $(OPTFLAG_YP_CMD) $(OPTFLAG_RPC_HDR_CMD) \
	  $(DFT_LIBFLAGS_CMD) -c $? -o $@
$(BUILDDIR)/login_cap.o: login_cap.c
	$(CC) $(CFLAGS) $(OPTFLAG_LIBCBSD_CMD) $(DFT_LIBFLAGS_CMD) -c $? -o $@
$(BUILDDIR)/yp_check_int.o: yp_check_int.c
	$(CC) $(CFLAGS) $(DFT_LIBFLAGS_CMD) -c $? -o $@
$(BUILDDIR)/ypexclude_int.o: ypexclude_int.c
	$(CC) $(CFLAGS) $(DFT_LIBFLAGS_CMD) -c $? -o $@
$(BUILDDIR)/portable/arc4random_int.o: portable/arc4random_int.c
	$(CC) $(CFLAGS) $(DFT_LIBFLAGS_CMD) -c $? -o $@
$(BUILDDIR)/portable/bcrypt_int_ptb.o: portable/bcrypt_int_ptb.c
	$(CC) $(CFLAGS) $(OPTFLAG_BLF_CMD) $(DFT_LIBFLAGS_CMD) -c $? -o $@
$(BUILDDIR)/portable/getcap_int.o: portable/getcap_int.c
	$(CC) $(CFLAGS) $(OPTFLAG_BSDDB_CMD) $(DFT_LIBFLAGS_CMD) -c $? -o $@
$(BUILDDIR)/portable/passwd_int.o: portable/passwd_int.c
	$(CC) $(CFLAGS) $(DFT_LIBFLAGS_CMD) -c $? -o $@
$(BUILDDIR)/portable/pw_dup_int.o: portable/pw_dup_int.c
	$(CC) $(CFLAGS) $(DFT_LIBFLAGS_CMD) -c $? -o $@
$(BUILDDIR)/portable/sha2_int.o: portable/sha2_int.c
	$(CC) $(CFLAGS) $(DFT_LIBFLAGS_CMD) -c $? -o $@
$(BUILDDIR)/portable/strtonum_int.o: portable/strtonum_int.c
	$(CC) $(CFLAGS) $(DFT_LIBFLAGS_CMD) -c $? -o $@
$(BUILDDIR)/portable/timingsafe_bcmp_int.o: portable/timingsafe_bcmp_int.c
	$(CC) $(CFLAGS) $(DFT_LIBFLAGS_CMD) -c $? -o $@
$(BUILDDIR)/libbsd4.so: $(LIBBSD4_OBJS) $(COMMON_OBJS) $(PORTABLE_OBJS)
	if [ "$(BUILD_PORTABLE_CMD)" = "true" ]; then \
	    $(CC) $(LDFLAGS) $(DFT_SHAREDLDFLAGS) \
	      -o "$(BUILDDIR)/libbsd4.so" $? $(LNK_LDFLAGS); \
	else \
	    $(CC) $(LDFLAGS) $(DFT_SHAREDLDFLAGS) \
	      -o "$(BUILDDIR)/libbsd4.so" \
              $(LIBBSD4_OBJS) $(COMMON_OBJS) $(LNK_LDFLAGS); \
	fi
$(BUILDDIR)/libbsd4.a: $(LIBBSD4_OBJS) $(COMMON_OBJS) $(PORTABLE_OBJS)
	if [ "$(BUILD_PORTABLE_CMD)" = "true" ]; then \
	    $(AR) $(ARFLAGS) "$(BUILDDIR)/libbsd4.a" $?; \
	else \
	    $(AR) $(ARFLAGS) "$(BUILDDIR)/libbsd4.a" \
              $(LIBBSD4_OBJS) $(COMMON_OBJS); \
	fi

## Install

install: install-hdr install-lib install-man

install-hdr: $(LIBBSD4_HDRS)
	([ -d "$(DESTDIR)/$(PREFIX)" ] || [ "$(DESTDIR)/$(PREFIX)" = "/" ]) \
	  || mkdir -pm "$(PFIXPERM)" "$(DESTDIR)/$(PREFIX)"
	( \
	    [ -d "$(DESTDIR)/$(INCLUDEDIR)" ] \
	    || [ "$(DESTDIR)/$(INCLUDEDIR)" = "/" ] \
	) \
	  || mkdir -pm "$(INCDPERM)" "$(DESTDIR)/$(INCLUDEDIR)"

	OGDIR="$(DESTDIR)/$(PREFIX)"; \
	OWNGRP=$$(ls -ld "$${OGDIR}" 2>/dev/null | awk '{print $$3, $$4}'); \
	set -- "$${OWNGRP}"; \
	[ "$$1" = "$(PFIXOWN)" ] \
	  || chown "$(PFIXOWN)" "$(DESTDIR)/$(PREFIX)"; \
	[ "$$2" = "$(PFIXGRP)" ] \
	  || chgrp "$(PFIXGRP)" "$(DESTDIR)/$(PREFIX)"

	if [ "$(DIRPGRP)" = "true" ]; then \
	    LSPERMS="ls -ld \"$(DESTDIR)/$(PREFIX)\" 2>/dev/null"; \
	    PERMS=$("$${LSPERMS}" | awk '{print $1}' | cut -c6); \
	    [ "$(PERMS)" = "s" ] || chmod g+s "$(DESTDIR)/$(PREFIX)"; \
	fi

	OGDIR="$(DESTDIR)/$(INCLUDEDIR)"; \
	OWNGRP=$$(ls -ld "$${OGDIR}" 2>/dev/null | awk '{print $$3, $$4}'); \
	set -- "$${OWNGRP}"; \
	[ "$$1" = "$(INCDOWN)" ] \
	  || chown "$(INCDOWN)" "$(DESTDIR)/$(INCLUDEDIR)"; \
	[ "$$2" = "$(INCDGRP)" ] \
	  || chgrp "$(INCDGRP)" "$(DESTDIR)/$(INCLUDEDIR)"

	if [ "$(DIRPGRP)" = "true" ]; then \
	    LSPERMS="ls -ld \"$(DESTDIR)/$(SHAREDIR)\" 2>/dev/null"; \
	    PERMS=$("$${LSPERMS}" | awk '{print $1}' | cut -c6); \
	    [ "$(PERMS)" = "s" ] || chmod g+s "$(DESTDIR)/$(SHAREDIR)"; \
	fi

	cp -p $(LIBBSD4_HDRS) "$(DESTDIR)/$(INCLUDEDIR)"
	for FILE in $(LIBBSD4_HDRS); do \
	    chmod "$(INCFPERM)" \
	      "$(DESTDIR)/$(INCLUDEDIR)/$${FILE}"; \
	    chown "$(INCFOWN):$(INCFGRP)" \
	      "$(DESTDIR)/$(INCLUDEDIR)/$${FILE}"; \
	done
	[ ! -f "$(DESTDIR)/$(INCLUDEDIR)/pwd_bsd4_without_bsddb.h" ] \
	    || mv "$(DESTDIR)/$(INCLUDEDIR)/pwd_bsd4_without_bsddb.h" \
	    "$(DESTDIR)/$(INCLUDEDIR)/pwd_bsd4.h"
	[ ! -f "$(DESTDIR)/$(INCLUDEDIR)/util_bsd4_with_blf.h" ] \
	    || mv "$(DESTDIR)/$(INCLUDEDIR)/util_bsd4_with_blf.h" \
	    "$(DESTDIR)/$(INCLUDEDIR)/util_bsd4.h"

install-lib:
	([ -d "$(DESTDIR)/$(PREFIX)" ] || [ "$(DESTDIR)/$(PREFIX)" = "/" ]) \
	  || mkdir -pm "$(PFIXPERM)" "$(DESTDIR)/$(PREFIX)"
	([ -d "$(DESTDIR)/$(LIBDIR)" ] || [ "$(DESTDIR)/$(LIBDIR)" = "/" ]) \
	  || mkdir -pm "$(LIBDPERM)" "$(DESTDIR)/$(LIBDIR)"

	OGDIR="$(DESTDIR)/$(PREFIX)"; \
	OWNGRP=$$(ls -ld "$${OGDIR}" 2>/dev/null | awk '{print $$3, $$4}'); \
	set -- "$${OWNGRP}"; \
	[ "$$1" = "$(PFIXOWN)" ] \
	  || chown "$(PFIXOWN)" "$(DESTDIR)/$(PREFIX)"; \
	[ "$$2" = "$(PFIXGRP)" ] \
	  || chgrp "$(PFIXGRP)" "$(DESTDIR)/$(PREFIX)"

	if [ "$(DIRPGRP)" = "true" ]; then \
	    LSPERMS="ls -ld \"$(DESTDIR)/$(PREFIX)\" 2>/dev/null"; \
	    PERMS=$("$${LSPERMS}" | awk '{print $1}' | cut -c6); \
	    [ "$(PERMS)" = "s" ] || chmod g+s "$(DESTDIR)/$(PREFIX)"; \
	fi

	OGDIR="$(DESTDIR)/$(LIBDIR)"; \
	OWNGRP=$$(ls -ld "$${OGDIR}" 2>/dev/null | awk '{print $$3, $$4}'); \
	set -- "$${OWNGRP}"; \
	[ "$$1" = "$(LIBDOWN)" ] \
	  || chown "$(LIBDOWN)" "$(DESTDIR)/$(LIBDIR)"; \
	[ "$$2" = "$(LIBDGRP)" ] \
	  || chgrp "$(LIBDGRP)" "$(DESTDIR)/$(LIBDIR)"

	if [ "$(DIRPGRP)" = "true" ]; then \
	    LSPERMS="ls -ld \"$(DESTDIR)/$(LIBDIR)\" 2>/dev/null"; \
	    PERMS=$("$${LSPERMS}" | awk '{print $1}' | cut -c6); \
	    [ "$(PERMS)" = "s" ] || chmod g+s "$(DESTDIR)/$(LIBDIR)"; \
	fi

	cp -p $(LIBS) "$(DESTDIR)/$(LIBDIR)"
	for FILE in $(ls "$(BUILDDIR)/libbsd4."* | xargs -n1 basename); do \
	    chmod "$(LIBFPERM)" \
	      "$(DESTDIR)/$(LIBDIR)/$${FILE}"; \
	    chown "$(LIBFOWN):$(LIBFGRP)" \
	      "$(DESTDIR)/$(LIBDIR)/$${FILE}"; \
	done

## Install Manuals

install-man: $(LIBBSD4_MANS)
	([ -d "$(DESTDIR)/$(PREFIX)" ] || [ "$(DESTDIR)/$(PREFIX)" = "/" ]) \
	  || mkdir -pm "$(PFIXPERM)" "$(DESTDIR)/$(PREFIX)"
	( \
	    [ -d "$(DESTDIR)/$(SHAREDIR)" ] \
	    || [ "$(DESTDIR)/$(SHAREDIR)" = "/" ] \
	) \
	  || mkdir -pm "$(SHRDPERM)" "$(DESTDIR)/$(SHAREDIR)"
	([ -d "$(DESTDIR)/$(MANDIR)" ] || [ "$(DESTDIR)/$(MANDIR)" = "/" ]) \
	  || mkdir -pm "$(MANDPERM)" "$(DESTDIR)/$(MANDIR)"
	[ -d "$(DESTDIR)/$(MANDIR)/man3" ] \
	  || mkdir -pm "$(MANDPERM)" "$(DESTDIR)/$(MANDIR)/man3"

	OGDIR="$(DESTDIR)/$(PREFIX)"; \
	OWNGRP=$$(ls -ld "$${OGDIR}" 2>/dev/null | awk '{print $$3, $$4}'); \
	set -- "$${OWNGRP}"; \
	[ "$$1" = "$(PFIXOWN)" ] \
	  || chown "$(PFIXOWN)" "$(DESTDIR)/$(PREFIX)"; \
	[ "$$2" = "$(PFIXGRP)" ] \
	  || chgrp "$(PFIXGRP)" "$(DESTDIR)/$(PREFIX)"

	if [ "$(DIRPGRP)" = "true" ]; then \
	    LSPERMS="ls -ld \"$(DESTDIR)/$(PREFIX)\" 2>/dev/null"; \
	    PERMS=$("$${LSPERMS}" | awk '{print $1}' | cut -c6); \
	    [ "$(PERMS)" = "s" ] || chmod g+s "$(DESTDIR)/$(PREFIX)"; \
	fi

	OGDIR="$(DESTDIR)/$(SHAREDIR)"; \
	OWNGRP=$$(ls -ld "$${OGDIR}" 2>/dev/null | awk '{print $$3, $$4}'); \
	set -- "$${OWNGRP}"; \
	[ "$$1" = "$(SHRDOWN)" ] \
	  || chown "$(SHRDOWN)" "$(DESTDIR)/$(SHAREDIR)"; \
	[ "$$2" = "$(SHRDGRP)" ] \
	  || chgrp "$(SHRDGRP)" "$(DESTDIR)/$(SHAREDIR)"

	if [ "$(DIRPGRP)" = "true" ]; then \
	    LSPERMS="ls -ld \"$(DESTDIR)/$(SHAREDIR)\" 2>/dev/null"; \
	    PERMS=$("$${LSPERMS}" | awk '{print $1}' | cut -c6); \
	    [ "$(PERMS)" = "s" ] || chmod g+s "$(DESTDIR)/$(SHAREDIR)"; \
	fi

	OGDIR="$(DESTDIR)/$(MANDIR)"; \
	OWNGRP=$$(ls -ld "$${OGDIR}" 2>/dev/null | awk '{print $$3, $$4}'); \
	set -- "$${OWNGRP}"; \
	[ "$$1" = "$(MANDOWN)" ] \
	  || chown "$(MANDOWN)" "$(DESTDIR)/$(MANDIR)"; \
	[ "$$2" = "$(MANDGRP)" ] \
	  || chgrp "$(MANDGRP)" "$(DESTDIR)/$(MANDIR)"

	if [ "$(DIRPGRP)" = "true" ]; then \
	    LSPERMS="ls -ld \"$(DESTDIR)/$(MANDIR)\" 2>/dev/null"; \
	    PERMS=$("$${LSPERMS}" | awk '{print $1}' | cut -c6); \
	    [ "$(PERMS)" = "s" ] || chmod g+s "$(DESTDIR)/$(MANDIR)"; \
	fi

	OGDIR="$(DESTDIR)/$(MANDIR)/man3"; \
	OWNGRP=$$(ls -ld "$${OGDIR}" 2>/dev/null | awk '{print $$3, $$4}'); \
	set -- "$${OWNGRP}"; \
	[ "$$1" = "$(MANDOWN)" ] \
	  || chown "$(MANDOWN)" "$(DESTDIR)/$(MANDIR)/man3"; \
	[ "$$2" = "$(MANDGRP)" ] \
	  || chgrp "$(MANDGRP)" "$(DESTDIR)/$(MANDIR)/man3"

	if [ "$(DIRPGRP)" = "true" ]; then \
	    LSPERMS="ls -ld \"$(DESTDIR)/$(MANDIR)/man3\" 2>/dev/null"; \
	    PERMS=$("$${LSPERMS}" | awk '{print $1}' | cut -c6); \
	    [ "$(PERMS)" = "s" ] || chmod g+s "$(DESTDIR)/$(MANDIR)/man3"; \
	fi

	cp -p $(LIBBSD4_MANS) "$(DESTDIR)/$(MANDIR)/man3"
	for FILE in $(LIBBSD4_MANS); do \
	    chmod "$(MANFPERM)" \
	      "$(DESTDIR)/$(MANDIR)/man3/$${FILE}"; \
	    chown "$(MANFOWN):$(MANFGRP)" \
	      "$(DESTDIR)/$(MANDIR)/man3/$${FILE}"; \
	done

## Clean

clean:
	rm -frv "$(BUILDDIR)"

.PHONY: all clean install install-hdr install-lib install-man $(LIBS)
