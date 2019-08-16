## Cybmod patches for 5.2 kernel  

Get kernel source from here: [https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.2.tar.xz](https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.2.tar.xz)  

**Custom kernel with the following patches**  

0000 : Kernel patch 5.2.9  
0001 : -ck kernel patches incl MuQSS scheduler: [http://ck-hack.blogspot.com/](http://ck-hack.blogspot.com/)  
to  
0016 : Last of the -ck patches.  
0017 : revert_acpi_change_for_nct6775  
0018 : zswap-tweaks.patch  
0019 : Graysky's GCC optimization patch  
0020 : Add -O3 optimize option patch  
0021 : Cake_Qdisc_default  
0022 : "Cybmod" version name  
0024 : clear-patches (patch from TK-Glitch patchset)  
0025 : add-acs-overrides_iommu (patch from TK-Glitch patchset)  
0026 : ZFS-fix (patch from TK-Glitch patchset)  
0027 : v5.2-fsync (fsync patch from TK-Glitch patchset) ref. [https://steamcommunity.com/app/221410/discussions/0/3158631000006906163/](https://steamcommunity.com/app/221410/discussions/0/3158631000006906163/)  
0030 : Custom kernel .config. Tested with Intel processor. (Uses -march=native gcc optimization - see patch 0020/0021)  
ubuntu : Ubuntu kernel patchset  
efi-lockdown : EFI lockdown patchset (se note below!)  
blk-patches : Collection of "block" patches picked from [https://github.com/sirlucjan/kernel-patches/tree/master/5.2](https://github.com/sirlucjan/kernel-patches/tree/master/5.2)  
bfq-patches : Collection of BFQ patches picked from [https://github.com/sirlucjan/kernel-patches/tree/master/5.2](https://github.com/sirlucjan/kernel-patches/tree/master/5.2)  

**AMD support is disabled in the example config (patch 0028), so if you have a AMD processor, you need to enable that**  
**This branch has MuQSS CPU scheduler, config (patch 0030) set up with CONFIG_RQ_SMT and 100Hz (NO_HZ_IDLE)**  

To build on Ubuntu:  
```
tar xf linux-5.2.tar.xz    
cd linux-5.2  
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
