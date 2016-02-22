## Version 0.2.1
  * First CRAN version
  
## Version 0.2.0
  * More flexibilty in plot and datatable functions - you can now specify the test you want to compare.
  * The number of cores returned by get_cpu().
  * Adding io benchmarks.
  * New shiny interface.

## Version 0.1.9
  * Default log scale on y-axis (suggested by @eddelbuettel). Fixes #5.
  * Moved data sets to benchmarkmeData package.
  * New ranking function to compare results with past.

## Version 0.1.8
  * Added introduction to benchmarkme vignette.
  * Adjust placement of "You" in the S3 plot.
  * Add `.Machine` to `get_sys_details`.

## Version 0.1.7
  * Add locale to `get_sys_details`.

## Version 0.1.6
  * Still trying to fix RAM and Mac issues.

## Version 0.1.5
  * Further RAM and Mac issues.

## Version 0.1.4
  * Bug fix: Remove white space from apple RAM output (thanks to @vzemlys). Fixes #2. 
  
## Version 0.1.3
  * Add a fallback when getting RAM - grab everything.
  * Minor: Added a horizontal line automatically generated plots.
  * Deprecated `benchmark_all` (use `benchmark_std`).

## Version 0.1.2
  * First public release.