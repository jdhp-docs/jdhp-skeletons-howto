include meta.make

###############################################################################

SUBDIRS = figs

SRCFILES = Makefile \
           main.rst \
           content/*.rst

.PHONY : all clean init open html pdf odt pdf-latex slides jdhp publish $(SUBDIRS)

all: $(FILE_BASE_NAME).html $(FILE_BASE_NAME).pdf

# SUBDIRS #####################################################################

$(SUBDIRS):
	$(MAKE) --directory=$@

# OPEN IN WEB BROWSER #########################################################

# TODO: follow the full setup procedure (with NodeJS) described there
#       https://github.com/hakimel/reveal.js/#full-setup

# Inspired by https://git.kernel.org/cgit/git/git.git/tree/config.mak.uname
# See also http://stackoverflow.com/questions/3466166/

# If uname not available then UNAME_S is set to 'unknown' 
UNAME_S := $(shell sh -c 'uname -s 2>/dev/null || echo unknown')

open: $(SUBDIRS)
# Linux ###############################
# See: http://askubuntu.com/questions/8252/
ifeq ($(UNAME_S),Linux)
	@xdg-open main.html
endif

# MacOSX ##############################
ifeq ($(UNAME_S),Darwin)
	@open -a firefox main.html
	#open -a Google\ Chrome main.html
endif

# Windows #############################
ifneq (,$(findstring CYGWIN,$(UNAME_S)))
	@#start chrome  main.html
	@start firefox  main.html
endif
ifneq (,$(findstring MINGW32,$(UNAME_S)))
	@#start chrome  main.html
	@start firefox  main.html
endif
ifneq (,$(findstring MSYS,$(UNAME_S)))
	@#start chrome  main.html
	@start firefox  main.html
endif

# MAKE PDF ####################################################################

pdf: $(FILE_BASE_NAME).pdf $(SUBDIRS)

# TODO: follow the full setup procedure (with NodeJS) described there
#       https://github.com/hakimel/reveal.js/#full-setup

$(FILE_BASE_NAME).pdf: $(SRCFILES)
	@echo "Not fully available yet"           # TODO
# Linux ###############################
# See: http://askubuntu.com/questions/8252/
ifeq ($(UNAME_S),Linux)
	@xdg-open main.html?print-pdf
endif

# MacOSX ##############################
ifeq ($(UNAME_S),Darwin)
	@open -a Google\ Chrome main.html?print-pdf
endif

# Windows #############################
ifneq (,$(findstring CYGWIN,$(UNAME_S)))
	@start chrome  main.html?print-pdf
endif
ifneq (,$(findstring MINGW32,$(UNAME_S)))
	@start chrome  main.html?print-pdf
endif
ifneq (,$(findstring MSYS,$(UNAME_S)))
	@start chrome  main.html?print-pdf
endif


## ARTICLE ####################################################################

# HTML ############

html: $(FILE_BASE_NAME).html

$(FILE_BASE_NAME).html: $(SRCFILES)
	rst2html --title="$(TITLE)" --date --time --generator \
		--language=$(LANGUAGE) --tab-width=4 --math-output=$(MATH_OUTPUT) \
		--source-url="$(SOURCE_URL)" --stylesheet=$(HTML_STYLESHEET) \
		--section-numbering --embed-stylesheet --strip-comments \
		main.rst $@

# PDF #############

pdf: $(FILE_BASE_NAME).pdf

$(FILE_BASE_NAME).pdf: $(SRCFILES)
	rst2pdf --language=$(LANGUAGE) --repeat-table-rows -o $@ main.rst

# ODT #############

odt: $(FILE_BASE_NAME).odt

$(FILE_BASE_NAME).odt: $(SRCFILES)
	rst2odt main.rst $@

# PDF Latex #######

pdf-latex: $(FILE_BASE_NAME).latex.pdf

$(FILE_BASE_NAME).latex.pdf: $(SRCFILES)
	#pandoc --toc -N  -V papersize:"a4paper" -V geometry:"top=2cm, bottom=3cm, left=2cm, right=2cm" -V "fontsize:12pt" -o $@ main.rst
	pandoc --toc -N  -V papersize:"a4paper" -V "fontsize:12pt" -o $@ main.rst

## SLIDES #####################################################################

slides: $(FILE_BASE_NAME)_slides.html

$(FILE_BASE_NAME)_slides.html: $(SRCFILES)
	rst2s5 --title=$(TITLE) --date --time --generator \
		--language=$(LANGUAGE) --tab-width=4 --math-output=$(MATH_OUTPUT) \
		--source-url=$(SOURCE_URL) \
		main.rst $@


# PUBLISH #####################################################################

publish: jdhp

jdhp: $(FILE_BASE_NAME).html $(FILE_BASE_NAME).pdf $(SUBDIRS)
	
	########
	# HTML #
	########
	
	# JDHP_DOCS_URI is a shell environment variable that contains the
	# destination URI of the HTML files.
	@if test -z $$JDHP_DOCS_URI ; then exit 1 ; fi
	
	# Copy HTML
	@rm -rf $(HTML_TMP_DIR)/
	@mkdir $(HTML_TMP_DIR)/
	cp -v $(FILE_BASE_NAME).html $(HTML_TMP_DIR)/
	cp -vr figs $(HTML_TMP_DIR)/
	rm -rf $(HTML_TMP_DIR)/figs/logos
	
	# Upload the HTML files
	rsync -r -v -e ssh $(HTML_TMP_DIR)/ ${JDHP_DOCS_URI}/$(FILE_BASE_NAME)/
	
	#######
	# PDF #
	#######
	
	# JDHP_DL_URI is a shell environment variable that contains the destination
	# URI of the PDF files.
	@if test -z $$JDHP_DL_URI ; then exit 1 ; fi
	
	# Upload the PDF file
	rsync -v -e ssh $(FILE_BASE_NAME).pdf ${JDHP_DL_URI}/pdf/

## CLEAN ######################################################################

clean:
	@echo "Remove generated files"
	@rm -rvf ui/
	@rm -rvf $(HTML_TMP_DIR)/
	$(MAKE) clean --directory=figs

init: clean
	@echo "Remove target files"
	@rm -vf $(FILE_BASE_NAME).html
	@rm -vf $(FILE_BASE_NAME).pdf
	@rm -vf $(FILE_BASE_NAME).latex.pdf
	@rm -vf $(FILE_BASE_NAME).odt
	@rm -vf $(FILE_BASE_NAME).latex
	@rm -vf $(FILE_BASE_NAME)_slides.html
