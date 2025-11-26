# Academic Figures Quiz

An interactive quiz based on the "Academic Figures: Common Pitfalls and Best Practices" presentation.

## Running the Quiz

### Option 1: Direct Run (Recommended)

```r
# Install learnr if needed
if (!requireNamespace("learnr", quietly = TRUE)) {
  install.packages("learnr")
}

# Run the quiz
rmarkdown::run("quiz.Rmd")
```

The quiz will open in your web browser!

### Option 2: If you encounter namespace errors

Sometimes there are version conflicts with the `markdown` package. If you get an error about "namespace is already loaded", try this:

```r
# Restart R session first
.rs.restartR()  # In RStudio

# Then run:
rmarkdown::run("quiz.Rmd")
```

Or restart R manually and try again.

### Option 3: Render to HTML

You can render the quiz to a static HTML file:

```r
rmarkdown::render("quiz.Rmd")
```

Then open `quiz.html` in your web browser. Note: This creates a static version - you'll need to run it through `rmarkdown::run()` for full interactivity.

## Quiz Content

The quiz contains **31 questions** covering all major topics from the presentation:

1. **Color Gradients** (7 questions) - Rainbow problems, viridis, colorblindness
2. **Heatmaps** (3 questions) - Outliers, scaling methods
3. **File Formats** (5 questions) - Vector vs raster, photos vs generated plots, DPI
4. **Text Sizing** (2 questions) - Canvas size, base_size
5. **Themes** (2 questions) - theme_set(), ggpubr
6. **Saving Plots** (3 questions) - ggsave(), Cairo devices
7. **Post-Processing** (2 questions) - Reproducibility, metafile issues
8. **Factor Ordering** (3 questions) - Sorting issues, forcats functions
9. **Interactive Plots** (4 questions) - ggplotly, saveWidget, ggiraph

## Features

- ✅ Progressive format (one section at a time)
- ✅ Immediate feedback with explanations
- ✅ Retry functionality for learning
- ✅ Skip questions if needed
- ✅ Clean, interactive interface

## Troubleshooting

**Problem:** Error about markdown namespace

**Solution:** Restart your R session before running the quiz.

---

**Problem:** Quiz doesn't open in browser

**Solution:** Make sure you're using `rmarkdown::run()` not `rmarkdown::render()`

---

**Problem:** Missing packages

**Solution:** The quiz automatically loads required packages, but if you get errors, install manually:

```r
install.packages(c("learnr", "rmarkdown", "knitr"))
```

## About

This quiz is a companion to the presentation available at:
https://stanstrup.github.io/figure_presentation/
