/*
 * Blowfish - a fast block cipher designed by Bruce Schneier
 *
 * Copyright 1997 Niels Provos <provos@physnet.uni-hamburg.de>
 * All rights reserved.
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
 * 3. All advertising materials mentioning features or use of this software
 *    must display the following acknowledgement:
 *      This product includes software developed by Niels Provos.
 * 4. The name of the author may not be used to endorse or promote products
 *    derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
 * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 * IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
 * THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/* blowfish internal header from OpenBSD 7.0 source code: include/blf.h */

#ifndef _LIBBSD4_PORTABLE_BLF_INT_H
#define _LIBBSD4_PORTABLE_BLF_INT_H

#ifdef __cplusplus
extern "C" {
#endif

#include <stdint.h>
#include "../features.h"

#define BLF_N 16

typedef struct BlowfishContext {
	uint32_t S[4][256];	/* S-Boxes */
	uint32_t P[BLF_N + 2];	/* Subkeys */
} blf_ctx;

void blf_enc(blf_ctx *, uint32_t *, uint16_t) HIDDEN;
uint32_t Blowfish_stream2word(const uint8_t *, uint16_t , uint16_t *) HIDDEN;
void Blowfish_expand0state(blf_ctx *, const uint8_t *, uint16_t) HIDDEN;
void Blowfish_expandstate(blf_ctx *, const uint8_t *, uint16_t,
	const uint8_t *, uint16_t) HIDDEN;
void Blowfish_initstate(blf_ctx *) HIDDEN;

#ifdef __cplusplus
}
#endif

#endif
