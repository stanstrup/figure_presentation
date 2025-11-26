# Custom Docker image with all R packages pre-installed for figure_presentation
FROM rocker/tidyverse:4.5

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libmagick++-dev \
    librsvg2-dev \
    cmake \
    && rm -rf /var/lib/apt/lists/*

# Configure RSPM for binary packages (faster installation)
RUN echo "options(repos = c(RSPM = 'https://packagemanager.posit.co/cran/__linux__/jammy/latest', CRAN = 'https://cloud.r-project.org'))" >> /usr/local/lib/R/etc/Rprofile.site

# Copy package installation script
COPY .github/workflows/install_packages.R /tmp/install_packages.R

# Install all R packages
RUN Rscript /tmp/install_packages.R

# Clean up
RUN rm /tmp/install_packages.R

# Set working directory
WORKDIR /workspace

# Document what this image contains
LABEL org.opencontainers.image.description="Pre-built R environment for Academic Figures presentation with ggplot2, viridis, pheatmap, plotly, and all dependencies"
LABEL org.opencontainers.image.source="https://github.com/stanstrup/figure_presentation"
