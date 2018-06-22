This repo is for review of requests for signing shim.  To create a request for review:

- clone this repo
- edit the template below
- add the shim.efi to be signed
- add build logs
- commit all of that
- tag it with a tag of the form "myorg-shim-arch-YYYYMMDD"
- push that to github
- file an issue at https: //github.com/rhboot/shim-review/issues with a link to your tag

Note that we really only have experience with using grub2 on Linux, so asking
us to endorse anything else for signing is going to require some convincing on
your part.

Here's the template:

-------------------------------------------------------------------------------
What organization or people are asking to have this signed:
-------------------------------------------------------------------------------

Wuhan Deepin Technology Co., Ltd.

Building B18, Optics Valley Financial Harbour,
No. 77, Optics Valley Avenue,
Wuhan, China

https: //www.deepin.org/en/

Established in 2011, Wuhan Deepin Technology Co., Ltd. is a commercial company
focused on the R&D and service of Linux-based Chinese operating system.

-------------------------------------------------------------------------------
What product or service is this for:
-------------------------------------------------------------------------------

This is for Deepin GNU/Linux operating system, or referred as deepin.

-------------------------------------------------------------------------------
What's the justification that this really does need to be signed for the whole world to be able to boot it:
-------------------------------------------------------------------------------
Secure Boot is commonly used in modern motherboard and deepin needs to support
it to make our products more secure.

Both grub2 and linux kernel will be signed with our own private key to make
sure that these critical packages are supplied by ourselves.

-------------------------------------------------------------------------------
Who is the primary contact for security updates, etc.
-------------------------------------------------------------------------------
- Name: Xu Shaohua
- Position: App Store Director
- Email address: xushaohua@deepin.com
- PGP key, signed by the other security contacts, and preferably also with signatures that are reasonably well known in the linux community:
  https: //pgp.mit.edu/pks/lookup?op=get&search=0xA45D92C206D5EEE5
  PGP key fingerprint: AC52 085A 3905 893D 3868 C9D7 A45D 92C2 06D5 EEE5

-------------------------------------------------------------------------------
Who is the secondary contact for security updates, etc.
-------------------------------------------------------------------------------
- Name: Xu Shaohua
- Position: App Store Director
- Email address: xushaohua@deepin.com
- PGP key, signed by the other security contacts, and preferably also with signatures that are reasonably well known in the linux community:
  https: //pgp.mit.edu/pks/lookup?op=get&search=0xA45D92C206D5EEE5
  PGP key fingerprint: AC52 085A 3905 893D 3868 C9D7 A45D 92C2 06D5 EEE5

-------------------------------------------------------------------------------
What upstream shim tag is this starting from:
-------------------------------------------------------------------------------
15

-------------------------------------------------------------------------------
URL for a repo that contains the exact code which was built to get this binary:
-------------------------------------------------------------------------------
https: //github.com/rhboot/shim/tree/15

-------------------------------------------------------------------------------
What patches are being applied and why:
-------------------------------------------------------------------------------
None

-------------------------------------------------------------------------------
What OS and toolchain must we use to reproduce this build?  Include where to find it, etc.  We're going to try to reproduce your build as close as possible to verify that it's really a build of the source tree you tell us it is, so these need to be fairly thorough. At the very least include the specific versions of gcc, binutils, and gnu-efi which were used, and where to find those binaries.
-------------------------------------------------------------------------------

- Ubuntu 16.04 LTS Xenial Xerus
- gcc: 4:5.3.1-1ubuntu1
- binutils: 2.26.1-1ubuntu1~16.04.6
- gnu-efi: 3.0.8

-------------------------------------------------------------------------------
Which files in this repo are the logs for your build?   This should include logs for creating the buildroots, applying patches, doing the build, creating the archives, etc.
-------------------------------------------------------------------------------
- [logs/shim-build-x64.log](logs/shim-build-x64.log)

-------------------------------------------------------------------------------
Put info about what bootloader you're using, including which patches it includes to enforce Secure Boot here:
-------------------------------------------------------------------------------
grub-2.02

For patches please see grub2_2.02~beta3-4.diff
All patches applied to grub 2.02 are placed at [src/grub2.02-patches](src/grub2.02-patches)

-------------------------------------------------------------------------------
Put info about what kernel you're using, including which patches it includes to enforce Secure Boot here:
-------------------------------------------------------------------------------
linux-4.14.49

All applied patches are included in [src/kernel-secure-boot-patches](src/kernel-secure-boot-patches) folder.
These patches are picked from https: //github.com/vathpela/linux/tree/secure-boot-4.14

-------------------------------------------------------------------------------
Files to be signed:
-------------------------------------------------------------------------------

- 69b542e50bfde0889f70b71bbdf2eb28ce352c72f091ec7000529efcba0b9ce0  [shim/shimx64.efi](shim/shimx64.efi)

-------------------------------------------------------------------------------
CAB archive submitted to Microsoft:
-------------------------------------------------------------------------------
UEFI submission #2259422
- 337601ab6f30baa5da6c26e0225e2bbb8fad58e8b3d01c7b0d54f178c5130bae  [shim/shimx64.cab](shim/shimx64.cab)


------------------------------------------------------------------------------
Notes:
------------------------------------------------------------------------------

File info:

```text
.
├── deepin.cer                            // Public CERT file
├── grub
│   ├── grubx64.efi                       // GRUB 2.02 efi firmware
│   ├── grubx64.efi.sha256sum
│   ├── grubx64-signed.efi
│   └── grubx64-signed.efi.sha256sum
├── logs
│   └── shim-build-x64.log                // Build log for SHIM 15 on x64
├── shim
│   ├── cab
│   │   ├── shimx64-signed.cab
│   │   ├── shimx64-unsigned.cab          // Generated SHIM x64 cab file
│   │   └── shimx64-unsigned.cab.sha256
│   ├── shimx64.efi                       // SHIM x64 firmware
│   └── shimx64.efi.sha256
└── src
    ├── build-gnu-efi.sh                  // gnu-efi build script
    ├── build-grub.sh                     // GRUB efi build script
    ├── build-kernel.sh                   // Kernel build script
    ├── build-shim.sh                     // SHIM efi build script
    ├── gnu-efi-3.0.8.tar.bz2             // gnu-efi source tarball
    ├── grub2.02-patches                  // GRUB 2.02 patches
    ├── grub-debian-2.02+dfsg1-4.tar.bz2  // GRUB 2.02 source tarball
    ├── kernel-secure-boot-patches        // Linux kernel 4.14 Secure-Boot patches
    ├── linux-4.14.49.tar.xz              // Linux 4.14 source tarball
    └── shim-15.tar.gz                    // SHIM 15 source tarball
```
