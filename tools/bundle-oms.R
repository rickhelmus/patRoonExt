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
    file.path("bin", "FeatureFinderMetabo.exe"),
    file.path("bin", "FileConverter.exe"),
    file.path("bin", "MetaboliteAdductDecharger.exe"),
    file.path("bin", "MapAlignerPoseClustering.exe"),
    file.path("bin", "FeatureLinkerUnlabeled.exe"),
    file.path("bin", "FeatureLinkerUnlabeledQT.exe"),
    file.path("share", "OpenMS", "CHEMISTRY", "unimod.xml"),
    Sys.glob(file.path(extrDir, "bin", "*.dll")), # UNDONE: probably not all are needed
    Sys.glob(file.path(extrDir, "share", "OpenMS", "CHEMISTRY", "Metabolite*")), # UNDONE: needed?
    Sys.glob(file.path(extrDir, "share", "OpenMS", "CHEMISTRY", "*Adducts*")), # UNDONE: needed?
    Sys.glob(file.path(extrDir, "share", "OpenMS", "SCHEMAS", "*")), # UNDONE: needed?
    Sys.glob(file.path(extrDir, "share", "OpenMS", "XSL", "*")), # UNDONE: needed?
    Sys.glob(file.path(extrDir, "share", "OpenMS", "CV", "*")),
    Sys.glob(file.path(extrDir, "share", "OpenMS", "MAPPING", "*"))
)
copyFiles <- gsub("\\", "/", copyFiles, fixed = TRUE)
extrDir <- gsub("\\", "/", extrDir, fixed = TRUE)
copyFiles <- sub(paste0("^", extrDir, "/"), "", copyFiles) # make globs relative paths
allSubDirs <- unique(sapply(copyFiles, function(cf) sub(basename(cf), "", cf)))
selDir <- tempfile("oms-sel")
for (sd in allSubDirs)
    dir.create(file.path(selDir, sd), recursive = TRUE)
file.copy(file.path(extrDir, copyFiles), file.path(selDir, copyFiles))

# generate final zip
zipFile(selDir, file.path(file.path(pkgPath, "tools", "openms.zip")))
