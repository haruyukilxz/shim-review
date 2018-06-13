#!/bin/bash

# Download and build shim efi files

readonly BASEDIR=$(dirname $(realpath $0))
readonly VERSION=15
readonly WORKDIR="${BASEDIR}/shim-15"
readonly OUTPUT="${BASEDIR}/shim-output"
readonly LOGDIR="${BASEDIR}/../logs"
readonly SHIM_EFI_DIR="${BASEDIR}/../shim"
readonly CERT_FILE="${BASEDIR}/../deepin.cer"
readonly EFI_DIR=deepin
readonly SRC_URL="https://github.com/rhboot/shim/archive/${VERSION}.tar.gz"
readonly TARBALL="shim-${VERSION}.tar.gz"

error() {
  echo "ERROR: $*" >&2
  exit 1
}

# Install toolchain
check_toolchain() {
  echo "Checking toolchain .."
  which wget 1>/dev/null || sudo apt install -y wget && \
  which gcc 1>/dev/null || sudo apt install -y build-essentials && \
  which lcab 1>/dev/null || sudo apt install -y lcab
  dpkg -l gnu-efi || sudo apt install -y gnu-efi
}

# Download shim source
prepare_source() {
  echo "Checking source file .."
  if [ ! -f "${TARBALL}" ]; then
    wget "${SRC_URL}" -O "${TARBALL}" || return 1
  fi
}

# Build shim efi file and convert to cab format
# @param $1 arch, target architecture, might be x64 or ia32
build() {
  local arch=$1
  local gcc_arch="${arch}"
  local shim_file="shim${arch}"
  local ncpu
  ncpu=$(grep 'cpu cores' /proc/cpuinfo | wc -l)
  [ "${arch}" = "x64" ] && gcc_arch=x86_64

  echo "Building ${arch} .."

  if [ ! -f "${CERT_FILE}" ]; then
    echo "Failed to find cert file at: ${CERT_FILE}"
    return 1
  fi

  tar -xf "${TARBALL}" || return 1
  cd "${WORDIR}"

  make ARCH="${gcc_arch}" VENDOR_CERT_FILE="${CERT_FILE}" -j${ncpu} 2>&1 | \
    tee "${LOGDIR}/shim-build-${arch}.log" && \
  make ARCH="${gcc_arch}" DESTDIR="${OUTPUT}/${arch}" EFIDIR="${EFI_DIR}" install && \
  install -m644 "${OUTPUT}/${arch}/boot/efi/EFI/${EFI_DIR}/${shim_file}.efi" "${OUTPUT}/" && \
  lcab"${OUTPUT}/${shim_file}.efi" "${OUTPUT}/${shim_file}-unsigned.cab"

  cd ..
  rm -rvf "${WORDIR}"
}

clean() {
  rm -rvf "${OUTPUT}"
}

main() {
  check_toolchain || error "Failed to install toolchain"
  prepare_source || error "Failed to download shim source file"
  build ia32 || error "Failed to build shim ia32"
  build x64 || error "Failed to build shim x64"
  #clean
}

main
