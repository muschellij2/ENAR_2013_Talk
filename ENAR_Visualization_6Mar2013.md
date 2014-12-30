---
title       : Visualizing Brain Imaging in Interactive 3D
subtitle    : 
author      : John Muschelli
job         : Johns Hopkins Bloomberg School of Public Health
framework   : io2012        # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : hemisu-dark      # 
widgets     : []            # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}
---










```r
### Template from MNI152 from FSL


# dtemp <- dim(template)
# brain <- contour3d(template, x=1:dtemp[1], y=1:dtemp[2], z=1:dtemp[3], level = cut, alpha = 0.15, draw = FALSE)

# ### this would be the ``activation'' or surface you want to render 
# ### here just taking the upper WM from the template image
# activation <- contour3d(template, level = c(8200, 8250), alpha = c(0.5, 0.8), add = TRUE, color=c("yellow", "red"), draw=FALSE)

# scene <- list(brain, activation)
# drawScene.rgl(scene)
# text3d(x=dtemp[1]/2, y=dtemp[2]/2, z = dtemp[3]*0.98, text="Top")
# text3d(x=dtemp[1]*0.98, y=dtemp[2]/2, z = dtemp[3]/2, text="Right")
# ## triangle_split()
# index <- writeWebGL_split(dir=file.path(outdir, "webGL"), width=700, height=500, template= file.path(outdir, "my_template.html"))
```


## R programs used for this presentation

* knitr [Xie (2013)]
* slidify [Vaidyanathan (2012)]
* knitcitations [Boettiger (2013)]
* RStudio [RStudio (2013)]

---


## 3D Graphics?

```r
##########
### 3D HIST EXAMPLE:
### Taken from system.file("demo", "hist3d.R", package="rgl")

binplot.3d<-function(x,y,z,alpha=1,topcol="#ff0000",sidecol="#aaaaaa")
{
  save <- par3d(skipRedraw=TRUE)
  on.exit(par3d(save))
    
  x1<-c(rep(c(x[1],x[2],x[2],x[1]),3),rep(x[1],4),rep(x[2],4))
  z1<-c(rep(0,4),rep(c(0,0,z,z),4))
  y1<-c(y[1],y[1],y[2],y[2],rep(y[1],4),rep(y[2],4),rep(c(y[1],y[2],y[2],y[1]),2))
  x2<-c(rep(c(x[1],x[1],x[2],x[2]),2),rep(c(x[1],x[2],rep(x[1],3),rep(x[2],3)),2))
  z2<-c(rep(c(0,z),4),rep(0,8),rep(z,8) )
  y2<-c(rep(y[1],4),rep(y[2],4),rep(c(rep(y[1],3),rep(y[2],3),y[1],y[2]),2) )
  rgl.quads(x1,z1,y1,col=rep(sidecol,each=4),alpha=alpha)
  rgl.quads(c(x[1],x[2],x[2],x[1]),rep(z,4),c(y[1],y[1],y[2],y[2]),
              col=rep(topcol,each=4),alpha=1) 
  rgl.lines(x2,z2,y2,col="#000000")
}

hist3d<-function(x,y=NULL,nclass="auto",alpha=1,col="#ff0000",scale=10)
  {
  save <- par3d(skipRedraw=TRUE)
  on.exit(par3d(save))
  xy <- xy.coords(x,y)
  x <- xy$x
  y <- xy$y
  n<-length(x)
  if (nclass == "auto") { nclass<-ceiling(sqrt(nclass.Sturges(x))) }
  breaks.x <- seq(min(x),max(x),length=(nclass+1))
  breaks.y <- seq(min(y),max(y),length=(nclass+1))
  z<-matrix(0,(nclass),(nclass))
  for (i in 1:nclass) 
    {
    for (j in 1:nclass) 
      {
      z[i, j] <- (1/n)*sum(x < breaks.x[i+1] & y < breaks.y[j+1] & 
                            x >= breaks.x[i] & y >= breaks.y[j])
      binplot.3d(c(breaks.x[i],breaks.x[i+1]),c(breaks.y[j],breaks.y[j+1]),
                 scale*z[i,j],alpha=alpha,topcol=col)
      }
    }
}

# Drawing a 3d histogramm of 2500 normaly distributed observations:
hist3d(rnorm(2500),rnorm(2500),alpha=0.4,nclass=7,scale=30)
filename <- file.path(outdir, "3D_Hist.png")
rgl.snapshot(filename)
rgl.close()
```

