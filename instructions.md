

* use dark theme
* All tables need to have newlines around them to render properly.
* all codes that make plots should show the output plots!

## formats

* explain what a vector image means and what a vector image means. 
  * make a vector image and low-res raster image with text as an example
  * use a table
  * explain that vectors have infinite resolution
  * explain that pdf and tif are containers that could contain anything
    * lossless tif vs lossy tif
  * make a mermaid graph decision tree for format selection. It should start with what kind of image it is. i.e. photo versus created figures
  * say you can use png for quick and dirty lossless. but vectors for publications
  * the examples of formats in "Demonstration: Format Comparison" is good. but actually read in the generated images, zoom and show the problem!
  * in the recommendation mention that eps is a more commonly accepted vector format if they don't support pdf
  
## Color Gradients  
  
* don't stat by saying it is bad. start with the example
* show what the rainbow scale looks like and what color it contains
* compare native ranbow scale with one you generate from the colors it contain so they can see how it is made.
* show the right order of colors in the rainbow scale
* show actual example of problematic plots. Find on the internet and cite properly.
* "Perceptual Non-Uniformity" <-- show the resulting plots!
* "Medical Consequences" citation needed and example of jet color map.
* show viridis examples! show the different color scales. On the viridis website there is a nice comparison. replicate some of that. That means also show what they look like after conversion to B/W
* show all color brewer scales. Show screenshot of the colorbrewer website.
* note that even if colorbrewer uses yellow it is not a good color to use as it prints poorly and can be invisible on projected slides.

## ggplot2 Themes

* show example of themes!
* show some examples of nice non-default themes? there is some R package for publication ready plots. don't recall the name.
