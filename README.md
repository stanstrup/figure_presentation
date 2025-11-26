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
├── topics/*.qmd              # Source files for BOTH slides and book chapters
├── book/                     # Quarto Book configuration
│   ├── _quarto.yml          # Book configuration (includes ../topics/*.qmd)
│   ├── index.qmd            # Book homepage
│   └── references.qmd       # Bibliography
├── quiz.Rmd                  # Interactive learnr quiz
├── plots/                    # Generated plots (auto-created)
├── sources/                  # Static source images
└── custom.css                # Custom styling
```

### Single-Source Architecture

This project uses a **single-source approach** where the same `.qmd` files in `topics/` render as:

- **Slides** (RevealJS format) - via `presentation.qmd`
- **Book chapters** (HTML book) - via `book/_quarto.yml`

Conditional content blocks using `::: {.content-visible unless-format="revealjs"}` add book-specific sections (introductions, summaries, exercises) while keeping slide content unchanged. This eliminates content duplication and ensures consistency.

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

Test your knowledge with an interactive quiz covering all topics! See [`QUIZ_README.md`](QUIZ_README.md) for full instructions.

**Quick start:**
```r
rmarkdown::run("quiz.Rmd")
```

The quiz contains **31 questions** with immediate feedback, performance-based guidance, and full explanations.

## CI/CD

This project uses GitHub Actions to automatically build and deploy the presentation:

- **Build**: Renders the Quarto presentation
- **Deploy**: Publishes to GitHub Pages
- **Trigger**: Commits to `main` or `master` branch

See `.github/workflows/deploy.yml` for configuration details.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
