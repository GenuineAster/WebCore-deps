if (CMAKE_SIZEOF_VOID_P EQUAL 8)
    set(ARCHITECTURE "x64")
else ()
    set(ARCHITECTURE "x86")
endif ()

set(INSTALL_DIR ${CMAKE_CURRENT_BINARY_DIR}/out)
    
add_custom_target(create_sdk ALL "${CMAKE_COMMAND}" 
    -D CMAKE_INSTALL_PREFIX:string=${INSTALL_DIR}
    -P "${CMAKE_CURRENT_BINARY_DIR}/cmake_install.cmake" 
    DEPENDS WebCore-Deps) 
    
# Get name of current branch
execute_process(
  COMMAND git rev-parse --abbrev-ref HEAD
  WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
  OUTPUT_VARIABLE GIT_BRANCH
  OUTPUT_STRIP_TRAILING_WHITESPACE
)

# Get status of current branch
execute_process(
  COMMAND git status --untracked-files=no --porcelain
  WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
  OUTPUT_VARIABLE GIT_STATUS
  OUTPUT_STRIP_TRAILING_WHITESPACE
)

# Get abbreviated commit hash of current branch
execute_process(
  COMMAND git rev-parse --short=8 HEAD
  WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
  OUTPUT_VARIABLE GIT_COMMIT_HASH
  OUTPUT_STRIP_TRAILING_WHITESPACE
)

# Get list of local, unpushed commits
execute_process(
  COMMAND git cherry -v
  WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
  OUTPUT_VARIABLE GIT_CHERRY
  OUTPUT_STRIP_TRAILING_WHITESPACE
)
    
if (CMAKE_SYSTEM_NAME MATCHES "Linux")
    set(PLATFORM "linux")
elseif (CMAKE_SYSTEM_NAME MATCHES "Darwin")
    set(PLATFORM "mac")
elseif (CMAKE_SYSTEM_NAME MATCHES "Windows")
    if (UWP_PLATFORM)
        set(PLATFORM "win-uwp")
    else ()
        set(PLATFORM "win")
    endif ()
endif ()

set(PKG_FILENAME "webcore-deps-bin-${GIT_COMMIT_HASH}-${PLATFORM}-${ARCHITECTURE}.7z")

add_custom_command(TARGET create_sdk POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E tar "cf" ${CMAKE_CURRENT_BINARY_DIR}/${PKG_FILENAME} --format=7zip -- .
    WORKING_DIRECTORY ${INSTALL_DIR}
)
add_custom_command(TARGET create_sdk POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E echo "Created release archive: ${CMAKE_CURRENT_BINARY_DIR}/${PKG_FILENAME}"
)
