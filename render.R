# Render Academic Figures Presentation
# This script helps you render the presentation and debug individual topics

# Install quarto package if needed
if (!require("quarto", quietly = TRUE)) {
  install.packages("quarto")
}

library(quarto)

# ============================================================
# Option 1: Render the full presentation (slides)
# ============================================================
render_presentation <- function(cleanup = TRUE) {
  cat("Rendering full presentation (slides)...\n")
  quarto_render("slides/presentation.qmd")

  # Copy sources and custom.css to public/
  if (!dir.exists("public/sources")) {
    dir.create("public/sources", recursive = TRUE, showWarnings = FALSE)
  }
  file.copy("sources/", "public/", recursive = TRUE, overwrite = TRUE)
  if (file.exists("custom.css")) {
    file.copy("custom.css", "public/custom.css", overwrite = TRUE)
  }

  if (cleanup) {
    cat("Cleaning up render artifacts...\n")
    unlink("slides/plots", recursive = TRUE)
    unlink("slides/presentation_files", recursive = TRUE)
    if (file.exists("slides/presentation.revealjs.md")) {
      file.remove("slides/presentation.revealjs.md")
    }
  }

  cat("✓ Done! Open public/slides/presentation.html to view\n")
}

# ============================================================
# Option 1b: Render the book
# ============================================================
render_book <- function(cleanup = TRUE) {
  cat("Rendering book...\n")
  quarto_render("book")

  # Copy book output to public/ root
  cat("Copying book output to public/...\n")
  if (dir.exists("public")) unlink("public", recursive = TRUE)
  dir.create("public", showWarnings = FALSE)
  book_files <- list.files("book/_book", full.names = TRUE, all.files = TRUE, no.. = TRUE)
  file.copy(book_files, "public/", recursive = TRUE, overwrite = TRUE)

  # Copy sources and custom.css to public/
  file.copy("sources/", "public/", recursive = TRUE, overwrite = TRUE)
  if (file.exists("custom.css")) {
    file.copy("custom.css", "public/custom.css", overwrite = TRUE)
  }

  if (cleanup) {
    cat("Cleaning up render artifacts...\n")
    unlink("book/_book", recursive = TRUE)
    unlink("book/topics/plots", recursive = TRUE)
    unlink("book/plots", recursive = TRUE)
    # Clean up any *_files directories in book root
    book_files_dirs <- list.files("book", pattern = "_files$", full.names = TRUE)
    for (d in book_files_dirs) {
      unlink(d, recursive = TRUE)
    }
  }

  cat("✓ Done! Open public/index.html to view\n")
}

