include(vcpkg_common_functions)
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/podofo-0.9.5)
vcpkg_download_distfile(ARCHIVE
    URLS "https://downloads.sourceforge.net/project/podofo/podofo/0.9.5/podofo-0.9.5.tar.gz"
    FILENAME "podofo-0.9.5.tar.gz"
    SHA512 d13b30bfebc89b809173cd2251eed1f15dfa90abb58371bfdce875797d40663923571824ad2b0b1d97aa1be212bdbb710c3a0439bc05bed7022b8eb75ca74705
)
vcpkg_extract_source_archive(${ARCHIVE})

set(PODOFO_NO_FONTMANAGER ON)
if("fontconfig" IN_LIST FEATURES)
  set(PODOFO_NO_FONTMANAGER OFF)
endif()

string(COMPARE EQUAL "${VCPKG_LIBRARY_LINKAGE}" "dynamic" PODOFO_BUILD_SHARED)
string(COMPARE EQUAL "${VCPKG_LIBRARY_LINKAGE}" "static" PODOFO_BUILD_STATIC)

set(IS_WIN32 OFF)
if(VCPKG_CMAKE_SYSTEM_NAME STREQUAL "WindowsStore" OR NOT VCPKG_CMAKE_SYSTEM_NAME)
    set(IS_WIN32 ON)
endif()

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS
        -DPODOFO_BUILD_LIB_ONLY=1
        -DPODOFO_BUILD_SHARED=${PODOFO_BUILD_SHARED}
        -DPODOFO_BUILD_STATIC=${PODOFO_BUILD_STATIC}
        -DPODOFO_NO_FONTMANAGER=${PODOFO_NO_FONTMANAGER}
        -DCMAKE_DISABLE_FIND_PACKAGE_FONTCONFIG=${PODOFO_NO_FONTMANAGER}
        -DCMAKE_DISABLE_FIND_PACKAGE_LIBCRYPTO=${IS_WIN32}
        -DCMAKE_DISABLE_FIND_PACKAGE_LIBIDN=ON
)

vcpkg_install_cmake()

# Handle copyright
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(COPY ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/podofo)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/podofo/COPYING ${CURRENT_PACKAGES_DIR}/share/podofo/copyright)
