LibBSD licensed with advertising clause (BSD-4-Clause) - COPYRIGHT
==================================================================

1) Licensing model
------------------
• Each source file in this repository is licensed individually.
• Hyperbola Project accepts all free, permissive licenses such
  as BSD-2-Clause, BSD-3-Clause, ISC, as well as public domain
  equivalents such as CC0-1.0.
• The Simplified BSD License (BSD-2-Clause) is preferred for new
  and rewritten code because it is simple and GPL-compatible.
• Nonfree or proprietary licenses are NOT accepted.
• Binary-only firmware, microcode, or blobs are NOT included.

2) SPDX-only per-file notice
----------------------------
Each copyrightable source file MUST begin with a single SPDX line
identifying its license.  The SPDX line replaces long boilerplate
text.

Examples:
  /* SPDX-License-Identifier: BSD-2-Clause */
  /* SPDX-License-Identifier: ISC */
  /* SPDX-License-Identifier: CC0 */

Placeholders such as “All rights reserved” MUST NOT appear alone.

3) Trivial files (non-copyrightable)
------------------------------------
Short, purely functional files (≤15 effective lines, excluding
comments and blanks) are considered non-copyrightable.  Such
files may omit an SPDX line, though adding one is harmless.

4) Canonical license texts
--------------------------
Full license texts are stored under LICENSES/:
  • LICENSES/preferred/BSD-2-Clause        – preferred license
  • LICENSES/deprecated/BSD-3-Clause       – accepted legacy license
  • LICENSES/deprecated/BSD-4-Clause       – accepted legacy license
  • LICENSES/deprecated/ISC                – accepted legacy license
  • LICENSES/deprecated/CC0-1.0            – public domain equivalent

5) Contribution requirements
----------------------------
Contributors affirm that:
  • they hold copyright or sufficient rights to contribute;
  • new files include a correct SPDX line;
  • NO nonfree components or binary blobs are introduced.

6) Compliance and audits
------------------------
Hyperbola Project follows the Free System Distribution Guidelines
(FSDG).  Regular audits ensure:
  • every source file has a valid SPDX identifier,
  • NO binary blobs are included,
  • ambiguous or incompatible code is flagged for replacement.

7) Contact
-----------
Hyperbola Project
https://www.hyperbola.info/
Licensing and compliance: licensing@hyperbola.info
(Include file paths and commit references in all reports.)
