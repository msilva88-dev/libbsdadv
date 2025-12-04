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

#ifndef _UTIL_BSD4_H
#define _UTIL_BSD4_H

#ifdef __cplusplus
extern "C" {
#endif

#include <util.h>

struct __sFILE;

char *fparseln(struct __sFILE *, size_t *, size_t *, const char[3], int);
int login_check_expire(struct __sFILE *, struct passwd *, char *, int);

#ifdef __cplusplus
}
#endif

#endif
