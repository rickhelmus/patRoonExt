pkgPath <- getwd()

source(file.path(pkgPath, "tools", "utils.R"))

# download
dlFile <- file.path(tempdir(), "openbabel.exe") # use a fixed file name so it can be cached by downloadFile
stopifnot(downloadFile("OpenBabel",
                       "https://github.com/openbabel/openbabel/releases/download/openbabel-3-1-1/OpenBabel-3.1.1-x64.exe",
                       dlFile))

# extract
extrDir <- tempfile("ob-extr")
extractNSIS(dlFile, extrDir)

# remove unnecessary files
unlink(file.path(extrDir, c("$*", "vc_redist.x64.exe", "vc_redist.x86.exe", "Uninstall.exe")), recursive = TRUE)

# copy some MSVC dlls from OpenMS that are normally installed by the OpenBabel installer
cpDlls <- file.path("bin", c("msvcp140.dll", "vcruntime140.dll", "vcruntime140_1.dll"))
unzip(file.path(pkgPath, "tools", "openms.zip"), files = cpDlls, exdir = extrDir, junkpaths = TRUE)

# generate final zip
zipFile(extrDir, file.path(file.path(pkgPath, "tools", "openbabel.zip")))
