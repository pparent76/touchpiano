#!/bin/bash
set -e  # Exit immediately on error

lsb_release -a
# ========================
# PROJECT CONFIGURATION
# ========================
PROJECT_NAME="touchpiano"
INSTALL_DIR="${BUILD_DIR}/install"

# =================================================
# STEP 6: Install dependencies
# =================================================
echo "[1/4] Install dependencies..."


 DEPENDENCIES="libb2-1 libopengl0 libxcb-cursor0"
  for dep in $DEPENDENCIES ; do
    echo "Handle $dep"
     if [ ! -d "${dep}.deb_extract_chsdjksd" ]; then
        apt download $dep:arm64
        mv ${dep}_*.deb ${dep}.deb
        mkdir "${dep}.deb_extract_chsdjksd"
        dpkg-deb -x "${dep}.deb" "${dep}.deb_extract_chsdjksd"
     fi
 done
mkdir -p $BUILD_DIR/ubports-apt/etc/apt
mkdir -p $BUILD_DIR/ubports-apt/var/lib/apt/lists/partial
mkdir -p $BUILD_DIR/ubports-apt/var/cache/apt/archives/partial
mkdir -p $BUILD_DIR/ubports-apt/etc/apt/sources.list.d/

echo "deb https://repo.ubports.com/ 24.04-2.x main" > $BUILD_DIR//ubports-apt/etc/apt/sources.list

apt -o Dir=$BUILD_DIR/ubports-apt -o Dir::Etc=$BUILD_DIR/ubports-apt/etc/apt -o Dir::State=$BUILD_DIR/ubports-apt/var/lib/apt  -o Dir::Cache=~$BUILD_DIR/ubports-apt/var/cache/apt -o Dir::Etc::trusted=/etc/apt/trusted.gpg -o Dir::Etc::trustedparts=/etc/apt/trusted.gpg.d update

 cd ${BUILD_DIR}
 DEPENDENCIES="libqt6core6t64 libqt6qml6 libqt6quick6 libqt6webenginecore6 libqt6webenginequick6 libqt6webenginewidgets6  maliit-inputcontext-qt6 qml6-module-qtquick qmlscene-qt6 libqt6widgets6 libqt6gui6 libqt6qmlmeta6 libqt6qmlmodels6 libqt6network6 libqt6opengl6 libqt6qmlworkerscript6 libqt6dbus6 qml6-module-qtwebengine qml6-module-lomiri-components liblomiritoolkit-qt6-1 liblomirigestures-qt6-1 liblomirimetrics-qt6-1 liblomirisysteminfo-qt6-1 lomiri-ui-toolkit-theme-qt6 libqt6webchannelquick6 libqt6webchannel6 libqt6positioning6 qml6-module-lomiri-performancemetrics qml6-module-qtquick-window libqt6webenginecore6-bin maliit-inputcontext-qt6 qtubuntu-qt6 libqt6core5compat6 liblomiri-content-hub-qt6-1 liblomiri-download-manager-client-qt6-0 libldm-common-qt6-0 liblomiri-download-manager-common-qt6-0 "
 
 for dep in $DEPENDENCIES ; do
    echo "Handle $dep"
     if [ ! -d "${dep}.deb_extract_chsdjksd" ]; then
        apt -o Dir=$BUILD_DIR/ubports-apt -o Dir::Etc=$BUILD_DIR/ubports-apt/etc/apt -o Dir::State=$BUILD_DIR/ubports-apt/var/lib/apt -o Dir::Cache=$BUILD_DIR/ubports-apt/var/cache/apt download $dep:arm64
        mv ${dep}_*.deb ${dep}.deb
        mkdir "${dep}.deb_extract_chsdjksd"
        dpkg-deb -x "${dep}.deb" "${dep}.deb_extract_chsdjksd"
     fi
 done
 
 DEPENDENCIES="libqt6webengine6-data libqt6webengine6-data"
 
 for dep in $DEPENDENCIES ; do
    echo "Handle $dep"
     if [ ! -d "${dep}.deb_extract_chsdjksd" ]; then
        apt -o Dir=$BUILD_DIR/ubports-apt -o Dir::Etc=$BUILD_DIR/ubports-apt/etc/apt -o Dir::State=$BUILD_DIR/ubports-apt/var/lib/apt -o Dir::Cache=$BUILD_DIR/ubports-apt/var/cache/apt download $dep:all
        mv ${dep}_*.deb ${dep}.deb
        mkdir "${dep}.deb_extract_chsdjksd"
        dpkg-deb -x "${dep}.deb" "${dep}.deb_extract_chsdjksd"
     fi
 done
 
  echo "Handle qtubuntu-qt6"
  wget https://repo.ubports.com/pool/main/q/qtubuntu-gles/qtubuntu-qt6_0.66~20251210073359.15~5499edf+ubports24.04.2_arm64.deb

