
include(CMakeParseArguments)
include(ExternalProject)


function( niral_utilitiesExternalProject projectname)
  set(options INSTALL)
  set(oneValueArgs GIT_REPOSITORY GIT_TAG)
  set(multiValueArgs ADDITIONAL_OPTIONS DEPENDS)
  cmake_parse_arguments(_ep "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  set(proj ${projectname})

  option(COMPILE_${proj} "Compile ${proj}" OFF)
  if(NOT COMPILE_${proj})
     return()
  endif()

  if(_ep_INSTALL)
    set(install_cmd INSTALL_COMMAND ${CMAKE_MAKE_PROGRAM} install )
  endif()

  foreach(var ${_ep_DEPENDS})
    find_package(${var} REQUIRED)
    include(${${var}_USE_FILE})
    list(APPEND _ep_ADDITIONAL_OPTIONS -D${var}_DIR:PATH=${${var}_DIR})
  endforeach()

  set( ${proj}_REPOSITORY ${_ep_GIT_REPOSITORY})
  set( ${proj}_GIT_TAG ${_ep_GIT_TAG} )

  ExternalProject_Add(${projectname}
    GIT_REPOSITORY ${${proj}_REPOSITORY}
    GIT_TAG ${${proj}_GIT_TAG}
    SOURCE_DIR ${proj}
    BINARY_DIR ${proj}-build
    CMAKE_GENERATOR ${gen}
    CMAKE_ARGS
      -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
      -DMAKECOMMAND:STRING=${MAKECOMMAND}
      -DCMAKE_SKIP_RPATH:BOOL=${CMAKE_SKIP_RPATH}
      -DCMAKE_MODULE_PATH:PATH=${CMAKE_MODULE_PATH}
      -DCMAKE_CXX_COMPILER:PATH=${CMAKE_CXX_COMPILER}
      -DCMAKE_CXX_FLAGS_RELEASE:STRING=${CMAKE_CXX_FLAGS_RELEASE}
      -DCMAKE_CXX_FLAGS_DEBUG:STRING=${CMAKE_CXX_FLAGS_DEBUG}
      -DCMAKE_CXX_FLAGS:STRING=${CMAKE_CXX_FLAGS}
      -DCMAKE_C_COMPILER:PATH=${CMAKE_C_COMPILER}
      -DCMAKE_C_FLAGS_RELEASE:STRING=${CMAKE_C_FLAGS_RELEASE}
      -DCMAKE_C_FLAGS_DEBUG:STRING=${CMAKE_C_FLAGS_DEBUG}
      -DCMAKE_C_FLAGS:STRING=${CMAKE_C_FLAGS}
      -DCMAKE_SHARED_LINKER_FLAGS:STRING=${CMAKE_SHARED_LINKER_FLAGS}
      -DCMAKE_EXE_LINKER_FLAGS:STRING=${CMAKE_EXE_LINKER_FLAGS}
      -DCMAKE_MODULE_LINKER_FLAGS:STRING=${CMAKE_MODULE_LINKER_FLAGS}
      -DCMAKE_GENERATOR:STRING=${CMAKE_GENERATOR}
      -DCMAKE_EXTRA_GENERATOR:STRING=${CMAKE_EXTRA_GENERATOR}
      -DCMAKE_LIBRARY_OUTPUT_DIRECTORY:PATH=${CMAKE_LIBRARY_OUTPUT_DIRECTORY}
      -DCMAKE_ARCHIVE_OUTPUT_DIRECTORY:PATH=${CMAKE_ARCHIVE_OUTPUT_DIRECTORY}
      -DCMAKE_RUNTIME_OUTPUT_DIRECTORY:PATH=${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
      -DCMAKE_BUNDLE_OUTPUT_DIRECTORY:PATH=${CMAKE_BUNDLE_OUTPUT_DIRECTORY}
      -DCTEST_NEW_FORMAT:BOOL=${CTEST_NEW_FORMAT}
      -DMEMORYCHECK_COMMAND_OPTIONS:STRING=${MEMORYCHECK_COMMAND_OPTIONS}
      -DMEMORYCHECK_COMMAND:PATH=${MEMORYCHECK_COMMAND}
      ${_ep_ADDITIONAL_OPTIONS}
    INSTALL_COMMAND "" #Just in case we don't want to install this project. ${install_cmd} will be empty and nothing will be installed
    ${install_cmd}
  )
endfunction()
