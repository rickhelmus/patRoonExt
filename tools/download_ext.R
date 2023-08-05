source("utils.R")

downloads <- list(
    SIRIUS = list(
        url = sprintf("https://github.com/boecker-lab/sirius/releases/download/v5.6.3/sirius-5.6.3-%s64-headless.zip",
                      switch(Sys.info()[["sysname"]], Windows = "win", Linux = "linux", Darwin = "osx")),
        dest = "sirius.zip",
        destUnZip = ".",
        exclude = "SIRIUS"
    ),
    MetFrag = list(
        url = "https://github.com/ipb-halle/MetFragRelaunched/releases/download/v.2.5.0/MetFragCommandLine-2.5.0.jar",
        dest = "MetFragCommandLine.jar",
        exclude = "METFRAGCL"
    ),
    CompTox = list(
        url = "https://zenodo.org/record/3472781/files/CompTox_07March19_WWMetaData.csv",
        dest = "CompToxWW.csv",
        exclude = "METFRAGCT"
    ),
    PubChemLite = list(
        url = "https://zenodo.org/record/8191746/files/PubChemLite_exposomics_20230728.csv",
        dest = "PubChemLite.csv",
        exclude = "METFRAGPCL"
    ),
    BioTransformerFiles = list(
        url = "https://bitbucket.org/djoumbou/biotransformer/get/master.zip",
        dest = "biotransformer_files.zip",
        destUnZip = ".",
        exclude = "BIOTRANSFORMER"
    ),
    BioTransformerJar = list(
        url = "https://github.com/rickhelmus/patRoonDeps/raw/master/ext/biotransformer-3.0.0.jar",
        dest = "biotransformer-3.0.0.jar",
        exclude = "BIOTRANSFORMER"
    )
)

destPath <- file.path("..", "inst", "ext")
dir.create(destPath, recursive = TRUE, showWarnings = FALSE)

for (ext in names(downloads))
{
    if (nzchar(Sys.getenv(paste0("PATROONEXT_NO_", downloads[[ext]]$exclude))))
        next
    
    p <- file.path(destPath, downloads[[ext]]$dest)
    if (downloadFile(ext, downloads[[ext]]$url, p))
    {
        if (!is.null(downloads[[ext]][["destUnZip"]]))
            unzipFile(p, file.path(destPath, downloads[[ext]]$destUnZip), clear = TRUE)
    }
}

if (Sys.info()[["sysname"]] == "Darwin")
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
    file.rename(file.path(destPath, downloads$BioTransformerJar$dest),
                file.path(destPath, "biotransformer", downloads$BioTransformerJar$dest))
}

# Install OpenBabel/OpenMS on Windows
if (Sys.info()[["sysname"]] == "Windows")
{
    if (!nzchar(Sys.getenv("PATROONEXT_NO_OPENBABEL")))
        unzipFile("openbabel.zip", file.path(destPath, "openbabel"))
    if (!nzchar(Sys.getenv("PATROONEXT_NO_OPENMS")))
        unzipFile("openms.zip", file.path(destPath, "openms"))
}
