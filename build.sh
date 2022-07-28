#!/bin/bash

pkgname=tuxedo-keyboard-tools
pkgver=1.1
pkgrel=1
arch=amd64
srcdir=$(pwd)
pkgdir=${pkgname}_${pkgver}-${pkgrel}_${arch}

make
mkdir -p ${pkgdir} ${pkgdir}/usr ${pkgdir}/usr/bin ${pkgdir}/etc ${pkgdir}/etc/sudoers.d ${pkgdir}/etc/systemd/system ${pkgdir}/etc/systemd/user ${pkgdir}/opt ${pkgdir}/opt/tuxedo-keyboard-tools

cp -rf ${srcdir}/DEBIAN ${pkgdir} 
cp -rf ${srcdir}/idle ${pkgdir}/opt/tuxedo-keyboard-tools
cp -rf ${srcdir}/tuxedo-color-changer ${pkgdir}/usr/bin
cp -rf ${srcdir}/idle.sh ${pkgdir}/opt/tuxedo-keyboard-tools
cp -rf ${srcdir}/keep.sh ${pkgdir}/opt/tuxedo-keyboard-tools
cp -rf ${srcdir}/tuxedo-keyboard-idle ${pkgdir}/etc/sudoers.d
cp -rf ${srcdir}/tuxedo-keyboard-keep-light-level.service ${pkgdir}/etc/systemd/system
cp -rf ${srcdir}/tuxedo-keyboard-idle.service ${pkgdir}/etc/systemd/user
dpkg-deb --build --root-owner-group ${pkgdir}
clear
