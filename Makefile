############################################################################
# Copyright 2009, 2010 Benjamin Kellermann                                 #
#                                                                          #
# This program is free software: you can redistribute it and/or modify it  #
# under the terms of the GNU General Public License as published by the    #
# Free Software Foundation, either version 3 of the License, or (at your   #
# option) any later version.                                               #
#                                                                          #
# This program is distributed in the hope that it will be useful, but      #
# WITHOUT ANY WARRANTY; without even the implied warranty of               #
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU        #
# General Public License for more details.                                 #
#                                                                          #
# You should have received a copy of the GNU General Public License along  #
# with this program.  If not, see <http://www.gnu.org/licenses/>.          #
############################################################################

############################################################################
# This is a Makefile to compile LaTeX files                                #
# try: make watch                        # requires inotifytools           #
#      make <presentationfilename>_notes # requires bensbeamernotepage     #
#      make watchtikz_<picturefile>                                        #
############################################################################

# the documents to be compiled by default
DOC=$(foreach i,$(filter-out $(wildcard *_notes.tex),$(shell grep -l documentclass *.tex)), $(basename $i))

# dir to scp the main documents to (for "publish" target)
PUBLISH=dud.inf.tu-dresden.de:public_html

# if svgs should be compiled as pdf or png
SVG_TARGET_EXT=pdf

# your favorite pdf viewer 
# (I recommend evince or okular as they update rebuilt pdfs automatically)
PDFVIEWER=acroread

# the command to call latex, e.g. pdflatex or xelatex
# LATEXCMD=xelatex -interaction=nonstopmode
LATEXCMD=pdflatex -interaction=nonstopmode -synctex=1

# the directory where pictures are inside 
# (for automatic compiling .svg (inkscape) or .tex (pgf))
PICDIR=pic

# should the declaration \pgfrealjobname{} be checked?
CHECKPGFREALJOBNAME=true

# all extensions which should be deleted with make clean
TEXEXT=log aux toc synctex.gz pdfsync
# hyperref
TEXEXT+=out
# bibtex
TEXEXT+=bbl blg
# thumbpdf
TEXEXT+=tpt
# makeindex
TEXEXT+=ist
# glossaries
TEXEXT+=glo glg gls
# latex-beamer
TEXEXT+=nav snm
# ntheorem
TEXEXT+=thm
# changebar
TEXEXT+=cb2 cb
# insdljs
TEXEXT+=djs
# vim-latexsuite
TEXEXT+=tex.latexmain
# other stuff, whereever it came from
TEXEXT+=url ilg brf lof lot loc nav nlo snm idx

