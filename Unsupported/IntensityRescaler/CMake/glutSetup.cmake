#
# try to find glut library and include files
#
# GLUT_INCLUDE_DIR, where to find GL/glut.h, etc.
# GLUT_LIBRARIES, the libraries to link against to use GLUT.
# GLUT_FOUND, If false, do not try to use GLUT.

# also defined, but not for general use are
# GLUT_glut_LIBRARY = the full path to the glut library.
# GLUT_Xmu_LIBRARY  = the full path to the Xmu library if available.
# GLUT_Xi_LIBRARY   = the full path to the Xi Library if available.

if(WIN32)

  if(CYGWIN)

    find_path( GLUT_INCLUDE_DIR GL/glut.h
      /usr/include
    )

    find_library( GLUT_glut_LIBRARY glut32
      ${OPENGL_LIBRARY_DIR}
      /usr/lib
      /usr/lib/w32api
      /usr/local/lib
      /usr/X11R6/lib
    )


  else()

    find_library( GLUT_glut_LIBRARY glut32
      ${OPENGL_LIBRARY_DIR}
    )

  endif()

else()

  if(APPLE)
# These values for Apple could probably do with improvement.
    find_path( GLUT_INCLUDE_DIR GL/glut.h
      ${OPENGL_LIBRARY_DIR}
    )
    set(GLUT_glut_LIBRARY "-framework Glut" CACHE STRING "GLUT library for OSX")
  else()

    find_path( GLUT_INCLUDE_DIR GL/glut.h
      /usr/include
      /usr/include/GL
      /usr/local/include
      /usr/openwin/share/include
      /usr/openwin/include
      /usr/X11R6/include
      /usr/include/X11
      /opt/graphics/OpenGL/include
      /opt/graphics/OpenGL/contrib/libglut
    )

    find_library( GLUT_glut_LIBRARY glut
      /usr/lib
      /usr/local/lib
      /usr/openwin/lib
      /usr/X11R6/lib
    )

    find_library( GLUT_Xi_LIBRARY Xi
      /usr/lib
      /usr/local/lib
      /usr/openwin/lib
      /usr/X11R6/lib
    )

    find_library( GLUT_Xmu_LIBRARY Xmu
      /usr/lib
      /usr/local/lib
      /usr/openwin/lib
      /usr/X11R6/lib
    )

  endif()

endif()

set( GLUT_FOUND "NO" )
if(GLUT_INCLUDE_DIR)
  if(GLUT_glut_LIBRARY)
    # Is -lXi and -lXmu required on all platforms that have it?
    # If not, we need some way to figure out what platform we are on.
    set( GLUT_LIBRARIES
      ${GLUT_glut_LIBRARY}
      ${GLUT_Xmu_LIBRARY}
      ${GLUT_Xi_LIBRARY}
    )
    set( GLUT_FOUND "YES" )

#The following deprecated settings are for backwards compatibility with CMake1.4
    set(GLUT_LIBRARY ${GLUT_LIBRARIES})
    set(GLUT_INCLUDE_PATH ${GLUT_INCLUDE_DIR})

  endif()
else()
   message(FATAL_ERROR "GLUT library not found!\n" "Please go to http://www.ia.unc.edu/dev/tutorials/InstallLib")
endif()

mark_as_advanced(
  GLUT_INCLUDE_DIR
  GLUT_glut_LIBRARY
  GLUT_Xmu_LIBRARY
  GLUT_Xi_LIBRARY
)
