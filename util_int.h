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

#ifndef _LIBBSD4_UTIL_INT_H
#define _LIBBSD4_UTIL_INT_H

#ifdef MUSL_WITH_BSD
#include <util.h>
#else
int pw_abort(void) HIDDEN;
void pw_copy(int, int, const struct passwd *, const struct passwd *) HIDDEN;
void pw_init(void) HIDDEN;
int pw_lock(int) HIDDEN;
int pw_mkdb(char *, int) HIDDEN;
#endif

#endif
