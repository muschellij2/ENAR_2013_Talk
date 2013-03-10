rm(list=ls())

	basedir <- "~/Dropbox/3DPDF_Example/Presentation/Slicer_Export_4D"
	codedir <- basedir
	moddir <- basedir
	## index is already converted
	index <- file.path(moddir, "index.html")
	
	ff <- file(index)
	
	dat <- readLines(ff)
	close(ff)
	
	index <- file.path(codedir, "Brain_Slice_Code_revised.txt")
	
	ff <- file(index)
	
	code <- readLines(ff)
	close(ff)
	
	
	type <- "checkbox"
	getitem <- file.path(codedir, "getItem.txt")
	if (type== "checkbox") getitem <- file.path(codedir, "getItem_checkbox.txt")
		
	ff <- file(getitem)
	
	getitem <- readLines(ff)
	close(ff)
	
	
	
	html.end <- grep(pattern="</body>", x=dat, fixed=TRUE)
	java.end <- grep(pattern="renderer0.render();", x=dat, fixed=TRUE)
	script.end <- grep(pattern="</script>", x=dat, fixed=TRUE)[2]
	
	dat <- data.frame(cbind(dat=dat, obj_num=cumsum(grepl(x=dat, pattern="new X\\."))), stringsAsFactors=FALSE)
	
	dropper <- function(x) return(x[x != ""])
	trim <- function (x) gsub("^\\s+|\\s+$", "", x)
	getInfo <- function(x, info) {
	#	print(x)
		if (info == "object"){
			x <- x[grep(x=x, pattern="(.*) = new X.*")]
			x <- gsub(x=trim(x), pattern="(.*) = new X.*", replacement = "\\1")
		} else {
			x <- x[grep(x=x, pattern=paste("\\.", info, sep=""))]
			x <- trim(gsub(x=x, pattern=paste("vtk.*.", info, " =(.*);", sep=""), replacement = "\\1"))
			x <- gsub(x=x, pattern="'", replacement = "")
			x <- gsub(x=x, pattern=".vtk", replacement = "", fixed=TRUE)
		}
			if (length(x) == 0) x <- NA
	#	print(length(x))
		return(x)
		}
		
	info <- sapply(c("caption", "file", "object"), function(type) tapply(dat$dat, dat$obj_num, getInfo, info=type))
	info <- info[!is.na(info[, "file"]), ]
	
	
	## making all rois invisible
	ROIS <-  info[grepl(x=c(info[, "caption"]), pattern="ROI"), "object"]
	for (iROI in 1:length(ROIS)) {
		dat$dat <- gsub(x=dat$dat, pattern = paste(ROIS[iROI], ".visible = true;", sep=""), replacement = paste(ROIS[iROI], ".visible = false;", sep=""), fixed=TRUE)
#		gsub(x=dat, pattern = paste(ROIS[iROI], ".opacity = .*;"), replacement = paste(ROIS[iROI], ".opacity = 0.0;"), fixed=TRUE)
	}	

	
	ROIS <- paste(paste("'", ROIS, "'", sep=""), collapse= ", ")
	
	addscript <- paste("ROIS = [", ROIS, "];", sep="")

	info <- info[order(info[, "caption"]),]
	
	brains <-  info[grepl(x=c(info[, "caption"]), pattern="Brain"), "object"]
	opac_brain <- c('function opac_brain(sliderID, textbox) {', '            var x = document.getElementById(textbox);', '            var y = document.getElementById(sliderID);', 
'    var val = y.value;',
'    x.value = val;',
'	low = Math.floor(val);',
'	op_low = (val - low);',
paste(brains[1], '.opacity = op_low;', sep=""),
paste(brains[1], '.visible = true;', sep=""),
'};')

