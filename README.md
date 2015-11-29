# System benchmarking 
[![Build Status](https://travis-ci.org/csgillespie/benchmarkme.svg?branch=master)](https://travis-ci.org/csgillespie/benchmarkme)
[![Coverage Status](https://coveralls.io/repos/csgillespie/benchmarkme/badge.svg?branch=master&service=github)](https://coveralls.io/github/csgillespie/benchmarkme?branch=master)
[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/benchmarkme)](http://cran.r-project.org/package=benchmarkme)


To install:
```
install.packages("drat")
drat::addRepo("csgillespie")
install.packages("benchmarkme")
```

To run

```
library("benchmarkme")
res = benchmark_all()
plot(res)
upload_results(res)
```