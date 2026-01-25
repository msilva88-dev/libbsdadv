/* SPDX-License-Identifier: CC0-1.0 */

/*
 * Public Domain
 *
 * Modifications to support HyperbolaBSD:
 * Written in 2025-2026 by Hyperbola Project
 *
 * To the extent possible under law, the author(s) have dedicated all copyright
 * and related and neighboring rights to this software to the public domain
 * worldwide. This software is distributed without any warranty.
 *
 * You should have received a copy of the CC0 Public Domain Dedication along
 * with this software. If not, see
 * <https://creativecommons.org/publicdomain/zero/1.0/>.
 */

#ifndef _UNISTD_BSDADV_H
#define _UNISTD_BSDADV_H

#ifdef __cplusplus
extern "C" {
#endif

#include <unistd.h>

#ifdef _BSD_SOURCE
int crypt_checkpass(const char *, const char *);
int crypt_newhash(const char *, const char *, char *, size_t);
int rcmd(char **, int, const char *, const char *, const char *, int *);
int rcmd_af(char **, int, const char *, const char *, const char *, int *,
    int);
int rresvport(int *);
int rresvport_af(int *, int);
int ruserok(const char *, int, const char *, const char *);
#endif

#ifdef __cplusplus
}
#endif

#endif
