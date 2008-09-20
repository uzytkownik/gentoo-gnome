# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/gconf/gconf-2.22.0.ebuild,v 1.8 2008/08/12 13:31:27 armin76 Exp $

inherit autotools eutils gnome2

MY_PN=GConf
MY_P=${MY_PN}-${PV}
PVP=(${PV//[-\._]/ })

DESCRIPTION="Gnome Configuration System and Daemon"
HOMEPAGE="http://www.gnome.org/"
SRC_URI="mirror://gnome/sources/${MY_PN}/${PVP[0]}.${PVP[1]}/${MY_P}.tar.bz2"

LICENSE="LGPL-2"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="debug doc ldap policykit"

RDEPEND=">=dev-libs/glib-2.10
		 >=x11-libs/gtk+-2.8.16
		 >=gnome-base/orbit-2.4
		 >=dev-libs/libxml2-2
		 ldap? ( net-nds/openldap )"
DEPEND="${RDEPEND}
		>=dev-util/intltool-0.35
		>=dev-util/pkgconfig-0.9
		>=dev-util/gtk-doc-am-1.10
		doc? ( >=dev-util/gtk-doc-1 )"

DOCS="AUTHORS ChangeLog NEWS README TODO"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	G2CONF="${G2CONF}
		--enable-gtk
		$(use_enable debug)
		$(use_enable policykit defaults-service)
		$(use_with ldap openldap)"
	kill_gconf
}

src_unpack() {
	gnome2_src_unpack

	# fix bug #193442, GNOME bug #498934
	epatch "${FILESDIR}/${PN}-HEAD-autofoo.patch"

	eautoreconf
}

src_install() {
	gnome2_src_install

	# hack hack
	#dodir /etc/gconf/gconf.xml.mandatory
	#dodir /etc/gconf/gconf.xml.defaults
	keepdir /etc/gconf/gconf.xml.mandatory
	keepdir /etc/gconf/gconf.xml.defaults

	echo 'CONFIG_PROTECT_MASK="/etc/gconf"' > 50gconf
	doenvd 50gconf || die "doenv failed"
	dodir /root/.gconfd
}

pkg_preinst() {
	kill_gconf
}

pkg_postinst() {
	kill_gconf

	#change the permissions to avoid some gconf bugs
	einfo "changing permissions for gconf dirs"
	find  /etc/gconf/ -type d -exec chmod ugo+rx "{}" \;

	einfo "changing permissions for gconf files"
	find  /etc/gconf/ -type f -exec chmod ugo+r "{}" \;
}

kill_gconf() {
	# This function will kill all running gconfd-2 that could be causing troubles
	if [ -x /usr/bin/gconftool-2 ]
	then
		/usr/bin/gconftool-2 --shutdown
	fi

	return 0
}
