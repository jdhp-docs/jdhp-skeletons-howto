# LIST OF FILES TO MAKE #######################################################

# PUT HERE THE LIST OF FILES TO MAKE
# (E.G. "FILES_TO_MAKE = foo.png bar.svg baz.png")

FILES_TO_MAKE = 

###############################################################################

.PHONY: all clean

all: $(FILES_TO_MAKE)

# DESCRIBE HERE HOW TO MAKE EACH FILE #########################################

%.py.png: %.py
	python3 $<

%.py.svg: %.py
	python3 $<

%.tex.png: %.tex
	# Taken from https://github.com/jeremiedecock/latex2png
	latex -interaction=nonstopmode $< 1> /dev/null 2>&1
	dvipng -q -T tight -D 300 `echo $< | sed "s/\.tex/\.dvi/"` -o $@ 1> /dev/null 2>&1

%.tex.svg: %.tex
	# Taken from https://github.com/jeremiedecock/latex2png
	latex -interaction=nonstopmode $< 1> /dev/null 2>&1
	dvisvgm -n `echo $< | sed "s/\.tex/\.dvi/"` -o $@ 1> /dev/null 2>&1

# CLEAN #######################################################################

clean:
	# Latex generated files
	rm -vf *.aux  *.dvi  *.log
	# Generated files
	@if [ -n "$(FILES_TO_MAKE)" ] ; then rm -v $(FILES_TO_MAKE) ; fi
