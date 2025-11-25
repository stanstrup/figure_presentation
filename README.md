# Academic Figures: Common Pitfalls and Best Practices

A Quarto RevealJS presentation about common pitfalls in creating academic figures using R.

## Viewing the Presentation

The presentation is automatically built and deployed to GitHub Pages on every commit to the main branch.

**Live Presentation:** https://stanstrup.github.io/figure_presentation/

## Local Development

### Prerequisites

- [Quarto](https://quarto.org/) (v1.4 or later)
- R (v4.5 or later)
- Required R packages (see installation below)

### Installation

Install all required R packages:

```bash
# Install all dependencies
Rscript .github/workflows/install_packages.R
```

Or install manually using R:

```r
# Core packages
install.packages(c("ggplot2", "dplyr", "tidyr", "forcats", "patchwork",
                   "viridis", "RColorBrewer", "colorspace", "scales",
                   "pheatmap", "plotly", "gtools", "magick"))

# Bioconductor packages
if (!requireNamespace("BiocManager", quietly = TRUE)) install.packages("BiocManager")
BiocManager::install("mixOmics")

# GitLab packages
remotes::install_gitlab("stanstrup_R_packages/massageR")
```

### Rendering Locally

```bash
# Render the presentation
quarto render presentation.qmd

# Preview while developing
quarto preview presentation.qmd

# Or use the helper script
Rscript render.R
```

### Development Workflow

The `render.R` script provides helpful utilities:

```r
# Load functions
source("render.R")

# Test all topics in parallel (fast!)
results <- test_all_topics_parallel()

# Test a specific topic
render_topic(9)  # Test topic 09

# Render full presentation
render_presentation()
```

## Structure

- `presentation.qmd` - Main presentation file
- `topics/*.qmd` - Individual topic sections (modular structure)
- `plots/` - Generated plots (auto-created during rendering)
- `sources/` - Static source images
- `custom.css` - Custom styling

## Topics Covered

1. Color Gradients
2. Heatmap Scaling
3. File Formats (Vector vs Raster)
4. Text Sizing
5. Themes & Styling
6. Saving Plots
7. Factor Ordering
8. Post-Processing
9. PowerPoint Import
10. Rendering Issues
11. Interactive Plots

## CI/CD

This project uses GitHub Actions to automatically build and deploy the presentation:

- **Build**: Renders the Quarto presentation
- **Deploy**: Publishes to GitHub Pages
- **Trigger**: Commits to `main` or `master` branch

See `.github/workflows/deploy.yml` for configuration details.

## License

[Add your license here]
