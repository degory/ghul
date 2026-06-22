#!/usr/bin/env bash
# Filter JetBrains ExternalAnnotations XML to the subset the compiler reads.
#
# The upstream XML carries dozens of attribute kinds (NotNull,
# ContractAnnotation, LinqTunnel, …). The compiler only consumes
# `JetBrains.Annotations.PureAttribute` (see `jb_annotations.ghul`),
# so most of the ~12 MB ships dead weight. This trims each XML to
# `<member>` blocks that carry a PureAttribute and drops files (and
# eventually directories) that end up empty.
#
# Usage: filter-jb-annotations.sh <root-directory>

set -euo pipefail

if (( $# != 1 )); then
    echo "usage: $0 <root-directory>" >&2
    exit 2
fi

root=$1

if [[ ! -d "${root}" ]]; then
    echo "error: ${root} is not a directory" >&2
    exit 2
fi

before_bytes=$(du -sb "${root}" | cut -f1)
before_files=$(find "${root}" -name '*.xml' | wc -l)
before_members=$(grep -rhc '<member name=' "${root}" 2>/dev/null | awk '{s+=$1}END{print s+0}')

awk_script='
BEGIN { in_member = 0; buf = ""; kept = 0 }
/^[[:space:]]*<member / && !in_member {
    in_member = 1
    buf = $0 "\n"
    if (/<\/member>/) {
        # self-contained `<member ... />` or `<member ...></member>`
        in_member = 0
        if (buf ~ /PureAttribute/) {
            printf "%s", buf
            kept++
        }
        buf = ""
    }
    next
}
in_member {
    buf = buf $0 "\n"
    if (/<\/member>/) {
        in_member = 0
        if (buf ~ /PureAttribute/) {
            printf "%s", buf
            kept++
        }
        buf = ""
    }
    next
}
{ print }
END { exit (kept == 0 ? 1 : 0) }
'

while IFS= read -r -d '' xml; do
    tmp=$(mktemp)
    if awk "${awk_script}" "${xml}" > "${tmp}"; then
        mv "${tmp}" "${xml}"
    else
        # No PureAttribute matches — drop the file entirely.
        rm -f "${tmp}" "${xml}"
    fi
done < <(find "${root}" -type f -name '*.xml' -print0)

# Clear out any directories left empty after dropping files.
find "${root}" -type d -empty -delete
# Recreate the root in case it itself was emptied (shouldn't happen,
# but `find -delete` would remove it).
mkdir -p "${root}"

after_bytes=$(du -sb "${root}" | cut -f1)
after_files=$(find "${root}" -name '*.xml' | wc -l)
after_members=$(grep -rhc '<member name=' "${root}" 2>/dev/null | awk '{s+=$1}END{print s+0}')

printf 'jb-annotations filter: %d->%d files, %d->%d members, %d->%d bytes\n' \
    "${before_files}" "${after_files}" \
    "${before_members}" "${after_members}" \
    "${before_bytes}" "${after_bytes}"
