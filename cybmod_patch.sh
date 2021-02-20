#!/bin/bash
RED='\033[1;31m'
NC='\033[0m'
DIR=$(dirname $0)
echo -e " "
echo -e "${RED}***************${NC}"
echo -e "Base patches"
echo -e "${RED}***************${NC}"
echo -e " "
for each in $DIR/0*.patch
do
	echo -e "${RED}***************"
	echo -e "Applying patch: $(basename $each)"
	echo -e "***************${NC}"
	patch -p1 < $each
done
echo -e " "
echo -e "${RED}***************${NC}"
echo -e "Ubuntu patches"
echo -e "${RED}***************${NC}"
echo -e " "
for each in $DIR/ubuntu/0*.patch
do
        echo -e "${RED}***************"
        echo -e "Applying patch: $(basename $each)"
        echo -e "***************${NC}"
        patch -p1 < $each
done
echo -e " "
echo Done patching
echo --
while true; do
    read -p "Do you need backwards compatibility with older Proton/wine? (Fsync patch)" yn
    case $yn in
        [Yy]* ) patch -p1 < $DIR/1000-v5.11-fsync.patch; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done
echo -e " "
