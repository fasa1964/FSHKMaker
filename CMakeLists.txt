cmake_minimum_required(VERSION 3.16)

project(FSHKMaker VERSION 1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTORCC ON)

# set icon on windows
set(APP_ICON_RESOURCE_WINDOWS "${CMAKE_CURRENT_SOURCE_DIR}/appicon.rc")

find_package(Qt6 REQUIRED COMPONENTS Quick Svg Core Qml Network Gui)



qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(appFSHKMaker
    main.cpp
    ${APP_ICON_RESOURCE_WINDOWS}
)

qt_add_qml_module(appFSHKMaker
    URI FSHKMaker
    VERSION 1.0
    QML_FILES
        Main.qml
        RESOURCES images.qrc
        QML_FILES Arrow.qml
        QML_FILES DialogLogin.qml
        QML_FILES DialogInfo.qml
        QML_FILES FMessageBox.qml
        QML_FILES FLed.qml
        RESOURCES android/AndroidManifest.xml android/build.gradle android/res/values/libs.xml
        android/res/xml/qtprovider_paths.xml android/gradle/wrapper/gradle-wrapper.jar
        android/gradle/wrapper/gradle-wrapper.properties android/gradle.properties android/gradlew android/gradlew.bat
        SOURCES fshkdata.h fshkdata.cpp
        SOURCES fthreadmessage.h fthreadmessage.cpp
)

# For Android SSL Support
# On Windows ->  D:/Qt/Android/android_openssl/CMakeLists.txt
# On Linux -> /home/farschad/Qt/Tools/OpenSSLv3/CMakeLists.txt
if(ANDROID)
    # try to load CMakeList.txt from android
    #include(/home/farschad/Qt/Android/android_openssl-master/CMakeLists.txt)
    include(/home/farschad/Qt/Android/android_openssl-master/android_openssl.cmake)
    #set_target_properties(appFQMLHttp PROPERTIES QT_ANDROID_PACKAGE_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/android )
endif()

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appFSHKMaker PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appFSHKMaker
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appFSHKMaker
    PRIVATE Qt6::Quick
            Qt6::Svg
            Qt6::Core
            Qt6::Qml
            Qt6::Network
            Qt6::Gui
)


if(ANDROID)
    set_target_properties(appFSHKMaker PROPERTIES QT_ANDROID_PACKAGE_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/android )
    add_android_openssl_libraries(appFSHKMaker)
endif()


include(GNUInstallDirs)
install(TARGETS appFSHKMaker
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
