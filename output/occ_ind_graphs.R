## @knitr setup

# Set occ_ind codelengths to load
  indcode_min <- 1
  indcode_max <- 4
  occcode_min <- 1
  occcode_max <- 4

# Load packages
  library(foreign)
  library(ggplot2)

# Set working directory
  setwd(dir = "/Users/kbp2w/Box Sync/Adam/Occupation & Industry Stats/data/clean/")
  
# Read Stata data into R
  ind <- read.dta(file = "ind_v12.dta")
  occ <- read.dta(file = "occ_v12.dta")
  for (indcode_length in indcode_min:indcode_max) {
    for (occcode_length in occcode_min:occcode_max) {
      assign(paste0("ind",indcode_length,"_occ",occcode_length), read.dta(file = paste0("ind",indcode_length, "_occ",occcode_length,"_v12.dta")))
    }
  }
  
# Plot functions
  # Full density plot
    plot_full_density <- function(data, dataname, includeflags) {
      if (includeflags==TRUE) {
        ggbase <- ggplot(data = data, mapping = aes(x = num_labforce))
      }
      else {
        ggbase <- ggplot(data = data, mapping = aes(x = num_labforce_noflag))
      }
      ggbase +
        geom_histogram(aes(y=..density..),
                       bins = 100,
                       color="black", 
                       fill="grey") +
        geom_density(alpha=.2,
                     color = "#000099",
                     fill="#000099") +
        ggtitle(paste(dataname,"~","Full"))
    }
  
  # Density plot with shorter x limits
    plot_partial_density <- function(data, dataname, includeflags, xhigh) {
      if (includeflags==TRUE) {
        ggbase <- ggplot(data = data, mapping = aes(x = num_labforce))
      }
      else {
        ggbase <- ggplot(data = data, mapping = aes(x = num_labforce_noflag))
      }
      ggbase +
        geom_histogram(aes(y=..density..),
                       binwidth = xhigh/50,
                       color="black", 
                       fill="grey") +
        geom_density(alpha=.2, 
                     color = "#000099",
                     fill="#000099") +
        xlim(0, xhigh) +
        ggtitle(paste(dataname,"~","xlimits:","0","to",xhigh))
    }

# Data frame list
 #   df.list <- list(ind,
 #                   occ,
 #                   ind4_occ4,
 #                   ind3_occ3,
 #                   ind3_occ2,
 #                   ind2_occ3,
 #                   ind2_occ2,
 #                   ind1_occ3
 #   )
 #   
 #   indnumlist <- list(
 #                   4,
 #                   0,
 #                   4,
 #                   3,
 #                   3,
 #                   2,
 #                   2,
 #                   1)
 #          
 #   occnumlist <- list(
 #                   0,
 #                   4,
 #                   4,
 #                   3,
 #                   2,
 #                   3,
 #                   2,
 #                   3)         
    df.list <- list(
                    ind,
                    occ,
                    ind1_occ1,
                    ind1_occ2,
                    ind1_occ3,
                    ind1_occ4,
                    ind2_occ1,
                    ind2_occ2,
                    ind2_occ3,
                    ind2_occ4,
                    ind3_occ1,
                    ind3_occ2,
                    ind3_occ3,
                    ind3_occ4,
                    ind4_occ1,
                    ind4_occ2,
                    ind4_occ3,
                    ind4_occ4
                    )
    indnumlist <- list(
                    4,
                    0,
                    1,
                    1,
                    1,
                    1,
                    2,
                    2,
                    2,
                    2,
                    3,
                    3,
                    3,
                    3,
                    4,
                    4,
                    4,
                    4)
    occnumlist <- list(
                    0,
                    4,
                    1,
                    2,
                    3,
                    4,
                    1,
                    2,
                    3,
                    4,
                    1,
                    2,
                    3,
                    4,
                    1,
                    2,
                    3,
                    4)

    #paste0("ind", rep(indcode_min:indcode_max, each = 4), "_occ", occcode_min:occcode_max)
    #message()
    #message(paste0("ind", rep(indcode_min:indcode_max, each = 4), "_occ", occcode_min:occcode_max,",")))
    
    table <- cbind(
      #ind
      ind = 
        indnumlist,
      #occ
      occ = 
        occnumlist,
      #Total # of obs 
      totalobs = 
        lapply(df.list, function(x) nrow(x)), 
      #05 percentile
      q_05 = 
        lapply(df.list, function(x) nrow(x[x$num_labforce<=(quantile(x$num_labforce, prob = 0.05)),])),
      #25 percentile
      q_25 = 
        lapply(df.list, function(x) nrow(x[x$num_labforce<=(quantile(x$num_labforce, prob = 0.25)),])),
      #50 percentile
      q_50 = 
        lapply(df.list, function(x) nrow(x[x$num_labforce<=(quantile(x$num_labforce, prob = 0.50)),])),
      #75 percentile
      q_75 = 
        lapply(df.list, function(x) nrow(x[x$num_labforce<=(quantile(x$num_labforce, prob = 0.75)),])),
      #95 percentile
      q_95 = 
        lapply(df.list, function(x) nrow(x[x$num_labforce<=(quantile(x$num_labforce, prob = 0.95)),])),
      #Total # of obs with 100 workers or fewer--including flagged data 
      obswith100workersorless_flag = 
        lapply(df.list, function(x) nrow(x[x$num_labforce<=100,])),
      #05 percentile
      q_05 = 
        lapply(df.list, function(x) nrow(x[x$num_labforce<=(quantile(x$num_labforce_noflag, prob = 0.05)),])),
      #25 percentile
      q_25 = 
        lapply(df.list, function(x) nrow(x[x$num_labforce<=(quantile(x$num_labforce_noflag, prob = 0.25)),])),
      #50 percentile
      q_50 = 
        lapply(df.list, function(x) nrow(x[x$num_labforce<=(quantile(x$num_labforce_noflag, prob = 0.50)),])),
      #75 percentile
      q_75 = 
        lapply(df.list, function(x) nrow(x[x$num_labforce<=(quantile(x$num_labforce_noflag, prob = 0.75)),])),
      #95 percentile
      q_95 = 
        lapply(df.list, function(x) nrow(x[x$num_labforce<=(quantile(x$num_labforce_noflag, prob = 0.95)),])),
      #Total # of obs with 100 workers or fewer--excluding flagged data 
      obswith100workersorless_noflag = 
        lapply(df.list, function(x) nrow(x[x$num_labforce_noflag<=100,]))
    )
    
