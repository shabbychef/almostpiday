######################
# 
# Created: 2017.03.12
# Copyright: Steven E. Pav, 2017
# Author: Steven E. Pav
# SVN: $Id$
######################

############### FLAGS ###############

OWNER        = $(shell whoami)
THIS_HOST    = $(shell hostname)
CWD          = $(shell pwd)

############## DEFAULT ##############

default : all

############## MARKERS ##############

.PHONY   : 
.SUFFIXES: .html .md .Rmd
.PRECIOUS: %.html %.md 

############ BUILD RULES ############

all : index.md index.html
	
# compile and convert
%.md %.html : %.Rmd
	r -l slidify -e 'slidify("$<")'

#for vim modeline: (do not edit)
# vim:ts=2:sw=2:tw=79:fdm=marker:fmr=FOLDUP,UNFOLD:cms=#%s:tags=.tags;:syn=make:ft=make:ai:si:cin:nu:fo=croqt:cino=p0t0c5(0:
