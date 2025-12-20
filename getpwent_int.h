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

#ifndef _LIBBSD4_GETPWEND_INT_H
#define _LIBBSD4_GETPWEND_INT_H

#include "pwd_int.h"

#ifndef _PASSWORD_NOGID
#define _PASSWORD_NOGID 0x02
#endif

#ifndef _PASSWORD_NOUID
#define _PASSWORD_NOUID 0x01
#endif

#ifdef BSDDB

#ifndef _PATH_MP_DB
#define _PATH_MP_DB "/etc/pwd.db"
#endif

#ifndef _PATH_SMP_DB
#define _PATH_SMP_DB "/etc/spwd.db"
#endif

#endif /* BSDDB */

#ifndef _PW_KEYBYNUM
#define _PW_KEYBYNUM '2'
#endif

#ifndef _PW_NAME_LEN
#define _PW_NAME_LEN 31
#endif

#if defined(_BSD_SOURCE) && !defined(LIBC_WITH_BSD)
struct passwd *getpwent(void);
struct passwd *getpwnam(const char *);
#ifdef BSDDB
struct passwd *getpwnam_shadow(const char *);
#endif
struct passwd *getpwuid(uid_t);
#ifdef BSDDB
struct passwd *getpwuid_shadow(uid_t);
#endif
int setpassent(int);
void setpwent(void);
#endif

#endif
