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

#ifndef _LIBBSD4_PWD_INT_H
#define _LIBBSD4_PWD_INT_H

#include <pwd.h>
#include "features.h"

#ifndef _PASSWORD_LEN
#define _PASSWORD_LEN 128
#endif

#ifndef _PATH_MASTERPASSWD
#define _PATH_MASTERPASSWD "/etc/master.passwd"
#endif

#ifndef _PW_BUF_LEN
#define _PW_BUF_LEN 1024
#endif

#endif
