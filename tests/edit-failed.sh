#!/bin/bash
for f in `find tests/cases -name failed`; do code `dirname $f` ; read -n 1 -s ; done
