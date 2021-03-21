# benchmarkme Version 1.0.7 _2021-03-21_
  * Internal: Suppress warnings on `sysctl` calls

# benchmarkme Version 1.0.6 _2021-02-25_
  * Internal: Better detection of `sysctl`

# benchmarkme Version 1.0.5 _2021-02-08_
  * Internal: Move to GitHub Actions
  * Internal: Detect `sysctl` on Macs
  * Bug: To run parallel checks, the package needs to be attached (thanks to @davidhen #33)

# Version 1.0.4
  * Improve RAM detection in Windows (thanks to @xiaodaigh #25)
  * Example on using IEC units (#22)

## Version 1.0.2
  * Minor Bug fix for get_sys_details (thanks to @dipterix)

## Version 1.0.1
  * Typo in vignette (thanks to @tmartensecon)

## Version 1.0.0
  * Update version focused on R 3.5 & above. Start anew. Sorry everyone

## Version 0.6.1 
  * Improved BLAS detection (suggested by @ck37 #15)

## Version 0.6.0
  * Adding parallel benchmarks (thanks to @jknowles)
  * Since JIT has been introduced, just byte compile the package for ease of comparison.

## Version 0.5.1
  * Add id_prefix to the upload function
  * Can now run `benchmark_std` if the package is not attached (thanks to @YvesCR)
  * Nicer version of `print.bytes` (thanks to @richierocks)
  * Adding parallel benchmarks (thanks to @jknowles)
  
## Version 0.5.0
  * Bug fix in get_byte_compiler when `cmpfun` was used.
  
## Version 0.4.0
  * Update to shinyapps.io example
  * Moved benchmark description to shinyapps.io
  * Additional checks on `get_ram()`

## Version 0.3.0
  * New vignette describing benchmarks.
  * Used `Sys.getpid()` to try and determine the BLAS/LAPACK library (suggested by
  Ashley Ford).

## Version 0.2.3 
  * Return `NA` for `get_cpu()`/`get_ram()` when it isn't possible to determine
  CPU/RAM.
  
## Version 0.2.2
  * First CRAN version
  
## Version 0.2.0
  * More flexibility in plot and datatable functions - you can now specify the test you want to compare.
  * The number of cores returned by `get_cpu()`.
  * Adding io benchmarks.
  * New shiny interface.

## Version 0.1.9
  * Default log scale on y-axis (suggested by @eddelbuettel). Fixes #5.
  * Moved data sets to `benchmarkmeData` package.
  * New ranking function to compare results with past.

## Version 0.1.8
  * Added introduction to `benchmarkme` vignette.
  * Adjust placement of "You" in the S3 plot.
  * Add `.Machine` to `get_sys_details`.

## Version 0.1.7
  * Add locale to `get_sys_details`.

## Version 0.1.6
  * Further RAM and Mac issues.

## Version 0.1.4
  * Bug fix: Remove white space from apple RAM output (thanks to @vzemlys). Fixes #2. 
  
## Version 0.1.3
  * Add a fall-back when getting RAM - grab everything.
  * Minor: Added a horizontal line automatically generated plots.
  * Deprecated `benchmark_all` (use `benchmark_std`).

## Version 0.1.2
  * First public release.
