/*
 * Copyright (c) 2014 Ted Unangst <tedu@openbsd.org>
 * Copyright (c) 1997 Niels Provos <provos@umich.edu>
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

/* bcrypt internal from OpenBSD 7.0 source code: lib/libc/crypt/bcrypt.c */

#include <stdlib.h>
#include <time.h>
#include "pwd_int.h"

/*
 * Measure this system's performance by measuring the time for 8 rounds.
 * We are aiming for something that takes around 0.1s, but not too much over.
 */
int
_bcrypt_autorounds(void)
{
	struct timespec before, after;
	int r = 8;
	char buf[_PASSWORD_LEN];
	int duration;

	clock_gettime(CLOCK_THREAD_CPUTIME_ID, &before);
	bcrypt_newhash("testpassword", r, buf, sizeof(buf));
	clock_gettime(CLOCK_THREAD_CPUTIME_ID, &after);

	duration = after.tv_sec - before.tv_sec;
	duration *= 1000000;
	duration += (after.tv_nsec - before.tv_nsec) / 1000;

	/* too quick? slow it down. */
	while (r < 16 && duration <= 60000) {
		r += 1;
		duration *= 2;
	}
	/* too slow? speed it up. */
	while (r > 6 && duration > 120000) {
		r -= 1;
		duration /= 2;
	}

	return r;
}
