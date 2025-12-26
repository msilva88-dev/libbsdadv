# Changelog

This project follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/)
and [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-12-10
Initial stable release.

### Added
- Core BSD authentication, password, and capability tools:
  `authenticate`, `auth_subr`, `check_expire`, `cryptutil`, `fparseln`, `getnetgrent`, `login_cap` (with headers and manual pages).
- Blowfish (BLF) cipher implementation and public API (`blf.h`, `blowfish.c`), with full bcrypt integration (with manual pages).
- bcrypt internal implementation with `bcrypt_newhash`, `bcrypt_checkpass`, `bcrypt_gensalt`, and `bcrypt`.
- Internal adaptive rounds helper `_bcrypt_autorounds()` (targets ~0.1s execution).
- Cryptographically secure randomness with `arc4random_buf` (portable, internal).
- Portable ChaCha20 primitives (`chacha_int.h`, used by `arc4random_int.c`).
- Internal `pw_dup` for systems lacking `pw_dup(3)`, plus portable password utilities.
- Internal and portable password functions from `passwd_int.c`.
- Internal and portable implementations of `strtonum`, and capability database helpers: `cgetcap`, `cgetent`, `cgetstr`, `cgetustr`.
- Constant-time comparison function `timingsafe_bcmp` for security-sensitive operations (portable, internal).
- POSIX-style Makefile supporting static/shared builds, feature toggles, platform detection, and install targets.
- Changelog, VERSION file (`1.0.0`), COPYRIGHT policy, SPDX license texts under `LICENSES/`, and `.gitignore`.
- Clean build triplet and platform detection:
  - Autodetect musl vs glibc on Linux (`linux-musl` vs `linux-gnu`).
  - Define `CBUILD`/`CHOST` consistently; set `CHOST` from `CBUILD`.
  - Standardize feature macro naming (`USE_LIBC_WITH_BSDLIB`).
- Installation defaults and permissions:
  - Default `PREFIX=/usr`, `LIBDIR=lib`; directory permissions default to `0755`.
  - Guard setgid behavior with `DIRPGRP`; use `DESTDIR`-rooted install paths.
  - Generalize install ownership/permissions variables (e.g., `DIROWN`, `DIRGRP`, `DIRPERM`).

### Changed
- Adopt fixed-size integer types (`uint32_t`, `uint8_t`, etc.) across Blowfish, bcrypt, and related APIs for portability.
- Normalize symbol visibility:
  - Use `HIDDEN_A` for internal declarations.
  - Use `DEF_WEAK` for weak-linkable functions; place `DEF_WEAK` immediately before definitions.
- Header and internal API consolidation:
  - Consistently use `*_int.h` for internal headers; separate public vs internal interfaces.
  - Modernize headers (licenses, provenance, guards, includes) for HyperbolaBSD portability.
  - Provide portable `pwd.h`/`pwd_int.h` with fallback `struct passwd` and prototypes where needed.
  - Introduce `features.h` for visibility macros and shared attributes.
- API and portability cleanups:
  - Replace `strlcpy()` with `strncpy()` plus explicit NUL termination for wider portability.
  - Standardize return statements (`return value;`) and printing types (e.g., `%lld` for `long long`).
  - Define `_GNU_SOURCE` in sources needing extended libc features.
  - Use standard unsigned types in place of BSD `u_int` legacy types.

### Fixed
- Improve `_ng_makekey` bounds checking to avoid buffer overflows and handle large/small sizes safely.
- Consistent `ssize_t` usage and comparisons in snprintf/array logic to prevent signed/unsigned issues.
- Ensure proper includes (e.g., `<grp.h>`) and remove implicit declarations.

### Security
- Integrate timing-attack-resistant comparisons via `timingsafe_bcmp`.
- Use ChaCha-backed `arc4random_buf` for strong randomness in crypto paths.
- Bcrypt wired to full Blowfish implementation by default; supports weak linking for system-provided BLF.

### Compatibility
- Conditional `setlogin()` and `LOGIN_SETLOGIN` usage only on HyperbolaBSD/OpenBSD.
- Provide `closefrom_int()` fallback on platforms lacking `closefrom(3)`.
- Netgroup builds work with or without BSDDB via `#ifdef BSDDB` guards; YP paths remain distinct.
- BLF selection via `-DBLF`:
  - When defined, rely on system/library Blowfish and disable builtin.
  - When not defined, compile builtin OpenBSD-derived Blowfish.
- Makefile feature toggles for BLF, BSDDB, YP, and musl/bsd portability.

---

[1.0.0]: https://github.com/msilva88-dev/libbsdadv/releases/tag/v1.0.0
