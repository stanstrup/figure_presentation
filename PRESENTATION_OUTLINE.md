# Academic Figures: Common Pitfalls and Best Practices

## Presentation Outline

---

## 1. File Formats: Making the Right Choice

### Vector vs. Raster (Pixel-based) Formats

**The Problem:**
Many researchers save publication-quality figures as JPG or low-resolution PNG, leading to pixelated images when printed or scaled.

**Key Concepts:**

- **Vector formats (PDF, EPS, SVG)**: Mathematical descriptions of shapes
  - Infinitely scalable without quality loss
  - Perfect for: plots, diagrams, text-heavy figures
  - File size: Often smaller for simple graphics

- **Raster formats (PNG, TIFF, JPG)**: Grid of pixels
  - Resolution-dependent (measured in DPI)
  - Perfect for: photographs, complex images with many colors
  - File size: Depends on dimensions and compression

### Resolution Guidelines

- **Screen viewing**: 72-96 DPI sufficient
- **Print publications**: Minimum 300 DPI (many journals require 600-1200 DPI)
- **Poster presentations**: 150-300 DPI (depending on viewing distance)

### Compression: The Quality vs. Size Trade-off

```
Image Compression Decision Tree:

Publication Figure?
├─ Yes → Use lossless compression
│   ├─ Vector graphics preferred: PDF, EPS, SVG
│   └─ Raster if needed: PNG, TIFF (uncompressed or LZW)
│
└─ No (Presentation/Draft)
    ├─ Need transparency? → PNG
    ├─ Photo/complex image? → JPG (quality 90-95%)
    └─ Simple graphics? → PNG
```

**Format Recommendations:**
- **Never use**: JPG for line plots, graphs, or diagrams (creates artifacts)
- **Journal submission**: PDF or EPS (vector) or TIFF 300+ DPI (raster)
- **PowerPoint**: EMF or high-quality PNG with transparency
- **Web**: SVG (vector) or PNG (raster)

**Demonstration Activity:**
Show same figure saved as:
1. JPG (low quality, compressed)
2. PNG (lossless, appropriate DPI)
3. PDF (vector)
Then zoom in 400% to show differences.

---

## 2. Color Gradients: The Rainbow Problem

### Why Rainbow Color Scales Are Problematic

**The "Rainbow Test":**
*Interactive Activity*: Display a rainbow color scale and ask audience to:
1. Sort the colors from lowest to highest value
2. Identify where exactly 0.5 falls on the scale

**Why this fails:**
- Non-perceptually uniform (yellow appears "brighter" than blue)
- Creates false boundaries/edges where none exist in data
- Culturally biased color associations (red=hot, blue=cold)
- Perceptual brightness varies: yellow pops, dark blue recedes

### The Accessibility Issue: Color Blindness

**Statistics:**
- ~8% of men, ~0.5% of women have color vision deficiency
- Most common: red-green color blindness (deuteranopia/protanopia)

**Common Failures:**
- Red-green heatmaps (classic offender)
- Multi-line plots using only red/green/brown for distinction
- Traffic light color schemes (red/yellow/green)

### Testing Your Figures:
- Convert to grayscale - can you still distinguish categories?
- Use colorblind simulation tools (coblis.org, ColorOracle)
- Print on black & white printer - does information persist?

### Recommended Color Palettes

**For Sequential Data (low to high):**
- **Viridis** (perceptually uniform, colorblind-friendly, prints well in grayscale)
- **ColorBrewer Sequential** (Blues, Greens, Purples single hue)

**For Diverging Data (negative to positive):**
- **ColorBrewer Diverging** (RdBu, BrBG, PiYG)
- Center = neutral/zero, extremes = contrasting hues

**For Categorical Data:**
- **ColorBrewer Qualitative** (Set1, Set2, Paired)
- Maximum 8-10 distinguishable categories
- Beyond that: use shapes, line types, faceting

**R Implementation:**
```r
# Viridis family
scale_color_viridis_c()  # continuous
scale_color_viridis_d()  # discrete

# ColorBrewer
scale_color_brewer(palette = "Set1")  # categorical
scale_color_brewer(palette = "YlOrRd")  # sequential
scale_color_distiller(palette = "RdBu")  # diverging for continuous
```

---

## 3. ggplot2 Themes: Professional Polish

### Default Theme Problems

