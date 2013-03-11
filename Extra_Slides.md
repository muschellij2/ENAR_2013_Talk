---
title       : Visualizing Brain Imaging in Interactive 3D Extra slides
subtitle    : John Muschelli  (ENAR 2013)
author      : "@StrictlyStat (github: muschellij2)" 
job         : Johns Hopkins Bloomberg School of Public Health
framework   : io2012        # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : hemisu-dark      # 
widgets     : []            # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}
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

## DTI Example 

<object data="./WebGL/index_dti.html" width="800" height="600"> <embed src="./WebGL/index_dti.html" width="800" height="600"> </embed> Error: Embedded data could not be displayed. </object>

----
