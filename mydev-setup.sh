#
# Lib install script for MinGW.
#
# - zlib-1.2.8         壓縮
# - openSSL-1.0.2d     加解密 https://www.openssl.org/
# - libpng-1.6.19      png
# - protobuf-2.6.1     google protocol buffers https://developers.google.com/protocol-buffers/docs/downloads
# - qrencode-3.4.4     QR-Code 編碼freetype-2.6.1 https://fukuchi.org/works/qrencode/
# - freetype-2.6.1     text-2-image
#
 
# build by cmake, not here
# - opencv-2.4.9       影像處理(暫時應用, 因為 merge 影像不需要用到 opencv 就可以做到了)
 
#
# Config
#
PREFIX=/usr
DLPATH=~/mydev_tmp
# /usr 對應到 windows path = "C:\MinGW\msys\1.0"

 
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
# 檔案傳輸協定 (下載工具, 非專案必要函式庫, 使用 win32 安裝包就好)
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


# 安裝 freetype2
wget -v -N -a mydev-setup.log -P $DLPATH http://sourceforge.net/projects/freetype/files/freetype2/2.6.1/freetype-2.6.1.tar.gz
tar xvfz $DLPATH/freetype-2.6.1.tar.gz
cd freetype-2.6.1
./configure --prefix=/mingw/local/freetype2 --enable-static
make
make install
cd ..

# 安裝 zbar QR-Code 解碼工具
curl -L -k -o $DLPATH/zbar-master.zip https://github.com/devilstan/ZBar/archive/master.zip
./configure --prefix=/mingw/local/zbar --enable-static --without-jpeg --without-python --without-gtk --without-qt --without-imagemagick
# make 時，如果遇到 iconv 庫找不到的編譯錯誤訊息，可利用 mingw-get 下載 MinGW Autotools: libiconv (class:dev)
make
make install