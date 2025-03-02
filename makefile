# ------------------------------------------------
# Project Makefile (Maintained by David Lee McDanel)
# Date  : 2025-03-01
# License: CC BY-SA 3.0 (inherited from original work)
# ------------------------------------------------
#
# ------------------------------------------------
# Changelog :
#   2010-11-05 - First version by yanick.rochon@gmail.com
#   2011-08-10 - Added src/obj/bin structure (thanks to Beta http://stackoverflow.com/users/128940/beta)
#   2017-04-24 - changed order of linker params - David Lee McDanel
#   2018-05-05 - Changed to C++, added target based upon project root DLM
#   2018-07-14 - Added phony; all, clean, remove, commit and run. DLM
#	2019-09-16 - Added pull and push. DLM
#   2019-09-28 - Added doxygen. DLM
#   2020-04-11 - Removed doxygen and related wiki git items.  Created new repo for documentation. DLM
#	2020-04-11 - Added ability to add git comments to the commit. DLM
#	2021-06-19 - Added install, uninstall, dummy init and fixed typos. DLM
#	2024-12-01 - Added define "BUILD_SYSTEM_OKAY" to be used with VSCODE. DLM
#   2025-01-26 - Modified install, target as install directory name. DLM
#   2025-02-23 - Added doxygen, again. DLM
#   2025-02-23 - Modified to keep ./docs with PlaceHolder.txt, added docsclean target. DLM
#	2025-02-23 - Added DOCDIR for documentation directory. DLM
#	2025-02-25 - Added VERSION for single point version documentation. DLM
#	2025-02-26 - Added automatic version bumps. DLM
#	2025-02-27 - Allow overriding CC and LINKER via environment variables or command line.
#				 Add a toggle for debug (-g -O0) vs. release (-O2)
#				 Modified install and uninstall for Windows and Linux.
#				 Added permissions warning for Unix install to /usr/bin requiring sudo.
#                Added config file backup before overwriting during install.
#                Added cleanup of empty config directory during uninstall.
#                Quoted executable path in run target for paths with spaces.
#                Fixed missing quote in VERSION_STRING definition in version.h.
#                (Changes refined with assistance from Grok 3 by xAI) DLM
#	2025-03-01 - Changed title of the makefile. DLM
#				 Changed CC to CXX and CFLAGS to CXXFLAGS. DLM
# ------------------------------------------------

# project name (generate executable with this name)
TARGET ?= $(notdir $(shell pwd))
TARGET_DIR = $(shell pwd)
PROJECT_NAME = "Hello World! - For C++"

BUILDID=$(shell date +%Y%m%d-%H:%M:%S)
COMMIT_COMMENT?='Automatic commit of successful build.'

HOMEDIR= ../

# change these to proper sub-directories where each file should be located
SRCDIR = ./Source_Files
HDRDIR = ./Header_Files
OBJDIR = ./obj
BINDIR = ./bin
DOCDIR = ./docs

