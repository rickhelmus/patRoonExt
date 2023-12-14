downloadFile <- function(what, url, dest, sha256 = NULL)
{
    cachePath <- Sys.getenv("PATROONEXT_CACHE")
    if (nzchar(cachePath))
    {
        cp <- file.path(cachePath, basename(dest))
        if (file.exists(cp))
        {
            if (!is.null(sha256) && sha256 != digest::digest(file = cp, algo = "sha256"))
                warning(sprintf("Ignoring cached file for %s as checksums are different", what), call. = FALSE)
            else
            {
                file.copy(cp, dest)
                return(TRUE)
            }
        }
    }

    # increase timeout for large files, thanks to https://stackoverflow.com/a/68944877
    otimeout <- getOption("timeout")
    options(timeout = max(900, otimeout))
    on.exit(options(timeout = otimeout), add = TRUE)

    if (download.file(url, dest, mode = "wb") != 0)
    {
        warning(sprintf("Failed to download %s from '%s'", what, url), call. = FALSE)
        return(FALSE)
    }

    if (!is.null(sha256) && sha256 != digest::digest(file = dest, algo = "sha256"))
    {
        warning(sprintf("Failed to download %s from '%s': sha256 checksums differ", what, url), call. = FALSE)
        return(FALSE)
    }

    if (nzchar(cachePath))
    {
        dir.create(cachePath, recursive = TRUE, showWarnings = FALSE)
        file.copy(dest, cachePath, overwrite = TRUE)
    }

    return(TRUE)
}

# to update checksums in downloads table of download_ext.R
getChecksums <- function(dls)
{
    cacheDir <- Sys.getenv("PATROONEXT_CACHE")
    if (!nzchar(cacheDir))
        stop("Please set PATROONEXT_CACHE", call. = FALSE)
    for (f in list.files(cacheDir, full.names = TRUE))
        cat(sprintf("sha256 of %s: %s\n", f, digest::digest(file = f, algo = "sha256")))
}

unzipFile <- function(file, dest, what, clear = FALSE)
{
    unzip(file, exdir = dest)
    if (!file.exists(dest))
    {
        warning(paste("Failed to extract %s to '%s'", what, dest))
        return(FALSE)
    }
    if (clear)
        unlink(file)
    return(TRUE)
}

zipFile <- function(dir, dest)
{
    # UNDONE: add withr to DESCRIPTION?
    dest <- normalizePath(dest, mustWork = FALSE) # to keep relative paths valid when changing wd below
    unlink(dest)
    withr::with_dir(dir, utils::zip(dest, Sys.glob("*")))
}

extractNSIS <- function(file, dest)
{
    # assumes 7zip is in PATH
    system2(if (Sys.info()["sysname"] == "Windows") "7z.exe" else "7zzs", c("x", file, paste0("-o", dest)))
}
