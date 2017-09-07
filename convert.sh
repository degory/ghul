#!/bin/bash
mkdir /tmp/lcache
find driver ioc system logging source lexical syntax -name '*.l' | xargs ./lc -X imports.l
rm source/*.ghul
