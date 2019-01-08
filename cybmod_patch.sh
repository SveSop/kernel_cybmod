#!/bin/bash
RED='\033[1;31m'
NC='\033[0m'
DIR=$(dirname $0)
for each in $DIR/*.patch
do
        echo -e "${RED}***************"
        echo -e "Applying patch: $(basename $each)"
        echo -e "***************${NC}"
	patch -p1 < $each
done
echo Done patching
