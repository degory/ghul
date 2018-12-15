#!/bin/bash
gcc -fPIC -shared llvm-5.0-stub.c -o libLLVM-5.0.so.1
gcc -fPIC -shared llvm-6.0-stub.c -o libLLVM-6.0.so.1
gcc -fPIC -shared llvm-7.0-stub.c -o libLLVM-7.0.so.1
gcc -fPIC -shared llvm-8.0-stub.c -o libLLVM-8.0.so.1
