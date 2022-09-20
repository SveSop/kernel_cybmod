## Cybmod patches for 5.19 kernel  

Get kernel source from here: [https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.19.tar.xz](https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.19.tar.xz)  

**Custom kernel with the following patches**  

0000 : Patch 5.19.10  
0000 : ProjectC v5.19-r0  
0002 : 5.19 Graysky's CPU optimization patches  
0003 : v5.19-fsync1_futex_waitv  
0004 : Revert ACPI change for NCT6775 chips(Asus MB)  
0005 : zstd kernel settings  
0010 : Ubuntu based config (See note below!)  
0011 : Add-cybmod-version.patch  
0015 : ZRAM entropy calculation patch  
0020 : Clearlinux patches  
0021 : Misc fixes  
0022 : BFQ patchset  
0023 : mm: LRU patchset  
0024 : zstd upstream patches  
0025 : LRNG kernel patches  
0026 : BBR2 patchset  
0027 : Winesync kernel module  
0028 : NTFS3 patches  
0029 : LRNG dependency patches  
0030 : Various kernel tweaks patch  

ubuntu : Ubuntu mainline kernel patchset  

**AMD support is disabled in the example config (patch 0010), so if you have a AMD processor, you need to enable that**  
**Also note that you should preferrably disable the clearlinux patchset for an AMD processor!**  
**This config has default Project C - PDS scheduler and CONFIG_HZ=1000 + NO_HZ_FULL + Fsync_waitv (backwards compatible)**  

To build on Ubuntu:  
```
** Requires lz4lib-tool to compile **
tar xf linux-5.19.tar.xz    
cd linux-5.19  
/path/to/patches/and/cybmod_patch.sh  
make -j12 deb-pkg # -j depending on your processor cores  
```
When build is done, the .deb files is in the ../ folder relative to the source.  

To sign your kernel modules with dkms with Ubuntu you need to do:  
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
