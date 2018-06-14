#!/bin/bash

# Download and build shim efi files

readonly BASEDIR=$(dirname $(realpath $0))
readonly VERSION=15
readonly WORKDIR="${BASEDIR}/shim-${VERSION}"
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
  which gcc 1>/dev/null || sudo apt install -y build-essential && \
  which lcab 1>/dev/null || sudo apt install -y lcab && \
  which nproc 1>/dev/null || sudo apt install -y coreutils && \
  stat /usr/include/efi/efi.h 1>/dev/null || sudo apt install -y gnu-efi && \
  stat /usr/include/libelf.h 1>/dev/null || sudo apt install libelf-dev
  #dpkg -l gnu-efi 1>/dev/null || sudo apt install -y gnu-efi
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
  [ "${arch}" = "x64" ] && gcc_arch=x86_64

  echo "Building ${arch} .."

  if [ ! -f "${CERT_FILE}" ]; then
    echo "Failed to find cert file at: ${CERT_FILE}"
    return 1
  fi

  rm -rf "${WORKDIR}"
  tar -xf "${TARBALL}" || return 1
  cd "${WORKDIR}"

  make ARCH="${gcc_arch}" VENDOR_CERT_FILE="${CERT_FILE}" -j$(nproc) 2>&1 | \
    tee "${LOGDIR}/shim-build-${arch}.log" && \
  rm -rf "${OUTPUT}/${arch}" && \
  make ARCH="${gcc_arch}" DESTDIR="${OUTPUT}/${arch}" EFIDIR="${EFI_DIR}" install && \
  mkdir -p "${SHIM_EFI_DIR}/cab" && \
  install -m644 "${OUTPUT}/${arch}/boot/efi/EFI/${EFI_DIR}/${shim_file}.efi" "${SHIM_EFI_DIR}/" && \
  sha256sum "${SHIM_EFI_DIR}/${shim_file}.efi" | tee "${SHIM_EFI_DIR}/${shim_file}.efi.sha256" && \
  lcab "${SHIM_EFI_DIR}/${shim_file}.efi" "${SHIM_EFI_DIR}/cab/${shim_file}-unsigned.cab"

  cd ..
  rm -rf "${WORKDIR}"
}

main() {
  check_toolchain || error "Failed to install toolchain"
  prepare_source || error "Failed to download shim source file"
  #build ia32 || error "Failed to build shim ia32"
  build x64 || error "Failed to build shim x64"
}

main
