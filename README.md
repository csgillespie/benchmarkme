
<!-- README.md is generated from README.Rmd. Please edit that file -->

# System benchmarking

[![R-CMD-check](https://github.com/csgillespie/benchmarkme/workflows/R-CMD-check/badge.svg)](https://github.com/csgillespie/benchmarkme/actions)
[![codecov.io](https://codecov.io/github/csgillespie/benchmarkme/coverage.svg?branch=master)](https://codecov.io/github/csgillespie/benchmarkme?branch=master)
[![Downloads](http://cranlogs.r-pkg.org/badges/benchmarkme?color=brightgreen)](https://cran.r-project.org/package=benchmarkme)
[![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/benchmarkme)](https://cran.r-project.org/package=benchmarkme)

R benchmarking made easy. The package contains a number of benchmarks,
heavily based on the benchmarks at
<http://r.research.att.com/benchmarks/R-benchmark-25.R>, for assessing
the speed of your system.

The package is for R 3.5 and above. In previous versions R, detecting
the effect of the byte compiler was tricky and produced unrealistic
comparisons.

## Overview

A straightforward way of speeding up your analysis is to buy a better
computer. Modern desktops are relatively cheap, especially compared to
user time. However, it isn’t clear if upgrading your computing is worth
the cost. The **benchmarkme** package provides a set of benchmarks to
help quantify your system. More importantly, it allows you to compare
your timings with *other* systems.

<!-- You can view past benchmarks via the [Shiny](https://jumpingrivers.shinyapps.io/benchmarkme/) interface. -->

## Overview

The package is on [CRAN](https://cran.r-project.org/package=benchmarkme)
and can be installed in the usual way

``` r
install.packages("benchmarkme")
```

There are two groups of benchmarks:

-   `benchmark_std()`: this benchmarks numerical operations such as
    loops and matrix operations. The benchmark comprises of three
    separate benchmarks: `prog`, `matrix_fun`, and `matrix_cal`.
-   `benchmark_io()`: this benchmarks reading and writing a 5 / 50, MB
    csv file.

### The benchmark\_std() function

This benchmarks numerical operations such as loops and matrix
operations. This benchmark comprises of three separate benchmarks:
`prog`, `matrix_fun`, and `matrix_cal`. If you have less than 3GB of RAM
(run `get_ram()` to find out how much is available on your system), then
you should kill any memory hungry applications, e.g. firefox, and set
`runs = 1` as an argument.

To benchmark your system, use

``` r
library("benchmarkme")
## Increase runs if you have a higher spec machine
res = benchmark_std(runs = 3)
```

and upload your results

``` r
## You can control exactly what is uploaded. See details below.
upload_results(res)
```

You can compare your results to other users via

``` r
plot(res)
```

<!-- You can also compare your results using the [Shiny](https://jumpingrivers.shinyapps.io/benchmarkme/) interface.  -->
<!-- Simply create a results bundle -->
<!-- ```{r, eval=FALSE} -->
<!-- create_bundle(res, filename = "results.rds") -->
<!-- ``` -->
<!-- and upload to the webpage. -->

### The benchmark\_io() function

This function benchmarks reading and writing a 5MB or 50MB (if you have
less than 4GB of RAM, reduce the number of `runs` to 1). Run the
benchmark using

``` r
res_io = benchmark_io(runs = 3)
upload_results(res_io)
plot(res_io)
```

By default the files are written to a temporary directory generated

``` r
tempdir()
```

which depends on the value of

``` r
Sys.getenv("TMPDIR")
```

You can alter this to via the `tmpdir` argument. This is useful for
comparing hard drive access to a network drive.

``` r
res_io = benchmark_io(tmpdir = "some_other_directory")
```

### Parallel benchmarks

The benchmark functions above have a parallel option - just simply
specify the number of cores you want to test. For example to test using
four cores

``` r
res_io = benchmark_std(runs = 3, cores = 4)
plot(res_io)
```

## Previous versions of the package

This package was started around 2015. However, multiple changes in the
byte compiler over the last few years, has made it very difficult to use
previous results. So we have to start from scratch.

The previous data can be obtained via

``` r
data(past_results, package = "benchmarkmeData")
```

## Machine specs

The package has a few useful functions for extracting system specs:

-   RAM: `get_ram()`
-   CPUs: `get_cpu()`
-   BLAS library: `get_linear_algebra()`
-   Is byte compiling enabled: `get_byte_compiler()`
-   General platform info: `get_platform_info()`
-   R version: `get_r_version()`

The above functions have been tested on a number of systems. If they
don’t work on your system, please raise
[GitHub](https://github.com/csgillespie/benchmarkme/issues) issue.

## Uploaded data sets

A summary of the uploaded data sets is available in the
[benchmarkmeData](https://github.com/csgillespie/benchmarkme-data)
package

``` r
data(past_results_v2, package = "benchmarkmeData")
```

A column of this data set, contains the unique identifier returned by
the `upload_results()` function.

## What’s uploaded

Two objects are uploaded:

1.  Your benchmarks from `benchmark_std` or `benchmark_io`;
2.  A summary of your system information (`get_sys_details()`).

The `get_sys_details()` returns:

-   `Sys.info()`;
-   `get_platform_info()`;
-   `get_r_version()`;
-   `get_ram()`;
-   `get_cpu()`;
-   `get_byte_compiler()`;
-   `get_linear_algebra()`;
-   `installed.packages()`;
-   `Sys.getlocale()`;
-   The `benchmarkme` version number;
-   Unique ID - used to extract results;
-   The current date.

The function `Sys.info()` does include the user and nodenames. In the
public release of the data, this information will be removed. If you
don’t wish to upload certain information, just set the corresponding
argument, i.e.

``` r
upload_results(res, args = list(sys_info = FALSE))
```

------------------------------------------------------------------------

Development of this package was supported by [Jumping
Rivers](https://www.jumpingrivers.com)
