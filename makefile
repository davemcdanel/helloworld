# ------------------------------------------------
# Generic Makefile
#
# Author: yanick.rochon@gmail.com
# Date  : 2011-08-10
#
# Changelog :
#   2010-11-05 - first version
#   2011-08-10 - added structure : sources, objects, binaries
#                thanks to http://stackoverflow.com/users/128940/beta
#   2017-04-24 - changed order of linker params
#   2018-05-05 - Changed to C++, added target based upon project root - David Lee McDanel
#   2018-07-14 - Added phony; all, clean, remove, commit and run. DLM
#	2019-09-16 - Added pull and push. DLM
#   2019-09-28 - Added doxygen. DLM
#   2020-04-11 - Removed doxygen and related wiki git items.  Created new repo for documentation. DLM
#	2020-04-11 - Added ability to add git comments to the commit. DLM
#	2021-06-19 - Added install, uninstall, dummy init and fixed typos. DLM
#	2024-12-01 - Added define "BUILD_SYSTEM_OKAY" to be used with VSCODE.
#   2025-01-26 - Modified install, target as install directory name.
# ------------------------------------------------

# project name (generate executable with this name)
TARGET ?= $(notdir $(shell pwd))
TARGET_DIR = $(shell pwd)

BUILDID=$(shell date +%Y%m%d-%H:%M:%S)
COMMIT_COMMENT?='Automatic commit of successful build.'

HOMEDIR= ../

# change these to proper sub-directories where each file should be located
SRCDIR = ./Source_Files
HDRDIR = ./Header_Files
OBJDIR = ./obj
BINDIR = ./bin

SOURCES := $(wildcard $(SRCDIR)/*.cpp)
OBJECTS := $(SOURCES:$(SRCDIR)/%.cpp=$(OBJDIR)/%.o)

rm = rm -f

CC = g++
# compiling flags here
CFLAGS = -I$(HDRDIR) -Wall -I. -g -O0 -DBUILD_SYSTEM_OKAY

LINKER = g++
# linking flags here
#LFLAGS = -Wall -I. -lm -lpthread -lpigpio -lrt
#LFLAGS = -Wall -I. -lm -lpthread -Wl,-subsystem,windows
LFLAGS   = -Wall -I. -lm -lpthread

$(BINDIR)/$(TARGET): $(OBJECTS)
	@$(LINKER) $(OBJECTS) $(LFLAGS) -o $@
	@echo "Linking complete!"

$(OBJECTS): $(OBJDIR)/%.o : $(SRCDIR)/%.cpp
	@$(CC) $(CFLAGS) -c $< -o $@
	@echo "Compiled "$<" successfully!"

.PHONY: all
all: 
	clean $(BINDIR)/$(TARGET)

.PHONY: clean
clean:
	$(rm) $(OBJECTS)
	echo "Object cleanup complete!"
	$(rm) $(BINDIR)/$(TARGET)
	echo "Executable removed!"

.PHONY: commit
commit:
	cd $(TARGET_DIR) && \
		pwd && \
		git add -A . && \
		git commit -m "$(COMMIT_COMMENT) Build:$(BUILDID)"

.PHONY: push
push:
	git push origin master

.PHONY: pull
pull:
	git pull origin master

.PHONY: run
run: $(BINDIR)/$(TARGET)
	$(BINDIR)/$(TARGET)

.PHONY: install
install:
	$(rm) C:\Users\$(USERNAME)\appdata\Local\$(TARGET_DIR)\$(TARGET)
	install $(BINDIR)/$(TARGET) C:\Users\$(USERNAME)\appdata\Local\$(TARGET_DIR)\
	rm -fr $(HOMEDIR)/.$(TARGET)/
	install -d $(HOMEDIR)/.$(TARGET)/
	install $(TARGET_DIR)/.$(TARGET)/$(TARGET).conf $(HOMEDIR)/.$(TARGET)/$(TARGET).conf
	@echo Configuration file located $(HOMEDIR)/.$(TARGET)/.$(TARGET).conf
	@echo "$(TARGET) installed to C:\Users\$(USERNAME)\appdata\Local\$(TARGET_DIR)\ Install complete!"

.PHONY: uninstall
uninstall:
	@rm C:\Users\$(USERNAME)\appdata\Local\$(TARGET_DIR)\$(TARGET)\$(TARGET)
	@echo "$(TARGET) removed from C:\Users\$(USERNAME)\appdata\Local\$(TARGET_DIR)\ Uninstall complete!"

.PHONY: init
init:
	@echo "This is a holder to provide compatibility. Init complete!"

-include $(DEPS)
