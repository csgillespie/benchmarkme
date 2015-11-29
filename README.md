# System benchmarking 

[![Build Status](https://travis-ci.org/csgillespie/benchmarkme.svg?branch=master)](https://travis-ci.org/csgillespie/benchmarkme)
[![codecov.io](https://codecov.io/github/csgillespie/benchmarkme/coverage.svg?branch=master)](https://codecov.io/github/csgillespie/benchmarkme?branch=master)
[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/benchmarkme)](http://cran.r-project.org/package=benchmarkme)

R benchmarking made easy. The package contains a number of benchmarks for assessing 
the speed of your system. 

## Installation

The package isn't yet available on CRAN. To install the current version use

```
install.packages("drat")
drat::addRepo("csgillespie")
install.packages("benchmarkme")
```

## Usage

Load the package in the usual way

```
library("benchmarkme")
```

All benchmarks can be run using

```
## This will take somewhere between 
## 1 and 5 minutes
res = benchmark_all()
```

You can compare your results other users

```
plot(res)
## Needs the DT package
get_datatable(res)
```

and upload your results

```
upload_results(res)
```