echo "[2/4] Build painco..."

rm -rvf $INSTALL_DIR/pianco || true
cp -r ${ROOT}/pianco $INSTALL_DIR/

# npm run build
# npx pkg . --targets node18-linux-arm64

# ==============================
# STEP 6: Copying files
# ==============================  
echo "[3/4] Copying files..." 


cp ${ROOT}/touchpiano.desktop "$INSTALL_DIR/"
cp ${ROOT}/manifest.json "$INSTALL_DIR/"
cp ${ROOT}/touchpiano.apparmor "$INSTALL_DIR/"
cp ${ROOT}/launcher.sh "$INSTALL_DIR/"
cp ${ROOT}/icon.png "$INSTALL_DIR/"
cp -r ${ROOT}/qml "$INSTALL_DIR/"


echo "Copying libraries dependencies..."
cd ${BUILD_DIR}
# Copie des fichiers du dossier /lib/ de chaque paquet
rm -rvf $INSTALL_DIR/lib
mkdir -p "$INSTALL_DIR/lib/aarch64-linux-gnu/qt6/qml"
mkdir -p "$INSTALL_DIR/lib/aarch64-linux-gnu/qt6/libexec"
for DIR in *_extract_chsdjksd; do
    
    if [ -d "$DIR/usr/lib/aarch64-linux-gnu/" ]; then
        cp -r "$DIR/usr/lib/aarch64-linux-gnu/"* "$INSTALL_DIR/lib/aarch64-linux-gnu/"
        if [ -d "$DIR/usr/lib/aarch64-linux-gnu/qt6/qml/" ]; then
            echo $DIR
            cp -r "$DIR/usr/lib/aarch64-linux-gnu/qt6/qml/"* "$INSTALL_DIR/lib/aarch64-linux-gnu/qt6/qml"
        fi
    fi
done

rm -rvf $INSTALL_DIR/usr || true
cp -r qmlscene-qt6.deb_extract_chsdjksd/usr $INSTALL_DIR/

cp libqt6webenginecore6-bin.deb_extract_chsdjksd/usr/lib/qt6/libexec/* $INSTALL_DIR/lib/aarch64-linux-gnu/qt6/libexec
chmod +x $INSTALL_DIR/lib/aarch64-linux-gnu/qt6/libexec/*

cp -r  lomiri-ui-toolkit-theme-qt6.deb_extract_chsdjksd/usr/lib/aarch64-linux-gnu/qt6/qml/Lomiri/Components/Themes $INSTALL_DIR/lib/aarch64-linux-gnu/qt6/qml/Lomiri/Components/

cp -r  libqt6webengine6-data.deb_extract_chsdjksd/usr/share/ $INSTALL_DIR/usr/


cp libqt6webenginecore6-bin.deb_extract_chsdjksd/usr/share/qt6/resources/v8_context_snapshot.bin $INSTALL_DIR/usr/share/qt6/resources/

chmod +x $INSTALL_DIR/launcher.sh
chmod +x $INSTALL_DIR/usr/bin/qmlscene6


# ========================
# STEP 7: BUILD THE CLICK PACKAGE
# ========================
echo "[4/4] Building click package..."
# click build "$INSTALL_DIR"

echo "✅ Preparation done, building the .click package."
 
