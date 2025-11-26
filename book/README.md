# Academic Figures Book

This directory contains the Quarto Book version of the Academic Figures guide - a comprehensive, tutorial-style companion to the presentation slides.

## Structure

- `_quarto.yml` - Book configuration
- `index.qmd` - Homepage/welcome page
- `chapters/` - Individual book chapters (expanded from slide topics)
- `references.qmd` - Bibliography and resources
- `quiz-info.qmd` - Information about the interactive quiz
- `resources.qmd` - Additional tools and learning materials

## Building the Book

```bash
# From the book directory
quarto render

# Or from the project root
quarto render book
```

The book will be built to `book/_book/`

## Relationship to Slides

The slides (`presentation.qmd` and `topics/`) remain the primary, complete material. The book chapters provide:

- Expanded explanations and context
- Step-by-step tutorials
- Additional code examples
- Exercises and practice problems

Currently, most chapters link back to the slides. The full book content is being developed incrementally, starting with Chapter 1 (Color Gradients).

## Development Status

- ✅ Chapter 1: Color Gradients - Complete
- 🚧 Chapters 2-11: Stubs with links to slides
- ✅ Index/Welcome page - Complete
- ✅ References - Complete
- ✅ Resources - Complete
- ✅ Quiz info - Complete

## Contributing

To contribute a chapter:

1. Use `chapters/01-colors.qmd` as a template
2. Expand on the slide content with detailed explanations
3. Add practical examples and exercises
4. Include code that readers can run themselves
5. Link to relevant resources

## License

MIT License - see the main repository LICENSE file.
