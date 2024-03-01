# testingdsem

test to make sure dsem output is consisent

## Usage

```
devtools::install_github("andybeet/testingdsem")

testingdsem::testJim()

```

## Results

* Three figures will be made created in the Plots tab. 
* Each figure will show the fitted network as found in the dsem [vignette](https://james-thorson-noaa.github.io/dsem/articles/vignette.html#comparison-with-dynamic-linear-models) alongside the same fitted network but with 25% of each of the variables data set as missing(NA). The NAs were randomly omitted

* Each of the three figures show three random assignments of NAs. In each case 25% of the data was assigned missing.

* The parameters seem to be estimated ok, the algorithm seems to have converged ok, and the parameters that differe substaially are statistically significant.

* Note in particular the paths time->pwage and cprofits->invest

