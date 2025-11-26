# Copyright Solutions - Action Plan

## Immediate Actions (Good News!)

### ✅ Already Legally Clear

1. **BMC Plant Biology figure** (`12870_2011_Article_914_Fig2_HTML.webp`)
   - License: CC BY 2.0 (Open Access)
   - Action: **Keep it!** Just ensure citation is visible

2. **The Conversation figure** (`file-20211005-30173-hog6m.avif`)
   - License: CC BY-ND 4.0
   - Action: **Keep it!** Just don't modify it

## Option A: Strengthen Fair Use (Current Approach)

### Advantages
- Keep all current examples
- Minimal work required
- Legally defensible for educational use

### Required Changes

1. **Add explicit attribution on slides**

   For each copyrighted figure, add:
   ```markdown
   ::: {.aside}
   Figure from [Author et al., Year]. Used under fair use for educational purposes.
   :::
   ```

2. **Add COPYRIGHT_NOTICES.md** (✅ Done)

3. **Add educational context**
   - Ensure each figure is discussed/criticized
   - Not just displayed but analyzed
   - Makes fair use argument stronger

4. **Keep nonprofit/educational focus**
   - Don't sell the materials
   - Don't use commercially
   - Maintain MIT license with fair use notice

### Risk Level: **Low-Medium**
- Very unlikely to be challenged for educational use
- Even if challenged, fair use defense is strong
- No monetary damages likely

## Option B: Replace Problematic Figures

### High Priority Replacements

#### 1. Borkin Medical Imaging Figure
**Current:** `sources/borkin.png` (IEEE © 2011)

**Replacement Options:**
- Create your own simplified diagram showing the concept
- Use a different open-access study example
- Link to the paper instead of embedding

**Code to replace:**
```r
# Create demonstration of jet colormap problem
# Show how yellow appears more intense than red
```

#### 2. ISPRS Rainbow Review Figure
**Current:** `sources/1-s2.0-S0924271622002659-gr1_lrg.jpg` (Elsevier © 2022)

**Replacement Options:**
- Create your own comparison plot showing rainbow ordering
- Use the interactive challenge you already have
- Generate synthetic example

#### 3. Elsevier Figures (Analytica Chimica Acta)
**Current:** `sources/1-s2.0-S0003267012000062-fx1.jpg`, `gr4.jpg`

**Replacement Options:**
- Generate your own examples showing format differences
- Use R to create vector vs raster comparisons
- Already have some of this in your code!

### Medium Priority (Screenshots)

#### ColorBrewer Screenshot
**Current:** `sources/colorbrewer.png`

**Better approach:**
```markdown
Visit [ColorBrewer](https://colorbrewer2.org) to explore palettes interactively.

![ColorBrewer website - color palette tool](link-to-screenshot)
Or embed: <iframe src="https://colorbrewer2.org" ...>
```

## Option C: Hybrid Approach (Recommended)

### Keep These (Already Licensed):
- ✅ BMC Plant Biology (CC BY 2.0)
- ✅ The Conversation (CC BY-ND 4.0)
- ✅ Your own SVGs (pre-edit.svg, post-edit.svg)
- ✅ Wikimedia Commons (if Rgb-raster-image.svg is from there)

### Replace These:
- 🔄 Borkin figure → Create your own medical imaging example
- 🔄 ISPRS figure → Already have the interactive challenge!
- 🔄 Elsevier ACA figures → Generate with R code

### Document These (Fair Use):
- 📝 ColorBrewer screenshot → Add attribution
- 📝 Software screenshots → Add fair use notice

## Implementation Priority

### Immediate (Before Public Release)
1. ✅ Add COPYRIGHT_NOTICES.md
2. Add attribution to slides with figures
3. Verify licenses for "already clear" figures

### Short Term (Nice to Have)
1. Replace Borkin figure with your own example
2. Replace ISPRS figure (use your interactive challenge)
3. Replace Elsevier figures with generated examples

### Long Term (Best Practice)
1. Create all examples from scratch
2. Use only CC-licensed or public domain images
3. Document all sources thoroughly

## Legal Disclaimer

**For your LICENSE file, consider adding:**

```markdown
## Third-Party Content

This project includes educational examples from published research,
used under fair use provisions for nonprofit educational purposes.
See COPYRIGHT_NOTICES.md for details.

When reusing this material:
- Educational use: Follow fair use guidelines
- Commercial use: Replace copyrighted figures or obtain permission
```

## Recommendation

**For maximum safety with minimal work:**

1. Keep the current figures (fair use is solid for educational use)
2. Add COPYRIGHT_NOTICES.md (✅ done)
3. Add attribution text on slides
4. Eventually replace the Elsevier figures (easiest to recreate)
5. Note this as "educational fair use" in README

**Risk assessment:** Very low. Academic presentations use copyrighted figures routinely under fair use. Your case is stronger because:
- Nonprofit educational purpose
- Critical commentary (discussing what's wrong with the figures)
- Limited use (single figures, not whole papers)
- No commercial benefit
- Proper attribution

The most likely scenario if challenged is: request to remove figure. No legal consequences for good-faith educational use.
