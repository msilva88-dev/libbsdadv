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

#ifdef __GNUC__
#define DEF_WEAK(x) extern __typeof(x) x __attribute__((weak, visibility("hidden")))
#define HIDDEN __attribute__((__visibility__("hidden")))
#else
#define DEF_WEAK(x)
#define HIDDEN
#endif

#endif