<img src="3D_Hist.png" style="width:400px; height:400px; border:1px solid blue; float:left;" alt="Lot of code" >

<img src="3D_Excel.png"  style="width:500px; height:400px; border:1px solid blue; float:right;" alt="Lot of code">

---


## I'm not referring to 3D histograms

* 3D is not good just because of one more D
* 3D data representing 2D is still bad
  * No 3D Pie charts/histograms
  * See Karl Broman's [The top ten worst graphs](http://www.biostat.wisc.edu/~kbroman/topten_worstgraphs/)


```r
slices <- c(50, 50) 
lbls <- paste0("group", 1:length(slices) )
pie3D(slices,explode=0.3, theta = pi/3, start=pi/6, col=c("gray", "white", border="green"), main="Pies taste better in 2D")
text(0, 0, "NO", cex=5, col="red")
```

![plot of chunk unnamed-chunk-2](assets/fig/unnamed-chunk-2-1.png) 

---

## Neuroimaging Data 
What kind of data do we have?
* Structural MRIs
* Functional MRIs
* CT
* DTI
* EEG
* PET
* etc. 

Visualization and presentation of these data can be improved with the use of 3D tools.

---


## 3D rendering tools out there

* *3D Slicer* - http://www.slicer.org/
* Paraview - http://www.paraview.org/
* *RGL* (Adler and Murdoch, 2013) using *R* - http://cran.r-project.org/
* Freesurfer - http://surfer.nmr.mgh.harvard.edu/
* AFNI - http://afni.nimh.nih.gov/afni
* MIPAV - http://mipav.cit.nih.gov/
* Matlab, etc.

---



## Current methods of visualizing/EDA

* Time series of individual voxels/regions of interest (ROI)
* Look at data by slice over time 
  * Need registration for this - anything temporal
* Look at data cross-sectionally ("Lightbox" - below)

Overall, most methods keep temporal or 2D spatial components fixed and vary the other.

Using image.nifti from *oro.nifti*  [Whitcher, Schmid, and Thornton (2011)] package:


```r
have_info <- which(!apply(tmp, 3, function(x) any(x > 0)))
mid <- dim(tmp)[3]/2
have_info <- have_info[have_info > mid]
#image(tmp, plot.type="multiple")
x <- tmp[,,1:min(have_info), drop=FALSE]
image.nifti(nifti(x))
```

![plot of chunk lightbox](assets/fig/lightbox-1.png) 

---

## Example of 3D in R
Using orthographic from **oro.nifti** package:


```r
orthographic(template, col=c(gray(0:61/64), hotmetal(3)), xyz=c(60, 85, 35), text="Example of an activation map", text.cex=1)
```

![plot of chunk ortho](assets/fig/ortho-1.png) 
---

## Example of 3D in R 
The same data presented in a 3D model, using **misc3d** and **rgl**

<object data="./WebGL/index.html" width="800" height="600"> <embed src="./WebGL/index.html" width="800" height="600"> </embed> Error: Embedded data could not be displayed. </object>

---

## What makes a good figure
  - 3-4D Interactive
  - Easy to use
  - Quick to render
  - Transparency (opacity) - subcortical structures
  - No (or very limited) 3rd Party software
  (Note - current figures do not have all these qualities )

---

## Why are we still 2D?

* We do EDA/QC mainly only in 2D
* Some investment in new software - how many languages is enough!?
* 3D Figures in Papers/Presentations are not generally accepted
* Software exists to embed 3D in pdf - but not as smooth for large data
* "Tradition!" Stein, Jewison, Topol, et al. (1964)

---