**Common Issues with theme_gray() (ggplot2 default):**
- Gray background wastes ink, unprofessional for publications
- Grid lines can interfere with data
- Excessive chart junk

### Publication-Ready Themes

```r
# Built-in clean themes
theme_bw()          # White background, black border
theme_classic()     # No gridlines, classic look
theme_minimal()     # Clean, modern, subtle gridlines
theme_void()        # Completely blank canvas

# Specialized theme packages
library(ggthemes)
theme_few()         # Based on Stephen Few's principles
theme_tufte()       # Edward Tufte's minimalist style
theme_economist()   # The Economist magazine style

library(hrbrthemes)
theme_ipsum()       # Modern, professional typography
```

### Consistent Theming Across Project

```r
# Set default theme for all plots in session
theme_set(theme_bw(base_size = 12))

# Create custom theme
my_pub_theme <- theme_classic() +
  theme(
    axis.line = element_line(linewidth = 0.5),
    axis.ticks = element_line(linewidth = 0.5),
    text = element_text(family = "Arial", size = 11),
    plot.title = element_text(face = "bold")
  )
```

---

## 4. Heatmap Pitfalls: Scaling and Outliers

### The Outlier Problem

**Scenario:**
You have gene expression data: 99% of values between -2 and +2, but one gene has value of +20.

**What happens with default scaling:**
- Color scale spans -20 to +20
- 99% of your data compressed into narrow color range
- Entire heatmap appears uniform gray/single color
- Real biological signal is invisible

### Solutions

**1. Standard Deviation Cutoffs**
```r
# Cap extreme values at ±2 or ±3 SD
heatmap_data <- data %>%
  mutate(across(where(is.numeric), ~pmin(pmax(., -2*sd(.)), 2*sd(.))))
```

**2. Quantile-based Scaling**
```r
# Cap at 5th and 95th percentiles
lower <- quantile(data, 0.05)
upper <- quantile(data, 0.95)
data_capped <- pmin(pmax(data, lower), upper)
```

**3. Separate Outlier Annotation**
- Use asterisks or symbols to mark capped values
- Include note: "Values capped at ±2 SD"

**4. Log Transformation (for positive values)**
```r
scale_fill_gradient(trans = "log10")
```

### Color Scale Considerations
- Always include color scale bar with actual numbers
- Consider if zero should be a specific color (diverging scales)
- Label extremes if capped: "<-2" or ">+2"

---

## 5. Text Sizing: The Zoom Fallacy

### The Common Mistake

**Wrong Approach:**
1. Create plot with default sizes
2. Realize text is too small in final layout
3. Zoom/resize entire image larger
4. Result: Huge points/lines, barely larger text, distorted proportions

**Correct Approach:**
Set text sizes explicitly based on final output dimensions

### The Math of Sizing

**Key Principle:** Set physical output size first, then adjust text

```r
# Bad: resize at end
p <- ggplot(data, aes(x, y)) + geom_point()
ggsave("plot.pdf", p, width = 10, height = 8)  # Then manually resize

# Good: set sizes for target dimensions
p <- ggplot(data, aes(x, y)) +
  geom_point(size = 3) +
  theme_classic(base_size = 14) +  # Readable at this size
  theme(
    axis.title = element_text(size = 16),
    axis.text = element_text(size = 12),
    legend.text = element_text(size = 12)
  )

ggsave("plot.pdf", p, width = 6, height = 4, units = "in")
```

### Journal Requirements
- Most journals specify figure dimensions (e.g., single column = 3.5", double = 7")
- Minimum readable font size: 6-8 pt in final printed size
- Design at final size, not larger

### Testing Readability
1. Print at actual size (not "fit to page")
2. View PDF at 100% zoom
3. Can you read axis labels comfortably?

---

## 6. Saving Plots in R: The Right Way

### The Device System in R

**Graphics Devices:**
Every plot needs a "device" - where R sends the graphical output

```r
# Opening devices manually
pdf("plot.pdf", width = 7, height = 5)
  plot(x, y)
dev.off()  # Critical! Close the device

# Problem: easy to forget dev.off()
# Solution: use ggsave() for ggplot2
```

### ggsave(): The Modern Approach

```r
p <- ggplot(data, aes(x, y)) + geom_point()

# Simplest form (saves last plot)
ggsave("myplot.pdf")

# Full control
ggsave(
  filename = "myplot.pdf",
  plot = p,
  width = 6,
  height = 4,
  units = "in",  # or "cm", "mm"
  dpi = 300,     # for raster formats
  device = "pdf" # or "png", "svg", etc.
)
```

