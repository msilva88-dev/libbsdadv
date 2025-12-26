/* SPDX-License-Identifier: CC0-1.0 */

/*
 * Public Domain
 *
 * Modifications to support HyperbolaBSD:
 * Written in 2025 by Hyperbola Project
 *
 * To the extent possible under law, the author(s) have dedicated all copyright
 * and related and neighboring rights to this software to the public domain
 * worldwide. This software is distributed without any warranty.
 *
 * You should have received a copy of the CC0 Public Domain Dedication along
 * with this software. If not, see
 * <https://creativecommons.org/publicdomain/zero/1.0/>.
 */

#ifndef _LIBBSD4_FEATURES_INT_H
#define _LIBBSD4_FEATURES_INT_H

#ifndef ALIGN
#undef _ALIGNBYTES
#if defined(__aarch64__) || defined(__powerpc64__) \
	|| (defined(__riscv) && (__riscv_xlen == 64)) || defined(__x86_64__)
#define _ALIGNBYTES (sizeof(long) - 1)
#elif defined(__i386__)
#define _ALIGNBYTES (sizeof(int) - 1)
#else
#define _ALIGNBYTES (sizeof(double) - 1)
#endif
#define ALIGN(p) (((unsigned long)(p) + _ALIGNBYTES) & ~_ALIGNBYTES)
#endif

#ifdef __GNUC__
#define DEF_WEAK(x) \
	extern __typeof(x) x __attribute__((__weak__)); \
	extern __typeof(x) __bsd4_##x __attribute__((__alias__(#x)))
	/*
	 * No trailing ";" after this macro
	 * to prevent Clang's [-Wextra-semi] warning.
	 */
#define FALLTHROUGH_A __attribute__((__fallthrough__))
#define HIDDEN_A __attribute__((__visibility__("hidden")))
#define UNUSED_A __attribute__((__unused__))
#else
#define DEF_WEAK(x)
#define FALLTHROUGH_A
#define HIDDEN_A
#define UNUSED_A
#endif

#endif
