#
# libjpeg install script for MinGW.
#
# - libjpeg V9
#
 
 
#
# Config
#
PREFIX=/usr
#LIBPNG_VERSION=v9
 
 
#
# Install msys tools.
#
mingw-get update
mingw-get install msys-wget msys-unzip msys-perl
 
#
# Install pkg-config
#
wget http://ftp.gnome.org/pub/gnome/binaries/win32/glib/2.24/glib_2.24.0-2_win32.zip
wget http://ftp.gnome.org/pub/gnome/binaries/win32/dependencies/pkg-config_0.23-3_win32.zip
unzip -n glib_2.24.0-2_win32.zip -d /usr
unzip -n pkg-config_0.23-3_win32.zip -d /usr
rm glib_2.24.0-2_win32.zip
rm pkg-config_0.23-3_win32.zip
pkg-config --version

# using mingw default zlib

#
# Install libjpeg
#
#wget http://prdownloads.sourceforge.net/libpng/libpng-1.6.17.tar.gz
#tar zxvf libpng-1.6.17.tar.gz
#cd libpng-1.6.17 && \
#./configure --prefix=$PREFIX --enable-shared --enable-static && \
#mqake && \
#make install