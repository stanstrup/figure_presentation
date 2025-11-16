# Academic Figures: Common Pitfalls and Best Practices

A comprehensive Quarto presentation covering common mistakes in creating publication-quality figures in academic research.

## Structure

This presentation uses a **modular structure** for easy maintenance and parallel editing:

```
figure_presentation/
├── presentation.qmd          # Master presentation file
├── topics/                   # Individual topic modules
│   ├── 01_formats.qmd       # File formats & compression
│   ├── 02_colors.qmd        # Color gradients & palettes
│   ├── 03_themes.qmd        # ggplot2 themes
│   ├── 04_heatmaps.qmd      # Heatmap scaling issues
│   ├── 05_sizing.qmd        # Text sizing
│   ├── 06_saving.qmd        # Saving plots in R
│   ├── 07_editing.qmd       # Post-export editing
│   ├── 08_powerpoint.qmd    # PowerPoint import
│   ├── 09_rendering.qmd     # PDF rendering issues
│   ├── 10_interactive.qmd   # Interactive plots
│   └── 11_factors.qmd       # Factor ordering
└── PRESENTATION_OUTLINE.md  # Detailed narrative outline
```

## Rendering the Presentation

### From R (Recommended)

**First time setup:**
```r
# Install required packages
source("install_packages.R")

# Load rendering functions
source("render.R")
```

**Test all topics to find errors:**
```r
# This will test each topic individually and report which ones fail
results <- test_all_topics()
```

**Render individual topics:**
```r
# Test a specific topic by number
render_topic(2)   # Test colors topic

# Or use shortcuts
test_colors()     # Topic 2
test_heatmaps()   # Topic 4
test_factors()    # Topic 11
```

**Render full presentation:**
```r
render_presentation()
```

**Preview with live reload:**
```r
preview_presentation()  # Opens in browser, auto-refreshes on changes
```

### From Command Line

```bash
# Render the complete presentation
quarto render presentation.qmd

# Render a single topic
quarto render topics/02_colors.qmd

# Preview while editing
quarto preview presentation.qmd
```

## Topics Covered

### 1. File Formats (01_formats.qmd)
- Vector vs raster (pixel-based) formats
- Resolution requirements (DPI) for different uses
- Compression: lossless vs lossy
- Format decision tree
- Real-world examples of JPEG compression artifacts

### 2. Color Gradients (02_colors.qmd)
- **Why rainbow/jet colormaps are problematic**
  - False boundaries in smooth data
  - Perceptual non-uniformity
  - Medical diagnosis errors
