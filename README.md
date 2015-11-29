# System benchmarking 
[![Build Status](https://travis-ci.org/csgillespie/benchmarkme.svg?branch=master)](https://travis-ci.org/csgillespie/benchmarkme)

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