# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-accessibility/accerciser/accerciser-1.6.1.ebuild,v 1.5 2009/11/01 18:35:31 eva Exp $
inherit subversion eutils autotools

ESVN_REPO_URI="svn+ssh://public.nic.cz/svn/enum/"

ESVN_STORE_DIR="${PORTAGE_ACTUAL_DISTDIR-${DISTDIR}}/svn-src/"

DESCRIPTION="FRED is system for managing TLD"
HOMEPAGE="http://www.nic.cz/"
RESTRICT="test"

#IUSE="ipv6 mysql sqlite ncurses nls gtk"
IUSE=""
KEYWORDS="amd64 ~ppc ~sparc x86"
LICENSE="GPL-2"
SLOT="0"

RDEPEND="
dev-db/postgresql-base
dev-db/postgresql-server
dev-libs/libdaemon
app-arch/unzip
net-misc/omniORB
dev-python/simpletal
net-dns/bind-tools
dev-python/pyorbit
media-fonts/freefont-ttf
dev-python/simplejson
dev-python/dnspython
dev-python/cherrypy
net-dns/ldns-utils
dev-python/python-ldap
www-apache/mod_python
net-dns/bind
app-arch/zip
app-doc/doxygen
=dev-libs/boost-1.35.0-r5
=dev-util/boost-build-1.35.0-r2
=dev-python/simpletal-4.2
dev-python/omniorbpy
dev-db/pygresql
dev-libs/clearsilver
net-misc/whois"


#>=media-libs/libextractor-0.5.13
#>=dev-libs/gmp-4.0.0
#sys-libs/zlib
#net-misc/curl
#gtk? ( >=x11-libs/gtk+-2.6.10 )
#sys-apps/sed
#>=dev-scheme/guile-1.8.0
#ncurses? ( sys-libs/ncurses )
#mysql? ( >=virtual/mysql-4.0 )
#sqlite? ( >=dev-db/sqlite-3.0.8 )
#nls? ( sys-devel/gettext )"

#pkg_setup() {
#if ! use mysql && ! use sqlite; then
#einfo "You need to specify at least one of 'mysql' or 'sqlite'"
#einfo "USE flag in order to have properly installed gnunet"
#einfo
#die "Invalid USE flag set"
#fi
#}

#pkg_preinst() {
#enewgroup gnunetd || die "Problem adding gnunetd group"
#enewuser gnunetd -1 -1 /dev/null gnunetd || die "Problem adding gnunetd user"
#}

src_unpack() {
#ESVN_BOOTSTRAP="bootstrap"
ESVN_UPDATE_CMD="svn up" \
ESVN_FETCH_CMD="svn checkout" \
subversion_src_unpack
AT_M4DIR="${S}/m4" eautoreconf
#subversion_bootstrap
cd "${S}"
##! use sqlite && \
#sed -i 's:default "sqstore_sqlite":default "sqstore_mysql":' \
#contrib/config-daemon.in

# we do not want to built gtk support with USE=-gtk
#if ! use gtk ; then
#sed -i "s:AC_DEFINE_UNQUOTED..HAVE_GTK.*:true:" configure.ac
#fi

}

src_compile() {
local myconf

#if use ipv6; then
#if use amd64; then
#ewarn "ipv6 in GNUnet does not currently work with amd64 and has been disabled"
#else
#myconf="${myconf} --enable-ipv6"
#fi
#fi

#use mysql || myconf="${myconf} --without-mysql"

#econf \
#$(use_with sqlite) \
#$(use_enable nls) \
#$(use_enable ncurses) \
#$(use_enable guile) \
#${myconf} || die "econf failed"

#emake || die "emake failed"
}

src_install() {
make install DESTDIR="${D}" || die "make install failed"
#dodoc ABOUT-NLS AUTHORS ChangeLog COPYING INSTALL NEWS PLATFORMS README README.fr UPDATING
#insinto /etc
#newins contrib/gnunet.root gnunet.conf
#docinto contrib
#dodoc contrib/*
#newinitd ${FILESDIR}/${PN}-2 gnunet
#dodir /var/lib/gnunet
#chown gnunetd:gnunetd ${D}/var/lib/gnunet
}

pkg_postinst() {
# make sure permissions are ok
#chown -R gnunetd:gnunetd /var/lib/gnunet
#
#use ipv6 && ewarn "ipv6 support is -very- experimental and prone to bugs"
einfo
einfo "Make sure that user is in group cron and crontab"
einfo "if not run  # sudo gpasswd -a username cron crontab "
einfo "Plese check that settings was appliad by running # crontab -l"
einfo "If not you have to logout and login again"
einfo
einfo "continue with installation of fred by "
einfo "wget http://fred.nic.cz/sources/fred-manager"
einfo "chmod a+x fred-manager "
einfo "./fred-manager download"
einfo "./fred-manager install"
einfo "Before starting fred run"
einfo "sed"
einfo "sed"
einfo "./fred-manager start"
}