### Format-Specific Considerations

**PDF (vector):**
```r
ggsave("plot.pdf", width = 7, height = 5, device = cairo_pdf)
# cairo_pdf gives better font embedding and Unicode support
```

**PNG (high resolution):**
```r
ggsave("plot.png", width = 7, height = 5, dpi = 300, type = "cairo")
# Results in 2100 × 1500 pixel image (7×300 by 5×300)
```

**TIFF (for some journals):**
```r
ggsave("plot.tiff", width = 7, height = 5, dpi = 600, compression = "lzw")
```

### Converting PDF to High-Res PNG

**Why you might need this:**
- PDF for print, PNG for web/presentations
- Keep vector source, generate raster as needed

**Using ImageMagick (command line):**
```bash
# Convert PDF to 300 DPI PNG
convert -density 300 plot.pdf -quality 100 plot.png

# With antialiasing for smoother appearance
convert -density 300 -quality 100 -alpha remove plot.pdf plot.png
```

**Using R packages:**
```r
library(pdftools)
pdf_convert("plot.pdf", format = "png", dpi = 300)

# Or with magick
library(magick)
image_read_pdf("plot.pdf", density = 300) %>%
  image_write("plot.png", format = "png")
```

---

## 7. Post-Export Editing: Illustrator and Inkscape

### Why Edit After Export?

**Legitimate uses:**
- Combine multiple plots into multi-panel figures (A, B, C labels)
- Fine-tune alignment and spacing
- Add annotations or arrows
- Adjust specific elements without re-running analysis

### Vector Editing Tools

**Adobe Illustrator (Commercial):**
- Industry standard
- Best PDF/EPS import
- Precise typography control

**Inkscape (Free/Open Source):**
- Excellent alternative to Illustrator
- Native SVG format
- Cross-platform
- Some limitations with PDF import (use SVG from R)

### Best Practices for Editable Exports

```r
# Export as SVG for maximum editability in Inkscape
ggsave("plot.svg", width = 7, height = 5)

# For Illustrator, PDF with fonts embedded
ggsave("plot.pdf", width = 7, height = 5, device = cairo_pdf)
```

### Common Editing Tasks

**Adding panel labels:**
- Use consistent font, size, position
- Typical: Bold, 14-16 pt, Arial or Helvetica
- Position: top-left of each panel

**Aligning multiple plots:**
- Use alignment guides
- Ensure consistent spacing
- Match axis widths across stacked plots

**What NOT to edit:**
- Data points themselves (always regenerate from R)
- Axis scales (do this in R code)
- Statistical elements (error bars, fit lines)

### Maintaining Reproducibility

**The Golden Rule:** Keep your R scripts as source of truth

```r
# Document your workflow
# 1_analysis.R          → generates raw plots
# 2_export_figures.R    → standardized export
# 3_illustrator_edits.ai → final touch-ups (manual)
# README.txt            → documents what was edited manually
```

---

## 8. Importing into PowerPoint: Vector vs. Raster

### The Problem with Copy-Paste

**What happens when you copy from RStudio/R:**
- Usually pastes as low-resolution bitmap
- Looks fine on screen (72 DPI)
- Pixelated when projected or printed
- Doesn't scale well if you resize

### Vector Formats for PowerPoint

**Best Options:**

1. **EMF (Enhanced Metafile) - Windows recommended**
```r
# Best for PowerPoint on Windows
ggsave("plot.emf", width = 8, height = 6, device = "emf")
```
- Native PowerPoint vector format
- Fully editable in PowerPoint (can change colors, ungroup, etc.)
- Windows-specific

2. **PDF (Cross-platform)**
```r
ggsave("plot.pdf", width = 8, height = 6, device = cairo_pdf)
```
- Insert → Object → Create from File → PDF
- Maintains vector quality
- Less editable than EMF

3. **SVG (Modern PowerPoint)**
- PowerPoint 2016+ supports SVG
- Insert → Pictures → select .svg file
- Cross-platform, maintains quality

### High-Resolution Raster Alternative

**If you must use PNG:**
```r
# Create at 2-3x display size with high DPI
ggsave("plot.png", width = 10, height = 7, dpi = 300, type = "cairo")
```

