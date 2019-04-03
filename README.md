## Cybmod patches for 5.0 kernel  

Get kernel source from here: [https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.0.tar.xz](https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.0.tar.xz)  

**Custom kernel with the following patches**  

0001 : Kernel 5.0.6 patch  
0002 : BMQ Cpu scheduler [https://cchalpha.blogspot.com/](https://cchalpha.blogspot.com/)  
0004 : Swap tweak from -ck kernel  
0005 : ZSwap tweak from -ck kernel  
0006 : EFI Module patch to allow kernel modules to be signed with Ubuntu dkms  
0007 : Set_MinMax_KB_Read-ahead from Xanmod patches  
0008 : Increase_task_balance from Xanmod patches  
0009 : set_rq_affinity_mt_block from Xanmod patches  
0010 : Graysky's GCC optimization patches  
0011 : Graysky's GCC optimization patches  
0012 : Set CAKE qdisk default  
0013 : Kernel naming tweak  
0014 : Custom kernel .config. Tested with Intel processor. (Uses -march=native gcc optimization - see patch 0010/0011)  
0015 : Kernel patch for 5.0 that fix Asus motherboards using nct6775 module to monitor volt/temps.  
0016 : Add ZEN -O3 optimize option patch.  
blk-patches : Collection of "block" patches picked from [https://github.com/sirlucjan/kernel-patches/tree/master/5.0](https://github.com/sirlucjan/kernel-patches/tree/master/5.0)  

**AMD support is disabled in the example config (patch 0014), so if you have a AMD processor, you need to enable that**  

To build on Ubuntu:  
```
tar xf linux-5.0.tar.xz  
cd linux-5.0  
/path/to/patches/and/cybmod.sh  
make -j12 bindeb-pkg # -j depending on your processor cores  
```
When build is done, the .deb files is in the ../ folder relative to the source.  

To benefit from patch 0006, and sign your kernel modules with dkms with Ubuntu you need to do:  
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
