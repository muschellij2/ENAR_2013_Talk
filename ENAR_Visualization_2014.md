---
title       : brainR Interactive 3 and 4d Images of High Resolution Neuroimage Data
subtitle    : John Muschelli  (ENAR 2014)
author      : "@StrictlyStat (github: muschellij2)" 
job         : Johns Hopkins Bloomberg School of Public Health
framework   : io2012        # {io2012, html5slides, shower, dzslides, ...}
highlighter : prettify  # {highlight.js, prettify, highlight}
hitheme     : hemisu-dark      # 
widgets     : []            # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}
--- .cover #Cover











<!---
<object data="./WebGL/index.html" width="600" height="400"> <embed src="./WebGL/index.html" width="600" height="400"> </embed> Error: Embedded data could not be displayed. </object>
-->


## Talk Outline

* We have 3D/4D data
  * Single-subject brains over time
  * Brain maps over group
* We want to visualize the data
* We wrote some software to do it
* Examples

---

## 3D Graphics? - just because we can, doesn't mean we should



<img src="3D_Hist.png" style="width:400px; height:400px; border:1px solid blue; float:left;" alt="Lot of code" >

<img src="3D_Excel.png"  style="width:500px; height:400px; border:1px solid blue; float:right;" alt="Lot of code">

---



## Neuroimaging Data 

<img src="movie_final.gif" style="float:right;" height=350 width=350 alt="Spinning floating brain">

<img src="Data_pixels.png" height=308 width=600 alt="Data structure">

---


## Brain acquisition

<span class="black"><b>Read left to right like a book - down the page is down the brain</b></span>

Whole brain is acquired in "slices" - like a deli slicer.

![plot of chunk lightbox](assets/fig/lightbox.png) 



---


## Current methods of visualizing/EDA
Overall, most methods keep temporal or 2D spatial components fixed and vary the other. 
Using orthographic from `oro.nifti` package:


```r
orthographic(template, col = c(gray(0:61/64), hotmetal(3)), xyz = c(60, 85, 
    35), text = "Example of activation map", text.cex = 2)
```

![plot of chunk ortho](assets/fig/ortho.png) 


---

## Moving through Space <span class="black"><b>and</b></span> Time!

<img src="238-4136_Thumbnails2.png" style="width:780px; height:540px; center;" alt="Lot of code" >

---


## Example of 4D data

---


## How do we make these?

An `R` package that can create exportable `4D` scenes of surfaces:
<div align="center">
<p style="font-size:200px; text-align:center;">brainR</p>

</div>

---

## What actually goes on?

* In `R` - load the data using `oro.nifti`
* Make a contour/surface using `contour3d` from `misc3d`
* Collect surfaces in a `scene` (list of objects)
* Use `write4D` function to create `.STL` or `.OBJ` files and an html file.
* X toolkit (XTK): [https://github.com/xtk/X#readme](https://github.com/xtk/X#readme) reads and renders those files

---


## Why (I think) this makes a good interactive neuroimaging figure

* 3-4D <span class="black"><b>Interactive</b></span> (move, zoom, remove/add surfaces)
* <span class="black"><b>Transparency</b></span> (opacity) - subcortical structures
* Easy to use
* <span class="black"><b>Quick</b></span> to render (at least on user level)
* No (or very limited) 3rd Party software
* <span class="black"><b>Exportable</b></span>

---



## Thanks

* Ciprian Craniceanu and Brian Caffo - SMART Group
* Dan Hanley - MISTIE Trial
* Elizabeth Sweeney 
* Taki Shinohara

---


