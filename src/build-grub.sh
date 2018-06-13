#!/bin/sh

# Download and build gnu-efi

readonly BASEDIR=$(dirname $(realpath $0))
readonly VERSION="2.02"
readonly WORKDIR="${BASEDIR}/grub-${VERSION}"
readonly TARBALL="grub-${VERSION}.tar.xz"
readonly SRC_URL="ftp://ftp.gnu.org/gnu/grub/${TARBALL}"

error() {
  echo "ERROR: $*" >&2
  exit 1
}

# Install toolchain
check_toolchain() {
  echo "Checking toolchain .."
  which wget 1>/dev/null || sudo apt install -y wget && \
  which gcc 1>/dev/null || sudo apt install -y build-essential
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
  make
}

clean() {
  echo "Clean up .."
  rm -rvf "${WORKDIR}"
}

main() {
  check_toolchain || error "Failed to install toolchain"
  prepare_source || error "Failed to download source"
  build
  clean
}

main
