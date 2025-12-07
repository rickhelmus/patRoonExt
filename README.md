
# patRoonExt

This [R](https://www.r-project.org/) package bundles several (non
R-based) software tools and data files that are commonly used in
[patRoon](https://rickhelmus.github.io/patRoon/) workflows. Currently,
the following are provided:

| name | license | installation | OS |
|:---|:---|:---|:---|
| <a href='https://openms.de/'>OpenMS (3.0.0)</a> | BSD-3 | Bundled (stripped) | Windows (x86-64) |
| <a href='https://bio.informatik.uni-jena.de/software/sirius/'>SIRIUS (5.8.2)</a> | SIRIUS: AGPL-3; CSI:FingerID: free for academic research/education | Download | Windows, Linux, macOS |
| <a href='https://github.com/ipb-halle/MetFragRelaunched/releases/download/v2.6.3/MetFragCommandLine-2.6.3.jar'>MetFrag CLI (2.6.3)</a> | LGPL-2.1 | Download | All |
| <a href='https://zenodo.org/records/3472781/files/CompTox_07March19_WWMetaData.csv'>MetFrag CompTox WW database (07March19_WWMetaData)</a> | CC BY 4.0 | Download | All |
| <a href='https://zenodo.org/records/14781118/files/PubChemLite_exposomics_20250131.csv'>MetFrag PubChemLite database (2.6.3)</a> | CC BY 4.0 | Download | All |
| <a href='https://github.com/openbabel/openbabel'>OpenBabel (3.1.1)</a> | GPL-2 | Bundled | Windows (x86-64) |
| <a href='https://bitbucket.org/djoumbou/biotransformer/src/master/'>BioTransformer (3.0.0)</a> | BioTransformer: LGPL-3; enviPath module: CC BY-NC 4.0 | Download | All |
| <a href='https://www.bruker.com/'>TDF SDK (3.3.6.2)</a> | Proprietary. Copyright © 2022 by Bruker Daltonics GmbH & Co. KG. All rights reserved | Bundled | Windows (x86-64), Linux (x86-64) |

> **IMPORTANT** Please inform yourself about the license requirements of
> these software tools and data files prior to installing `patRoonExt`.
> Furthermore, please make sure to properly cite the work of the
> involved authors if you use their tools/data via patRoon. You can find
> more information on the respective websites linked in the table.

Most tools and data are downloaded when installing `patRoonExt` (see
table). Therefore, please make sure an active internet connection is
available during installation. The
[OpenBabel](https://github.com/openbabel/openbabel) and
[OpenMS](http://openms.de/) software tools are directly bundled in
`patRoonExt`. Furthermore, the OpenMS distribution was significantly
reduced in size by stripping files not necessary for `patRoon`.

The package is installed like any other R package living on GitHub, e.g.

``` r
remotes::install_github("rickhelmus/patRoonExt")
```

## Customizing installation

Everything from the table will be installed by default. However, several
environment variables can be used to customize the installation process.
The following environment variables can be set to a non-empty string to
disable the installation of a certain tool or data file:

- `PATROONEXT_NO_OPENMS`
- `PATROONEXT_NO_SIRIUS`
- `PATROONEXT_NO_METFRAGCL`
- `PATROONEXT_NO_METFRAGCT` (CompTox DB)
- `PATROONEXT_NO_METFRAGPCL` (PubChemLite DB)
- `PATROONEXT_NO_OPENBABEL`
- `PATROONEXT_NO_BIOTRANSFORMER`
- `PATROONEXT_NO_TDFSDK` (used by the `patRoon` `OpenTIMS` `msdata`
  backend)

Furthermore, the `PATROONEXT_CACHE` variable can be set to a path where
all downloaded files are stored, and retrieved if the file was already
downloaded. This is primarily for debugging purposes, but can be useful
if you want manually download a file prior to installation of
`patRoonExt`.

The environment variables should be set prior to installing
`patRoonExt`, e.g.

``` r
Sys.setenv(PATROONEXT_NO_SIRIUS = 1)
remotes::install_github("rickhelmus/patRoonExt")
```
