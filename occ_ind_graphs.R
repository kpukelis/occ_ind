## @knitr setup
# Load packages
  library(foreign)
  library(ggplot2)

# Set extract number
  extract_num <- 2
  
# Set graph parameters
  xlow <- 0
  xhigh <- 500

# Set working directory
  #setwd(dir = paste("/Users/kbp2w/Box Sync/Adam/Occupation & Industry Stats/data/clean/Extract ", extract_num))
  setwd(dir = "/Users/kbp2w/Box Sync/Adam/Occupation & Industry Stats/data/clean/Extract 2")

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
      geom_density() +
        ggtitle(paste(dataname,"~","Full"))
    }
  
  # Density plot with shorter x limits
    plot_partial_density <- function(data, dataname, includeflags) {
      if (includeflags==TRUE) {
        ggbase <- ggplot(data = data, mapping = aes(x = num_labforce))
      }
      else {
        ggbase <- ggplot(data = data, mapping = aes(x = num_labforce_noflag))
      }
      ggbase +
        geom_density() +
        xlim(xlow, xhigh) +
        ggtitle(paste(dataname,"~","xlimits:",xlow,"to",xhigh))
    }

# Plot all plots
## @knitr plots_noflags
  plot_full_density(data = ind, dataname = "ind",includeflags = FALSE)
  plot_full_density(data = occ, dataname = "occ",includeflags = FALSE)
  plot_full_density(data = ind_occ, dataname = "ind_occ",includeflags = FALSE)

  plot_partial_density(data = ind, dataname = "ind", includeflags = FALSE)
  plot_partial_density(data = occ, dataname = "occ",includeflags = FALSE)
  plot_partial_density(data = ind_occ, dataname = "ind_occ",includeflags = FALSE)
## @knitr plots_withflags
  plot_full_density(data = ind, dataname = "ind",includeflags = TRUE)
  plot_full_density(data = occ, dataname = "occ",includeflags = TRUE)
  plot_full_density(data = ind_occ, dataname = "ind_occ",includeflags = TRUE)
  
  plot_partial_density(data = ind, dataname = "ind", includeflags = TRUE)
  plot_partial_density(data = occ, dataname = "occ",includeflags = TRUE)
  plot_partial_density(data = ind_occ, dataname = "ind_occ",includeflags = TRUE)
  