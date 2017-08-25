# Load packages
  library(foreign)
  library(ggplot2)

# Set extract number
  extract_num <- 2
  
# Set graph parameters
  xlow <- 0
  xhigh <- 500

# Set working directory
  setwd(dir = paste("/Users/kbp2w/Box Sync/Adam/Occupation & Industry Stats/data/clean/Extract ", extract_num))

# Read Stata data into R
  ind <- read.dta(file = "ind_v12.dta")
  occ <- read.dta(file = "occ_v12.dta")
  ind_occ <- read.dta(file = "ind_occ_v12.dta")
  
# Plot functions
  # Full density plot
    plot_full_density <- function(data, dataname) {
      ggplot(data = data, mapping = aes(x = num_labforce)) +
        geom_density() +
        ggtitle(paste(dataname,"~","Full"))
    }
  
  # Density plot with shorter x limits
    plot_partial_density <- function(data, dataname) {
      ggplot(data = data, mapping = aes(x = num_labforce)) +
        geom_density() +
        xlim(xlow, xhigh) +
        ggtitle(paste(dataname,"~","xlimits:",xlow,"to",xhigh))
    }

# Plot all plots
  plot_full_density(data = ind, dataname = "ind")
  plot_full_density(data = occ, dataname = "occ")
  plot_full_density(data = ind_occ, dataname = "ind_occ")

  plot_partial_density(data = ind, dataname = "ind")
  plot_partial_density(data = occ, dataname = "occ")
  plot_partial_density(data = ind_occ, dataname = "ind_occ")
