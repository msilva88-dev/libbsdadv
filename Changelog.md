# Changelog

This project follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/)
and [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-12-10
Initial stable release.

### Added
- Core BSD authentication, password, and capability tools:
  `authenticate`, `auth_subr`, `check_expire`, `cryptutil`, `fparseln`,
  `getnetgrent`, `login_cap` (with headers and manual pages).
- Blowfish (BLF) cipher implementation and public API (`blf.h`, `blowfish.c`),
  with full bcrypt integration (with manual pages).
- bcrypt internal implementation with `bcrypt_newhash`, `bcrypt_checkpass`,
  `bcrypt_gensalt`, and `bcrypt`.
- Added `bcrypt_pbkdf(3)` support:
  - New implementation (`bcrypt_pbkdf.c`) and manual page (`bcrypt_pbkdf.3`).
  - Exposed prototype via `util_bsdadv_with_blf.h` when applicable.
- Added OpenBSD-derived passwd database routines (feature-gated):
  - New implementation `getpwent.c` plus internal header `getpwent_int.h`.
  - New manual pages `getpwent.3` and `getpwnam.3`.
  - New public headers `pwd_bsdadv.h` and `pwd_bsdadv_without_bsddb.h`
    (selected at install time depending on enabled features).
- Added portable SHA-512 (SHA2) internal implementation
  for platforms without BSD libc support:
  - New files `portable/sha2_int.c` and `portable/sha2_int.h`.
- Added YP helper internals used by passwd/YP integration:
  - New files `yp_check_int.c`, `yp_check_int.h`, `ypexclude_int.c`,
    `ypexclude_int.h`.
- Added `pthread_int.h` providing internal mutex wrappers used
  for thread-safe passwd access.
- Added pkg-config metadata:
  - New template `libbsdadv.pc.in` (generates `build/libbsdadv.pc`).
- Added `Readme.md`.
- Internal adaptive rounds helper `_bcrypt_autorounds()`
  (targets ~0.1s execution).
- Cryptographically secure randomness with `arc4random_buf`
  (portable, internal).
- Portable ChaCha20 primitives (`chacha_int.h`, used by `arc4random_int.c`).
- Internal `pw_dup` for systems lacking `pw_dup(3)`,
  plus portable password utilities.
- Internal and portable password functions from `passwd_int.c`.
- Internal and portable implementations of `strtonum`,
  and capability database helpers:
  `cgetcap`, `cgetent`, `cgetstr`, `cgetustr`.
- Constant-time comparison function `timingsafe_bcmp`
  for security-sensitive operations (portable, internal).
- POSIX-style Makefile supporting static/shared builds, feature toggles,
  platform detection, and install targets.
- Changelog, VERSION file (`1.0.0`), COPYRIGHT policy,
  SPDX license texts under `LICENSES/`, and `.gitignore`.
- Clean build triplet and platform detection:
  - Autodetect musl vs glibc on Linux (`linux-musl` vs `linux-gnu`).
  - Define `CBUILD`/`CHOST` consistently; set `CHOST` from `CBUILD`.
  - Standardize feature macro naming (`USE_LIBC_WITH_BSDLIB`).
- Installation defaults and permissions:
  - Default `PREFIX=/usr`, `LIBDIR=lib`;
    directory permissions default to `0755`.
  - Guard setgid behavior with `DIRPGRP`; use `DESTDIR`-rooted install paths.
  - Generalize install ownership/permissions variables
    (e.g., `DIROWN`, `DIRGRP`, `DIRPERM`).

### Changed
- Major Makefile overhaul:
  - Standardized outputs to `libbsdadv`
    (`build/libbsdadv.so`, `build/libbsdadv.a`)
    and added version variables (`VER_MAJOR`, `VER_MINOR`, `VER_REV`, `VER`).
  - Added/expanded feature toggles: `ENABLE_STATIC`, `ENABLE_DYNAMIC`,
    `ENABLE_GETPW`, and improved handling of `ENABLE_BLF`, `ENABLE_BSDDB`,
    `ENABLE_YP`.
  - Added header installation logic with conditional header selection/renaming
    at install time (e.g. choosing the right `pwd_bsdadv*.h`,
    and mapping `util_bsdadv_with_blf.h` → `util_bsdadv.h` on install).
  - Added pkg-config install target and shared-library symlink installation
    (`libbsdadv.so.1`, `libbsdadv.so.1.0.0`).
  - Added optional link flags for `bsddb`, `pthread`, and YP (`tirpc`/`nsl`)
    depending on platform and enabled features.
- Public API exposure is now more explicitly feature-gated:
  many headers only expose prototypes when `_BSD_SOURCE` is defined
  (e.g. `bsd_auth.h`, `login_cap.h`, `netgroup.h`, `unistd_bsdadv.h`,
  `util_bsdadv.h`).
- Renamed headers to project naming:
  - `unistd_bsd4.h` → `unistd_bsdadv.h`
  - `util_bsd4.h` → `util_bsdadv.h`
- Blowfish API/types adjustments for BSD-style typedefs and conditional exposure:
  - Improved BLF selection logic in `blowfish.c`
    for system vs bundled implementations.
- GNU libc portability cleanups: added `_DEFAULT_SOURCE` and `_BSD_SOURCE`
  to multiple translation units to silence deprecated-feature warnings
  and enable required prototypes.
- Adopt fixed-size integer types (`uint32_t`, `uint8_t`, etc.)
  across Blowfish, bcrypt, and related APIs for portability.
- Normalize symbol visibility:
  - Use `HIDDEN_A` for internal declarations.
  - Use `DEF_WEAK` for weak-linkable functions;
    place `DEF_WEAK` immediately before definitions.
- Header and internal API consolidation:
  - Consistently use `*_int.h` for internal headers;
    separate public vs internal interfaces.
  - Modernize headers (licenses, provenance, guards, includes)
    for HyperbolaBSD portability.
  - Provide portable `pwd.h`/`pwd_int.h`
    with fallback `struct passwd` and prototypes where needed.
  - Introduce `features.h` for visibility macros and shared attributes.
- API and portability cleanups:
  - Replace `strlcpy()` with `strncpy()` plus explicit NUL termination
    for wider portability.
  - Standardize return statements (`return value;`) and printing types
    (e.g., `%lld` for `long long`).
  - Define `_GNU_SOURCE` in sources needing extended libc features.
  - Use standard unsigned types in place of BSD `u_int` legacy types.

### Fixed
- `getnetgrent.c`: added missing `<limits.h>` includes for BSDDB/YP builds
  and fixed an unused-parameter case in `lookup()` when YP is not enabled.
- `portable/getcap_int.c`: fixed a signed/unsigned comparison
  in a `snprintf()` length check.
- Aligned symbol/visibility behavior by removing several `DEF_WEAK(...)`
  usages in portable sources (e.g. `arc4random_buf`, `bcrypt_newhash`,
  `bcrypt_checkpass`, `pw_dup`, `strtonum`, `timingsafe_bcmp`,
  and some `cget*` functions).
- Improve `_ng_makekey` bounds checking to avoid buffer overflows
  and handle large/small sizes safely.
- Consistent `ssize_t` usage and comparisons in snprintf/array logic
  to prevent signed/unsigned issues.
- Ensure proper includes (e.g., `<grp.h>`) and remove implicit declarations.

### Security
- Integrate timing-attack-resistant comparisons via `timingsafe_bcmp`.
- Use ChaCha-backed `arc4random_buf` for strong randomness in crypto paths.
- Bcrypt wired to full Blowfish implementation by default;
  supports weak linking for system-provided BLF.

### Compatibility
- Conditional `setlogin()` and `LOGIN_SETLOGIN` usage only
  on HyperbolaBSD/OpenBSD.
- Provide `closefrom_int()` fallback on platforms lacking `closefrom(3)`.
- Netgroup builds work with or without BSDDB via `#ifdef BSDDB` guards;
  YP paths remain distinct.
- BLF selection via `-DBLF`:
  - When defined, rely on system/library Blowfish and disable builtin.
  - When not defined, compile builtin OpenBSD-derived Blowfish.
- Makefile feature toggles for BLF, BSDDB, YP, and musl/bsd portability.

---

[1.0.0]: https://github.com/msilva88-dev/libbsdadv/releases/tag/v1.0.0
