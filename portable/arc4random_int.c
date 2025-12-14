/* SPDX-License-Identifier: ISC */

/*
 * Copyright (c) 1996, David Mazieres <dm@uun.org>
 * Copyright (c) 2008, Damien Miller <djm@openbsd.org>
 * Copyright (c) 2013, Markus Friedl <markus@openbsd.org>
 * Copyright (c) 2014, Theo de Raadt <deraadt@openbsd.org>
 *
 * Modifications to support HyperbolaBSD:
 * Copyright (c) 2025 Hyperbola Project
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 */

/*
 * Portable arc4random internal code from OpenBSD 7.0 source code:
 * lib/libc/crypt/arc4random.c
 */
/*
 * Part of arc4random internal header from OpenBSD 7.0 source code:
 * lib/libc/crypt/arc4random.h
 */
/*
 * Part of arc4random internal header from OpenBSD 7.0 source code:
 * lib/libcrypto/arc4random/arc4random_linux.h
 */

/*
 * ChaCha based random number generator for OpenBSD.
 */

/* Ignore deprecated warning in GNU libc */
#define _DEFAULT_SOURCE

#define _BSD_SOURCE
#include <sys/time.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <limits.h>
#include <pthread.h>
#include <signal.h>
#include <string.h>
#include <unistd.h>
#include "stdlib_int.h"

#define KEYSTREAM_ONLY
#include "chacha_int.h"

#define minimum(a, b) ((a) < (b) ? (a) : (b))

#define KEYSZ	32
#define IVSZ	8
#define BLOCKSZ	64
#define RSBUFSZ	(16*BLOCKSZ)

static pthread_mutex_t arc4random_mtx = PTHREAD_MUTEX_INITIALIZER;
#define _ARC4_LOCK()   pthread_mutex_lock(&arc4random_mtx)
#define _ARC4_UNLOCK() pthread_mutex_unlock(&arc4random_mtx)

/* Marked MAP_INHERIT_ZERO, so zero'd out in fork children. */
static struct _rs {
	size_t		rs_have;	/* valid bytes at end of rs_buf */
	size_t		rs_count;	/* bytes till reseed */
} *rs;

/* Maybe be preserved in fork children, if _rs_allocate() decides. */
static struct _rsx {
	chacha_ctx	rs_chacha;	/* chacha context for random keystream */
	unsigned char		rs_buf[RSBUFSZ];	/* keystream blocks */
} *rsx;

static inline void
_getentropy_fail(void)
{
	raise(SIGKILL);
}

#if defined(__linux__)
static volatile sig_atomic_t _rs_forked;

static inline void _rs_forkhandler(void)
{
	_rs_forked = 1;
}
#endif

static inline int
_rs_allocate(struct _rs **rsp, struct _rsx **rsxp)
{
#if defined(__HyperbolaBSD__) || defined(__OpenBSD__)
	struct {
		struct _rs rs;
		struct _rsx rsx;
	} *p;

	if ((p = mmap(NULL, sizeof(*p), PROT_READ|PROT_WRITE,
	    MAP_ANON|MAP_PRIVATE, -1, 0)) == MAP_FAILED)
		return -1;
	if (minherit(p, sizeof(*p), MAP_INHERIT_ZERO) == -1) {
		munmap(p, sizeof(*p));
		return -1;
	}

	*rsp = &p->rs;
	*rsxp = &p->rsx;
#elif defined(__linux__)
	struct {
		struct _rs *rs;
		struct _rsx *rsx;
	} p;

	if ((p.rs = mmap(NULL, sizeof(struct _rs), PROT_READ|PROT_WRITE,
	    MAP_ANON|MAP_PRIVATE, -1, 0)) == MAP_FAILED)
		return -1;

	if ((p.rsx = mmap(NULL, sizeof(struct _rsx), PROT_READ|PROT_WRITE,
	    MAP_ANON|MAP_PRIVATE, -1, 0)) == MAP_FAILED) {
		munmap(p.rs, sizeof(struct _rs));
		return -1;
	}

	*rsp = p.rs;
	*rsxp = p.rsx;

	pthread_atfork(NULL, NULL, _rs_forkhandler);
#endif
	return 0;
}

