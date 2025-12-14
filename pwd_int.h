/* SPDX-License-Identifier: BSD-3-Clause */

/*
 * Copyright (c) 1989, 1993
 *      The Regents of the University of California.  All rights reserved.
 * (c) UNIX System Laboratories, Inc.
 *
 * All or some portions of this file are derived from material licensed
 * to the University of California by American Telephone and Telegraph
 * Co. or Unix System Laboratories, Inc. and are reproduced herein with
 * the permission of UNIX System Laboratories, Inc.
 * Portions Copyright(C) 1995, 1996, Jason Downs.  All rights reserved.
 *
 * Modifications to support HyperbolaBSD:
 * Copyright (c) 2025 Hyperbola Project
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. Neither the name of the University nor the names of its contributors
 *    may be used to endorse or promote products derived from this software
 *    without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 */

/* pwd internal header from OpenBSD 7.0 source code: include/pwd.h */

#ifndef _LIBBSD4_PWD_INT_H
#define _LIBBSD4_PWD_INT_H

#include <sys/types.h>
#include "features.h"

#ifdef LIBC_WITH_BSD
#include <pwd.h>
#else

struct passwd {
	char *pw_name;
	char *pw_passwd; // linux/bsd
	uid_t pw_uid;
	gid_t pw_gid;
	time_t pw_change; //bsd
	char *pw_class; // bsd
	char *pw_gecos; // linux/bsd
	char *pw_dir;
	char *pw_shell;
	time_t pw_expire; // bsd
};

#ifdef _BSD_SOURCE
void endpwent(void);
int getpwnam_r(const char *, struct passwd *, char *, size_t, struct passwd **);
int getpwuid_r(uid_t, struct passwd *, char *, size_t, struct passwd **);

/* internal code */
int bcrypt_checkpass(const char *, const char *) HIDDEN_A;
int bcrypt_newhash(const char *, int, char *, size_t) HIDDEN_A;
struct passwd *pw_dup(const struct passwd *) HIDDEN_A;
#endif

#endif

#ifndef _PASSWORD_LEN
#define _PASSWORD_LEN 128
#endif

#ifndef _PATH_MASTERPASSWD
#define _PATH_MASTERPASSWD "/etc/master.passwd"
#endif

#ifndef _PW_BUF_LEN
#define _PW_BUF_LEN 1024
#endif

int _bcrypt_autorounds(void) HIDDEN_A;

#endif