**PowerPoint insertion:**
- Insert → Pictures
- **Critical:** Right-click image → Format Picture → Size
- Uncheck "Lock aspect ratio" is NOT selected
- Verify "Relative to original picture size" is checked

### Testing Your Figures

1. Zoom to 200-400% in PowerPoint
2. Are edges still crisp? → Vector format working
3. Are edges pixelated? → Raster/low-res

---

## 9. Rendering Issues: What You See Isn't Always What You Get

### The PDF Preview Problem

**Scenario:**
You create a plot with thin lines and many points. In RStudio or PDF viewer, it looks wrong:
- Lines disappear
- Points overlap strangely
- Colors look off
- Borders appear jagged

**But when printed or opened in Illustrator: it's perfect!**

### Why This Happens

**Rendering vs. Actual Content:**
- PDF contains exact mathematical instructions
- Viewer software approximates for screen display
- Different viewers = different rendering
- Print engines more accurate than screen display

### Common Rendering Issues

**1. Thin Lines Disappearing**
```r
# Lines < 0.5 pt may not render on screen
geom_line(linewidth = 0.3)  # May look broken in viewer

# Solution: 0.5+ pt for visibility
geom_line(linewidth = 0.5)
```

**2. Overlapping Transparency**
```r
# Many semi-transparent points can render slowly/incorrectly
geom_point(alpha = 0.3, size = 2)

# May appear as solid blob in some viewers
# but print correctly
```

**3. Font Substitution**
- Viewer doesn't have specified font
- Substitutes different font
- Spacing/alignment looks wrong
- **Solution:** Embed fonts with cairo_pdf device

### Testing Recommendations

1. **Test in multiple viewers:**
   - Adobe Acrobat (most accurate)
   - Preview (Mac) or PDF-XChange (Windows)
   - Web browsers
   - Your target journal's submission system

2. **Always check print preview**

3. **When in doubt, trust the print/Acrobat rendering**

### Communication Tip

When sharing drafts: "If it looks odd on screen, please check print preview or open in Acrobat Reader"

---

## 10. Interactive Plots with plotly/ggplotly

### The Appeal of Interactive Figures

**Advantages:**
- Hover for exact values
- Zoom and pan
- Toggle traces on/off
- Great for exploratory analysis and presentations
- Excellent for HTML reports/websites

### Creating Interactive Plots

```r
library(plotly)

# Convert ggplot to interactive
p <- ggplot(data, aes(x, y, color = group)) +
  geom_point()

ggplotly(p)

# Build plotly directly for more control
plot_ly(data, x = ~x, y = ~y, color = ~group, type = 'scatter', mode = 'markers')
```

### The Saving Problem

**Issue:** Interactive plots are HTML widgets, not static images

**Solutions:**

**1. Save as HTML (preserves interactivity)**
```r
library(htmlwidgets)

p <- ggplotly(myplot)
saveWidget(p, "interactive_plot.html", selfcontained = TRUE)

# selfcontained = TRUE bundles all dependencies
# Can email or put on website
```

**2. Save static snapshot (loses interactivity)**
```r
# Requires additional installation (orca or kaleido)
library(plotly)

# Using kaleido (newer, recommended)
save_image(p, "plot.png", width = 800, height = 600)
save_image(p, "plot.pdf")
```

**Installation (command line):**
```bash
# For kaleido
pip install kaleido
```

**3. Screenshot for quick sharing**
- Many plotly viewers have camera icon
- Downloads PNG
- Quick but not reproducible

### When to Use Interactive vs. Static

**Use Interactive:**
- HTML reports (R Markdown, Quarto)
- Lab meetings / group presentations
- Exploratory data analysis
- Supplementary materials for papers

**Use Static:**
- Journal publications (required)
- Print posters
- PowerPoint presentations (more reliable)
- Any non-digital format

### Hybrid Approach

```r
# Create both versions
p_static <- ggplot(data, aes(x, y)) + geom_point()
p_interactive <- ggplotly(p_static)

# Save static for publication
ggsave("figure1.pdf", p_static, width = 7, height = 5)

# Save interactive for supplement
saveWidget(p_interactive, "figure1_interactive.html")
```

---

## 11. Factor Ordering: Taking Control of Your Categories

### The Default Alphabetical Problem

**R's default behavior:**
```r
categories <- c("High", "Medium", "Low", "Very High")
factor(categories)
# Levels: High Low Medium Very High
# Alphabetical! Not meaningful!
```

