## Cybmod patches for 5.3 kernel  

Get kernel source from here: [https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.3.tar.xz](https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.3.tar.xz)  

**Custom kernel with the following patches**  

0000 : Kernel patch 5.3.5  
0001 : PDS 0.99o from TKGlitch patches  
0002 : PDS Fixes  
0010 : smpboot-reuse-timer-calibration.patch  
0011 : kernel-time-reduce-ntp-wakeups.patch  
0012 : Swap-sucks.patch  
0013 : revert_acpi_change_for_nct6775.patch  
0014 : zswap-tweaks.patch  
0015 : cpu-5.3-merge-graysky-s-patchset.patch  
0016 : cpu-5.3-add-a-CONFIG-option-that-sets-O3.patch  
0017 : Cake_Qdisc_default.patch  
0018 : loop-Better-discard-for-block-devices.patch  
0019 : v5.3-fsync.patch  
0020 : Ubuntu based config (See note below!)  
0021 : Add-cybmod-version.patch  
ubuntu : Ubuntu kernel patchset  
efi-lockdown : EFI lockdown patchset (se note below!)  
bfq-patches : Collection of "bfq" patches picked from [https://github.com/sirlucjan/kernel-patches/tree/master/5.3/bfq-patches-sep](https://github.com/sirlucjan/kernel-patches/tree/master/5.3/bfq-patches-sep)  

**AMD support is disabled in the example config (patch 0020), so if you have a AMD processor, you need to enable that**  
**This config has PDS 0.99o CPU scheduler, CONFIG_HZ=1000, and CONFIG_NO_HZ_IDLE**  

To build on Ubuntu:  
```
** Requires lz4lib-tool to compile **
tar xf linux-5.3.tar.xz    
cd linux-5.3  
/path/to/patches/and/cybmod.sh  
make -j12 bindeb-pkg # -j depending on your processor cores  
```
When build is done, the .deb files is in the ../ folder relative to the source.  

To benefit from patches in "efi-lockdown", and sign your kernel modules with dkms with Ubuntu you need to do:  
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
