# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
GCONF_DEBUG="yes"
AUTOTOOLS_PRUNE_LIBTOOL_FILES="modules"

MY_PN=${PN/-gnome}
MY_P=${MY_PN}-${PV}

inherit autotools eutils gnome3

DESCRIPTION="GNOME plugin for libsoup"
HOMEPAGE="http://live.gnome.org/LibSoup"
SRC_URI="${SRC_URI//-gnome}"

LICENSE="LGPL-2+"
SLOT="2.4"
IUSE="debug +introspection"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~x86-solaris"

RDEPEND="
	~net-libs/libsoup-${PV}[introspection?]
	dev-db/sqlite:3=
	introspection? ( >=dev-libs/gobject-introspection-0.9.5 )
	>=net-libs/libsoup-2.42.2-r1
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.10
	>=dev-util/intltool-0.35
	sys-devel/gettext
	virtual/pkgconfig
"

S=${WORKDIR}/${MY_P}

PATCHES=(
	"${FILESDIR}"/${P}-system-lib.patch
)
AUTOTOOLS_AUTORECONF="yes"

src_configure() {
	# FIXME: we need addpredict to workaround bug #324779 until
	# root cause (bug #249496) is solved
	addpredict /usr/share/snmp/mibs/.index

	# Disable apache tests until they are usable on Gentoo, bug #326957
	gnome3_src_configure \
		--disable-static \
		--disable-tls-check \
		$(use_enable introspection) \
		--with-libsoup-system \
		--with-gnome \
		--without-apache-httpd
}
