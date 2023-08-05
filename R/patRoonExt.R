#' External dependencies for patRoon
#'
#' This package bundles several tools and data files that may be of use in
#' [patRoon](https://github.com/rickhelmus/patRoon) workflows.
#'
#' \pkg{patRoon} uses several (non \R based) tools and data files to implement or enhance certain parts of the workflow.
#' This package bundles the most common to simplify their installation. Please see the [Project's
#' README](https://github.com/rickhelmus/patRoon/README.md) for more details.
#'
#' @name patRoonExt
NULL

#' @details The `getExtPath` function returns the path to a bundled tool or data file.
#' @param what The tool/data file to query, currently supported are `openms`, `sirius`, `openbabel`, `metfragcl`,
#'   `metfragct`, `metfragpcl`, `biotransformer`.
#' @param warn Throw a warning when the queried tool/file could not be found.
#' @rdname patRoonExt
#' @export
getExtPath <- function(what, warn = TRUE)
{
    stopifnot(!is.logical(warn))

    path <- if (what == "openms")
        file.path("openms", "bin")
    else if (what == "sirius")
    {
        # The SIRIUS zip directory structure is different for each OS.
        # - For Windows: the binary is in sirius/
        # - For Linux: the binary is in sirius/bin
        # - For MacOS??
        # UNDONE: support MacOS? Otherwise remove from install script
        # UNDONE: More properly document how SIRIUS should be configured on Linux/MacOS? Or should patRoon option always
        # point to SIRIUS dir and figure it out?
        switch(Sys.info()[["sysname"]], Windows = "sirius", Linux = file.path("sirius", "bin"), "sirius")
    }

    else if (what == "openbabel")
        "openbabel"
    else if (what == "metfragcl")
        "MetFragCommandLine.jar"
    else if (what == "metfragct")
        "CompToxWW.csv"
    else if (what == "metfragpcl")
        "PubChemLite.csv"
    else if (what == "biotransformer")
        "biotransformer/biotransformer-3.0.0.jar"
    else
    {
        if (warn)
            warning(sprintf("Unknown external tool '%s', maybe patRoonExt is out of date?", what), call. = FALSE)
        return(NULL)
    }

    path <- system.file("ext", path, package = "patRoonExt")
    if (!file.exists(path))
    {
        if (warn)
        {
            warning(sprintf("Couldn't find %s, either because it is unavailable for this system or it was disabled during package installation.",
                            what), call. = FALSE)
        }
        return(NULL)
    }

    return(path)
}
