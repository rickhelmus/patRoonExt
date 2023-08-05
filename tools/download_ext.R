source("utils.R")

downloads <- list(
    SIRIUS = list(
        url = sprintf("https://github.com/boecker-lab/sirius/releases/download/v5.6.3/sirius-5.6.3-%s64-headless.zip",
                      switch(Sys.info()[["sysname"]], Windows = "win", Linux = "linux", Darwin = "osx")),
        dest = "sirius.zip",
        destUnZip = "."
    ),
    MetFrag = list(
        url = "https://github.com/ipb-halle/MetFragRelaunched/releases/download/v.2.5.0/MetFragCommandLine-2.5.0.jar",
        dest = "MetFragCommandLine.jar"
    ),
    CompTox = list(
        url = "https://zenodo.org/record/3472781/files/CompTox_07March19_WWMetaData.csv",
        dest = "CompToxWW.csv"
    ),
    PubChemLite = list(
        url = "https://zenodo.org/record/8191746/files/PubChemLite_exposomics_20230728.csv",
        dest = "PubChemLite.csv"
    ),
    BioTransformerFiles = list(
        url = "https://bitbucket.org/djoumbou/biotransformer/get/master.zip",
        dest = "biotransformer_files.zip",
        destUnZip = "."
    ),
    BioTransformerJar = list(
        url = "https://github.com/rickhelmus/patRoonDeps/raw/master/ext/biotransformer-3.0.0.jar",
        dest = "biotransformer-3.0.0.jar"
    )
)

destPath <- file.path("..", "inst", "ext")
dir.create(destPath, recursive = TRUE, showWarnings = FALSE)

for (ext in names(downloads))
{
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
    unzipFile("openbabel.zip", file.path(destPath, "openbabel"))
    unzipFile("openms.zip", file.path(destPath, "openms"))
}
