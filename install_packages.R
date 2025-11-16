# Install Required R Packages for Academic Figures Presentation
# Run this script once before rendering the presentation

cat("Installing required R packages...\n")
cat(strrep("=", 60), "\n")

# Required packages (presentation will not render without these)
required_packages <- c(
  "ggplot2",      # Core plotting
  "patchwork",    # Combining plots
  "viridis",      # Color palettes
  "RColorBrewer", # Color palettes
  "dplyr",        # Data manipulation
  "forcats",      # Factor handling
  "quarto"        # Rendering Quarto documents
)

# Optional packages (for some code examples, but not required for rendering)
optional_packages <- c(
  "plotly",       # Interactive plots
  "htmlwidgets",  # Saving interactive plots
  "pheatmap",     # Heatmaps
  "ggiraph",      # Interactive ggplot2
  "purrr",        # Functional programming
  "tidyr"         # Data tidying
)

# Function to install if not already installed
install_if_missing <- function(packages, type = "required") {
  new_packages <- packages[!(packages %in% installed.packages()[,"Package"])]

  if (length(new_packages) == 0) {
    cat("✓ All", type, "packages already installed\n")
    return(invisible(NULL))
  }

  cat("Installing", length(new_packages), type, "package(s):\n")
  cat("  ", paste(new_packages, collapse = ", "), "\n")

  install.packages(new_packages, dependencies = TRUE)

  # Check if installation was successful
  failed <- new_packages[!(new_packages %in% installed.packages()[,"Package"])]

  if (length(failed) > 0) {
    cat("❌ Failed to install:", paste(failed, collapse = ", "), "\n")
  } else {
    cat("✓ Successfully installed all", type, "packages\n")
  }
}

# Install required packages
cat("\n1. Installing REQUIRED packages...\n")
install_if_missing(required_packages, "required")

# Install optional packages
cat("\n2. Installing OPTIONAL packages...\n")
cat("   (Used in some examples, but not required for rendering)\n")
install_if_missing(optional_packages, "optional")

# Verify installation
cat("\n", strrep("=", 60), "\n")
cat("Installation Summary:\n")
cat(strrep("=", 60), "\n")

all_packages <- c(required_packages, optional_packages)
installed <- all_packages %in% installed.packages()[,"Package"]

results <- data.frame(
  Package = all_packages,
  Type = c(rep("Required", length(required_packages)),
           rep("Optional", length(optional_packages))),
  Installed = ifelse(installed, "✓", "❌"),
  stringsAsFactors = FALSE
)

print(results, row.names = FALSE)

n_required_installed <- sum(required_packages %in% installed.packages()[,"Package"])
n_optional_installed <- sum(optional_packages %in% installed.packages()[,"Package"])

cat("\nRequired packages:", n_required_installed, "/", length(required_packages), "\n")
cat("Optional packages:", n_optional_installed, "/", length(optional_packages), "\n")

if (n_required_installed == length(required_packages)) {
  cat("\n✓ Ready to render! Run: source('render.R')\n")
} else {
  cat("\n❌ Some required packages failed to install.\n")
  cat("   Try installing them manually:\n")
  missing <- required_packages[!(required_packages %in% installed.packages()[,"Package"])]
  cat("   install.packages(c('", paste(missing, collapse = "', '"), "'))\n", sep = "")
}
