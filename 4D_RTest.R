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
r3dDefaults$windowRect <- c(0,50, 700, 700)

webdir <- file.path(outdir, "webGL")
f <- file(file.path(webdir, "index_template.html"))
htmltmp <- readLines(f)

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

dtemp <- dim(template)
brain <- contour3d(template, x=1:dtemp[1], y=1:dtemp[2], z=1:dtemp[3], level = cut, alpha = 0.15, draw = FALSE)

### this would be the ``activation'' or surface you want to render 
### here just taking the upper WM from the template image
cut1 <- 8000
cut2 <- 8100
activation <- contour3d(template, level = c(cut2), alpha = c(0.5), add = TRUE, color=c("yellow"), draw=FALSE)
ac2 <- contour3d(template, level = c(cut1), alpha = c(0.5), add = TRUE, color=c("red"), draw=FALSE)

tmp <- 1*(template >= cut1 & template < cut2)
ac3 <- contour3d(tmp, level = 0.9, alpha = c(0.5), add = TRUE, color=c("green"), draw=FALSE)

scene <- list(brain, activation, ac2, ac3)
# rgl.close()
# close3d()
open3d()
drawScene.rgl(scene)
text3d(x=dtemp[1]/2, y=dtemp[2]/2, z = dtemp[3]*0.98, text="Top")
text3d(x=-0.98, y=dtemp[2]/2, z = dtemp[3]/2, text="Right")
## triangle_split()

play3d(spin3d(axis=c(0,0,1), rpm=45), duration=1)


writeWebGL_split(dir=webdir)

writeOBJ(file.path(outdir, "webGL", "scene.obj"))
writeSTL(file.path(outdir, "webGL", "scene.stl"))
writePLY(file.path(outdir, "webGL", "scene.ply"))


drawScene.rgl(brain)
writeOBJ(file.path(outdir, "webGL", "braintest.obj"))
writeSTL(file.path(outdir, "webGL", "braintest.stl"))
writePLY(file.path(outdir, "webGL", "braintest.ply"))

drawScene.rgl(activation)
writeOBJ(file.path(outdir, "webGL", "actest.obj"))
writeSTL(file.path(outdir, "webGL", "actest.stl"))
writePLY(file.path(outdir, "webGL", "actest.ply"))

drawScene.rgl(ac2)
writeOBJ(file.path(outdir, "webGL", "actest2.obj"))
writeSTL(file.path(outdir, "webGL", "actest2.stl"))
writePLY(file.path(outdir, "webGL", "actest2.ply"))


drawScene.rgl(ac3)
writeOBJ(file.path(outdir, "webGL", "diff.obj"))
writeSTL(file.path(outdir, "webGL", "diff.stl"))
writePLY(file.path(outdir, "webGL", "diff.ply"))


