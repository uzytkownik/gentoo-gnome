# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
GCONF_DEBUG="no"

inherit eutils gnome2
if [[ ${PV} = 9999 ]]; then
	inherit gnome2-live
fi

DESCRIPTION="Collection of tools for building and converting documentation"
HOMEPAGE="http://www.gnome.org/"

LICENSE="|| ( GPL-2+ freedist ) GPL-2+" # yelp.m4 is GPL2 || freely distributable
SLOT="0"
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd"
fi
IUSE=""

# Requires gawk, not virtual/awk; using nawk as awk results in syntax errors
RDEPEND=">=dev-libs/libxml2-2.6.12
	>=dev-libs/libxslt-1.1.8
	dev-util/itstool
	gnome-extra/yelp-xsl
	sys-apps/gawk"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}/${PN}-3.6.1-gawk.patch"
	default
}
