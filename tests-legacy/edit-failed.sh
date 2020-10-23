#!/bin/bash
for f in `find tests-legacy/cases -name failed`; do code `dirname $f` ; read -n 1 -s ; done
