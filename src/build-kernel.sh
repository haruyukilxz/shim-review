#!/bin/sh

# Download and build kernel with shim efi patches

readonly BASEDIR=$(dirname $(realpath $0))
readonly VERSION="4.14.49"
readonly WORKDIR="${BASEDIR}/linux-${VERSION}"
readonly TARBALL="linux-${VERSION}.tar.xz"
readonly SRC_URL="https://cdn.kernel.org/pub/linux/kernel/v4.x/${TARBALL}"

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
  cd "${WORKDIR}"
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
