#' create data sets from atlantis to run DSEM

atlantisDailyDsem <- function() {

  atlantisData <- read_data(plotTS = F)




  sampledAtlantis <- atlantisData
  nyrs <- nrow(atlantisData)
  nmissing <- 5
  for (i in 1:5) {
    ind <- sample(nyrs,nmissing)
    sampledAtlantis[ind,i+1] <- NA
  }




  sem = "
    # Link, lag, param_name
    SHK -> HER, 0, a1
    SHK -> MAK, 0, a2
    STB -> HER, 0, a3
    STB -> MAK, 0, a4

    MAK -> ZM, 0, b1
    MAK -> Diatom_N, 0, b4
    HER -> ZL, 0, b2
    HER -> ZM, 0, b3
    HER -> Diatom_N, 1, b5

    ZL -> ZM, 1, c1
    ZL -> Diatom_N, 1, c2
    ZM -> ZS, 1, c3
    ZM -> Diatom_N, 1, c4
    ZS -> PicoPhytopl_N, 1, c5

  "

  fit = dsem( sem=sem,
              tsdata = sampledAtlantis,
              estimate_delta0 = FALSE,
              control = dsem_control(
                quiet = TRUE,
                newton_loops = 0) )
  summary(fit)

  p3 <-  plot( dsem::as_fitted_DAG(fit) ) +
    expand_limits(x = c(-0.2,1) )

  print(p3)
}