SOURCES := $(wildcard $(SRCDIR)/*.cpp)
OBJECTS := $(SOURCES:$(SRCDIR)/%.cpp=$(OBJDIR)/%.o)
DEPS := $(OBJECTS:.o=.d)

# Replace VERSION_STRING definition and all target
# Read VERSION_STRING from version.h and update on build
VERSION_STRING := $(shell grep 'define VERSION_STRING' $(HDRDIR)/version.h | sed 's/.*VERSION_STRING "\(.*\)"/\1/')
export VERSION_STRING

# Detect OS
ifeq ($(OS),Windows_NT)
    # Windows-specific settings
    INSTALL_DIR = /c/Users/$(USERNAME)/AppData/Local/$(TARGET)
    CONFIG_DIR = $(INSTALL_DIR)/config
else
    # Unix-specific settings
    INSTALL_DIR = $(HOME)/bin
    CONFIG_DIR = $(HOME)
endif

RM = rm -f
MKDIR = mkdir -p
INSTALL = install
FIND = /usr/bin/find

CXX ?= g++
# compiling flags here
CXXFLAGS = -std=c++17 -I$(HDRDIR) -Wall -I. -DBUILD_SYSTEM_OKAY -MMD -MP

LINKER ?= g++
# linking flags here
#LFLAGS = -Wall -I. -lm -lpthread -lpigpio -lrt
#LFLAGS = -Wall -I. -lm -lpthread -Wl,-subsystem,windows
LFLAGS   = -Wall -I. -lm -lpthread

BUILD_TYPE ?= debug
ifeq ($(BUILD_TYPE),release)
    CXXFLAGS += -O2
else
    CXXFLAGS += -g -O0
endif

$(BINDIR)/$(TARGET): $(OBJECTS)
	@$(LINKER) $(OBJECTS) $(LFLAGS) -o $@
	@echo "Linking complete!"

$(OBJECTS): $(OBJDIR)/%.o : $(SRCDIR)/%.cpp
	@$(CXX) $(CXXFLAGS) -c $< -o $@
	@echo "Compiled "$<" successfully!"

.PHONY: all
all: check-tools bump-version $(BINDIR)/$(TARGET)

.PHONY: bump-version
bump-version: $(HDRDIR)/version.h
	@CURRENT_VERSION=$$(grep 'define VERSION_STRING' $(HDRDIR)/version.h | sed 's/.*VERSION_STRING "\(.*\)"/\1/'); \
	MAJOR=$$(echo $$CURRENT_VERSION | cut -d'.' -f1); \
	MINOR=$$(echo $$CURRENT_VERSION | cut -d'.' -f2); \
	PATCH=$$(echo $$CURRENT_VERSION | cut -d'.' -f3); \
	NEW_PATCH=$$((PATCH + 1)); \
	NEW_VERSION="$$MAJOR.$$MINOR.$$NEW_PATCH"; \
	sed -i "s/VERSION_STRING \".*\"/VERSION_STRING \"$$NEW_VERSION\"/" $(HDRDIR)/version.h; \
	echo "Updated version to $$NEW_VERSION in $(HDRDIR)/version.h"

$(HDRDIR)/version.h:
	@echo "/** @file version.h" >> $@
	@echo " * @brief Auto-generated version file.  Do not modify this file directly." >> $@
	@echo " */" >> $@
	@echo "#ifndef VERSION_H" >> $@
	@echo "#define VERSION_H" >> $@
	@echo "#define VERSION_STRING \"0.0.1\"" >> $@
	@echo "#endif" >> $@
	@echo "Created initial $(HDRDIR)/version.h with version 0.0.1"

.PHONY: clean
clean:
	@$(RM) $(OBJECTS) $(DEPS)
	@echo "Object cleanup complete!"
	@$(RM) $(BINDIR)/$(TARGET)
	@echo "Executable removed!"

.PHONY: check-tools 
check-tools:
	@command -v $(CXX) >/dev/null 2>&1 || { echo "Error: $(CXX) not found"; exit 1; }
	@command -v doxygen >/dev/null 2>&1 || { echo "Warning: doxygen not found, 'docs' target will fail"; }

.PHONY: docsclean
docsclean:
	@test -d $(DOCDIR) && cd $(DOCDIR) && $(FIND) . -type f -not -name "PlaceHolder.txt" -exec rm -f {} \;
	@test -d $(DOCDIR) && cd $(DOCDIR) && $(FIND) . -type d -not -path . -exec rmdir {} \; 2>/dev/null || true
	@echo "Documentation cleaned, preserving PlaceHolder.txt!"

.PHONY: docsinit
docsinit:
	@test -d $(DOCDIR) || mkdir $(DOCDIR)
	@test -f $(DOCDIR)/PlaceHolder.txt || echo "Placeholder for docs directory" > $(DOCDIR)/PlaceHolder.txt
	@echo "$(DOCDIR)/PlaceHolder.txt created!"

.PHONY: docs
docs: docsinit docsclean
	@sed -i '/^INPUT[ \t]*=/c\INPUT = . $(SRCDIR) $(HDRDIR)' Doxyfile || echo "INPUT = . $(SRCDIR) $(HDRDIR)" >> Doxyfile
	@sed -i '/^OUTPUT_DIRECTORY[ \t]*=/c\OUTPUT_DIRECTORY = $(DOCDIR)' Doxyfile || echo "OUTPUT_DIRECTORY = $(DOCDIR)" >> Doxyfile
	@sed -i '/^ENABLE_PREPROCESSING[ \t]*=/c\ENABLE_PREPROCESSING = YES' Doxyfile || echo "ENABLE_PREPROCESSING = YES" >> Doxyfile
	@sed -i '/^MACRO_EXPANSION[ \t]*=/c\MACRO_EXPANSION = YES' Doxyfile || echo "MACRO_EXPANSION = YES" >> Doxyfile
	@sed -i '/^EXPAND_ONLY_PREDEF[ \t]*=/c\EXPAND_ONLY_PREDEF = YES' Doxyfile || echo "EXPAND_ONLY_PREDEF = YES" >> Doxyfile
	@sed -i '/^EXPAND_AS_DEFINED[ \t]*=/c\EXPAND_AS_DEFINED = VERSION_STRING' Doxyfile || echo "EXPAND_AS_DEFINED = VERSION_STRING" >> Doxyfile
	@sed -i '/^PREDEFINED[ \t]*=/c\PREDEFINED =' Doxyfile || echo "PREDEFINED =" >> Doxyfile
	@sed -i '/^PROJECT_NUMBER[ \t]*=/c\PROJECT_NUMBER = \"$(VERSION_STRING)\"' Doxyfile || echo "PROJECT_NUMBER = \"$(VERSION_STRING)\"" >> Doxyfile
	@sed -i '/^PROJECT_NAME[ \t]*=/c\PROJECT_NAME = $(PROJECT_NAME)' Doxyfile || echo "PROJECT_NAME = \"$(PROJECT_NAME)\"" >> Doxyfile
	@doxygen Doxyfile
	@echo "Doxygen documentation generated in $(DOCDIR)/"

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
	"$(BINDIR)/$(TARGET)"

.PHONY: install
install: $(TARGET_DIR)/.$(TARGET)/$(TARGET).conf $(BINDIR)/$(TARGET)
	@if [ "$(INSTALL_DIR)" = "/usr/bin" ] && [ ! -w "$(INSTALL_DIR)" ]; then \
		echo "Warning: $(INSTALL_DIR) requires sudo; run 'sudo make install'"; \
		exit 1; \
	fi
	@$(MKDIR) "$(INSTALL_DIR)" || { echo "Error: Failed to create $(INSTALL_DIR)"; exit 1; }
	@$(INSTALL) $(BINDIR)/$(TARGET) "$(INSTALL_DIR)/"
	@$(MKDIR) "$(CONFIG_DIR)" || { echo "Error: Failed to create $(CONFIG_DIR)"; exit 1; }
	@if [ -f "$(CONFIG_DIR)/$(TARGET).conf" ]; then \
		cp "$(CONFIG_DIR)/$(TARGET).conf" "$(CONFIG_DIR)/$(TARGET).conf.bak"; \
		echo "Backed up existing config to $(CONFIG_DIR)/$(TARGET).conf.bak"; \
	fi
	@$(INSTALL) $(TARGET_DIR)/.$(TARGET)/$(TARGET).conf "$(CONFIG_DIR)/$(TARGET).conf" || \
		{ echo "Warning: Config file not found, skipping"; }
	@echo "Installed $(TARGET) to $(INSTALL_DIR)"
	@echo "Configuration file placed at $(CONFIG_DIR)/$(TARGET).conf"

.PHONY: uninstall
uninstall:
	@$(RM) "$(INSTALL_DIR)/$(TARGET)"
	@$(RM) "$(CONFIG_DIR)/$(TARGET).conf"
	@if [ -d "$(CONFIG_DIR)" ] && [ -z "$$(ls -A "$(CONFIG_DIR)")" ]; then \
		rmdir "$(CONFIG_DIR)"; \
		echo "Removed empty $(CONFIG_DIR)"; \
	fi
	@echo "Uninstalled $(TARGET) from $(INSTALL_DIR)"
	@echo "Removed config from $(CONFIG_DIR)"

$(TARGET_DIR)/.$(TARGET)/$(TARGET).conf:
	@mkdir -p $(TARGET_DIR)/.$(TARGET)
	@echo "# Default config for $(TARGET)" > $@
	@echo "Created default config at $@"

.PHONY: init
init:
	@echo "This is a holder to provide compatibility. Init complete!"

-include $(DEPS)