```r
# path2cibc <- file.path(outdir, "brain-dt/")
# 
# # read function for NRRD-files
# read.nrrd <- function(file,path=file.path(outdir, "brain-dt/")){
#   if(!file.exists(file)&&!file.exists(paste(path,file,sep=""))) {
#   cat("Please first download the data set from the CIBC Datasets Archive \n\n",
#       "http://www.sci.utah.edu/releases/scirun_v4.1/SCIRunData_4.1_20090629_data.tgz\n\n",
#       "which is part of the SCIRun software version (4.1)\n",
#       "and unpack it into your current directory or provide a path to the data in 
#        path2cibc \n\n")
#   cat("Note the mandatory acknowledgment if this dataset is used in any 
#        publication or third-party work, see:\n
#        http://www.sci.utah.edu/cibc/software/114-cibcdata.html \n\n")
#        stop("Stopping")
#   } 
#   if(!file.exists(file)) file <- paste(path,file,sep="")
#   con <- file(file,"r")
#   filetype <- readLines(con,n=1)
#   count <- 1
#   notempty <- TRUE
#   while (notempty) {
#      zzz <- readLines(con,n=1) 
#      if (nchar(zzz)==0) {
#         notempty <- FALSE
#         count <- count+1
#      } else {
#         zzz <- strsplit(zzz,": ")
#         what <- zzz[[1]][1]
#         if (what=="type") type<-switch(zzz[[1]][2],float="numeric",integer="integer","integer")
#         if (what=="dimension") dimension <- as.numeric(zzz[[1]][2])
#         if (what=="sizes") sizes <- as.numeric(unlist(strsplit(zzz[[1]][2]," ")))
#         if (what=="spacings") vextension <- as.numeric(unlist(strsplit(zzz[[1]][2]," ")))
#         if (what=="endian") endian <- zzz[[1]][2]
#         if (what=="encoding") encoding <- zzz[[1]][2]
#         count <- count+1
#      }
#   }
#   close(con)
#   if(encoding=="raw"){
#     con <- file(file,"rb")
#     ttt <- readLines(con,n=count) # header again
#     img <- readBin(con,type,n=prod(sizes),switch(type,numeric=4,integer=2),signed=FALSE,endian=endian)
#     close(con)
#   }
#   invisible(array(img,sizes))
# }
# 
# # read the data and create a prepared tmpfile, 
# # corresponds to "self-prepared" binary image file
# # see page 12 of manuscript
# s0 <- read.nrrd("gkwi-1.5mm-B0.nrrd",path=path2cibc)
# if(any(is.nan(s0))) stop("Please use the data from \n http://www.sci.utah.edu/releases/scirun_v4.1/SCIRunData_4.1_20090629_data.tgz \n")
# 
# ddim <- dim(s0)
# si <- read.nrrd("gkwi-1.5mm-DWI.nrrd",path=path2cibc)
# si <- aperm(si,c(2:4,1))
# file <- "demo-gradients.txt"
# if(!file.exists(file)) file <- paste(path2cibc,"demo-gradients.txt",sep="")
# if(!file.exists(file)) stop("need file SCIRunData_4.1_20090629_data/brain-dt/demo-gradients.txt from  SCIRunData ")
# grad <- rbind(c(0,0,0),read.table(file))
# cat("Use of this data set was made possible in part by software from the \n NIH/NCRR Center for Integrative Biomedical Computing, P41-RR12553-10.\n")
# s0[s0<0] <- 0
# si[si<0] <- 0
# s0[is.na(s0)] <- 0
# si[is.na(si)] <- 0
# rangesi <- range(s0,si)
# si <- c(as.integer(32000*s0/rangesi[2]),as.integer(32000*si/rangesi[2]))
# dim(si) <- c(ddim,dim(grad)[1])
# tmpfile <- tempfile("gkwi-1.5")
# con <- file(tmpfile,"wb")
# writeBin(as.integer(si),con,2)
# close(con)
# rm(s0,rangesi,si,read.nrrd)
# gc()
# 
# # start the analysis
# data <- dtiData(grad,tmpfile,ddim,maxvalue=32000)
# data <- sdpar(data,interactive=FALSE,level=1300)
# # # set to 1300, if you want to produce figure 2, run with TRUE
# # sdgraph <- FALSE
# # if (sdgraph) {
#   # pdf("figure2.pdf",width=8,height=4)
#   # par(mar=c(3,3,3,1),mgp=c(2,1,0))
#   # data <- sdpar(data,interactive=TRUE,level=1300)
#   # Y
#   # dev.off()
# # }
# 
# # create diffusion tensor estimates
# tensor <- dtiTensor(data)
# 
# # create anisotropy indices
# dtind <- dtiIndices(tensor)
# 
# show3d(dtind)
# index <- writeWebGL_split(dir=file.path(outdir, "webGL"), filename = file.path(outdir, "webGL", "index_dti.html"), width=700, height=500, template= file.path(outdir, "my_template.html"))
```


## Slicer Example - CT Data

From <a href="https://github.com/xtk/SlicerWebGLExport/blob/master/README.md">https://github.com/xtk/SlicerWebGLExport/blob/master/README.md</a>

<img src="Slicer_Example_web.png" alt="Example of web rendering">

---


## Slicer Example - CT Data
Motivating Example:

Thumbnails of clearance from Natalie

---

## Slicer Example - CT Data
<video width="900" height="580" controls>
  <source src="Slicer_Example.mp4" type="video/mp4">
</video>

---

## How do we view results:

