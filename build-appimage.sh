# Build an AppImage containing appimagetool and mksquashfs

if [ ! -d ./build ] ; then
  echo "You need to run build.sh first"
fi

mkdir -p appimagetool.AppDir/usr/bin
cp -f build/appimagetool appimagetool.AppDir/usr/bin

# Add -offset option to skip n bytes : https://github.com/plougher/squashfs-tools/pull/13
# It seems squashfs-tools need a new maintainer.
cd squashfs-tools/squashfs-tools
make XZ_SUPPORT=1 mksquashfs # LZ4_SUPPORT=1 did not build yet on CentOS 6
strip mksquashfs
cp mksquashfs ../../build

cd ../../

cp build/AppRun appimagetool.AppDir/
cp build/appimagetool appimagetool.AppDir/usr/bin/
cp build/mksquashfs appimagetool.AppDir/usr/bin/

cp $(which zsyncmake) appimagetool.AppDir/usr/bin/

cp resources/appimagetool.desktop appimagetool.AppDir/
cp resources/appimagetool.svg appimagetool.AppDir/

( cd appimagetool.AppDir ; ln -sf appimagetool.svg .DirIcon )

# Eat our own dogfood
PATH="$PATH:build"
appimagetool appimagetool.AppDir/ -v -u "zsync|https://github.com/probonopd/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage.zsync"

#######################################################################

mkdir -p appimaged.AppDir/usr/bin
mkdir -p appimaged.AppDir/usr/lib
cp -f build/appimaged appimaged.AppDir/usr/bin

cp build/AppRun appimaged.AppDir/
find /usr/lib -name libarchive.so.3 -exec cp {} appimaged.AppDir/usr/lib/ \;

cp resources/appimaged.desktop appimaged.AppDir/
cp resources/appimagetool.svg appimaged.AppDir/appimaged.svg

appimagetool appimaged.AppDir/ -v -u "zsync|https://github.com/probonopd/AppImageKit/releases/download/continuous/appimaged-x86_64.AppImage.zsync"

#######################################################################
