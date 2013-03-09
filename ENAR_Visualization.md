---
title       : Visualizing Brain Imaging in Interactive 3D
subtitle    : John Muschelli  (ENAR 2013)
author      : "@StrictlyStat (github: muschellij2)" 
job         : Johns Hopkins Bloomberg School of Public Health
framework   : io2012        # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : hemisu-dark      # 
widgets     : []            # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}
---













<!---
<object data="./WebGL/index.html" width="600" height="400"> <embed src="./WebGL/index.html" width="600" height="400"> </embed> Error: Embedded data could not be displayed. </object>
-->

## About Me 

* PhD student in Biostatistics at Johns Hopkins Bloomberg School of Public Health with <span class="black"><b>Ciprian Craniceanu</b></span>

* ScM 2010 (<span class="black"><b>Brian Caffo</b></span>)

* Worked in fMRI/CT for last 4 years

* Part of the <span class="black"><b>SMART group</b></span>, and ADHD-200 competition winners

* http://biostat.jhsph.edu/~jmuschel/

---

## R programs used for this presentation

* `knitr` [Xie (2013)] - compiles R code within markdown
* `slidify` [Vaidyanathan (2012)] - makes awesome slide decks (in html)
* `knitcitations` [Boettiger (2013)] - allows my BibTeX to cite in `knitr`
* `RStudio` [RStudio (2013)] - integrated R IDE

---

## 3D Graphics?



<img src="3D_Hist.png" style="width:400px; height:400px; border:1px solid blue; float:left;" alt="Lot of code" >

<img src="3D_Excel.png"  style="width:500px; height:400px; border:1px solid blue; float:right;" alt="Lot of code">

---


## I'm not referring to 3D histograms

* 3D is not good just because of one more D
* 3D data representing 2D is still bad
  * No 3D Pie charts/histograms
  * See Karl Broman's [The top ten worst graphs](http://www.biostat.wisc.edu/~kbroman/topten_worstgraphs/)



<p><img src="figure/piechart.png" style="width:400px; height:400px" alt="plot of chunk piechart"> </p>

---

## Why should I care/do imaging?

* Non-invasive (think <span class="black">craniotomy</span>)
* Potential biomarkers - early identification
  * Lesions in MS
  * Plaques in Alzheimer's
  * White matter volume
  * Cortical thickness

* Outcome measures
  * Stroke - amount of blood
  * Brain activity

---


## Neuroimaging Data 
What kind of data do we have?
* <span class = "green"><b>Structural MRIs</b></span>
* Functional MRIs
* Computed Tomography - <span class = "green"><b>CT</b></span>
* Diffusion Tensor Imaging (DTI)
* Electroencephalography (EEG)
* Positron Emission Tomography (PET)
* etc. 

<span class="black"><b>Visualization</b></span> and <span class="black"><b>presentation</b></span> of these data can be <span class="black"><b>improved</b></span> with the use of 3D tools.

---



## 3D rendering tools out there

* <span class = 'green'>RGL</span> (R Graphics Library) [Adler & Murdoch, 2013] using `R` - http://cran.r-project.org/
* <span class = 'green'>3D Slicer</span> - http://www.slicer.org/
* Paraview - http://www.paraview.org/
* Freesurfer - http://surfer.nmr.mgh.harvard.edu/
* AFNI - http://afni.nimh.nih.gov/afni
* MIPAV - http://mipav.cit.nih.gov/
* Matlab
* Many more

---

## Overall Message

* 3D (<span class="red"><b>neuroimaging</b></span>)  figures can be created/<span class="red"><b>exported easily</b></span>
 
* <span class="red"><b>Standalone</b></span> objects are needed for end-users/readers
 
*  <span class="red"><b>Webpages</b></span> are a good medium for these
 
* We need to figure how to effectively incorporate into pipelines/<span class="red"><b>publications</b></span>


---


## Current methods of visualizing/EDA

* Time series of individual voxels/regions of interest (ROI) <span class="black"><b>Keep 2D</b></span>
* Look at data cross-sectionally ("Lightbox")


Using image.nifti from `oro.nifti`  [Whitcher _et. al._ (2011)] package:

<span class="black"><b>Read left to right like a book</b></span>

![plot of chunk lightbox](figure/lightbox.png) 


---

## Current methods of visualizing/EDA
Overall, most methods keep temporal or 2D spatial components fixed and vary the other. 
Using orthographic from `oro.nifti` package:

![plot of chunk ortho](figure/ortho.png) 


---

## Example of 3D in `R` 


<object data="./WebGL/index.html" width="800" height="600"> <embed src="./WebGL/index.html" width="800" height="600"> </embed> Error: Embedded data could not be displayed. </object>

