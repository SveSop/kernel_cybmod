## Cybmod patches for 4.20 kernel  

Get kernel source from here: [https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-4.20.tar.xz](https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-4.20.tar.xz)  

**Custom kernel with the following patches**  

0001 : Kernel patch 4.20.4  
0002 : MuQSS CPU scheduler from -ck kernel: [http://ck-hack.blogspot.com/](http://ck-hack.blogspot.com/)  
0003 : Make preemptive kernel default from -ck kernel
0004 : BFQ SQ/MQ patch from [https://github.com/sirlucjan/kernel-patches/tree/master/4.20/bfq-sq-mq](https://github.com/sirlucjan/kernel-patches/tree/master/4.20/bfq-sq-mq)  
0005 : Swap tweak from -ck kernel  
0006 : ZSwap tweak from -ck kernel  
0007 : EFI Module patch to allow kernel modules to be signed with Ubuntu dkms  
0010 : Graysky's GCC optimization patches  
0011 : Graysky's GCC optimization patches  
0012 : Set CAKE qdisk default  
0013 : Kernel naming tweak  
0014 : Custom kernel .config. Tested with Intel processor. (Uses -march=native gcc optimization - see patch 0010/0011)  
0015 : Kernel patch for 4.20.4 that fix Asus motherboards using nct6775 module to monitor volt/temps.  
0016 : Add ZEN -O3 optimize option patch.  

**AMD support is disabled in the example config (patch 0014), so if you have a AMD processor, you need to enable that**  
**This branch has MuQSS CPU scheduler, config (patch 0014) set up with CONFIG_RQ_SMT (Hyperthreading) and 1000Hz tickrate**  

To build on Ubuntu:  
```
tar xf linux-4.20.tar.xz  
cd linux-4.20  
/path/to/patches/and/cybmod.sh  
make -j12 bindeb-pkg # -j depending on your processor cores  
```
When build is done, the .deb files is in the ../ folder relative to the source.  

To benefit from patch 0007, and sign your kernel modules with dkms with Ubuntu you need to do:  
`sudo mokutil --import /var/lib/shim-signed/mok/MOK.der`  
This will put the DKMS certificate up for signing. You then need to reboot and go through the bootup sequence allowing the certificate to be signed by Ubuntu.  

>Once this is done, reboot. Just before loading GRUB, shim will show a blue screen (which is actually another piece of the shim project called “MokManager”). use that screen to select “Enroll MOK” and follow the menus to finish the enrolling process. You can also look at some of the properties of the key you’re trying to add, just to make sure it’s indeed the right one using “View key”. MokManager will ask you for the password we typed in earlier when running mokutil; and will save the key, and we’ll reboot again.  

From [https://blog.ubuntu.com/2017/08/11/how-to-sign-things-for-secure-boot](https://blog.ubuntu.com/2017/08/11/how-to-sign-things-for-secure-boot)  

After this is done, all kernel modules built by DKMS will automatically be signed with a approved key, and get allowed by the kernel at boot-time. So you no longer get an error with PKCS#7 signed module of eg. nVidia binary driver.  

Example of script to sign kernel modules NOT built by DKMS (Example is for VirtualBox modules, but can be adapted to other stuff)  
```
#!/bin/bash

sudo -v

echo "Signing the following VirtualBox drivers"

for filename in /lib/modules/$(uname -r)/misc/*.ko; do
	sudo /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 /var/lib/shim-signed/mok/MOK.priv /var/lib/shim-signed/mok/MOK.der $filename

	echo "$filename"
done
```
If you sign a DKMS kernel module, or use this script (or manually) to add modules, it's a good idea to do:  
`sudo update-initramfs -u`  

_This kernelconfig is hugely inspired by the Xanmod kernel [https://xanmod.org](https://xanmod.org)_  

More info to come...  
