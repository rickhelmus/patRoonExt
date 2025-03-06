# patRoonExt

This [R] package bundles several (non R-based) software tools and data files that are commonly used in [patRoon]
workflows. Currently, the following are provided:

What                     |  License                                   | Installation type      | OS
------------------------ | ------------------------------------------ | ---------------------- | ---------------------
[OpenMS] (3.0.0)         | BSD-3                                      | Bundled (stripped)     | Windows (x86-64)
[SIRIUS] (5.8.2)         | SIRIUS: AGPL-3 <br> CSI:FingerID: free for academic research/education | Download | Windows, Linux, macOS
[MetFrag command line](MetFragCL) (2.6.3) | LGPL-2.1                      | Download               | All
[MetFrag CompTox WW database](MetFragCT) (07March19_WWMetaData) | CC BY 4.0              | Download               | All
[MetFrag PubChemLite database](MetFragPCL) (20250131) | CC BY 4.0            | Download               | All
[OpenBabel] (3.1.1)      | GPL-2                                      | Bundled                | Windows (x86-64)
[BioTransformer] (3.0.0) | BioTransformer: LGPL-3 <br> enviPath module: CC BY-NC 4.0 | Download | All

> **IMPORTANT** Please inform yourself about the license requirements of these software tools and data files prior to installing `patRoonExt`. Furthermore, please make sure to properly cite the work of the involved authors if you use their tools/data via patRoon. You can find more information on the respective websites linked in the table.

Most tools and data are downloaded when installing `patRoonExt` (see table). Therefore, please make sure an active internet connection is available during installation. The [OpenBabel] and [OpenMS] software tools are directly bundled in `patRoonExt`. Furthermore, the OpenMS distribution was significantly reduced in size by stripping files not necessary for `patRoon`.

The package is installed like any other R package living on GitHub, e.g.

```R
remotes::install_github("rickhelmus/patRoonExt")
```

## Customizing installation

Everything from the table will be installed by default. However, several environment variables can be used to customize
the installation process. The following environment variables can be set to a non-empty string to disable the
installation of a certain tool or data file:

* `PATROONEXT_NO_OPENMS`
* `PATROONEXT_NO_SIRIUS`
* `PATROONEXT_NO_METFRAGCL`
* `PATROONEXT_NO_METFRAGCT` (CompTox DB)
* `PATROONEXT_NO_METFRAGPCL` (PubChemLite DB)
* `PATROONEXT_NO_OPENBABEL`
* `PATROONEXT_NO_BIOTRANSFORMER`

Furthermore, the `PATROONEXT_CACHE` variable can be set to a path where all downloaded files are stored, and retrieved
if the file was already downloaded. This is primarily for debugging purposes, but can be useful if you want manually
download a file prior to installation of `patRoonExt`.

The environment variables should be set prior to installing `patRoonExt`, e.g.

```R
Sys.setenv(PATROONEXT_NO_SIRIUS = 1)
remotes::install_github("rickhelmus/patRoonExt")
```


[R]: https://www.r-project.org/
[patRoon]: https://rickhelmus.github.io/patRoon/
[OpenMS]: http://openms.de/
[SIRIUS]: https://bio.informatik.uni-jena.de/software/sirius/
[MetFragCL]: http://ipb-halle.github.io/MetFrag/projects/metfragcl/
[MetFragCT]: https://zenodo.org/record/3472781
[MetFragPCL]: https://zenodo.org/record/8191746
[OpenBabel]: https://github.com/openbabel/openbabel
[BioTransformer]: https://bitbucket.org/djoumbou/biotransformer/src/master/
