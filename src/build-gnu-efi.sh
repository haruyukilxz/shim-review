#!/bin/bash

# Download and build gnu-efi

readonly BASEDIR=$(dirname $(realpath $0))
readonly VERSION="3.0.8"
readonly WORKDIR="${BASEDIR}/gnu-efi-${VERSION}"
readonly TARBALL="gnu-efi-${VERSION}.tar.bz2"
readonly SRC_URL="https://jaist.dl.sourceforge.net/project/gnu-efi/${TARBALL}"

error() {
  echo "ERROR: $*" >&2
  exit 1
}

# Install toolchain
check_toolchain() {
  echo "Checking toolchain .."
  which wget 1>/dev/null || sudo apt install -y wget && \
  which gcc 1>/dev/null || sudo apt install -y build-essential && \
  dpkg -l libc6-dev-i386 1>/dev/null || sudo apt install -y libc6-dev-i386
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
  local libdir=/usr/lib/gnuefi
  [ "${arch}" = x86_64 ] && libdir=/usr/lib64/gnuefi

  cd "${WORKDIR}" && \
  make ARCH="${arch}" PREFIX=/usr LIBDIR="${libdir}"
}

install() {
  local arch=$1
  local libdir=/usr/lib/gnuefi
  [ "${arch}" = x86_64 ] && libdir=/usr/lib64/gnuefi

  cd "${WORKDIR}" && \
  sudo make ARCH="${arch}" PREFIX=/usr LIBDIR="${libdir}" install
}

clean() {
  echo "Clean up .."
  rm -rvf "${WORKDIR}"
}

main() {
  check_toolchain || error "Failed to install toolchain"
  prepare_source || error "Failed to download source"
  build ia32 || error "Failed to build ia32 type"
  build x86_64 || error "Failed to build x64 type"
  install ia32
  install x86_64
  clean
}

main
