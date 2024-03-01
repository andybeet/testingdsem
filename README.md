
<!-- README.md is generated from README.Rmd. Please edit that file -->

# testingdsem

<!-- badges: start -->
<!-- badges: end -->

test to make sure dsem output is consistent

## Installation

You can install the development version of testingdsem from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("andybeet/testingdsem")
```

## Results

-   See three figures below

-   Each figure shows the fitted network as found in the dsem
    [vignette](https://james-thorson-noaa.github.io/dsem/articles/vignette.html#comparison-with-dynamic-linear-models)
    alongside the same fitted network but with 25% of each of the
    variables data set as missing(NA). The NAs were randomly omitted

-   Each of the three figures show three random assignments of NAs. In
    each case 25% of the data was assigned missing.

-   The parameters seem to be estimated ok, the algorithm seems to have
    converged ok, and the parameters that look quite different are
    statistically significant.

-   Note in particular the paths time-\>pwage and cprofits-\>invest

## Example

Fit from vignette

    #> 1 regions found.
    #> Using 1 threads
    #> 1 regions found.
    #> Using 1 threads

<img src="man/figures/README-example-1.png" width="100%" />

Fits of same model with missing data
<img src="man/figures/README-example2-1.png" width="100%" /><img src="man/figures/README-example2-2.png" width="100%" /><img src="man/figures/README-example2-3.png" width="100%" />
