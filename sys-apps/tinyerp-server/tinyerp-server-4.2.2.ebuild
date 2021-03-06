# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/tinyerp-server/tinyerp-server-4.0.3.ebuild,v 1.3 2007/07/23 20:21:13 opfer Exp $

inherit eutils distutils

DESCRIPTION="Open Source ERP & CRM"
HOMEPAGE="http://tinyerp.org/"
SRC_URI="mirror://sourceforge/tinyerp/${P}.tar.gz
		http://www.tinyerp.org/download/old/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ssl"

DEPEND=">=dev-db/postgresql-server-8.4
	dev-python/pypgsql
	dev-python/reportlab
	dev-python/pyparsing
	media-gfx/pydot
	dev-python/psycopg
	dev-libs/libxml2
	dev-libs/libxslt
	>dev-python/pychart-1.37
	dev-python/pytz
	ssl? ( dev-python/pyopenssl )"

TINYERP_USER=terp
TINYERP_GROUP=terp

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${P}-ssl.patch
}

pkg_setup() {
	if ! built_with_use dev-libs/libxslt python ; then
		eerror "dev-libs/libxslt must be built with python"
		die "${PN} requires dev-libs/libxslt with USE=python"
	fi
}

src_install() {
	distutils_src_install

	newinitd "${FILESDIR}"/tinyerp-init.d tinyerp
	newconfd "${FILESDIR}"/tinyerp-conf.d tinyerp

	insinto /etc/tinyerp
	doins "${FILESDIR}"/terp_serverrc
	fowners ${TINYERP_USER}:${TINYERP_GROUP} /etc/tinyerp/terp_serverrc
	chmod 0600 "${D}"/etc/tinyerp/terp_serverrc

	keepdir /var/run/tinyerp
	keepdir /var/log/tinyerp
}

pkg_preinst() {
	enewgroup ${TINYERP_GROUP}
	enewuser ${TINYERP_USER} -1 -1 -1 ${TINYERP_GROUP}

	fowners ${TINYERP_USER}:${TINYERP_GROUP} /var/run/tinyerp
	fowners ${TINYERP_USER}:${TINYERP_GROUP} /var/log/tinyerp
}

pkg_postinst() {
	elog "In order to setup the initial database, run:"
	elog "  emerge --config =${CATEGORY}/${PF}"
	elog "Be sure the database is started before"
}

pquery() {
	psql -q -At -U postgres -d template1 -c "$@"
}

pkg_config() {
	einfo "In the following, the 'postgres' user will be used."
	if ! pquery "SELECT usename FROM pg_user WHERE usename = '${TINYERP_USER}'" | grep -q ${TINYERP_USER}; then
		ebegin "Creating database user ${TINYERP_USER}"
		createuser --quiet --username=postgres --createdb --no-adduser ${TINYERP_USER}
		eend $? || die "Failed to create database user"
	fi
}
