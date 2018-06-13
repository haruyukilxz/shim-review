#!/bin/bash

build() {
  rm -rf ia32/
  make clean
  setarch linux32 make ARCH=ia32 PREFIX=/usr LIBDIR=/usr/lib/gnuefi && \
  sudo make ARCH=ia32 PREFIX=/usr LIBDIR=/usr/lib/gnuefi install

  rm -rf x86_64/
  make clean
  setarch linux64 make ARCH=amd64 PREFIX=/usr LIBDIR=/usr/lib64/gnuefi && \
  sudo make ARCH=amd64 PREFIX=/usr LIBDIR=/usr/lib64/gnuefi install
}

build
