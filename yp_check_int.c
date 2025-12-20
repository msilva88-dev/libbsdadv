/* SPDX-License-Identifier: BSD-2-Clause */

/*
 * Copyright (c) 1992, 1993 Theo de Raadt <deraadt@theos.com>
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
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS
 * OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 */

/*
 * yp_check internal code from OpenBSD 7.0 source code:
 * lib/libc/yp/_yp_check.c
 */

#include <stdio.h>
#include <string.h>
#include <rpcsvc/ypclnt.h>

int
yp_check(char **dom)
{
	char *domain_name = NULL;

	if (yp_get_default_domain(&domain_name)) return 0;
	if (dom && domain_name) *dom = domain_name;
	if (yp_bind(domain_name) == 0) return 1;

	return 0;
}
