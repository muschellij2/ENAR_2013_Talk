####################################################
#                                                  #
# The Figure 3 of the manuscript has been created  #
# using demo("dti_art") of the dti package.        #
# The noise level has been choosen as 4000.        #
# All other choices are default.                   #
# Note, that the 3D images in the figure are       #
# positioned with mouse interaction, such that     #
# the exact figures are unlikely to be reproduced! #
#                                                  #
####################################################



##################################################################################
# This script uses data from the CIBC Datasets Archive                           #
#                                                                                #
# http://www.sci.utah.edu/releases/scirun_v4.1/SCIRunData_4.1_20090629_data.tgz  #
#                                                                                #
# which is part of the SCIRun software version (4.1)                             # 
# http://www.sci.utah.edu/download/scirun/4.1.html                               #
#                                                                                #
# The data set has to be downloaded separately! Also note the mandatory          #
# acknowledgment if this dataset is used in any publication or                   #
# third-party work, see:                                                         #
#                                                                                #
# http://www.sci.utah.edu/cibc/software/114-cibcdata.html                        #
#                                                                                #
# Note, that the script has been tested with this version of the data.           #
# There have been problems with the read.nrrd() function in later versions.      #
#                                                                                #
# The complete script runs approx. 12 mins, depending on hardware!               #
#                                                                                #
##################################################################################

path2cibc <- "./brain-dt/"

# read function for NRRD-files
read.nrrd <- function(file,path="SCIRunData_4.1_20090629_data/brain-dt/"){
  if(!file.exists(file)&&!file.exists(paste(path,file,sep=""))) {
  cat("Please first download the data set from the CIBC Datasets Archive \n\n",
      "http://www.sci.utah.edu/releases/scirun_v4.1/SCIRunData_4.1_20090629_data.tgz\n\n",
      "which is part of the SCIRun software version (4.1)\n",
      "and unpack it into your current directory or provide a path to the data in 
       path2cibc \n\n")
  cat("Note the mandatory acknowledgment if this dataset is used in any 
       publication or third-party work, see:\n
       http://www.sci.utah.edu/cibc/software/114-cibcdata.html \n\n")
       stop("Stopping")
  } 
  if(!file.exists(file)) file <- paste(path,file,sep="")
  con <- file(file,"r")
  filetype <- readLines(con,n=1)
  count <- 1
  notempty <- TRUE
  while (notempty) {
     zzz <- readLines(con,n=1) 
     if (nchar(zzz)==0) {
        notempty <- FALSE
        count <- count+1
     } else {
        zzz <- strsplit(zzz,": ")
        what <- zzz[[1]][1]
        if (what=="type") type<-switch(zzz[[1]][2],float="numeric",integer="integer","integer")
        if (what=="dimension") dimension <- as.numeric(zzz[[1]][2])
        if (what=="sizes") sizes <- as.numeric(unlist(strsplit(zzz[[1]][2]," ")))
        if (what=="spacings") vextension <- as.numeric(unlist(strsplit(zzz[[1]][2]," ")))
        if (what=="endian") endian <- zzz[[1]][2]
        if (what=="encoding") encoding <- zzz[[1]][2]
        count <- count+1
     }
  }
  close(con)
  if(encoding=="raw"){
    con <- file(file,"rb")
    ttt <- readLines(con,n=count) # header again
    img <- readBin(con,type,n=prod(sizes),switch(type,numeric=4,integer=2),signed=FALSE,endian=endian)
    close(con)
  }
  invisible(array(img,sizes))
}

# read the data and create a prepared tmpfile, 
# corresponds to "self-prepared" binary image file
# see page 12 of manuscript
s0 <- read.nrrd("gkwi-1.5mm-B0.nrrd",path=path2cibc)
if(any(is.nan(s0))) stop("Please use the data from \n http://www.sci.utah.edu/releases/scirun_v4.1/SCIRunData_4.1_20090629_data.tgz \n")

ddim <- dim(s0)
si <- read.nrrd("gkwi-1.5mm-DWI.nrrd",path=path2cibc)
si <- aperm(si,c(2:4,1))
file <- "demo-gradients.txt"
if(!file.exists(file)) file <- paste(path2cibc,"demo-gradients.txt",sep="")
if(!file.exists(file)) stop("need file SCIRunData_4.1_20090629_data/brain-dt/demo-gradients.txt from  SCIRunData ")
grad <- rbind(c(0,0,0),read.table(file))
cat("Use of this data set was made possible in part by software from the \n NIH/NCRR Center for Integrative Biomedical Computing, P41-RR12553-10.\n")
s0[s0<0] <- 0
si[si<0] <- 0
s0[is.na(s0)] <- 0
si[is.na(si)] <- 0
rangesi <- range(s0,si)
si <- c(as.integer(32000*s0/rangesi[2]),as.integer(32000*si/rangesi[2]))
dim(si) <- c(ddim,dim(grad)[1])
tmpfile <- tempfile("gkwi-1.5")
con <- file(tmpfile,"wb")
writeBin(as.integer(si),con,2)
close(con)
rm(s0,rangesi,si,read.nrrd)
gc()

# start the analysis
library(dti)
data <- dtiData(grad,tmpfile,ddim,maxvalue=32000)
# data <- sdpar(data,interactive=FALSE,level=1300)
# # set to 1300, if you want to produce figure 2, run with TRUE
# sdgraph <- FALSE
# if (sdgraph) {
  # pdf("figure2.pdf",width=8,height=4)
  # par(mar=c(3,3,3,1),mgp=c(2,1,0))
  # data <- sdpar(data,interactive=TRUE,level=1300)
  # Y
  # dev.off()
# }

# create diffusion tensor estimates
tensor <- dtiTensor(data)

# create anisotropy indices
dtind <- dtiIndices(tensor)


w1 <- show3d( tensor,level=. 1,nz=3,center=ind,maxobjects=3*441,FOV=1,windowRect = c(1, 1, size, size),what="tensor")

