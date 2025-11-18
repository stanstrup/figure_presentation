# Academic Figures: Common Pitfalls and Best Practices

A Quarto RevealJS presentation about common pitfalls in creating academic figures using R.

## Viewing the Presentation

The presentation is automatically built and deployed to GitLab Pages on every commit to the main branch.

**Live Presentation:** `https://<your-namespace>.gitlab.io/<your-project>/`

## Local Development

### Prerequisites

- [Quarto](https://quarto.org/) (v1.4 or later)
- R (v4.0 or later)
- Required R packages:
  - ggplot2
  - patchwork
  - magick
  - glue
  - viridis

### Rendering Locally

```bash
# Render the presentation
quarto render presentation.qmd

# Preview while developing
quarto preview presentation.qmd
```

## Structure

- `presentation.qmd` - Main presentation file
- `topics/*.qmd` - Individual topic sections (modular structure)
- `plots/` - Generated plots (auto-created during rendering)
- `sources/` - Static source images
- `custom.css` - Custom styling

## Topics Covered

1. File Formats (Vector vs Raster)
2. Color Gradients
3. Themes & Styling
4. Heatmap Scaling
5. Text Sizing
6. Saving Plots
7. Post-Processing
8. PowerPoint Import
9. Rendering Issues
10. Interactive Plots
11. Factor Ordering

## CI/CD

This project uses GitLab CI/CD to automatically build and deploy the presentation:

- **Build**: Renders the Quarto presentation
- **Deploy**: Publishes to GitLab Pages
- **Trigger**: Commits to `main` or `master` branch

See `.gitlab-ci.yml` for configuration details.

## License

[Add your license here]
