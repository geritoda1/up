cmake_minimum_required(VERSION 3.16)

project(University VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick Sql QuickControls2)

qt_standard_project_setup(REQUIRES 6.10)

if (EXISTS "${CMAKE_CURRENT_LIST_DIR}/importedcontent/CMakeLists.txt")
    add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/importedcontent)
endif()

qt_add_executable(appUniversity
    main.cpp
)

qt_add_qml_module(appUniversity
    URI University
    QML_FILES
        main.qml
        LoginView.qml
        AdminDashboard.qml
        TeacherDashboard.qml
        StudentDashboard.qml
    SOURCES
        databasemanager.h
        databasemanager.cpp
        authmanager.h
        authmanager.cpp
        QML_FILES AdminDashboard.qml
        QML_FILES TeacherDashboard.qml
        QML_FILES StudentDashboard.qml
        RESOURCES README.md
)

set_target_properties(appUniversity PROPERTIES
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appUniversity
    PRIVATE
        Qt6::Quick
        Qt6::Sql
        Qt6::QuickControls2
)

install(TARGETS appUniversity
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)