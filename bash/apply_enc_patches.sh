#!/bin/bash
unzip ./encrypted-core-patches/1.zip -d ./encrypted-core-patches
git apply --whitespace=nowarn encrypted-core-patches/1.patch
rm -f encrypted-core-patches/1.patch
