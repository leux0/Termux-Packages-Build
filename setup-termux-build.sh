#!/bin/bash
set -e -u

###############################################################################
# 
# 项目地址：https://github.com/termux/termux-packages/
# 
# 所有脚本来源于：https://github.com/termux/termux-packages/tree/master/scripts
#
# 将 setup-ubuntu.sh setup-android-sdk.sh properties.sh 脚本融合为一个脚本
# 
###############################################################################

TERMUX_NDK_VERSION=18
TERMUX_ANDROID_BUILD_TOOLS_VERSION=28.0.3

SDK="${HOME}/lib/android-sdk"
NDK="${HOME}/lib/android-ndk"
ANDROID_SDK_FILE=sdk-tools-linux-4333796.zip
ANDROID_SDK_SHA256=92ffee5a1d98d856634e8b71132e8a95d96c83a63fde1099be3d86df3106def9
ANDROID_NDK_FILE=android-ndk-r${TERMUX_NDK_VERSION}-Linux-x86_64.zip
ANDROID_NDK_SHA256=c413dd014edc37f822d0dc88fabc05b64232d07d5c6e9345224e47073fdf140b


###############################################################################

echo -e "\nStart Installing Dependencies...\n"

# sudo apt install asciidoc asciidoctor automake bison curl ed flex g++-multilib gettext g++ git gperf help2man intltool libglib2.0-dev libtool-bin libncurses5-dev lzip  python3 tar unzip m4 openjdk-8-jdk-headless pkg-config python3-docutils python3-setuptools python3-sphinx ruby scons texinfo xmlto libexpat1-dev libjpeg-dev gawk libssl-dev

PACKAGES=""
PACKAGES+=" asciidoc"
PACKAGES+=" asciidoctor" 			# Used by weechat for man pages.
PACKAGES+=" automake"
PACKAGES+=" bison"
PACKAGES+=" curl" 					# Used for fetching sources.
PACKAGES+=" ed" 					# Used by bc
PACKAGES+=" flex"
PACKAGES+=" g++-multilib" 			# Used by nodejs build for 32-bit arches.
PACKAGES+=" gettext" 				# Provides 'msgfmt' which the apt build uses.
PACKAGES+=" g++"
PACKAGES+=" git" 					# Used by the neovim build.
PACKAGES+=" gperf" 					# Used by the fontconfig build.
PACKAGES+=" help2man"
PACKAGES+=" intltool" 				# Used by qalc build.
PACKAGES+=" libglib2.0-dev" 		# Provides 'glib-genmarshal' which the glib build uses.
PACKAGES+=" libtool-bin"
PACKAGES+=" libncurses5-dev" 		# Used by mariadb for host build part.
PACKAGES+=" lzip"
PACKAGES+=" python3" 				# ubuntu is python3.7 , debian is python3
PACKAGES+=" tar"
PACKAGES+=" unzip"
PACKAGES+=" m4"
PACKAGES+=" make"
PACKAGES+=" openjdk-8-jdk-headless" # Used for android-sdk.
PACKAGES+=" pkg-config"
PACKAGES+=" python3-docutils" 		# For rst2man, used by mpv.
PACKAGES+=" python3-setuptools" 	# Needed by at least asciinema.
PACKAGES+=" python3-sphinx" 		# Needed by notmuch man page generation.
PACKAGES+=" ruby" 					# Needed to build ruby.
PACKAGES+=" scons"
PACKAGES+=" texinfo"
PACKAGES+=" xmlto"
PACKAGES+=" libexpat1-dev" 			# Needed by ghostscript
PACKAGES+=" libjpeg-dev" 			# Needed by ghostscript
PACKAGES+=" gawk" 					# Needed by apr-util
PACKAGES+=" libssl-dev" 			# Needed to build Rust

sudo DEBIAN_FRONTEND=noninteractive \
	apt-get install -yq --no-install-recommends $PACKAGES

echo -e "\nThe Installation Is Complete...\n"	

sudo mkdir -p /data/data/com.termux/files/usr
sudo chown -R `whoami` /data

###############################################################################

echo -e "\nStart Downloading And Configuring Android Development Tools...\n"

if [ ! -d $SDK ]; then
	mkdir -p $SDK
	cd $SDK/..
	rm -Rf `basename $SDK`

	# https://developer.android.com/studio/index.html#command-tools
	# The downloaded version below is 26.1.1.:
	echo "Downloading android sdk..."
	curl --fail --retry 3 \
		-o tools.zip \
		https://dl.google.com/android/repository/${ANDROID_SDK_FILE}
	echo "${ANDROID_SDK_SHA256} tools.zip" | sha256sum -c -
	rm -Rf android-sdk
	unzip -q tools.zip -d android-sdk
	rm tools.zip
fi

if [ ! -d $NDK ]; then
	mkdir -p $NDK
	cd $NDK/..
	rm -Rf `basename $NDK`
	echo "Downloading android ndk..."
	curl --fail --retry 3 -o ndk.zip \
		https://dl.google.com/android/repository/${ANDROID_NDK_FILE}
	echo "${ANDROID_NDK_SHA256} ndk.zip" | sha256sum -c -
	rm -Rf android-ndk-r$TERMUX_NDK_VERSION
	unzip -q ndk.zip
	mv android-ndk-r$TERMUX_NDK_VERSION `basename $NDK`
	rm ndk.zip
fi

yes | $SDK/tools/bin/sdkmanager --licenses

# The android-21 platform is used in the ecj package:
$SDK/tools/bin/sdkmanager "build-tools;${TERMUX_ANDROID_BUILD_TOOLS_VERSION}" "platforms;android-28" "platforms;android-21"

echo -e "\nAndroid Development Tool Configuration Is Complete...\n"

# git clone https://github.com/termux/termux-packages.git $HOME/
# cd $HOME/termux-packages
# ./build-package.sh packagename