---

## How do I do this in `R`? - Example


```r
### read in brain image
tmp <- readNIfTI("MNI152_T1_2mm_brain.nii", reorient = FALSE)
dtemp <- dim(tmp)
### make the surface object - RGL renders
contour3d(tmp, x = 1:dtemp[1], y = 1:dtemp[2], z = 1:dtemp[3], level = 4500, 
    alpha = 0.15)

### this would be the ``activation'' or surface you want to render here
### just taking the upper WM from the template image
contour3d(tmp, level = c(8200, 8250), alpha = c(0.5, 0.8), add = TRUE, color = c("yellow", 
    "red"))

### add text
text3d(x = dtemp[1]/2, y = dtemp[2]/2, z = dtemp[3] * 0.98, text = "Top")
text3d(x = dtemp[1] * 0.98, y = dtemp[2]/2, z = dtemp[3]/2, text = "Right")

### export this to a webpage
writeWebGL_split(dir = file.path(outdir, "webGL"), width = 700, height = 500, 
    template = file.path(outdir, "my_template.html"))
```


---

## Why use `R`?

* Why choose as the main tool? 
* <span class="black"><b>STATISTICS</b></span> 
* <span class="black"><b>Packages</b></span> - a lot of cutting edge tools 
* Open-source
* <span class="black"><b>Reproducible</b></span> - somewhat lacking in neuroimaging
* <span class="black"><b>Scriptable</b></span>
* Exportable
* It works (You've seen it!)

---


## Moving through Space <span class="black"><b>and</b></span> Time!

<img src="238-4136_Thumbnails.png" style="width:780px; height:540px; center;" alt="Lot of code" >

---

## Slicer Example - WebGL export - CT Data

<video width="900" height="580" controls>
  <source src="Slicer_Example.mp4" type="video/mp4" loop="true">
</video>

---


## What (I think) makes a good interactive neuroimaging figure


* 3-4D <span class="black"><b>Interactive</b></span> (move, zoom, remove/add surfaces)
* Easy to use
* <span class="black"><b>Quick</b></span> to render (at least on user level)
* <span class="black"><b>Transparency</b></span> (opacity) - subcortical structures
* No (or very limited) 3rd Party software
* <span class="black"><b>Exportable</b></span>
  
  (Note - current figures do not have all these qualities )

---







## DTI Example 

<object data="./WebGL/index_dti.html" width="800" height="600"> <embed src="./WebGL/index_dti.html" width="800" height="600"> </embed> Error: Embedded data could not be displayed. </object>

----


## Where's my 4D?

* Currently 4D is not implemented in `rgl`
* Can export multiple figures and switch
  * Doesn't hold camera angle
  * Current research work
*** Where's the beef?

---

 

## Why are we still 2D?

* We do exploratory data analysis / quality control mainly only in 2D

* Some investment in <span class="black>new software</span> - how many languages is enough!?

* 3D Figures in <span class="black>Papers/Presentations</span> are not generally accepted
  * "Nice picture, but where's the figure for the paper"
  
<!--- 
* Software exists to embed 3D in <span class="black"><b>PDF</b></span> - but not as smooth for large data (See Levine JGCS paper for misc3d)
-->
* "Tradition!" [Stein _et. al._ (1964)]


<img src="Fiddler.gif" alt="Fiddler" height="200" width="200">

<hr noshade size=1> Image from http://tvtropes.org/pmwiki/pmwiki.php/Theatre/FiddlerOnTheRoof?from=Main.FiddlerOnTheRoof</hr>


 

---


## Markdown - Use `R`!

* Integration into `knitr` is working - webgl hook
  * Exporting the html first, then embedding in html works fine
  * RStudio's default doesn't open md's over 2Mb (brain was 30Mb)
* `shiny` integration is possible, but slow depending on system
  * Meta-Interactive? Interactive control over interactive graphics
  
* `slidify` works with it (used in this presentation)

---

## Conclusion

* 3D figures are <span class="black"><b>doable</b></span>
* `R` has a good interface - other tools are available
* Currently - good for internal reports/<span class="black"><b>EDA</b></span>
* <span class="black"><b>Not accepted</b></span> as figures - but supplemental material
* <span class="black"><b>More use</b></span> - better tools and more acceptance
* Can be done for all `rgl` objects, but use with <span class="black"><b>caution</b></span>

---


## Thanks

* Ciprian Craniceanu and Brian Caffo - SMART Group
* Dan Hanley - MISTIE Trial
* Elizabeth Sweeney 
* Duncan Murdoch - for rgl and exporting: otherwise I'd still be presenting distorted brains
* Those who created the tools I use without even thinking

---

## Biblio
<span style="font-size:15px;">
<p>Stein J, Jewison N, Topol, Crane N, Frey L, Picon M, Mann P, Morris O, Harnick S, Williams J and others (1964).
<EM>Fiddler on the Roof</EM>.
Crown.

<p>Boettiger C (2013).
<EM>knitcitations: Citations for knitr markdown files</EM>.
R package version 0.3-3, <a href="http://CRAN.R-project.org/package=knitcitations">http://CRAN.R-project.org/package=knitcitations</a>.

<p>Xie Y (2013).
<EM>knitr: A general-purpose package for dynamic report generation in
R</EM>.
R package version 1.1.4, <a href="http://yihui.name/knitr/">http://yihui.name/knitr/</a>.

<p>Feng D and Tierney L (2008).
&ldquo;Computing and Displaying Isosurfaces in R.&rdquo;
<EM>Journal of Statistical Software</EM>, <B>28</B>(1).
<a href="http://www.jstatsoft.org/v28/i01/">http://www.jstatsoft.org/v28/i01/</a>.

<p>Whitcher B, Schmid VJ and Thornton A (2011).
&ldquo;Working with the DICOM and NIfTI Data Standards in R.&rdquo;
<EM>Journal of Statistical Software</EM>, <B>44</B>(6), pp. 1&ndash;28.
<a href="http://www.jstatsoft.org/v44/i06/">http://www.jstatsoft.org/v44/i06/</a>.

<p>Adler D and Murdoch D (2013).
&ldquo;rgl: 3D visualization device system (OpenGL).&rdquo;
R package version 0.93.928, <a href="http://CRAN.R-project.org/package=rgl">http://CRAN.R-project.org/package=rgl</a>.

<p>RStudio (2013).
&ldquo;RStudio: Integrated development environment for R (Version 0.97.320).&rdquo;
[Computer software]. Retrieved March 6, 2013.
<a href="http://www.rstudio.org/">http://www.rstudio.org/</a>.

<p>Vaidyanathan R (2012).
<EM>slidify: Generate reproducible html5 slides from R markdown</EM>.
R package version 0.3.3, <a href="http://ramnathv.github.com/slidify/">http://ramnathv.github.com/slidify/</a>.

<p>Sweeney E, Shinohara R, Shea C, Reich D and Crainiceanu C (2012).
&ldquo;Automatic Lesion Incidence Estimation and Detection in Multiple Sclerosis
Using Multisequence Longitudinal MRI.&rdquo;
<EM>American Journal of Neuroradiology</EM>.

</span>
---


## Slicer
* GUI-based interface:

<img src="Slicer.png" alt="Slicer" height="500" width="1000">

---

## Slicer Example 

From <a href="https://github.com/xtk/SlicerWebGLExport/blob/master/README.md">https://github.com/xtk/SlicerWebGLExport/blob/master/README.md</a>.  Shows exportability. 

(Left 3D Slicer, Right - Google Chrome)

<img src="Slicer_Example_web.png" height="400" width="700" alt="Example of web rendering">

---

## Pros of Using Slicer

* GUI interface - can change opacity/measures interactively WSIWYG-ish
* Can make <b>exportable</b> (to html) figures
* Can incorporate into 4D - but not "out of the box" - have to add on javascript 
* Has many capabilities
* Scripting interface (I've never used) using `Python`

---

## More addons in `R`/Explanation?

* RGL - `R` adaptation of OpenGL
* Has 3d extensions of many functions: `plot3d`, `hist3d`, `text3d`, etc.
* misc3d package [ Feng & Tierney (2008) ] - add ons to this and allows for contours
* `writeWebGL` - `rgl` function that allows you to write to webGL

---



## Things Hiding in 2D
* Real Life Example:

* SubLIME is a MS lesion detection algorithm [Sweeney _et. al._ 2012].  
* MS - SUBLIME
* before 3D rendering - didn't notice misregistration

---

## Moving through Space <span class="black"><b>and</b></span> Time!
* Look at data by slice over time 
  * Need to line up images so time 1 and time 2 are the same (registration) - applies to most temporal analysis

![plot of chunk lightbox2](figure/lightbox2.png) 

---


## RGL Caveats
So RGL rendering is perfect, right?

<img src="html_screenshot.png" height="400" alt="Lot of code">

---


## RGL Caveats

* Size of gzipped NIfTI file : 418Kb, unzipped 4Mb
* Size of html output : 30Mb  
* WebGL can only hold 65535 points in an object - need to break up 
  * http://biostat.jhsph.edu/~jmuschel/code/WebGL_Example.zip has example of how to do this (thanks to Duncan Murdoch)
* Also hard to see what's going on in the html

---
