## Cybmod patches for 5.12 kernel  

Get kernel source from here: [https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.12.tar.xz](https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.12.tar.xz)  

**Custom kernel with the following patches**  

0000 : Patch 5.12.7  
0001 : Project-C v5.12-r1  
0002 : 5.12 Graysky's CPU optimization patches  
0003 : Enable usage of optional -O3 optimization  
0004 : "Old" fsync patch for backwards compatibility  
0005 : Futex2 interface  
0006 : Revert ACPI change for NCT6775 chips(Asus MB)  
0008 : zstd kernel settings  
0010 : Initramfs Async unpack  
0011 : Winesync/Fastsync patchset for Wine (See note)  
0020 : Ubuntu based config (See note below!)  
0021 : Add-cybmod-version.patch  
0030 : Clearlinux patches  
0031 : Misc fixes  
0032 : Block patchset  
0033 : mm: LRU patchset  
0034 : BFQ disk patchset  
0035 : zstd upstream patches  
0036 : -ck picked patches (Xanmod)  
0037 : BBR2 + various net/TCP patches  
0038 : ntf3 patches  
0040 : Various kernel tweaks patch  

ubuntu : Ubuntu mainline kernel patchset  

**AMD support is disabled in the example config (patch 0020), so if you have a AMD processor, you need to enable that**  
**Also note that you should preferrably disable the clearlinux patchset for an AMD processor!**  
**This config has default BMQ (PrjC) scheduler and CONFIG_HZ=1000 + NO_HZ_FULL + Futex2 & Winesync/Fastsync**  

**Winesync is a custom "Fast Synchronization" patchset for wine replacing Esync(staging) and Fsync. Requires patched wine!**  
**Futex2 usage requires a patched wine version! Default proton will use futex2**  
**OBS! If using nVidia proprietary driver you need 455.45.01 (or newer), or 455.46.02 (or newer vulkan beta)**  

To build on Ubuntu:  
```
** Requires lz4lib-tool to compile **
tar xf linux-5.12.tar.xz    
cd linux-5.12  
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
