#########################################################################
# ejemplo de Makefile para aplicaciones roku.
#
# uso del Makefile:
# > make
# > make install
# > make remove
#
##########################################################################  
APPNAME = miaplicacion
APPTITLE = miaplicacion

##########################################################################
APPDEPS = manifest count_functions
ZIP_EXCLUDE = -x .git\* -x manifest.template -x \*.swp -x \*.DS_Store -x \*.py -x roku_screenshot.jpg
include ../app.mk



num_functions := $(shell grep -ri --include=*.brs 'end \(function\|sub\)' . | wc -l | tr -d ' ')

.PHONY: manifest count_functions beta dev rel test

beta: APPTITLE = $APPNAME_Beta
beta: $(APPNAME)

test: APPTITLE = $APPNAME_Test
test: $(APPNAME)

dev: APPTITLE = $APPNAME_Dev
dev: $(APPNAME)

rel: APPTITLE = $APPNAME
rel: $(APPNAME)

manifest:
	echo "Creating manifest for $(APPTITLE)"
	sed s/APPTITLE/$(APPTITLE)/ < manifest.template > manifest

count_functions:
	echo "Counting functions for $(APPTITLE), some Rokus limit to 768"
	test $(num_functions) -le 768

screenshot:
	$(CURL) -s -F passwd= -F mysubmit=Screenshot -F "archive=;filename=" -H "Expect:" "http://$(ROKU_DEV_TARGET)/plugin_inspect" > /dev/null
	$(CURL) -s "http://$(ROKU_DEV_TARGET)/pkgs/dev.jpg" > roku_screenshot.jpg

all: $(APPNAME)
