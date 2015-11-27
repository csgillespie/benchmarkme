# System benchmarking

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