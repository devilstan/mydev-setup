#
# libjpeg install script for MinGW.
#
# - libjpeg V9
#
 
 
#
# Config
#
PREFIX=/usr
DLPATH=~/mydev_tmp
# /usr 對應到 windows path = "C:\MinGW\msys\1.0"
#LIBPNG_VERSION=v9
 
 
#
# Install msys tools.
#
mingw-get update
mingw-get install msys-wget msys-unzip msys-perl msys-patch
 
#
# Install pkg-config
#
wget -v -N -o mydev-setup.log -P $DLPATH http://ftp.gnome.org/pub/gnome/binaries/win32/glib/2.24/glib_2.24.0-2_win32.zip
wget -v -N -o mydev-setup.log -P $DLPATH http://ftp.gnome.org/pub/gnome/binaries/win32/dependencies/pkg-config_0.23-3_win32.zip
unzip -n $DLPATH/glib_2.24.0-2_win32.zip -d /usr
unzip -n $DLPATH/pkg-config_0.23-3_win32.zip -d /usr
rm $DLPATH/glib_2.24.0-2_win32.zip
rm $DLPATH/pkg-config_0.23-3_win32.zip
pkg-config --version

# download source code
# 壓縮/解壓縮工具 (用最新的)
wget -v -N -o mydev-setup.log -P $DLPATH http://zlib.net/zlib-1.2.8.tar.gz
# PNG工具 (用最新的)
wget -v -N -a mydev-setup.log -P $DLPATH http://download.sourceforge.net/libpng/libpng-1.6.19.tar.gz
# 檔案傳輸協定
wget -v -N -a mydev-setup.log -P $DLPATH http://curl.haxx.se/download/curl-7.45.0.tar.gz
# google protocol buffers (github有認證問題, 使用 curl 工具)
curl -L -k -o $DLPATH/protobuf-2.6.1.tar.gz https://github.com/google/protobuf/releases/download/v2.6.1/protobuf-2.6.1.tar.gz


# 安裝壓縮工具
tar xvfz $DLPATH/zlib-1.2.8.tar.gz
cd zlib-1.2.8
#make -f win32/Makefile.gcc BINARY_PATH=/usr/local/bin INCLUDE_PATH=/usr/local/include LIBRARY_PATH=/usr/local/lib install
cd ..

# 安裝PNG工具 (需要先安裝壓縮工具)
tar xvfz $DLPATH/libpng-1.6.19.tar.gz
cd libpng-1.6.19
mv INSTALL INSTALL.txt
#./configure --prefix=$PREFIX --enable-shared --enable-static && \
#mqake && \
#make install
cd ..
#mqake && \
#make install

# 安裝檔案傳輸協定
tar xvfz $DLPATH/curl-7.45.0.tar.gz
cd curl-7.45.0
cd ..

# 安裝 google protocol buffers
tar xvfz $DLPATH/protobuf-2.6.1.tar.gz
cd protobuf-2.6.1
cd ..