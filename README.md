## Cybmod patches for 4.19 kernel  

Get kernel source from here: [https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-4.19.tar.xz](https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-4.19.tar.xz)  

**Custom kernel with the following patches**  

0001 : Kernel patch 4.19.6  
0002 : PDS Cpu scheduler [http://cchalpha.blogspot.com/search/label/PDS-mq](http://cchalpha.blogspot.com/search/label/PDS-mq)  
0003 : BFQ SQ/MQ patch from [https://github.com/sirlucjan/kernel-patches/tree/master/4.19/bfq-sq-mq](https://github.com/sirlucjan/kernel-patches/tree/master/4.19/bfq-sq-mq)  
0004 : Swap tweak from -ck kernel  
0005 : ZSwap tweak from -ck kernel  
0006 : EFI Module patch to allow kernel modules to be signed with Ubuntu dkms  
0010 : Graysky's GCC optimization patches  
0011 : Graysky's GCC optimization patches  
0012 : Set CAKE qdisk default  
0013 : Kernel naming tweak  
0014 : Custom kernel .config. Tested with Intel processor. (Uses -march=native gcc optimization - see patch 0010/0011)  

**AMD support is disabled in the example config (patch 0014), so if you have a AMD processor, you need to enable that**  

To build on Ubuntu:  
```
tar xf linux-4.19.tar.xz  
cd linux-4.19  
/path/to/patches/and/cybmod.sh  
make -j12 bindeb-pkg # -j depending on your processor cores  
```
When build is done, the .deb files is in the ../ folder relative to the source.  

More info to come...  

