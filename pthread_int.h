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

#include <pthread.h>

#ifndef _LIBBSD4_PTHREAD_INT_H
#define _LIBBSD4_PTHREAD_INT_H

#define _THREAD_PRIVATE_KEY(name) \
	static pthread_mutex_t name##_mutex = PTHREAD_MUTEX_INITIALIZER
#define _THREAD_PRIVATE_MUTEX_LOCK(name) pthread_mutex_lock(&name##_mutex)
#define _THREAD_PRIVATE_MUTEX_UNLOCK(name) pthread_mutex_unlock(&name##_mutex)

#endif