* Time series of individual voxels/regions of interest (ROI)
* Look at a subset of cross-sectional slices over time 
* Present spatial map summarizing temporal information

* Projection, mean, differrence
* Statistical Parametric Map (SPM) - Color as "activation level"

---

## Why use this for EDA

* Respects true nature of data (brains are not slices!)
* Can get more of an overview
* Motion - can look and interact to see if there are problems
* Some things become more apparent in 3D

---     



## Things Hiding in 2D
* Real Life Example:

* SubLIME is a MS lesion detection algorithm (Sweeney, Shinohara, Shea, et al., 2012).  
* MS - SUBLIME
* before 3D rendering - didn't notice misregistration

---


## DTI Example 

<object data="./WebGL/index_dti.html" width="800" height="600"> <embed src="./WebGL/index_dti.html" width="800" height="600"> </embed> Error: Embedded data could not be displayed. </object>

---

## RGL - Use R!

* Why choose as the main tool? (Other than the fact I'm at a statistics conference)
* Open - source (read Free)
* REPRODUCIBLE (R Markdown as Hadley will discuss)
* Scriptable
* Exportable
* It works (You've seen it!)

---

## Conclusion

* Currently - very good for internal reports/EDA
* Not accepted as figures in publication
* Need journals that can handle
* You can still include snapshots 
* Available methods allow for reproducibility

---

## What's the problem

* With the explosion of high dimensional data
* Areas - genomics, neuroscience, astronomy (not astrology), large networks
* Focus - 4D data, and specifically neuroscience 
* Currently - show orthogonal slices with colors proportional to intensity - "flat brains"

* Have alpha blending

* Have no "hurdle" with software

---

## Overall Goals
 
* Why we need them
* Why we should push for them to be done
  * Journal
* Discuss how to make these figure

---

## What do we want it to do?

* Have 2D presents - colors, shapes, axes
* Be able to be manipulated/rotated
* Present multiple meshes

* Have alpha blending

* Have no "hurdle" with downloading software for end users

---

## What are the options for rendering?

\begin{table}[h]
  \begin{tabular}{c|m{1in}|m{1in}|}
  \hline
	Software & Pros & Cons \\
	Slicer & Lightweight rendering, export to multiple formats & Python Scripting (Pro?) \\
	Slicer & & Import all types of formats \\
	Paraview & Lightweight Rendering & \\
	Paraview & Lightweight Rendering & Import all types of formats \\
	RGL, WebGL, OpenGL & & Scripting (Pro?) \\
	MeshLab & Converts Multiple formats & Not easy alpha blending, Not much brain data import \\
	Asymptote &  & Scripting language \\
	Adobe Presenter &  & Cost \\
	\hline
	\end{tabular}
\end{table}

---

## Where to Render

\begin{table}
{\scriptsize
	\begin{tabular}{c|m{0.5in}|c|}
	\hline
	& Pros & Cons \\
	\multirow{3}{*}{Web} &  & Need Internet \\
	& Updatable  &  Not linked to paper\\
	& Many tools available & Some html may be required \\
	& & \\ \hline
	\multirow{3}{*}{PDF} & Embedded all in one document - linked  & Need Adobe\\
	& Embedded all in one document & Only certain format (u3d, prc, etc) \\
	&  & Javascript may be possible \\
	\hline
	\end{tabular}
}
\end{table}

---

## RGL Caveats
So RGL rendering is perfect, right

<img src="html_screenshot.png" height="400" alt="Lot of code">

---


## RGL Caveats

* Size of gzipped NIfTI file : 418Kb, unzipped 4Mb
* Size of html output : 30Mb  

---

## Problems

* We're not movie directors: Camera angle/position may convey the wrong idea.  
* Presentation still plays a large role

---

## Thanks

* Ciprian Craniceanu and Brian Caffo - SMART Group
* Elizabeth Sweeney 
* Duncan Murdoch - otherwise I'd still be presenting distorted brains

---

## Biblio

```r
bibliography("html") 
```
---

## WHhat

Here are the steps.
Need a structure
4D - over time or multiple ROIs

---


## Slide 1

Functional brain imaging (e.g. fMRI, PET, EEG) data is a 4-dimensional time series representing changes in brain activity over time.  

Structrual imaging (e.g. MPRAGE, DTI, CT) also has been increasingly more common to have a longitudinal component, where participants/subjects are scanned multiple times. 

Visualization and presentation of these data can be improved with the use of 3D tools.


NEEDED: pictures of brains - a lot - DTI ex, MRI