# ============================================================
# Option 1c: Render both presentation and book
# ============================================================
render_all <- function(parallel = TRUE, cleanup = TRUE) {
  cat("Rendering both presentation and book...\n")
  cat(strrep("=", 60), "\n")

  if (!parallel) {
    # Clean public directory first (sequential mode)
    if (dir.exists("public")) unlink("public", recursive = TRUE)
    dir.create("public", showWarnings = FALSE)
    dir.create("public/slides", showWarnings = FALSE)
    cat("\n[1/2] Rendering presentation (slides)...\n")
    quarto_render("slides/presentation.qmd")
    cat("✓ Presentation complete\n")

    cat("\n[2/2] Rendering book...\n")
    quarto_render("book")
    cat("✓ Book complete\n")

    # Copy book output to public/ root
    cat("Organizing output to public/...\n")
    book_files <- list.files("book/_book", full.names = TRUE, all.files = TRUE, no.. = TRUE)
    file.copy(book_files, "public/", recursive = TRUE, overwrite = TRUE)
  } else {
    # Parallel mode - do NOT touch public directory yet
    # Let each render go to its default location first
    cat("\nRendering in PARALLEL using 2 cores...\n\n")
    start_time <- Sys.time()

    render_one <- function(target, working_dir) {
      tryCatch({
        # Set working directory in the worker
        setwd(working_dir)

        # Create unique temp directory for this worker to avoid conflicts
        temp_base <- tempdir()
        unique_temp <- file.path(temp_base, paste0("quarto_", target, "_", Sys.getpid()))
        dir.create(unique_temp, showWarnings = FALSE, recursive = TRUE)
        Sys.setenv(TMPDIR = unique_temp)
        Sys.setenv(TEMP = unique_temp)
        Sys.setenv(TMP = unique_temp)

        if (target == "presentation") {
          quarto::quarto_render("slides/presentation.qmd", quiet = FALSE)
          return(list(target = "Presentation (slides)", status = "PASS", error = NULL))
        } else {
          quarto::quarto_render("book", quiet = FALSE)
          return(list(target = "Book", status = "PASS", error = NULL))
        }
      }, error = function(e) {
        full_error <- paste(conditionMessage(e), "\n",
                           paste(capture.output(traceback()), collapse = "\n"))
        return(list(target = target, status = "FAIL", error = full_error))
      })
    }

    targets <- c("presentation", "book")
    current_dir <- getwd()

    if (.Platform$OS.type == "windows") {
      cl <- parallel::makeCluster(2, outfile = "")

      # Get critical environment variables
      r_home <- Sys.getenv("R_HOME")
      path_var <- Sys.getenv("PATH")

      parallel::clusterExport(cl, c("render_one", "current_dir", "r_home", "path_var"),
                             envir = environment())

      # Set up environment in each worker
      parallel::clusterEvalQ(cl, {
        library(quarto)
        # Ensure R_HOME and PATH are set
        if (nchar(r_home) > 0) Sys.setenv(R_HOME = r_home)
        if (nchar(path_var) > 0) Sys.setenv(PATH = path_var)
      })

      results_list <- parallel::parLapply(cl, targets, render_one, working_dir = current_dir)
      parallel::stopCluster(cl)
    } else {
      results_list <- parallel::mclapply(targets, render_one,
                                         working_dir = current_dir,
                                         mc.cores = 2)
    }

    end_time <- Sys.time()
    elapsed <- round(as.numeric(difftime(end_time, start_time, units = "secs")), 2)

    cat("Results:\n")
    cat(strrep("-", 60), "\n")
    for (result in results_list) {
      symbol <- if (result$status == "PASS") "✓" else "❌"
      cat(sprintf("%s %-40s %s\n", symbol, result$target, result$status))
      if (!is.null(result$error)) cat("  Error:", result$error, "\n")
    }
    cat(strrep("-", 60), "\n")
    cat(sprintf("Completed in %.2f seconds\n", elapsed))

    failed <- sapply(results_list, function(r) r$status == "FAIL")
    if (any(failed)) {
      cat("\n❌ Some renders failed!\n")
      return(invisible(FALSE))
    }

    # Now organize output to public/ (after both renders complete)
    cat("\nOrganizing output to public/...\n")

    # Save slides output temporarily (it rendered to public/slides)
    temp_slides <- tempdir()
    if (dir.exists("public/slides")) {
      file.copy("public/slides", temp_slides, recursive = TRUE)
    }

    # Clean and create public directory
    if (dir.exists("public")) unlink("public", recursive = TRUE)
    dir.create("public", showWarnings = FALSE)

    # Copy book output to public/ root
    book_files <- list.files("book/_book", full.names = TRUE, all.files = TRUE, no.. = TRUE)
    file.copy(book_files, "public/", recursive = TRUE, overwrite = TRUE)

    # Restore slides output
    if (dir.exists(file.path(temp_slides, "slides"))) {
      file.copy(file.path(temp_slides, "slides"), "public/", recursive = TRUE)
      unlink(file.path(temp_slides, "slides"), recursive = TRUE)
    }
  }

  # Copy sources and custom.css to public/
  cat("Copying sources and assets to public/...\n")
  file.copy("sources/", "public/", recursive = TRUE, overwrite = TRUE)
  if (file.exists("custom.css")) {
    file.copy("custom.css", "public/custom.css", overwrite = TRUE)
  }

  if (cleanup) {
    cat("Cleaning up render artifacts...\n")
    unlink("book/_book", recursive = TRUE)
    unlink("book/topics/plots", recursive = TRUE)
    unlink("book/plots", recursive = TRUE)
    # Clean up any *_files directories in book root
    book_files_dirs <- list.files("book", pattern = "_files$", full.names = TRUE)
    for (d in book_files_dirs) {
      unlink(d, recursive = TRUE)
    }
    unlink("slides/plots", recursive = TRUE)
    unlink("slides/presentation_files", recursive = TRUE)
    if (file.exists("slides/presentation.revealjs.md")) {
      file.remove("slides/presentation.revealjs.md")
    }
  }

  cat(strrep("=", 60), "\n")
  cat("✓ All done!\n")
  cat("  - Slides: public/slides/presentation.html\n")
  cat("  - Book:   public/index.html\n")
  return(invisible(TRUE))
}

# ============================================================
# Option 2: Test a single topic
# ============================================================
render_topic <- function(topic_number, as_slides = TRUE) {
  # Topics are in book/topics/ directory
  topic_files <- list.files("book/topics", pattern = sprintf("^%02d_.*\\.qmd$", topic_number), full.names = TRUE)

  if (length(topic_files) == 0) {
    cat("❌ Topic", topic_number, "not found in book/topics/\n")
    return(FALSE)
  }

  topic_file <- topic_files[1]
  cat("Rendering", basename(topic_file), "...\n")

  tryCatch({
    if (as_slides) {
      # Render as revealjs slides
      quarto_render(topic_file, output_format = "revealjs")
    } else {
      # Render as HTML document (default)
      quarto_render(topic_file)
    }
    cat("✓", basename(topic_file), "rendered successfully\n")
    return(TRUE)
  }, error = function(e) {
    cat("❌ ERROR in", basename(topic_file), ":\n")
    cat(conditionMessage(e), "\n")
    return(FALSE)
  })
}