**Result in plots:**
- Bar charts with illogical ordering
- Legend entries that don't match your mental model
- Line plots with colors assigned randomly
- Facets in wrong order

### Solutions: Controlling Factor Order

**1. Manual Ordering**
```r
# Specify levels explicitly
data$category <- factor(data$category,
                       levels = c("Low", "Medium", "High", "Very High"))
```

**2. Ordering by Another Variable**
```r
library(forcats)

# Order by median value
data %>%
  mutate(group = fct_reorder(group, value, .fun = median))

# Order by frequency
data %>%
  mutate(category = fct_infreq(category))

# Reverse order
data %>%
  mutate(category = fct_rev(category))
```

**3. Common Use Cases**

**Ordered bar chart:**
```r
# Order bars by height
ggplot(data, aes(x = fct_reorder(name, value), y = value)) +
  geom_col() +
  coord_flip()  # Horizontal bars, easy to read labels
```

**Logical ordering in boxplots:**
```r
# Order boxplots by median
ggplot(data, aes(x = fct_reorder(treatment, response, median),
                 y = response)) +
  geom_boxplot()
```

**Time-based ordering:**
```r
months <- c("Jan", "Feb", "Mar", "Apr", "May", "Jun",
            "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")

data$month <- factor(data$month, levels = months)
```

**Legend ordering:**
```r
# forcats functions work for colors/legends too
ggplot(data, aes(x = x, y = y, color = fct_reorder(group, y, max))) +
  geom_line()
# Legend now ordered by maximum y value of each group
```

### The forcats Package Cheatsheet

```r
library(forcats)

fct_reorder()    # Reorder by another variable
fct_infreq()     # Order by frequency (most common first)
fct_rev()        # Reverse current order
fct_relevel()    # Move specific levels to front
fct_recode()     # Rename levels
fct_lump()       # Combine rare levels into "Other"
fct_explicit_na() # Make NA a visible level
```

### Visual Impact

**Before (alphabetical):**
```
Control | Treatment A | Treatment B | Treatment C
```

**After (logical order):**
```
Control | Treatment A | Treatment B | Treatment C
```

Or by effect size:
```
Treatment B | Control | Treatment C | Treatment A
```

---

## Summary: Figure Checklist for Publications

Before submitting a figure, verify:

**Format & Resolution:**
- [ ] Vector format (PDF/EPS) for line plots, diagrams
- [ ] If raster: ≥300 DPI at final size
- [ ] Correct dimensions for journal (single/double column)
- [ ] File size reasonable (<10 MB for most journals)

**Colors & Accessibility:**
- [ ] No rainbow color scales
- [ ] Colorblind-friendly palette (test with simulator)
- [ ] Distinguishable in grayscale
- [ ] Color scale bar with values (for heatmaps)

**Text & Sizing:**
- [ ] All text readable at final printed size (≥6-8 pt)
- [ ] Font sizes set explicitly, not by resizing image
- [ ] Axis labels, legends, titles all visible
- [ ] Consistent font family across figures

**Technical Quality:**
- [ ] Professional theme (not default gray)
- [ ] Heatmap scaling handles outliers appropriately
- [ ] Factor levels in logical order
- [ ] Saved with appropriate device (ggsave or cairo_pdf)
- [ ] Rendered correctly in print preview

**Reproducibility:**
- [ ] R script generates figure from raw data
- [ ] No manual edits to data in Illustrator
- [ ] Any post-processing documented
- [ ] Version control for code

---

## Additional Resources

**Color Palettes:**
- ColorBrewer: colorbrewer2.org
- Viridis documentation: cran.r-project.org/web/packages/viridis
- Colorblind simulator: coblis.org, colororacle.org

**R Packages:**
- ggplot2: ggplot2.tidyverse.org
- forcats: forcats.tidyverse.org
- patchwork: patchwork.data-imaginist.com (combining plots)
- cowplot: wilkelab.org/cowplot (publication-ready figures)

**Books:**
- "Fundamentals of Data Visualization" by Claus Wilke (free online)
- "ggplot2: Elegant Graphics for Data Analysis" by Hadley Wickham

**Tools:**
- Inkscape: inkscape.org
- ImageMagick: imagemagick.org
- GIMP: gimp.org (raster editing)

**Journal Guidelines:**
- Always check specific journal's author guidelines
- Common: Nature, Science, Cell, PLOS have detailed figure specs online