PIC=$(addsuffix .$(SVG_TARGET_EXT),$(basename $(wildcard $(PICDIR)/*.svg))) 
PIC+=$(foreach i,$(wildcard *.tex.erb),$(shell basename $i .erb))

TIKZPIC=$(addsuffix .pdf,$(foreach i,$(wildcard $(PICDIR)/*.tex),$(shell basename $i .tex)))

default: $(foreach i,$(DOC),$i.pdf)

$(PICDIR): $(PIC)

tikzpics: $(TIKZPIC)

$(DOC)_notes.pdf: $(DOC).pdf


%.pdf: %.tex $(wildcard *.tex) $(PIC) $(wildcard *.sty)
	$(call checkForRunningProcess,$*)
	$(call checkForPGFrealjobname,$*)
	touch $*.tex.latexmain
	$(LATEXCMD) $*
	make $*.bbl
	if [ "`grep makeglossaries *.tex`" ];then\
		make $*.gls;\
	fi
	$(LATEXCMD) $*
	$(LATEXCMD) $*

final: $(foreach i,$(DOC),$i_final.pdf)
%_final.pdf: %.pdf
	$(call checkForRunningProcess,$*)
	make $*.tpt
	$(LATEXCMD) $*
	qpdf --linearize $*.pdf $*_tmp.pdf
	mv $*_tmp.pdf $*.pdf
	cp $*.pdf $*_final.pdf

publish: $(foreach i,$(DOC),publish_$i)
publish_%: %_final.pdf
	scp $(foreach e,bib pdf,$(wildcard $*.$e)) $(PUBLISH)

clean:
	rm -f $(foreach ext,$(TEXEXT),*.$(ext))
	rm -f $(PIC) $(TIKZPIC)
	rm -f $(foreach i,$(DOC),$i_notes.tex)

distclean: $(foreach i,$(DOC),distclean_$i)
distclean_%: clean
	rm -f $(foreach ext,.pdf _notes.pdf,$*$(ext))

checkForRunningProcess = \
	@if [ -f /tmp/$(1)_watch.pid ];then\
		WATCHID=`cat /tmp/$(1)_watch.pid`;\
		if [ `ps --pid $$WATCHID|wc -l` = 2 ];then\
			echo "\033[31mThere is a \"make watch\" running!\033[0m";\
			return 1;\
		fi;\
	fi
	
ifeq ($(CHECKPGFREALJOBNAME),true)
checkForPGFrealjobname = \
	@if [ "`grep pgfrealjobname *.tex`" ];then\
		PGFREALJOBNAME="`grep pgfrealjobname *.tex|cut -f2 -d\{|cut -f1 -d\}`";\
		if [ "$$PGFREALJOBNAME" != "$*" ];then echo "\033[31m\\pgfrealjobname{$$PGFREALJOBNAME} is set to a wrong value! I expected:\n\\pgfrealjobname{$*}\033[0m"; return 1; fi;\
	fi
else
checkForPGFrealjobname = 
endif

watch: $(foreach i,$(DOC),watch_$i)
watch_%: %.pdf
	$(call checkForRunningProcess,$*)
	echo $$PPID > /tmp/$*_watch.pid
	cp $< /tmp/
	if [ -z "`ps x |grep "$(PDFVIEWER) /tmp/$<" |grep -v grep`" ];then $(PDFVIEWER) /tmp/$<; fi&
	COMPILEFILE=$*;\
	while true; do\
		rm *.tex.latexmain;\
		touch $$COMPILEFILE.tex.latexmain;\
		FILE=`inotifywait -r -e close_write --format="%w%f" --exclude '(/[^\\.]*\$$|\\.swp\$$|qt_temp\\..*)' . $$HOME/texmf/ 2>/dev/null`;\
		EXT=`echo $$FILE|sed -e 's/^.*\.\([^.]*\)$$/\1/g'`;\
		FILEBASENAME=`basename $$FILE .$$EXT`;\
		LACHECK=false;\
		case $$EXT in\
		tex)\
			if [ -f $${FILEBASENAME}_notes.tex ]; then make $${FILEBASENAME}_notes.tex; fi;\
			if [ "`echo $$FILE|grep '^\./$(PICDIR)/'`" != "" ]; then make $$FILEBASENAME.pdf; fi;\
			LACHECK=true;\
			;;\
		sty|cls)\
			LACHECK=true;\
			;;\
		pdf|png|jpg)\
			;;\
		bib)\
			bibtex $*;\
			$(LATEXCMD) $$COMPILEFILE;\
			LACHECK=true;\
			;;\
		svg)\
			make $(PICDIR)/$$FILEBASENAME.$(SVG_TARGET_EXT);\
			;;\
		erb)\
			make $$FILEBASENAME;\
			;;\
		latexmain)\
			COMPILEFILE=`basename $$FILEBASENAME .tex`;\
			echo "Switching \$$COMPILEFILE to $$COMPILEFILE";\
			continue;\
			;;\
		*)\
			echo "$$FILE was modified and I don't know what to do!";\
			continue;\
			;;\
		esac;\
		$(LATEXCMD) $$COMPILEFILE;\
		if [ $$? -eq 0 ];then\
			if [ "`grep 'LaTeX Warning: Citation .* on page .* undefined' $$COMPILEFILE.log`" ];then\
				bibtex $*;\
				$(LATEXCMD) $$COMPILEFILE;\
				$(LATEXCMD) $$COMPILEFILE;\
			fi;\
			if [ "`grep 'pdfTeX warning (dest): name{glo:.*} has been referenced but does not' $$COMPILEFILE.log`" ];then\
				makeglossaries $*;\
				$(LATEXCMD) $$COMPILEFILE;\
				$(LATEXCMD) $$COMPILEFILE;\
			fi;\
			if [ $$LACHECK = true ];then lacheck $$FILE; fi;\
			cp $$COMPILEFILE.pdf /tmp/$<;\
		else\
			if [ $$LACHECK = true ];then lacheck $$FILE; fi;\
			echo "\033[31mSOMETHING WENT WRONG, PLEASE CHECK THE CONSOLE!!!\033[0m";\
		fi;\
	done

watchtikz_%: %.pdf
	cp $< /tmp/
	if [ -z "`ps x |grep "$(PDFVIEWER) /tmp/$<" |grep -v grep`" ];then $(PDFVIEWER) /tmp/$<; fi&
	while true; do\
		inotifywait -r -e close_write --exclude '(/[^\\.]*\$$|\\.swp\$$)' $(PICDIR) 2>/dev/null;\
		$(LATEXCMD) --jobname=$* $(DOC);\
		if [ $$? -eq 0 ];then\
			cp $*.pdf /tmp/$<;\
		else\
			echo "\033[31mSOMETHING WENT WRONG, PLEASE CHECK THE CONSOLE!!!\033[0m";\
		fi;\
	done

.PHONY: default final clean distclean watch tikzpics $(PICDIR)

.SECONDARY:

%_notes.tex: %.tex
	sed -e 's/\\begin{document}/\\usepackage[previewfilename=$*]{bensbeamernotepage}\\begin{document}/g' $< > $@

%.tex: %.tex.erb
	erb $< >$@

%.bbl: %.aux $(wildcard *.bib)
	if test "`grep citation $*.aux`" -a "`grep 'bibliography{.*}' $*.tex`"; then bibtex $*; fi

%.tpt: %.pdf 
	thumbpdf $< 

%.gls: $(wildcard *.tex)
	makeglossaries $*
	$(LATEXCMD) $*
	makeglossaries $*

$(PICDIR)/%.pdf: $(PICDIR)/%.svg
	inkscape --export-pdf=$@ $<

%.pdf: $(PICDIR)/%.tex
	$(LATEXCMD) --jobname=$* $(DOC)
	$(LATEXCMD) --jobname=$* $(DOC)
	$(LATEXCMD) --jobname=$* $(DOC)

$(PICDIR)/%.png: $(PICDIR)/%.svg
	inkscape --export-png=$@ -w1000 $<
