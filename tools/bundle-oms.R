pkgPath <- getwd()

source(file.path(pkgPath, "tools", "utils.R"))

# download
dlFile <- file.path(tempdir(), "openms.exe") # use a fixed file name so it can be cached by downloadFile
stopifnot(downloadFile("OpenMS",
                       "https://github.com/OpenMS/OpenMS/releases/download/Release2.7.0/OpenMS-2.7.0-Win64.exe",
                       dlFile))

# extract
extrDir <- tempfile("oms-extr")
extractNSIS(dlFile, extrDir)

# copy files of interest
copyFiles <- c(
    "bin/FeatureFinderMetabo.exe",
    "bin/FileConverter.exe",
    "bin/MetaboliteAdductDecharger.exe",
    "bin/MapAlignerPoseClustering.exe",
    "bin/FeatureLinkerUnlabeled.exe",
    "bin/FeatureLinkerUnlabeledQT.exe",
    Sys.glob(file.path(extrDir, "bin", "*.dll")), # UNDONE: probably not all are needed
    Sys.glob(file.path(extrDir, "share", "OpenMS", "CHEMISTRY", "Metabolite*")), # UNDONE: needed?
    Sys.glob(file.path(extrDir, "share", "OpenMS", "CHEMISTRY", "*Adducts*")), # UNDONE: needed?
    Sys.glob(file.path(extrDir, "share", "OpenMS", "SCHEMAS", "*")), # UNDONE: needed?
    Sys.glob(file.path(extrDir, "share", "OpenMS", "XSL", "*")) # UNDONE: needed?
)
copyFiles <- sub(paste0("^", extrDir, "/"), "", copyFiles) # make globs relative paths
allSubDirs <- unique(sapply(copyFiles, function(cf) sub(basename(cf), "", cf)))
selDir <- tempfile("oms-sel")
for (sd in allSubDirs)
    dir.create(file.path(selDir, sd), recursive = TRUE)
file.copy(file.path(extrDir, copyFiles), file.path(selDir, copyFiles))

# generate final zip
zipFile(selDir, file.path(file.path(pkgPath, "tools", "openms.zip")))
