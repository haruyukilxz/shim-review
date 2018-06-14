#!/bin/sh

# Download and build gnu-efi

readonly BASEDIR=$(dirname $(realpath $0))
readonly OUTPUT="${BASEDIR}/../grub"
readonly WORKDIR="${BASEDIR}/grub-debian-2.02+dfsg1-4"
readonly TARBALL="grub-debian-2.02+dfsg1-4.tar.bz2"
readonly SRC_URL="https://salsa.debian.org/grub-team/grub/-/archive/debian/2.02+dfsg1-4/${TARBALL}"

error() {
  echo "ERROR: $*" >&2
  exit 1
}

# Install toolchain
check_toolchain() {
  echo "Checking toolchain .."
  which wget 1>/dev/null || sudo apt install -y wget && \
  which gcc 1>/dev/null || sudo apt install -y build-essential && \
  which nproc 1>/dev/null || sudo apt install -y coreutils
}

# Download shim source
prepare_source() {
  echo "Checking source file .."
  if [ ! -f "${TARBALL}" ]; then
    wget "${SRC_URL}" -O "${TARBALL}" || return 1
  fi

  tar -xf "${TARBALL}"
}

# Build gnu efi file
# @param $1 arch, target architecture, might be x64 or ia32
build() {
  local arch=$1

  cd "${WORKDIR}" && \
    ./configure --prefix=$PWD/out --with-platform=efi --target=amd64-pe \
    --program-prefix="" && make -j$(nproc) && make install
}

build_image() {
  cd "${WORKDIR}"
  mkdir -pv "${OUTPUT}"
  ./grub-mkimage -o "${OUTPUT}/grubx64.efi" -O x86_64-efi \
    -p /EFI/deepin ntfs hfs appleldr \
    boot cat efi_gop efi_uga elf fat hfsplus iso9660 linux keylayouts memdisk \
    minicmd part_apple ext2 extcmd xfs xnu part_bsd part_gpt search \
    search_fs_file chain btrfs loadbios loadenv lvm minix minix2 reiserfs \
    memrw mmap msdospart scsi loopback normal configfile gzio all_video \
    efi_gop efi_uga gfxterm gettext echo boot chain eval ls test sleep png \
    gfxmenu linuxefi
}

sign_image() {
  # NOTE(Shaohua): CA is an environment variable to private key path
  [ -z "${CA_KEY}" ] && error "CA_KEY variable not set"
  [ -z "${CA_CERT}" ] && error "CA_CERT variable not set"

  sbsign --key "${CA_KEY}" --cert "${CA_CERT}" \
    --output "${OUTPUT}/grubx64-signed.efi" \
    "${OUTPUT}/grubx64.efi"
}

clean() {
  echo "Clean up .."
  rm -rvf "${WORKDIR}"
}

main() {
  check_toolchain || error "Failed to install toolchain"
  prepare_source || error "Failed to download source"
  build || error "Failed to build"
  build_image || error "Failed to generate grub efi image"
  sign_image || error "Failed to sign grub efi image"
  #clean
}

main
