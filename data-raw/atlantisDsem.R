#' create data sets from atlantis to run DSEM
# library(magrittr)
# library(dsem)
# library(dynlm)
# library(ggplot2)
# library(reshape)
# library(gridExtra)
# library(phylopath)
atlantisDsem <- function(){
  atl.dir = "C:/Users/andrew.beet/Documents/myWork/githubRepos/atlantiseof/other/dev_3a75e57d1"
  param.ls <- atlantisprocessing::get_atl_paramfiles(param.dir = "C:/Users/andrew.beet/Documents/myWork/githubRepos/neus-atlantis/currentVersion",
                                                     atl.dir = atl.dir,
                                                     run.prefix = "neus_output",
                                                     include_catch = T)

  # Get PP from input -------------------------------------------------------

  ## plot daily N by EPU and species
  ppdata <- atlantiseof::get_pp(bgm = param.ls$bgm.file,
                   pathToForcing = "C:/Users/andrew.beet/Documents/myWork/githubRepos/atlantiseof/data-raw/data/")

  phyto <- ppdata$dailyspecies |>
    dplyr::group_by(year,day,variable,t) |>
    dplyr::summarise(value = sum(value),.groups="drop") |>
    dplyr::group_by(year,variable) |>
    dplyr::summarise(value = mean(value),.groups="drop")

  biom <- atlantistools::load_txt(paste0(here::here("data/neus_outputBiomIndx.txt"))) |>
    dplyr::filter(code %in% c("ZM","ZL","ZS","HER","MAK","SHK","STB")) |>
    dplyr::filter(time %% 365 == 0) |>
    dplyr::mutate(time = 1964 + (time / 365),
                  time = as.integer(time)) |>
    dplyr::rename(value = atoutput,
                  variable = code,
                  year=time) |>
    dplyr::filter(year < 2018) |>
    dplyr::as_tibble()

  atlantisData <- rbind(biom,phyto) |>
    dplyr::mutate(value = value/100000) |>
    tidyr::pivot_wider(id_cols="year",names_from=variable,values_from = value) |>
    dplyr::select(-DinoFlag_N) |>
    # dplyr::filter(year > 1997) |>
    stats::as.ts()

  atlantisData <- atlantisData[35:54,]
  sampledAtlantis <- atlantisData
  nyrs <- nrow(atlantisData)
  set.seed(1)
  nmissing <- 5
  for (i in 1:5) {
    ind <- sample(nyrs,nmissing)
    sampledAtlantis[ind,i+1] <- NA
  }

  p1 = rbind(biom,phyto) |>
    ggplot2::ggplot(ggplot2::aes(x=year, y=value) ) +
    ggplot2::facet_grid( rows=ggplot2::vars(variable), scales="free" ) +
    ggplot2::geom_line( )
  p1


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
    HER -> Diatom_N, 0, b5

    ZL -> ZM, 0, c1
    ZL -> Diatom_N, 0, c2
    ZM -> ZS, 0, c3
    ZM -> Diatom_N, 0, c4
    ZS -> PicoPhytopl_N, 0, c5

  "

  fit = dsem( sem=sem,
              tsdata = sampledAtlantis,
              estimate_delta0 = FALSE,
              control = dsem_control(
                quiet = TRUE,
                newton_loops = 0) )
  summary(fit)

  p3 = plot( dsem::as_fitted_DAG(fit) ) +
    expand_limits(x = c(-0.2,1) )

  p3
}
