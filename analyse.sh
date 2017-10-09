#!/bin/bash
find test/cases/001-hello-world -name '*.ghul' | xargs ./ghul -A -G -X test/ghul.ghul 

