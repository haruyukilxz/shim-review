This repo is for review of requests for signing shim.  To create a request for review:

- clone this repo
- edit the template below
- add the shim.efi to be signed
- add build logs
- commit all of that
- tag it with a tag of the form "myorg-shim-arch-YYYYMMDD"
- push that to github
- file an issue at https://github.com/rhboot/shim-review/issues with a link to your tag

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

https://www.deepin.org/en/

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
  https://pgp.mit.edu/pks/lookup?op=get&search=0xA45D92C206D5EEE5
  PGP key fingerprint: AC52 085A 3905 893D 3868 C9D7 A45D 92C2 06D5 EEE5

-------------------------------------------------------------------------------
Who is the secondary contact for security updates, etc.
-------------------------------------------------------------------------------
- Name: Xu Shaohua
- Position: App Store Director
- Email address: xushaohua@deepin.com
- PGP key, signed by the other security contacts, and preferably also with signatures that are reasonably well known in the linux community:
  https://pgp.mit.edu/pks/lookup?op=get&search=0xA45D92C206D5EEE5
  PGP key fingerprint: AC52 085A 3905 893D 3868 C9D7 A45D 92C2 06D5 EEE5

-------------------------------------------------------------------------------
What upstream shim tag is this starting from:
-------------------------------------------------------------------------------
14

-------------------------------------------------------------------------------
URL for a repo that contains the exact code which was built to get this binary:
-------------------------------------------------------------------------------
https://github.com/rhboot/shim/tree/14

-------------------------------------------------------------------------------
What patches are being applied and why:
-------------------------------------------------------------------------------
None

-------------------------------------------------------------------------------
What OS and toolchain must we use to reproduce this build?  Include where to find it, etc.  We're going to try to reproduce your build as close as possible to verify that it's really a build of the source tree you tell us it is, so these need to be fairly thorough. At the very least include the specific versions of gcc, binutils, and gnu-efi which were used, and where to find those binaries.
-------------------------------------------------------------------------------

- Ubuntu 16.04 LTS Xenial Xerus
- gcc: 4:5.3.1-1ubuntu1
- binutils: 2.26.1-1ubuntu1~16.04.4
- gnu-efi: 3.0.2-1ubuntu1

-------------------------------------------------------------------------------
Which files in this repo are the logs for your build?   This should include logs for creating the buildroots, applying patches, doing the build, creating the archives, etc.
-------------------------------------------------------------------------------
- shimia32-build.log
- shimx64-build.log

-------------------------------------------------------------------------------
Put info about what bootloader you're using, including which patches it includes to enforce Secure Boot here:
-------------------------------------------------------------------------------
grub2_2.02~beta3-4

For patches please see grub2_2.02~beta3-4.diff

-------------------------------------------------------------------------------
Put info about what kernel you're using, including which patches it includes to enforce Secure Boot here:
-------------------------------------------------------------------------------
linux-4.14.0

No pacthes are applied yet.

-------------------------------------------------------------------------------
Files to be signed:
-------------------------------------------------------------------------------

- 59c00f12bc207247a97712574013c8e15492b0e0ba37e10f04b8411ebafd51f2  shimia32.efi
- aae008dcead8298297f37234439037a642a46bbcf37c574926c547ab53647217  shimx64.efi

-------------------------------------------------------------------------------
CAB archive submitted to Microsoft:
-------------------------------------------------------------------------------
UEFI submission #2050412

- 821c02d88deaebb19416abddc8e77e258a790c7ad7f33b14860028051f66fcde  shimia32.cab

UEFI submission #2048383
- 09a2bdac0e73105a0a948df01f4360a70e6cee8b430c648243d556e84895cefb  shimx64.cab
