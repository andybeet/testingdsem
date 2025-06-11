#' read in atlantis data
#' 
#' primary production and select atlantis species (daily, 1 year)

read_data <- function(plotTS = F) {
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
    dplyr::filter(year == 1964) |> 
    dplyr::filter(day <= 365) |> 
    dplyr::select(-year,-t)
  
  biom <- atlantistools::load_txt(paste0(here::here("data/neus_outputDailyBiomIndx.txt"))) |> 
    dplyr::filter(code %in% c("ZM","ZL","ZS","HER","MAK","SHK","STB")) |> 
    dplyr::mutate(time = as.integer(time)) |> 
    dplyr::rename(value = atoutput,
                  variable = code,
                  day=time) |> 
    dplyr::mutate(day = day+1) |> 
    dplyr::as_tibble()
  
  atlantisData <- rbind(biom,phyto) |>
    dplyr::mutate(value = value/10000) |> 
    tidyr::pivot_wider(id_cols="day",names_from = variable,values_from = value) |> 
    dplyr::select(-DinoFlag_N) |> 
    # dplyr::filter(year > 1997) |> 
    stats::as.ts()
  
  if (plotTS) {
    p1 <-  rbind(biom,phyto) |> 
      ggplot2::ggplot(ggplot2::aes(x=day, y=value) ) +
      ggplot2::facet_grid( rows=ggplot2::vars(variable), scales="free" ) +
      ggplot2::geom_line( )
    print(p1)
  }
  
  return(atlantisData)
}

