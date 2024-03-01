#' replace jims data to include NAs
#'
#'@param sem sem. sem model definition
#'@param tsdata TS data frame. Assumes it has 8 columns (first being time) as in the vignette example
#'@param seed integer. random number generator seed
#'@param propMissing numeric. proportion of data to assign as NAs
#'@param makePlot Boolean. plot fitted sampled network
#'
#'@return list
#'
#'\item{sampledTS}{new data set sampled with missing obs}
#'\item{fit}{fitted dsem model}
#'\item{plot}{as_fitted_DAG model}
#'
#'
#' @export


removeData <- function(sem,tsdata,seed,propMissing=0.25,makePlot=F){
  # replace ~25% of data with NAs for all variables
  sampledTS <- tsdata
  nyrs <- nrow(tsdata)
  set.seed(seed)
  nmissing <- floor(propMissing*nyrs)
  # loop over all variables and replcar with NAs
  for (i in 1:7) {
    ind <- sample(nyrs,nmissing)
    sampledTS[ind,i+1] <- NA
  }

  # fit model again
  fitSampled = dsem::dsem( sem=sem,
                           tsdata = sampledTS,
                           estimate_delta0 = TRUE,
                           control = dsem::dsem_control(
                             quiet = TRUE,
                             newton_loops = 0) )

  if (any(is.na(fitSampled$sdrep$cov.fixed))) {
    message("nope")
    return(NULL)
  } else {
    summary(fitSampled)
    # plot new network
    p1 = plot(dsem::as_fitted_DAG(fitSampled) ) +
      ggplot2::expand_limits(x = c(-0.2,1) )
    if (makePlot) {
      print(p1)
    }
  }

  return(list(sampledTS=sampledTS,fit=fitSampled,plot=p1))
}
