#if (defined(WIN32) || defined(_WIN32)) && !defined(WINDOWS_DESKTOP_PLATFORM) && !defined(UWP_PLATFORM)

///
/// Some non-desktop Win32 toolchains don't define these so we need to
/// map them to Microsoft equivalents to avoid build errors.
///

#include <string.h>
#include <io.h>
#include <stdio.h>

#define strdup _strdup

#define open _open

#define close _close

#define read _read

#define write _write

#define access _access

#define fdopen _fdopen


#endif // #if (defined(WIN32) || defined(_WIN32)) && !defined(WINDOWS_DESKTOP_PLATFORM) && !defined(UWP_PLATFORM)
