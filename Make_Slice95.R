library(oro.nifti)

data <- readNIfTI("~/Dropbox/FOR_JOHN/Lesion_Movies/T2movie.nii.gz", reorient=FALSE)

newdat <- array(NA, dim=dim(data)[c(1,2, 4)])
for (iimg in 1:dim(data)[4]){
	newdat[,,iimg] <- data[,,95, iimg]
}
newdat <- nifti(newdat)
writeNIfTI(newdat, filename="~/Dropbox/3DPDF_Example/Presentation/Slice95")