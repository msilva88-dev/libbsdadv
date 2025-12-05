/*
 * Copyright (c) 1989, 1993
 *      The Regents of the University of California.  All rights reserved.
 * (c) UNIX System Laboratories, Inc.
 *
 * Modifications to support HyperbolaBSD:
 * Copyright (c) 2025 Hyperbola Project
 *
 * All or some portions of this file are derived from material licensed
 * to the University of California by American Telephone and Telegraph
 * Co. or Unix System Laboratories, Inc. and are reproduced herein with
 * the permission of UNIX System Laboratories, Inc.
 * Portions Copyright(C) 1995, 1996, Jason Downs.  All rights reserved.
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

/* pwd portable internal header from OpenBSD 7.0 source code: include/pwd.h */

#ifndef _LIBBSD4_PORTABLE_PWD_INT_H
#define _LIBBSD4_PORTABLE_PWD_INT_H

#ifdef __cplusplus
extern "C" {
#endif

#include "../pwd_int.h"

#define __dead __attribute__((__noreturn__))

#ifndef _PASSWORD_NOUID
#define _PASSWORD_NOUID 0x01
#endif

#ifndef _PASSWORD_NOGID
#define _PASSWORD_NOGID 0x02
#endif

#ifndef _PASSWORD_NOCHG
#define _PASSWORD_NOCHG 0x04
#endif

#ifndef _PASSWORD_NOEXP
#define _PASSWORD_NOEXP 0x08
#endif

#ifndef _PASSWORD_OMITV7
#define _PASSWORD_OMITV7 0x02
#endif

#ifndef _PASSWORD_SECUREONLY
#define _PASSWORD_SECUREONLY 0x01
#endif

#ifndef _PATH_MASTERPASSWD_LOCK
#define _PATH_MASTERPASSWD_LOCK "/etc/ptmp"
#endif

#ifndef _PATH_PWD_MKDB
#define _PATH_PWD_MKDB "/usr/sbin/pwd_mkdb"
#endif

void pw_error(const char *, int, int) HIDDEN;

#ifdef __cplusplus
}
#endif

#endif
