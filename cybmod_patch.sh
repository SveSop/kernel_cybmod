#!/bin/bash
DIR=$(dirname $0)
for each in $DIR/*.patch
do
	patch -p1 < $each
done
echo Done patching
