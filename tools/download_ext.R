source("utils.R")

skipMsg <- function(what, var)
{
    cat(sprintf("NOTE: Skipping installation of '%s' because '%s' was set.\n", what, var))
    invisible()
}

downloads <- list(
    SIRIUS = list(
        url = sprintf("https://github.com/boecker-lab/sirius/releases/download/v5.8.2/sirius-5.8.2-%s64.zip",
                      switch(Sys.info()[["sysname"]], Windows = "win", Linux = "linux", Darwin = "osx")),
        dest = "sirius.zip",
        destUnZip = ".",
        sha256 = switch(Sys.info()[["sysname"]],
                        Windows = "6c06221d671fa0a387c833bf4c0afc16dc3fff3067bd87914945e590427a2aaf",
                        Linux = "f83ad942a4de8c853df9588342c5ada0d6df828c532d5d168d71277d95c53c4e",
                        Darwin = "a5480fe74946addf89affc7a977734bb0b5c6deaa6d95f9a23dcaabe138b5c01"),
        exclude = "SIRIUS"
    ),
    MetFrag = list(
        url = "https://github.com/ipb-halle/MetFragRelaunched/releases/download/v.2.5.0/MetFragCommandLine-2.5.0.jar",
        dest = "MetFragCommandLine.jar",
        sha256 = "515edf1c6026bb99691b3c7b13503e31061087d1ca586fe361bcbc4ecad9b596",
        exclude = "METFRAGCL"
    ),
    CompTox = list(
        url = "https://zenodo.org/record/3472781/files/CompTox_07March19_WWMetaData.csv",
        dest = "CompToxWW.csv",
        sha256 = "3ec40cecac73ee15faf3eb76a019958377babace55ca713802b2ae2ab21e0e5b",
        exclude = "METFRAGCT"
    ),
    PubChemLite = list(
        url = "https://zenodo.org/record/8191746/files/PubChemLite_exposomics_20230728.csv",
        dest = "PubChemLite.csv",
        sha256 = "6ab8217be04502814e398365a72b470485e303c7153848d5ff92d07c220ce6e1",
        exclude = "METFRAGPCL"
    ),
    BioTransformerFiles = list(
        url = "https://bitbucket.org/djoumbou/biotransformer/get/master.zip",
        dest = "biotransformer_files.zip",
        destUnZip = ".",
        sha256 = "89b840d1bb62aef53635bd17b5a963bb7d9fb1923bbeb05b73381903f50a8bc4",
        exclude = "BIOTRANSFORMER"
    )
)

destPath <- file.path("..", "inst", "ext")
dir.create(destPath, recursive = TRUE, showWarnings = FALSE)

for (ext in names(downloads))
{
    skipVar <- paste0("PATROONEXT_NO_", downloads[[ext]]$exclude)
    if (nzchar(Sys.getenv(skipVar)))
    {
        skipMsg(ext, skipVar)
        next
    }

    p <- file.path(destPath, downloads[[ext]]$dest)
    if (downloadFile(ext, downloads[[ext]]$url, p, downloads[[ext]]$sha256))
    {
        if (!is.null(downloads[[ext]][["destUnZip"]]))
            unzipFile(p, file.path(destPath, downloads[[ext]]$destUnZip), clear = TRUE)
    }
    else
        stop("Download failed, aborting...", call. = FALSE)
}

if (Sys.info()[["sysname"]] == "Linux")
{
    # Finalize SIRIUS on Linux: make sure the executable bits are set
    Sys.chmod(c(file.path(destPath, "sirius", "bin", "sirius"),
                file.path(destPath, "sirius", "lib", "runtime", "bin", "java")),
              mode = "0744")
} else if (Sys.info()[["sysname"]] == "Darwin")
{
    # Finalize SIRIUS on macOS: make sure the executable bits are set
    Sys.chmod(c(file.path(destPath, "sirius.app", "Contents", "MacOS", "sirius"),
                file.path(destPath, "sirius.app", "Contents", "runtime", "Contents", "Home", "bin", "java")),
              mode = "0744")
}

# Finalize BioTransformer: normalize subdirectory (random within downloaded .zip) and place in Jar
BTDir <- list.files(destPath, pattern = "^djoumbou\\-biotransformer\\-[[:alnum:]]+$", full.names = TRUE)
if (length(BTDir) == 1)
{
    file.rename(BTDir, file.path(destPath, "biotransformer"))
    file.copy("biotransformer-3.0.0.jar", file.path(destPath, "biotransformer"))
}

# Install OpenBabel/OpenMS on Windows
if (Sys.info()[["sysname"]] == "Windows")
{
    if (!nzchar(Sys.getenv("PATROONEXT_NO_OPENBABEL")))
        unzipFile("openbabel.zip", file.path(destPath, "openbabel"))
    else
        skipMsg("OpenBabel", "PATROONEXT_NO_OPENBABEL")
    if (!nzchar(Sys.getenv("PATROONEXT_NO_OPENMS")))
        unzipFile("openms.zip", file.path(destPath, "openms"))
    else
        skipMsg("OpenMS", "PATROONEXT_NO_OPENMS")
}
