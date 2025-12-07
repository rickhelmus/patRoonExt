#' Get information about external dependencies
#'
#' Returns a \code{data.frame} with information about the external dependencies
#' (tools and data files) that are installed by \pkg{patRoonExt}.
#'
#' @seealso \code{\link{getExtPath}}
#'
#' @export
depInfo <- function()
{
    do.call(rbind, list(
        data.frame(
            name = "OpenMS",
            version = "3.0.0",
            license = "BSD-3",
            installation = "Bundled (stripped)",
            OS = "Windows (x86-64)",
            URL = "https://openms.de/"
        ),
        data.frame(
            name = "SIRIUS",
            version = "5.8.2",
            license = "SIRIUS: AGPL-3; CSI:FingerID: free for academic research/education",
            installation = "Download",
            OS = "Windows, Linux, macOS",
            URL = "https://bio.informatik.uni-jena.de/software/sirius/"
        ),
        data.frame(
            name = "MetFrag CLI",
            version = "2.6.3",
            license = "LGPL-2.1",
            installation = "Download",
            OS = "All",
            URL = "https://github.com/ipb-halle/MetFragRelaunched/releases/download/v2.6.3/MetFragCommandLine-2.6.3.jar"
        ),
        data.frame(
            name = "MetFrag CompTox WW database",
            version = "07March19_WWMetaData",
            license = "CC BY 4.0",
            installation = "Download",
            OS = "All",
            URL = "https://zenodo.org/records/3472781/files/CompTox_07March19_WWMetaData.csv"
        ),
        data.frame(
            name = "MetFrag PubChemLite database",
            version = "2.6.3",
            license = "CC BY 4.0",
            installation = "Download",
            OS = "All",
            URL = "https://zenodo.org/records/14781118/files/PubChemLite_exposomics_20250131.csv"
        ),
        data.frame(
            name = "OpenBabel",
            version = "3.1.1",
            license = "GPL-2",
            installation = "Bundled",
            OS = "Windows (x86-64)",
            URL = "https://github.com/openbabel/openbabel"
        ),
        data.frame(
            name = "BioTransformer",
            version = "3.0.0",
            license = "BioTransformer: LGPL-3; enviPath module: CC BY-NC 4.0",
            installation = "Download",
            OS = "All",
            URL = "https://bitbucket.org/djoumbou/biotransformer/src/master/"
        )        
    ))
}
