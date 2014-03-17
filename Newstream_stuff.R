rm(list=ls())
library(rgl)
library(misc3d)
library(oro.dicom)
library(AnalyzeFMRI)
library(knitcitations)
library(slidify)
library(dti)
library(plotrix)
rootdir <- "/Users/muschellij2/Dropbox/3DPDF_Example"
outdir <- file.path(rootdir, "Presentation")
homedir <- file.path(rootdir, "Paper")
datadir <- file.path(homedir, "data")
progdir <- file.path(homedir, "programs")
resdir <- file.path(homedir, "results")
source(file.path(progdir, "asy.R"))
source(file.path(progdir, "writeWebGL_split.R"))

#### bibliography
bibfile <- file.path(homedir, "Paper_ENAR_Visualization.bib")
bib <- read.bibtex(bibfile)

setwd(outdir)
tmp <- readNIfTI(file.path(datadir, "MNI152_T1_2mm_brain.nii"), reorient=FALSE)
template <- f.read.nifti.volume(file.path(datadir, "MNI152_T1_2mm_brain.nii"))
template <- template[,,,1]
cut <- 4500
x <- which(template > cut, arr.ind=TRUE)
ctr <- as.numeric(apply(x, 2, function(col) names(which.max(table(col)))))





### Template from MNI152 from FSL


dtemp <- dim(template)
brain <- contour3d(template, x=1:dtemp[1], y=1:dtemp[2], z=1:dtemp[3], level = cut, alpha = 0.2, draw = FALSE)

### this would be the ``activation'' or surface you want to render 
### here just taking the upper WM from the template image
activation <- contour3d(template, level = c(4500, 6000, 6500), alpha = c(0.1, 0.3, 1), add = TRUE, color=c("gray", "white", "orange"), draw=FALSE)
drawScene.rgl(activation)
## Not run: 
movie3d( spin3d(), duration=10, movie="NewBrain.gif", convert=TRUE )

