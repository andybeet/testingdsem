#' Jims code from vignette
#' run example in vignette, then introduce missing value and compare fitted model
#'
#'
#'@import phylopath
#'@import zoo
#'
#' @export

testJim <- function(){

  # data
  data(KleinI, package="AER")
  TS = ts(data.frame(KleinI, "time"=time(KleinI) - 1931))

  # dynlm
  fm_cons <- dynlm::dynlm(consumption ~ cprofits + L(cprofits) + I(pwage + gwage), data = TS)
  fm_inv <- dynlm::dynlm(invest ~ cprofits + L(cprofits) + capital, data = TS)                 #
  fm_pwage <- dynlm::dynlm(pwage ~ gnp + L(gnp) + time, data = TS)

  # dsem
  sem = "
    # Link, lag, param_name
    cprofits -> consumption, 0, a1
    cprofits -> consumption, 1, a2
    pwage -> consumption, 0, a3
    gwage -> consumption, 0, a3

    cprofits -> invest, 0, b1
    cprofits -> invest, 1, b2
    capital -> invest, 0, b3

    gnp -> pwage, 0, c2
    gnp -> pwage, 1, c3
    time -> pwage, 0, c1
  "
  tsdata = TS[,c("time","gnp","pwage","cprofits",'consumption',
                 "gwage","invest","capital")]

  # fit original model
  fit = dsem::dsem( sem=sem,
              tsdata = tsdata,
              estimate_delta0 = TRUE,
              control = dsem::dsem_control(
                quiet = TRUE,
                newton_loops = 0) )

  #plot network

  poriginal <-  plot(dsem::as_fitted_DAG(fit) ) +
    ggplot2::expand_limits(x = c(-0.2,1) )

  ## resample data
  sampled1 <- removeData(sem=sem,tsdata,5)
  sampled2 <- removeData(sem=sem,tsdata,35)
  sampled3 <- removeData(sem=sem,tsdata,36)


  # comparison plot
  p1 <- sampled1$plot
  p2 <- sampled2$plot
  p3 <- sampled3$plot



  return(list(porig=poriginal,p1=p1,p2=p2,p3=p3))

}
