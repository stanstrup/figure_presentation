# Example Usage of render.R
# This file demonstrates how to use the rendering functions

# Load the rendering functions
source("render.R")

# ============================================================
# RECOMMENDED WORKFLOW
# ============================================================

# Step 1: Install packages (first time only)
# source("install_packages.R")

# Step 2: Test all topics sequentially to see where it fails
cat("Testing all topics sequentially...\n")
cat("This will show you EXACTLY which topic fails:\n\n")

results <- test_all_topics()

# The output will look like this:
# [1/11] Testing 01_formats.qmd ... ✓ PASS
# [2/11] Testing 02_colors.qmd ... ✓ PASS
# [3/11] Testing 03_themes.qmd ... ❌ FAIL
#     Error: object 'xyz' not found
# [4/11] Testing 04_heatmaps.qmd ... ✓ PASS
# ... etc

# Step 3: Fix the failing topic, then test it individually
cat("\nNow test just the failing topic:\n")
render_topic(3)  # Test topic 03 that failed

# Step 4: Once all pass, test in parallel (faster)
cat("\nTest all topics in parallel:\n")
results_parallel <- test_all_topics_parallel()

# Step 5: Render full presentation
cat("\nRender the complete presentation:\n")
render_presentation()

# ============================================================
# OTHER USEFUL COMMANDS
# ============================================================

# Test specific topics
test_colors()      # Test just the colors topic
test_heatmaps()    # Test just heatmaps
test_factors()     # Test just factors

# Preview with live reload (opens in browser)
# preview_presentation()  # Uncomment to run

# Test with specific number of cores
# test_all_topics_parallel(n_cores = 2)
