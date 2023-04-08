QT += quick
QT += network
QT += quickcontrols2
CONFIG+=qtquickcompiler
SOURCES += \
        Filesforsend_class.cpp \
        Network.cpp \
        main.cpp \
        thread_for_network.cpp

resources.files += \
                main.qml\
                DialogWin.qml \
                Filesforsend.qml \
                Settings_win.qml
resources.prefix = /$${TARGET}
RESOURCES += resources
RESOURCES += qtquickcontrols2.conf
# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    Filesforsend_class.h \
    Network.h \
    thread_for_network.h

DISTFILES += \
    android/AndroidManifest.xml \
    android/build.gradle \
    android/gradle.properties \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew \
    android/gradlew.bat \
    android/res/values/libs.xml \
    qtquickcontrols2.conf

contains(ANDROID_TARGET_ARCH,x86) {
    ANDROID_PACKAGE_SOURCE_DIR = \
        $$PWD/android
}
