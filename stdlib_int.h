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

#ifndef _LIBBSD4_STDLIB_INT_H
#define _LIBBSD4_STDLIB_INT_H

#include <stdlib.h>
#include "features.h"

#ifndef MUSL_WITH_BSD

#ifdef __cplusplus
extern "C" {
#endif

char *cgetcap(char *, const char *, int) HIDDEN;
int cgetent(char **, char **, const char *) HIDDEN;
int cgetstr(char *, const char *, char **) HIDDEN;
int cgetustr(char *, const char *, char **) HIDDEN;
long long strtonum(const char *, long long, long long, const char **) HIDDEN;

#ifdef __cplusplus
}
#endif

#endif /* ! MUSL_WITH_BSD */

#endif
