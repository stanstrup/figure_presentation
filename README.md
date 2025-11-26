# Academic Figures: Common Pitfalls and Best Practices

A Quarto RevealJS presentation about common pitfalls in creating academic figures using R.

## Viewing the Materials

The materials are automatically built and deployed to GitHub Pages on every commit to the main branch.

**📖 Book (Comprehensive Guide):** https://stanstrup.github.io/figure_presentation/

**📊 Presentation Slides:** https://stanstrup.github.io/figure_presentation/presentation.html

**✅ Interactive Quiz:** https://stanstrup.github.io/figure_presentation/quiz.html

Choose the format that works best for you:
- **Book**: In-depth tutorials with detailed explanations
- **Slides**: Quick reference and presentations
- **Quiz**: Test your knowledge (31 questions)

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

## Repository Structure

```
.
├── presentation.qmd          # Main presentation file (slides)
├── topics/*.qmd              # Individual slide topics (modular)
├── book/                     # Quarto Book (comprehensive guide)
│   ├── _quarto.yml          # Book configuration
│   ├── index.qmd            # Book homepage
│   ├── chapters/*.qmd       # Expanded tutorial chapters
│   └── references.qmd       # Bibliography
├── quiz.Rmd                  # Interactive learnr quiz
├── plots/                    # Generated plots (auto-created)
├── sources/                  # Static source images
└── custom.css                # Custom styling
```

## Topics Covered

1. Color Gradients
2. Heatmap Scaling
3. File Formats (Vector vs Raster)
4. Text Sizing
5. Themes & Styling
6. Saving Plots
7. Post-Processing
8. PowerPoint Import
9. Factor Ordering
10. Interactive Plots
11. Rendering Issues

## Interactive Quiz

Test your knowledge with an interactive quiz covering all topics!

### Running the Quiz

```r
# Install learnr if needed
if (!requireNamespace("learnr", quietly = TRUE)) {
  install.packages("learnr")
}

# Run the quiz
rmarkdown::run("quiz.Rmd")
```

The quiz will open in your web browser with **31 questions** covering:

- Color gradients and palettes (7 questions)
- Heatmap scaling (3 questions)
- File formats (5 questions)
- Text sizing (2 questions)
- Themes and styling (2 questions)
- Saving plots (3 questions)
- Post-processing (2 questions)
- Factor ordering (3 questions)
- Interactive plots (4 questions)

### Quiz Features

- ✅ Progressive format (one section at a time)
- ✅ Immediate feedback with explanations
- ✅ Retry functionality for learning
- ✅ Performance-based guidance (score interpretation)
- ✅ Clean, interactive interface

### Troubleshooting

If you encounter a namespace error, restart your R session first:

```r
# In RStudio
.rs.restartR()

# Then run the quiz
rmarkdown::run("quiz.Rmd")
```

See `QUIZ_README.md` for detailed instructions and troubleshooting.

## CI/CD

This project uses GitHub Actions to automatically build and deploy the presentation:

- **Build**: Renders the Quarto presentation
- **Deploy**: Publishes to GitHub Pages
- **Trigger**: Commits to `main` or `master` branch

See `.github/workflows/deploy.yml` for configuration details.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