# ============================================================
# Option 3: Test ALL topics in PARALLEL (FASTER!)
# ============================================================
test_all_topics_parallel <- function(n_cores = NULL) {
  topic_files <- list.files("book/topics", pattern = "\\.qmd$", full.names = TRUE)
  topic_files <- sort(topic_files)

  # Determine number of cores
  if (is.null(n_cores)) {
    n_cores <- max(1, parallel::detectCores() - 1)  # Leave one core free
  }
  n_cores <- min(n_cores, length(topic_files))

  cat("Testing", length(topic_files), "topics in PARALLEL using", n_cores, "cores...\n")
  cat(strrep("=", 60), "\n\n")

  start_time <- Sys.time()

  # Helper function to render one topic
  render_one <- function(topic_file) {
    tryCatch({
      quarto::quarto_render(topic_file, quiet = TRUE)
      return(list(file = topic_file, status = "PASS", error = NULL))
    }, error = function(e) {
      return(list(file = topic_file, status = "FAIL", error = conditionMessage(e)))
    })
  }

  # Render in parallel
  if (.Platform$OS.type == "windows") {
    # Windows: use PSOCK cluster
    cl <- parallel::makeCluster(n_cores)
    parallel::clusterExport(cl, "render_one", envir = environment())
    parallel::clusterEvalQ(cl, library(quarto))
    results_list <- parallel::parLapply(cl, topic_files, render_one)
    parallel::stopCluster(cl)
  } else {
    # Unix/Mac: use fork
    results_list <- parallel::mclapply(topic_files, render_one, mc.cores = n_cores)
  }

  end_time <- Sys.time()
  elapsed <- round(as.numeric(difftime(end_time, start_time, units = "secs")), 2)

  # Convert to data frame
  results <- do.call(rbind, lapply(results_list, function(r) {
    data.frame(
      topic = basename(r$file),
      status = r$status,
      error = ifelse(is.null(r$error), "", r$error),
      stringsAsFactors = FALSE
    )
  }))

  # Print results
  cat("Results:\n")
  cat(strrep("-", 60), "\n")
  for (i in seq_len(nrow(results))) {
    symbol <- if (results$status[i] == "PASS") "✓" else "❌"
    cat(sprintf("%s %-40s %s\n", symbol, results$topic[i], results$status[i]))
  }

  cat(strrep("=", 60), "\n")
  n_pass <- sum(results$status == "PASS")
  n_fail <- sum(results$status == "FAIL")

  cat(sprintf("Results: %d passed, %d failed (%.2f seconds)\n", n_pass, n_fail, elapsed))

  if (n_fail > 0) {
    cat("\nFailed topics:\n")
    failed <- results[results$status == "FAIL", ]
    for (i in seq_len(nrow(failed))) {
      cat("  ❌", failed$topic[i], "\n")
      if (nchar(failed$error[i]) > 0) {
        cat("     Error:", failed$error[i], "\n")
      }
    }
  } else {
    cat("\n✓ All topics passed! Ready to render full presentation.\n")
  }

  return(results)
}

# ============================================================
# Option 4: Test ALL topics SEQUENTIALLY (slower but shows progress)
# ============================================================
test_all_topics <- function() {
  topic_files <- list.files("book/topics", pattern = "\\.qmd$", full.names = TRUE)
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
  quarto_preview("slides/presentation.qmd")
}

# ============================================================
# Quick helper functions
# ============================================================

# Render just the color topic (topic 1)
test_colors <- function() render_topic(1)

# Render just the heatmap topic (topic 2)
test_heatmaps <- function() render_topic(2)

# Render just the factors topic (topic 9)
test_factors <- function() render_topic(9)

# ============================================================
# USAGE EXAMPLES
# ============================================================

cat("
========================================
Academic Figures Presentation Renderer
========================================

Available commands:

1. Render outputs:
   render_presentation()              # Render slides only
   render_book()                      # Render book only
   render_all()                       # Render both in PARALLEL (default)
   render_all(parallel = FALSE)       # Render both sequentially

   Cleanup option (default TRUE):
   render_all(cleanup = FALSE)        # Keep render artifacts for debugging

2. Test a single topic (by number):
   render_topic(2)                    # Test topic 02 as slides
   render_topic(2, as_slides = FALSE) # Test topic 02 as HTML doc
   test_colors()                      # Shortcut for topic 1
   test_heatmaps()                    # Shortcut for topic 2
   test_factors()                     # Shortcut for topic 9

3. Test all topics - PARALLEL (FASTER!):
   results <- test_all_topics_parallel()
   results <- test_all_topics_parallel(n_cores = 4)  # Specify cores

4. Test all topics - Sequential (shows progress):
   results <- test_all_topics()

5. Preview presentation (live reload):
   preview_presentation()

6. Install required R packages:
   install.packages(c('ggplot2', 'patchwork', 'viridis',
                      'RColorBrewer', 'dplyr', 'forcats'))

Example workflow:
  # First, test all topics in parallel (faster)
  results <- test_all_topics_parallel()

  # Fix any errors, then test specific topic
  render_topic(1)

  # When all pass, render everything
  render_all()                       # Renders both slides and book

Output locations:
  - Book:   public/index.html
  - Slides: public/slides/presentation.html

Parallel vs Sequential:
  - Parallel: FASTER (uses multiple CPU cores)
  - Sequential: Shows live progress for each topic

========================================
")
