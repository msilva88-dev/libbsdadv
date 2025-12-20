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

#ifndef _LIBBSD4_PWD_H
#define _LIBBSD4_PWD_H

#include <pwd.h>

#ifndef _PATH_MP_DB
#define _PATH_MP_DB "/etc/pwd.db"
#endif

#ifndef _PATH_SMP_DB
#define _PATH_SMP_DB "/etc/spwd.db"
#endif

#ifdef _BSD_SOURCE
void endpwent(void);
struct passwd *getpwent(void);
struct passwd *getpwnam(const char *);
int getpwnam_r(const char *, struct passwd *, char *, size_t,
	struct passwd **);
struct passwd *getpwnam_shadow(const char *);
struct passwd *getpwuid(uid_t);
int getpwuid_r(uid_t, struct passwd *, char *, size_t, struct passwd **);
struct passwd *getpwuid_shadow(uid_t);
int setpassent(int);
void setpwent(void);
#endif

#endif
