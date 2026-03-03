#!/bin/sh

export QT_PLUGIN_PATH=$(pwd)/lib/aarch64-linux-gnu/qt6/plugins
export QT_OPENGL_VARIANT=gles
export QTWEBENGINEPROCESS_PATH=$(pwd)/lib/aarch64-linux-gnu/qt6/libexec/QtWebEngineProcess
export QTWEBENGINE_RESOURCES_PATH=$(pwd)/usr/share/qt6/resources/
export QTWEBENGINE_LOCALES_PATH=$(pwd)/usr/share/qt6/translations/qtwebengine_locales/
export QT_QPA_PLATFORM=ubuntumirclient

usr/bin/qmlscene6 qml/main.qml -I lib/aarch64-linux-gnu/qt6/qml/
