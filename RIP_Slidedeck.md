---
title       : Visualizing Brain Imaging in Interactive 3D
subtitle    : John Muschelli (RIP 2013)
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

## Overview 

* <strong>CLEAR and MISTIE Trials</strong>
* Visualizing imaging data better
* Novel methods for CT Data

---


## MISTIE and CLEAR Trials

* Intraventricular Hemorrhage (IVH) and Intracerebral Hemorrhage (ICH), and generally hypertensive bleeds

* CLEAR (IVH)- Clot Lysis: Evaluating Accelerated Resolution of Hemorrhage with rt-PA (Phase III - began Sept 2009)
    * 500 patients total
    * Placebo/Control
* MISTIE (ICH) - Minimally Invasive Surgery + rt-PA for Intracerebral Hemorrhage (Phase II - just completed)
    * 123 randomized patients: 60 surgical, 63 control (medical management)

---


## MISTIE and CLEAR Data

* Serial CT imaging to show clot clearance
* 5-12 per person
* (as a reference - many stroke trials get 1-2)
* Previous studies have shown that clot volume and clot location (at least for IVH) is indicative of good functional outcome
* Good functional - outcome (modified Rankin Score)

---

## Hey

<table border=1>
<CAPTION ALIGN="bottom"> Logistic regression for 180-day Modified Rankin outcome scores (mRS).  Models are presented with odds ratio of mRS < 4 and confidence intervals as: LB;OR UB;, where OR is the odds ratio, and LB/UB are the upper/lower bounds of the 95% confidence interval, respectively.  Both MIS and higher clot resolution increase the odds of a good functional outcome (mRS < 4), after adjusting for initial severity factors. </CAPTION>
  <TR> <TD> GCS at Enrollment </TD> <TD align="center">  1.34;1.75; 2.29 </TD> <TD align="center"> < 0.0001 </TD> <TD align="center">  1.36;1.81; 2.40 </TD> <TD align="center"> < 0.0001 </TD> </TR>
   <TR> <TD> Age at Enrollment </TD> <TD align="center">  0.86; 0.92; 0.97 </TD> <TD align="center"> 0.004 </TD> <TD align="center">  0.85; 0.91; 0.97 </TD> <TD align="center"> 0.003 </TD> </TR>
   <TR> <TD> Pre-Randomization ICH Volume (per 10cc) </TD> <TD align="center">  0.64; 0.90; 1.25 </TD> <TD align="center"> 0.514 </TD> <TD align="center">  0.40; 0.64; 1.01 </TD> <TD align="center"> 0.056 </TD> </TR>
   <TR> <TD> MIS vs. Medical </TD> <TD align="center">  0.75; 2.63; 9.30 </TD> <TD align="center"> 0.133 </TD> <TD align="center">  </TD> <TD align="center">  </TD> </TR>
   <TR> <TD> Resolved ICH Volume (per 10cc) </TD> <TD align="center">  </TD> <TD align="center">  </TD> <TD align="center">  1.12; 1.84; 3.03 </TD> <TD align="center"> 0.017 </TD> </TR>
</table>


---




## Moving through Space <span class="black"><b>and</b></span> Time!

<img src="238-4136_Thumbnails.png" style="width:780px; height:540px; center;" alt="Lot of code" >

---

## Slicer Example - WebGL export - CT Data

<video width="900" height="580" controls>
  <source src="Slicer_Example.mp4" type="video/mp4" loop="true">
</video>

---

## Neuroimaging Data 

<img src="movie_final.gif" style="float:right;" height=350 width=350 alt="Spinning floating brain">

<img src="Data_pixels.png" height=308 width=600 alt="Data structure">

---

## Overview 

* CLEAR and MISTIE Trials
* <strong>Visualizing imaging data better</strong>
* Novel methods for CT Data

---



## Current methods of visualizing/EDA
* "Lightbox" - using image.nifti from `oro.nifti`  [<a href="http://www.jstatsoft.org/v44/i06/">Whitcher _et. al._ (2011)</a>] package:

<span class="black"><b>Read left to right like a book - down the page is down the brain</b></span>

![plot of chunk lightbox](figure/lightbox.png) 

<!---
* Time series of individual voxels/regions of interest (ROI) <span class="black"><b>Keep 2D</b></span>
-->

---

## Current methods of visualizing/EDA
Overall, most methods keep temporal or 2D spatial components fixed and vary the other. 
Using orthographic from `oro.nifti` package:

![plot of chunk ortho](figure/ortho.png) 


---

## Example of 3D in `R` 


<iframe width="1200" height="800" src="./WebGL/index_jsed.html" style="-webkit-transform:scale(1);-moz-transform-scale(1);"></iframe>


---



## What (I think) makes a good interactive neuroimaging figure


* 3-4D <span class="black"><b>Interactive</b></span> (move, zoom, remove/add surfaces)
* <span class="black"><b>Transparency</b></span> (opacity) - subcortical structures
* Easy to use
* <span class="black"><b>Quick</b></span> to render (at least on user level)
* No (or very limited) 3rd Party software
* <span class="black"><b>Exportable</b></span>
  
  (Note - current figures do not have all these qualities )

---










## Biblio
<span style="font-size:15px;">
<p>Adler D and Murdoch D (2013).
&ldquo;rgl: 3D visualization device system (OpenGL).&rdquo;
R package version 0.93.928, <a href="http://CRAN.R-project.org/package=rgl">http://CRAN.R-project.org/package=rgl</a>.

<p>Boettiger C (2013).
<EM>knitcitations: Citations for knitr markdown files</EM>.
R package version 0.3-3, <a href="http://CRAN.R-project.org/package=knitcitations">http://CRAN.R-project.org/package=knitcitations</a>.

<p>RStudio (2013).
&ldquo;RStudio: Integrated development environment for R (Version 0.97.320).&rdquo;
[Computer software]. Retrieved March 6, 2013.
<a href="http://www.rstudio.org/">http://www.rstudio.org/</a>.

<p>Stein J, Jewison N, Topol, Crane N, Frey L, Picon M, Mann P, Morris O, Harnick S, Williams J and others (1964).
<EM>Fiddler on the Roof</EM>.
Crown.

<p>Vaidyanathan R (2012).
<EM>slidify: Generate reproducible html5 slides from R markdown</EM>.
R package version 0.3.3, <a href="http://ramnathv.github.com/slidify/">http://ramnathv.github.com/slidify/</a>.

<p>Whitcher B, Schmid VJ and Thornton A (2011).
&ldquo;Working with the DICOM and NIfTI Data Standards in R.&rdquo;
<EM>Journal of Statistical Software</EM>, <B>44</B>(6), pp. 1&ndash;28.
<a href="http://www.jstatsoft.org/v44/i06/">http://www.jstatsoft.org/v44/i06/</a>.

<p>Xie Y (2013).
<EM>knitr: A general-purpose package for dynamic report generation in
R</EM>.
R package version 1.1.4, <a href="http://yihui.name/knitr/">http://yihui.name/knitr/</a>.

</span>
---

