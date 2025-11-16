# Render Academic Figures Presentation
# This script helps you render the presentation and debug individual topics

# Install quarto package if needed
if (!require("quarto", quietly = TRUE)) {
  install.packages("quarto")
}

library(quarto)

# ============================================================
# Option 1: Render the full presentation
# ============================================================
render_presentation <- function() {
  cat("Rendering full presentation...\n")
  quarto_render("presentation.qmd")
  cat("✓ Done! Open presentation.html to view\n")
}

# ============================================================
# Option 2: Test a single topic
# ============================================================
render_topic <- function(topic_number) {
  topic_file <- sprintf("topics/%02d_*.qmd", topic_number)
  topic_files <- list.files("topics", pattern = sprintf("^%02d_", topic_number), full.names = TRUE)

  if (length(topic_files) == 0) {
    cat("❌ Topic", topic_number, "not found\n")
    return(FALSE)
  }

  topic_file <- topic_files[1]
  cat("Rendering", basename(topic_file), "...\n")

  tryCatch({
    quarto_render(topic_file)
    cat("✓", basename(topic_file), "rendered successfully\n")
    return(TRUE)
  }, error = function(e) {
    cat("❌ ERROR in", basename(topic_file), ":\n")
    cat(conditionMessage(e), "\n")
    return(FALSE)
  })
}

# ============================================================
# Option 3: Test ALL topics (find which ones fail)
# ============================================================
test_all_topics <- function() {
  topic_files <- list.files("topics", pattern = "\\.qmd$", full.names = TRUE)
  topic_files <- sort(topic_files)  # Alphabetical order

  results <- data.frame(
    topic = basename(topic_files),
    status = character(length(topic_files)),
    stringsAsFactors = FALSE
  )

  cat("Testing", length(topic_files), "topics...\n")
  cat(strrep("=", 60), "\n")

  for (i in seq_along(topic_files)) {
    topic_file <- topic_files[i]
    topic_name <- basename(topic_file)

    cat(sprintf("[%d/%d] Testing %s ... ", i, length(topic_files), topic_name))

    tryCatch({
      quarto_render(topic_file)
      cat("✓ PASS\n")
      results$status[i] <- "PASS"
    }, error = function(e) {
      cat("❌ FAIL\n")
      cat("    Error:", conditionMessage(e), "\n")
      results$status[i] <- "FAIL"
    })
  }

  cat(strrep("=", 60), "\n")
  cat("Summary:\n")
  print(results)

  n_pass <- sum(results$status == "PASS")
  n_fail <- sum(results$status == "FAIL")

  cat("\nResults:", n_pass, "passed,", n_fail, "failed\n")

  if (n_fail > 0) {
    cat("\nFailed topics:\n")
    print(results[results$status == "FAIL", ])
  }

  return(results)
}

# ============================================================
# Option 4: Preview presentation (opens in browser)
# ============================================================
preview_presentation <- function() {
  cat("Starting preview server...\n")
  cat("Press Ctrl+C to stop\n")
  quarto_preview("presentation.qmd")
}

# ============================================================
# Quick helper functions
# ============================================================

# Render just the color topic (topic 2)
test_colors <- function() render_topic(2)

# Render just the heatmap topic (topic 4)
test_heatmaps <- function() render_topic(4)

# Render just the factors topic (topic 11)
test_factors <- function() render_topic(11)

# ============================================================
# USAGE EXAMPLES
# ============================================================

cat("
========================================
Academic Figures Presentation Renderer
========================================

Available commands:

1. Render full presentation:
   render_presentation()

2. Test a single topic (by number):
   render_topic(2)        # Test topic 02_colors.qmd
   test_colors()          # Shortcut for topic 2
   test_heatmaps()        # Shortcut for topic 4
   test_factors()         # Shortcut for topic 11

3. Test all topics (find errors):
   results <- test_all_topics()

4. Preview presentation (live reload):
   preview_presentation()

5. Install required R packages:
   install.packages(c('ggplot2', 'patchwork', 'viridis',
                      'RColorBrewer', 'dplyr', 'forcats'))

Example workflow:
  # First, test all topics to find errors
  results <- test_all_topics()

  # Fix any errors, then test specific topic
  render_topic(2)

  # When all pass, render full presentation
  render_presentation()

========================================
")