## making all dup brains invisible and making one visible
	dat$dat <- gsub(x=dat$dat, pattern = paste(brains[1], ".visible = false;", sep=""), replacement = paste(brains[1], ".visible = true;", sep=""), fixed=TRUE)

	if (length(brains) > 1){
		for (ibrain in 2:length(brains)) {
			dat$dat <- gsub(x=dat$dat, pattern = paste(brains[ibrain], ".visible = true;", sep=""), replacement = paste(brains[ibrain], ".visible = false;", sep=""), fixed=TRUE)
	#		gsub(x=dat, pattern = paste(ROIS[iROI], ".opacity = .*;"), replacement = paste(ROIS[iROI], ".opacity = 0.0;"), fixed=TRUE)
		}	
		# stop("me")
		
	}	
	
	brains <- paste(paste("'", brains, "'", sep=""), collapse= ", ")
	if (length(brains) == 1) code <- gsub(x=code, pattern="o = eval(brains[1]);", replacement="o = eval(brains);", fixed=TRUE)
	addscript <- c(addscript, paste("brains = [", brains, "];", sep=""))
	
	info <-  info[grepl(x=c(info[, "caption"]), pattern="ROI"),]
	
	info <- cbind(info, obj_num = rownames(info))
	tmp <- matrix(unlist(info), nrow=nrow(info), ncol=ncol(info))
	colnames(tmp) <- colnames(info)
	rownames(tmp) <- rownames(info)
	info <- tmp
	info <- data.frame(info, stringsAsFactors=FALSE)
	
	info <- info[order(info$caption),]
	
	addhtml <- c('<FORM NAME = f1>', '<P align="center">')
	if (type== "checkbox")	addhtml <- c(addhtml, apply(info, 1, function(x) paste('<Input type = checkbox Name = r1 Value = "', x["object"], '" onClick =GetSelectedItem()>', x["caption"], sep="")), '</P>', '</FORM>') 
	else addhtml <- c(addhtml, apply(info, 1, function(x) paste('<Input type = radio Name = r1 Value = "', x["object"], '" onClick =GetSelectedItem()>', x["caption"], sep="")), '</P>', '</FORM>')
	
	# addhtml <- c(addhtml, "<div id='ROIS' class=\"anatomyBox\" onClick=\"show('ROIS');\" onMouseover=\"show('ROIS');\">", 
	# "      <span><img", 
	# "        src=\"viewall.png\" style=\"vertical-align: right\"> ROIs</span>", 
	# "    </div>"
	# )
	
	
	addmore <- NULL
	# addmore <- c('<fieldset>', '<div id="slider-v1-verticalWrapper" class="verticalWrapper">', '<input maxlength="6" name="slider1" id="slider-v1" type="text" title="Range: -10 to 10" class="" value="0" />', '</div>', '<script type="text/javascript" src="slider.js"></script>', '<script type="text/javascript">', '//<![CDATA[', 
	# '/*******************************************************************************',# ' Create the slider using JS',# ' ******************************************************************************/',# '// Remove the onload event as we are creating the sliders with a JS call',# 'fdSliderController.removeOnLoadEvent();',# '// Create an Object to hold the sliders initialisation data',# 'var options = {',# '        // A reference to the input',# '        inp:            document.getElementById("slider-v1"),',# '        // A String containing the increment value (and the return precision, in this case 2 decimal places "x.20")',# '        inc:            "0.10",',# '        // Maximum keyboard increment (automatically uses double the normal increment if not given)',# '        maxInc:         "1",',# '        // Numeric range',# paste('        range:          [1,', nrow(info), '],',sep=""),# '        // Callback functions',# '        callbacks:      { "update":[myObject.callback], "create":[setUpVerticalSliderOutput, myObject.callback] },',# '        // String representing the classNames to give the created slider',# '        classNames:     "verticalclass",',# '        // Tween the handle onclick?',# '        tween:          true,',# '        // Is this a vertical slider',# '        vertical:       true,',# '        // Do we hide the associated input on slider creation',# '        hideInput:      true,',# '        // Does the handle jump to the nearest click value point when the bar is clicked (tween cannot then be true)',# '        clickJump:      true,',# '        // Full ARIA required',# '        fullARIA:       false,',# '        // Do we disable the mouseWheel for this slider',# '        noMouseWheel:   false',# '};',# '// Create the slider',# 'fdSliderController.createSlider(options);',# '//]]>',# '</script></fieldset>')


	#printValue('slider2','rangeValue2');
	top <- nrow(info)-1
	step <- top/ 100
	addmore <- c(addmore, paste('<input id="slider2" type="range" min="0" max="', top, '" step="', step, "\" value=\"0\" onchange=\" show2('slider2','rangeValue2');\"/>", sep=""), '<input id="rangeValue2" type="text" size="10"/>')
	addmore <- c(addmore, paste('<input id="slider_brain" type="range" min="0.01" max="0.99" step="', 0.01, "\" value=\"0.50\" onchange=\"opac_brain('slider_brain','range_brain');\"/>", sep=""), '<input id="range_brain" type="text" size="10"/>')
	# addmore <- c(addmore, "<script type=\"text/javascript\"> show2('slider2','rangeValue2') </script>")
	dat <- dat$dat
	
	dat <- c(dat[1:java.end], dat[(java.end+1):(script.end-1)], addscript, getitem, code, opac_brain, dat[script.end], dat[(script.end+1):(html.end-1)], addhtml, addmore, dat[html.end:length(dat)])
	
	
	
	outfile <- file.path(moddir, "index_jsed.html")
	
	ff <- file(outfile)
	writeLines(dat, con=ff)
	close(ff)
	