table2 <- cbind(
      #ind
      ind = 
        indnumlist,
      #occ
      occ = 
        occnumlist,
      #Total # of obs 
      totalobs = 
        lapply(df.list, function(x) nrow(x)), 
      #05 percentile
      q_05 = 
        lapply(df.list, function(x) quantile(x$num_labforce, prob = 0.05)),
      #25 percentile
      q_25 = 
        lapply(df.list, function(x) quantile(x$num_labforce, prob = 0.25)),
      #50 percentile
      q_50 = 
        lapply(df.list, function(x) quantile(x$num_labforce, prob = 0.50)),
      #75 percentile
      q_75 = 
        lapply(df.list, function(x) quantile(x$num_labforce, prob = 0.75)),
      #95 percentile
      q_95 = 
        lapply(df.list, function(x) quantile(x$num_labforce, prob = 0.95)),
      #Total # of obs with 100 workers or fewer--including flagged data 
      obswith100workersorless_flag = 
        lapply(df.list, function(x) nrow(x[x$num_labforce<=100,])),
      #05 percentile
      q_05 = 
        lapply(df.list, function(x) quantile(x$num_labforce_noflag, prob = 0.05)),
      #25 percentile
      q_25 = 
        lapply(df.list, function(x) quantile(x$num_labforce_noflag, prob = 0.25)),
      #50 percentile
      q_50 = 
        lapply(df.list, function(x) quantile(x$num_labforce_noflag, prob = 0.50)),
      #75 percentile
      q_75 = 
        lapply(df.list, function(x) quantile(x$num_labforce_noflag, prob = 0.75)),
      #95 percentile
      q_95 = 
        lapply(df.list, function(x) quantile(x$num_labforce_noflag, prob = 0.95)),
      #Total # of obs with 100 workers or fewer--excluding flagged data 
      obswith100workersorless_noflag = 
        lapply(df.list, function(x) nrow(x[x$num_labforce_noflag<=100,]))
    )
    
    
# Plot all plots

## @knitr plots_noflags
  #lapply(df.list, function(x) plot_full_density(data = x, dataname = paste(x), includeflags = FALSE))
  
  #for (df in df.list) {
  #  plot_full_density(data = df, dataname = paste0(df), includeflags = FALSE)
  #}
  
  #plot_full_density(data = ind, dataname = "ind",includeflags = FALSE)
  #plot_full_density(data = occ, dataname = "occ",includeflags = FALSE)
  #plot_full_density(data = ind_occ, dataname = "ind_occ",includeflags = FALSE)

  #plot_partial_density(data = ind, dataname = "ind", includeflags = FALSE, xhigh = 20000)
  #plot_partial_density(data = occ, dataname = "occ",includeflags = FALSE, xhigh = 15000)
  #plot_partial_density(data = ind_occ, dataname = "ind_occ",includeflags = FALSE, xhigh = 200)

## @knitr plots_withflags
  #plot_full_density(data = ind, dataname = "ind",includeflags = TRUE)
  #plot_full_density(data = occ, dataname = "occ",includeflags = TRUE)
  #plot_full_density(data = ind_occ, dataname = "ind_occ",includeflags = TRUE)
  #
  #plot_partial_density(data = ind, dataname = "ind", includeflags = TRUE, xhigh = 20000)
  #plot_partial_density(data = occ, dataname = "occ",includeflags = TRUE, xhigh = 15000)
  #plot_partial_density(data = ind_occ, dataname = "ind_occ",includeflags = TRUE, xhigh = 200)

## @knitr table_withflags
  kable(table2[,1:9])
  
## @knitr table_noflags
  kable(table2[,c(1:3,10:15)])
  

  

