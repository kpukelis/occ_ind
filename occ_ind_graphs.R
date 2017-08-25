## @knitr setup
# Load packages
  library(foreign)
  library(ggplot2)

# Set working directory
  setwd(dir = "/Users/kbp2w/Box Sync/Adam/Occupation & Industry Stats/data/clean/Extract 3")
  
# Read Stata data into R
  ind <- read.dta(file = "ind_v12.dta")
  occ <- read.dta(file = "occ_v12.dta")
  ind_occ <- read.dta(file = "ind_occ_v12.dta")
  
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
    df.list <- list(ind,occ,ind_occ)
    
# Plot all plots

## @knitr plots_noflags
  plot_full_density(data = ind, dataname = "ind",includeflags = FALSE)
  plot_full_density(data = occ, dataname = "occ",includeflags = FALSE)
  plot_full_density(data = ind_occ, dataname = "ind_occ",includeflags = FALSE)

  plot_partial_density(data = ind, dataname = "ind", includeflags = FALSE, xhigh = 20000)
  plot_partial_density(data = occ, dataname = "occ",includeflags = FALSE, xhigh = 15000)
  plot_partial_density(data = ind_occ, dataname = "ind_occ",includeflags = FALSE, xhigh = 200)

## @knitr plots_withflags
  plot_full_density(data = ind, dataname = "ind",includeflags = TRUE)
  plot_full_density(data = occ, dataname = "occ",includeflags = TRUE)
  plot_full_density(data = ind_occ, dataname = "ind_occ",includeflags = TRUE)
  
  plot_partial_density(data = ind, dataname = "ind", includeflags = TRUE, xhigh = 20000)
  plot_partial_density(data = occ, dataname = "occ",includeflags = TRUE, xhigh = 15000)
  plot_partial_density(data = ind_occ, dataname = "ind_occ",includeflags = TRUE, xhigh = 200)
  
## @knitr stats
  #Total # of obs (ind, occ, ind_occ)
  lapply(df.list, function(x) nrow(x))
  #Total # of obs with 100 workers or fewer--including flagged data (ind, occ, ind_occ)
  lapply(df.list, function(x) nrow(x[x$num_labforce<=100,]))
  #Total # of obs with 100 workers or fewer--excluding flagged data (ind, occ, ind_occ)
  lapply(df.list, function(x) nrow(x[x$num_labforce_noflag<=100,]))
  