- Color blindness considerations (~8% of men affected)
- Recommended palettes: viridis, ColorBrewer
- Interactive examples with `faithfuld` and `volcano` datasets
- External image: [jet vs five perceptually uniform colormaps](https://www.domestic-engineering.com/drafts/viridis/jet_vs_five.png)

### 3. ggplot2 Themes (03_themes.qmd)
- Problems with default `theme_gray()`
- Publication-ready themes
- Setting global themes
- Custom theme creation

### 4. Heatmap Scaling (04_heatmaps.qmd)
- The outlier problem
- **Critical bug**: R's heatmap functions scale colors but NOT dendrograms
- Solution: `heat.clust()` from massageR package
- Standard deviation cutoffs
- Quantile-based scaling
- Source: [stanstrup.github.io/heatmaps.html](https://stanstrup.github.io/heatmaps.html)

### 5. Text Sizing (05_sizing.qmd)
- The "zoom fallacy"
- Setting text sizes for final output dimensions
- Journal dimension requirements
- Minimum font sizes for print

### 6. Saving Plots (06_saving.qmd)
- Graphics device system
- Using `ggsave()` properly
- Format-specific settings (PDF, PNG, TIFF, SVG)
- Converting PDF to high-res PNG

### 7. Post-Export Editing (07_editing.qmd)
- When to edit in Illustrator/Inkscape
- Maintaining reproducibility
- What NOT to edit manually
- Combining plots: R vs post-processing

### 8. PowerPoint Import (08_powerpoint.qmd)
- Why copy-paste fails
- Vector formats for PowerPoint (EMF, PDF, SVG)
- High-resolution raster alternatives
- Testing quality

### 9. Rendering Issues (09_rendering.qmd)
- Screen rendering vs print output
- The thin line problem
- Font substitution
- Viewer differences
- When to worry (and when not to)

### 10. Interactive Plots (10_interactive.qmd)
- plotly and ggplotly
- Saving interactive plots as HTML
- Static snapshots with kaleido
- When to use interactive vs static
- R Markdown/Quarto integration

### 11. Factor Ordering (11_factors.qmd)
- R's alphabetical default problem
- Manual factor ordering
- forcats package functions
- Real-world examples with surveys and clinical trials

## Data Sources

All examples use **real, built-in R datasets**:
- `mtcars` - Motor Trend car fuel efficiency
- `iris` - Anderson's iris flower measurements
- `faithful` - Old Faithful geyser eruptions
- `faithfuld` - 2D density of faithful data
- `volcano` - Maunga Whau volcano topography

Plus simulated data for specific demonstrations (gene expression, clinical trials, surveys).

## Key Features

✅ **Executable code** - All examples use real datasets and can be run
✅ **No `data` variable conflicts** - Uses proper variable names (expr_matrix, plot_df, etc.)
✅ **Modular structure** - Easy to update individual topics
✅ **Real-world references**:
   - HESS 2021: Rainbow colormap problems in hydrology
   - Borkin et al. 2011: Medical imaging errors with jet colormap
   - The Conversation: How rainbow colour maps distort data
   - domestic-engineering.com: Visual comparisons

✅ **Proper eval flags**:
   - `eval: true` for simple, guaranteed examples
   - `eval: false` for complex/external package examples

## References & Resources

### Color Palettes
- [ColorBrewer](https://colorbrewer2.org)
- [Viridis package documentation](https://cran.r-project.org/web/packages/viridis)
- [Colorblind simulator (Coblis)](https://www.coblis.com)

### Academic Articles
- HESS (2021): "Rainbow color map distorts and misleads research in hydrology"
- Borkin et al. (2011): "Evaluation of Artery Visualizations for Heart Disease Diagnosis"
- [The Conversation: Rainbow colour maps distort data](https://theconversation.com/how-rainbow-colour-maps-can-distort-data-and-be-misleading-167159)

### R Packages
- [ggplot2](https://ggplot2.tidyverse.org)
- [forcats](https://forcats.tidyverse.org)
- [patchwork](https://patchwork.data-imaginist.com)
- [plotly for R](https://plotly.com/r/)

### Books
- "Fundamentals of Data Visualization" by Claus Wilke (free online)
- "ggplot2: Elegant Graphics for Data Analysis" by Hadley Wickham

## Requirements

To render this presentation, you need:
- R (≥ 4.0)
- Quarto (≥ 1.3)
- R packages:
  ```r
  install.packages(c("ggplot2", "patchwork", "viridis", "RColorBrewer", "dplyr", "forcats"))
  ```

Optional packages for some examples:
```r
install.packages(c("plotly", "htmlwidgets", "pheatmap", "ggiraph"))
```

## Customization

### To add a new topic:
1. Create `topics/12_newtopic.qmd`
2. Add `{{< include topics/12_newtopic.qmd >}}` to `presentation.qmd`
3. Use the same structure as existing topics

### To modify themes/styling:
Edit the YAML header in `presentation.qmd`:
```yaml
format:
  revealjs:
    theme: simple  # or dark, sky, etc.
    slide-number: true
    chalkboard: true
```

## Contributing

Each topic file is independent, making it easy to:
- Work on multiple topics in parallel
- Test individual topics without rendering the full presentation
- Share specific topics with collaborators

## License

Feel free to use and adapt for your own presentations!

## Contact

For questions about the presentation content or structure, please open an issue.
