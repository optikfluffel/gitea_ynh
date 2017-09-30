#
# Common variables
#

APPNAME="gitea"

# Gogs version
VERSION="1.1.4"

# Detect the system architecture to download the right tarball
# NOTE: `uname -m` is more accurate and universal than `arch`
# See https://en.wikipedia.org/wiki/Uname
if [ -n "$(uname -m | grep 64)" ]; then
	ARCHITECTURE="linux-amd64"
elif [ -n "$(uname -m | grep 86)" ]; then
	ARCHITECTURE="linux-386"
elif [ -n "$(uname -m | grep armv6)" ]; then
	ARCHITECTURE="linux-arm-6"
elif [ -n "$(uname -m | grep armv7)" ]; then
	ARCHITECTURE="linux-arm-7"
else
	ynh_die "Unable to detect your achitecture, please open a bug describing \
        your hardware and the result of the command \"uname -m\"." 1
fi

# Remote URL to fetch Gitea binary
GITEA_BINARY_URL="https://dl.gitea.io/${APPNAME}/${VERSION}/${APPNAME}-${VERSION}-${ARCHITECTURE}"

# Download and move Gitea binary to the given directory
# usage: install_gitea DESTDIR
install_gitea() {
  local DESTDIR=$1
  
  # Retrieve Gitea binary
  gitea_binary="/tmp/gitea"
  rm -f "gitea_binary"
  wget -q -O "$gitea_binary" "$GITEA_BINARY_URL" \
    || ynh_die "Unable to download Gitea binary"
  sudo rsync -a "/tmp/gitea" "$DESTDIR"
  rm -rf "$gitea_binary" "${TMPDIR:-/tmp/fakefile}"
}