static inline void
_rs_forkdetect(void)
{
#if defined(__linux__)
	static pid_t _rs_pid = 0;
	pid_t pid = getpid();

	/* XXX unusual calls to clone() can bypass checks */
	if (_rs_pid == 0 || _rs_pid == 1 || _rs_pid != pid || _rs_forked) {
		_rs_pid = pid;
		_rs_forked = 0;
		if (rs)
			memset(rs, 0, sizeof(*rs));
	}
#endif
}

static inline void _rs_rekey(unsigned char *dat, size_t datlen);

static inline void
_rs_init(unsigned char *buf, size_t n)
{
	if (n < KEYSZ + IVSZ)
		return;

	if (rs == NULL) {
		if (_rs_allocate(&rs, &rsx) == -1)
			_exit(1);
	}

	chacha_keysetup(&rsx->rs_chacha, buf, KEYSZ * 8, 0);
	chacha_ivsetup(&rsx->rs_chacha, buf + KEYSZ);
}

static void
_rs_stir(void)
{
	unsigned char rnd[KEYSZ + IVSZ];

	if (getentropy(rnd, sizeof rnd) == -1)
		_getentropy_fail();

	if (!rs)
		_rs_init(rnd, sizeof(rnd));
	else
		_rs_rekey(rnd, sizeof(rnd));
	explicit_bzero(rnd, sizeof(rnd));	/* discard source seed */

	/* invalidate rs_buf */
	rs->rs_have = 0;
	memset(rsx->rs_buf, 0, sizeof(rsx->rs_buf));

	rs->rs_count = 1600000;
}

static inline void
_rs_stir_if_needed(size_t len)
{
	_rs_forkdetect();
	if (!rs || rs->rs_count <= len)
		_rs_stir();
	if (rs->rs_count <= len)
		rs->rs_count = 0;
	else
		rs->rs_count -= len;
}

static inline void
_rs_rekey(unsigned char *dat, size_t datlen)
{
#ifndef KEYSTREAM_ONLY
	memset(rsx->rs_buf, 0, sizeof(rsx->rs_buf));
#endif
	/* fill rs_buf with the keystream */
	chacha_encrypt_bytes(&rsx->rs_chacha, rsx->rs_buf,
	    rsx->rs_buf, sizeof(rsx->rs_buf));
	/* mix in optional user provided data */
	if (dat) {
		size_t i, m;

		m = minimum(datlen, KEYSZ + IVSZ);
		for (i = 0; i < m; i++)
			rsx->rs_buf[i] ^= dat[i];
	}
	/* immediately reinit for backtracking resistance */
	_rs_init(rsx->rs_buf, KEYSZ + IVSZ);
	memset(rsx->rs_buf, 0, KEYSZ + IVSZ);
	rs->rs_have = sizeof(rsx->rs_buf) - KEYSZ - IVSZ;
}

static inline void
_rs_random_buf(void *_buf, size_t n)
{
	unsigned char *buf = (unsigned char *)_buf;
	unsigned char *keystream;
	size_t m;

	_rs_stir_if_needed(n);
	while (n > 0) {
		if (rs->rs_have > 0) {
			m = minimum(n, rs->rs_have);
			keystream = rsx->rs_buf + sizeof(rsx->rs_buf)
			    - rs->rs_have;
			memcpy(buf, keystream, m);
			memset(keystream, 0, m);
			buf += m;
			n -= m;
			rs->rs_have -= m;
		}
		if (rs->rs_have == 0)
			_rs_rekey(NULL, 0);
	}
}

DEF_WEAK(arc4random_buf);
void
arc4random_buf(void *buf, size_t n)
{
	_ARC4_LOCK();
	_rs_random_buf(buf, n);
	_ARC4_UNLOCK();
}
