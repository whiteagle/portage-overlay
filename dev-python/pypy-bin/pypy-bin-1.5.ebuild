# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit eutils

DESCRIPTION="PyPy is a very compliant implementation of the Python language with
aim to improve speed of execution"
HOMEPAGE="http://pypy.org/"

LICENSE="MIT"
SLOT="2.5"
PYTHON_ABI="${SLOT}"
KEYWORDS="~amd64"
IUSE="doc examples"

if [ "${ARCH}" = "amd64" ] ; then
	PYPYFLAVOR="linux64"
else
	PYPYFLAVOR="linux"
fi
MY_P="pypy-${PV}-${PYPYFLAVOR}"

SRC_URI="http://pypy.org/download/${MY_P}.tar.bz2"

RDEPEND=">=app-admin/eselect-python-20091230
		>=sys-libs/zlib-1.1.3
		virtual/libffi
		virtual/libintl
		>=app-arch/bzip2-1.0.6-r1
		sys-libs/ncurses
		dev-libs/expat
		dev-libs/openssl"
DEPEND="${RDEPEND}"
PDEPEND="app-admin/python-updater"

S="${WORKDIR}/${MY_P}"

src_install() {
	INSPATH="/usr/$(get_libdir)/pypy-bin${SLOT}"
	insinto ${INSPATH}
	doins -r include lib_pypy lib-python bin || die "failed"
	fperms a+x ${INSPATH}/bin/pypy || die "failed"
	dosym ${INSPATH}/bin/pypy /usr/bin/pypy-bin${SLOT}  || die "failed"
}

