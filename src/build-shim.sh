#!/bin/bash

readonly OUTPUT=../shim-output
readonly CERT_FILE="../deepin.cer"
readonly EFI_DIR=deepin

build() {
  local arch=$1

  if [ ! -f "${CERT_FILE}" ]; then
    echo "Failed to find cert file at: ${CERT_FILE}"
    return 1
  fi

  make clean

  case "${arch}" in
    ia32)
      setarch linux32 make ARCH=ia32 VENDOR_CERT_FILE="${CERT_FILE}" -j4 | \
        tee "${OUTPUT}/shim-build-${arch}.log" && \
      setarch linux32 make ARCH=ia32 DESTDIR="${OUTPUT}/${arch}" \
        EFIDIR="${EFI_DIR}" install | tee "${OUTPUT}/shim-install-${arch}.log"
     ;;
    amd64)
      # Replace amd64 with x86_64 or else efibind.h will not found
      setarch linux64 make ARCH=x86_64 VENDOR_CERT_FILE="${CERT_FILE}" -j4 | \
        tee "${OUTPUT}/shim-build-${arch}.log" && \
      setarch linux64 make ARCH=x86_64 DESTDIR="${OUTPUT}/${arch}" \
        EFIDIR="${EFI_DIR}" install | tee "${OUTPUT}/shim-install-${arch}.log"
     ;;
  esac
}

efi_to_cab() {
  which lcab || sudo apt install -y lcab
  local efi_file=$1
  local cab_file=$2
  lcab "${efi_file}" "${cab_file}"
}

main() {
  mkdir -v "${OUTPUT}"
  build ia32 && \
  build amd64 && \
  install -m644 "${OUTPUT}/ia32/boot/efi/EFI/${EFI_DIR}/shimia32.efi" "${OUTPUT}/" && \
  install -m644 "${OUTPUT}/amd64/boot/efi/EFI/${EFI_DIR}/shimx64.efi" "${OUTPUT}/" && \
  efi_to_cab "${OUTPUT}/shimia32.efi" "${OUTPUT}/shimia32-unsigned.cab" && \
  efi_to_cab "${OUTPUT}/shimx64.efi" "${OUTPUT}/shimx64-unsigned.cab"
}

main
