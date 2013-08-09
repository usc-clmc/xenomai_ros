# (C) Copyright 2005-2012 Johns Hopkins University (JHU), All Rights
# Reserved.
#
# --- begin cisst license - do not edit ---
# 
# This software is provided "as is" under an open source license, with
# no warranty.  The complete license can be found in license.txt and
# http://www.cisst.org/cisst/license.txt.
# 
# --- end cisst license ---

if( UNIX )

  # set the search paths
  set( Xenomai_SEARCH_PATH /usr/local/xenomai /usr/xenomai /usr/include/xenomai $ENV{XENOMAI_ROOT_DIR})
  
  # find xeno-config.h
  find_path( Xenomai_ROOT_DIR
    include/xeno_config.h 
    PATHS ${Xenomai_SEARCH_PATH} 
    )

  # did we find xeno_config.h?
  if(Xenomai_ROOT_DIR) 
    MESSAGE(STATUS "xenomai found: \"${Xenomai_ROOT_DIR}\"")
    
    # set the include directory
    if( "${Xenomai_ROOT_DIR}" MATCHES "/usr/include/xenomai" )
      # on ubuntu linux, xenomai install is not rooted to a single dir
      set( Xenomai_INCLUDE_DIR ${Xenomai_ROOT_DIR} )
      set( Xenomai_INCLUDE_POSIX_DIR ${Xenomai_ROOT_DIR}/posix )
    else()
      # elsewhere, xenomai install is packaged
      set( Xenomai_INCLUDE_DIR ${Xenomai_ROOT_DIR}/include )
      set( Xenomai_INCLUDE_POSIX_DIR ${Xenomai_ROOT_DIR}/include/posix )
    endif()
    
    # find the xenomai pthread library
    find_library( Xenomai_LIBRARY_NATIVE  native  ${Xenomai_ROOT_DIR}/lib )
    find_library( Xenomai_LIBRARY_XENOMAI xenomai ${Xenomai_ROOT_DIR}/lib )
    find_library( Xenomai_LIBRARY_PTHREAD_RT pthread_rt rtdm ${Xenomai_ROOT_DIR}/lib )
    find_library( Xenomai_LIBRARY_RTDM    rtdm    ${Xenomai_ROOT_DIR}/lib )
    find_library( Xenomai_LIBRARY_RTDK    rtdk    ${Xenomai_ROOT_DIR}/lib )

    # Find xeno-config
    find_program(Xenomai_XENO_CONFIG NAMES xeno-config  PATHS ${Xenomai_ROOT_DIR}/bin NO_DEFAULT_PATH)

    # Linker flags for the posix wrappers
    set(Xenomai_LDFLAGS_NATIVE "")#"-lnative -lxenomai -lpthread -lrt")
    set(Xenomai_LDFLAGS_POSIX "-Wl,@${Xenomai_ROOT_DIR}/lib/posix.wrappers")#-lpthread_rt -lxenomai -lpthread -lrt")

    # add compile/preprocess options
    set(Xenomai_DEFINITIONS -D_GNU_SOURCE -D_REENTRANT -pipe -D__XENO__)
    set(Xenomai_DEFINITIONS_POSIX ${Xenomai_DEFINITIONS})


    # set the library dirs
    set( Xenomai_LIBRARY_DIRS ${Xenomai_ROOT_DIR}/lib )

  else( )
    MESSAGE(STATUS "xenomai NOT found. (${Xenomai_SEARCH_PATH})")
  endif( )

endif( UNIX )

include(FindPackageHandleStandardArgs)

find_package_handle_standard_args(Xenomai DEFAULT_MSG
  Xenomai_ROOT_DIR
  Xenomai_LIBRARY_NATIVE
  Xenomai_LIBRARY_XENOMAI
  Xenomai_LIBRARY_PTHREAD_RT
  Xenomai_LIBRARY_RTDM
  Xenomai_LIBRARY_RTDK
  )
