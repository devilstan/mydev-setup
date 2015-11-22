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

# msys 開發工具下載
# 壓縮/解壓縮工具 (用最新的)
wget -v -N -o mydev-setup.log -P $DLPATH http://zlib.net/zlib-1.2.8.tar.gz
# 加解密工具 openSSL (如果遇到https, 改成http才不會遇到下載認證問題)
wget -v -N -o mydev-setup.log -P $DLPATH http://www.openssl.org/source/openssl-1.0.2d.tar.gz
# PNG工具 (用最新的)
wget -v -N -a mydev-setup.log -P $DLPATH http://download.sourceforge.net/libpng/libpng-1.6.19.tar.gz
# 檔案傳輸協定
#wget -v -N -a mydev-setup.log -P $DLPATH http://curl.haxx.se/download/curl-7.45.0.tar.gz

# msys 開發工具安裝
# 安裝 openSSL
tar xvfz $DLPATH/openssl-1.0.2d.tar.gz
cd openssl-1.0.2d
perl Configure mingw no-shared no-asm --prefix=/mingw/local/openSSL
make depend
make
make install
cd ..

# 安裝壓縮工具
tar xvfz $DLPATH/zlib-1.2.8.tar.gz
cd zlib-1.2.8
make -f win32/Makefile.gcc BINARY_PATH=/mingw/local/bin INCLUDE_PATH=/mingw/local/include LIBRARY_PATH=/mingw/local/lib install
cd ..

# 安裝PNG工具 (需要先安裝壓縮工具)
ZLIBLIB=/mingw/local/lib export ZLIBLIB
ZLIBINC=/mingw/local/include export ZLIBINC
CPPFLAGS="-I$ZLIBINC" export CPPFLAGS
LDFLAGS="-L$ZLIBLIB" export LDFLAGS
tar xvfz $DLPATH/libpng-1.6.19.tar.gz
cd libpng-1.6.19
mv INSTALL INSTALL.txt
./configure --prefix=/mingw/local/png --enable-shared --enable-static 
make 
make install
cd ..

# 安裝檔案傳輸協定	(下載 https 用的, 裝到 mingw 系統路徑下)
tar xvfz $DLPATH/curl-7.45.0.tar.gz
cd curl-7.45.0
./configure --prefix=/usr
make 
make install
cd ..

# 專案需要工具安裝
# 安裝 google protocol buffers (使用curl下載)
curl -L -k -o $DLPATH/protobuf-2.6.1.tar.gz http://github.com/google/protobuf/releases/download/v2.6.1/protobuf-2.6.1.tar.gz
tar xvfz $DLPATH/protobuf-2.6.1.tar.gz
cd protobuf-2.6.1
./autogen.sh
./configure --prefix=/mingw/local/protobuf
make
make check
make install
cd ..

# 安裝 libqrencode (使用curl下載)
# 不要編譯工具 --with-tools=no
curl -L -k -o $DLPATH/qrencode-3.4.4.tar.gz https://fukuchi.org/works/qrencode/qrencode-3.4.4.tar.gz
tar xvfz $DLPATH/qrencode-3.4.4.tar.gz
cd qrencode-3.4.4
./autogen.sh
./configure --prefix=/mingw/local/qrencode --with-tools=no
make
make install
cd ..