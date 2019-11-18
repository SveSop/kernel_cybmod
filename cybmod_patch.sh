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
echo -e "${RED}***************${NC}"
echo -e "EFI Patches"
echo -e "${RED}***************${NC}"
echo -e " "
for each in $DIR/efi-lockdown/0*.patch
do
        echo -e "${RED}***************"
        echo -e "Applying patch: $(basename $each)"
        echo -e "***************${NC}"
        patch -p1 < $each
done
echo -e " "
echo -e "${RED}***************${NC}"
echo -e "BFQ patches"
echo -e "${RED}***************${NC}"
echo -e " "
for each in $DIR/bfq-patches/0*.patch
do
        echo -e "${RED}***************"
        echo -e "Applying patch: $(basename $each)"
        echo -e "***************${NC}"
        patch -p1 < $each
done
echo -e " "
echo -e "${RED}***************${NC}"
echo -e "Clearlinux patches"
echo -e "${RED}***************${NC}"
echo -e " "
for each in $DIR/clearlinux-patches/0*.patch
do
        echo -e "${RED}***************"
        echo -e "Applying patch: $(basename $each)"
        echo -e "***************${NC}"
        patch -p1 < $each
done
for each in $DIR/mm-patches/0*.patch
do
        echo -e "${RED}***************"
        echo -e "Applying patch: $(basename $each)"
        echo -e "***************${NC}"
        patch -p1 < $each
done
echo -e " "
echo Done patching
echo --
