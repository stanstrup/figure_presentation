# Install Required R Packages for Academic Figures Presentation
# Used by GitHub Actions workflow for automated deployment

cat("Installing required R packages...\n")
cat(strrep("=", 60), "\n")

# Core packages (absolutely required)
core_packages <- c(
  "remotes",      # For installing from GitLab/GitHub
  "ggplot2",      # Core plotting
  "dplyr",        # Data manipulation
  "tidyr",        # Data tidying
  "tibble",       # Modern data frames
  "forcats",      # Factor handling
  "patchwork",    # Combining plots
  "rmarkdown",    # Document rendering
  "knitr"         # Document rendering
)

# Tidyverse (includes many of the above, but explicit is better)
tidyverse_packages <- c(
  "tidyverse"     # Meta-package for data science
)

# Color and scales packages
color_packages <- c(
  "viridis",      # Color palettes
  "RColorBrewer", # Color palettes
  "colorspace",   # Color manipulation
  "dichromat",    # Color blindness simulation
  "scales"        # Scale functions
)

# Plotting extension packages
plotting_packages <- c(
  "ggpubr",       # Publication-ready plots
  "ggthemes",     # Additional themes
  "hrbrthemes",   # hrbrthemes fonts and themes
  "ggiraph",      # Interactive ggplot2
  "grid",         # Grid graphics
  "gridExtra"     # Grid extras
)

# Specialized visualization packages
specialized_packages <- c(
  "pheatmap",     # Heatmaps
  "corrplot",     # Correlation plots
  "plotly",       # Interactive plots
  "htmlwidgets",  # Saving interactive plots
  "crosstalk"     # Widget interactivity
)

# Data and utility packages
utility_packages <- c(
  "magick",       # Image processing
  "glue",         # String interpolation
  "gtools",       # Various utilities (mixedsort for natural sorting)
  "conflicted",   # Function conflict management
  "extrafont",    # Font management
  "devtools",     # Development tools
  "svglite",      # SVG graphics device
  "devEMF",       # EMF graphics device
  "pkgdown",      # Package documentation
  "rsvg"          # SVG rendering
)

# Combine all CRAN packages
all_cran_packages <- unique(c(
  core_packages,
  tidyverse_packages,
  color_packages,
  plotting_packages,
  specialized_packages,
  utility_packages
))

# Function to install if not already installed
install_if_missing <- function(packages, type = "CRAN") {
  new_packages <- packages[!(packages %in% installed.packages()[,"Package"])]

  if (length(new_packages) == 0) {
    cat("✓ All", type, "packages already installed\n")
    return(invisible(NULL))
  }

  cat("Installing", length(new_packages), type, "package(s):\n")
  cat("  ", paste(new_packages, collapse = ", "), "\n")

  install.packages(new_packages, dependencies = TRUE, repos = "https://cloud.r-project.org/")

  # Check if installation was successful
  failed <- new_packages[!(new_packages %in% installed.packages()[,"Package"])]

  if (length(failed) > 0) {
    cat("❌ Failed to install:", paste(failed, collapse = ", "), "\n")
    stop("Package installation failed")
  } else {
    cat("✓ Successfully installed all", type, "packages\n")
  }
}

# Install CRAN packages
cat("\n1. Installing CRAN packages...\n")
install_if_missing(all_cran_packages, "CRAN")

# Install Bioconductor packages
cat("\n2. Installing Bioconductor packages...\n")
if (!requireNamespace("BiocManager", quietly = TRUE)) {
  install.packages("BiocManager", repos = "https://cloud.r-project.org/")
}
BiocManager::install("mixOmics", update = FALSE, ask = FALSE)

# Install GitLab packages
cat("\n3. Installing GitLab packages...\n")
if (!requireNamespace("remotes", quietly = TRUE)) {
  install.packages("remotes", repos = "https://cloud.r-project.org/")
}
tryCatch({
  remotes::install_gitlab("stanstrup_R_packages/massageR", upgrade = "never")
  cat("✓ Successfully installed massageR from GitLab\n")
}, error = function(e) {
  cat("⚠ Failed to install massageR from GitLab:", conditionMessage(e), "\n")
  cat("  This may not affect the presentation if massageR is not used.\n")
})

# Verify installation
cat("\n", strrep("=", 60), "\n")
cat("Installation Summary:\n")
cat(strrep("=", 60), "\n")

installed <- all_cran_packages %in% installed.packages()[,"Package"]
bioc_installed <- "mixOmics" %in% installed.packages()[,"Package"]
gitlab_installed <- "massageR" %in% installed.packages()[,"Package"]

cat("\nCRAN packages:", sum(installed), "/", length(all_cran_packages), "\n")
cat("Bioconductor packages:", ifelse(bioc_installed, "1/1", "0/1"), "\n")
cat("GitLab packages:", ifelse(gitlab_installed, "1/1", "0/1"), "\n")

if (sum(installed) == length(all_cran_packages) && bioc_installed) {
  cat("\n✓ All essential packages installed successfully!\n")
} else {
  cat("\n❌ Some packages failed to install.\n")
  missing <- all_cran_packages[!installed]
  if (length(missing) > 0) {
    cat("   Missing CRAN packages:", paste(missing, collapse = ", "), "\n")
  }
  if (!bioc_installed) {
    cat("   Missing Bioconductor packages: mixOmics\n")
  }
  stop("Package installation incomplete")
}
