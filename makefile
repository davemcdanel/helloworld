# Project Makefile
# Author: David Lee McDanel
# Date: 2025-03-02
# License: Public Domain (Unlicense) - see LICENSE.md
# Description: A custom Makefile for building, documenting, and installing the Hello World! - For C++ project.

# Project configuration
PROJECT_NAME = "Hello World! - For C++"
TARGET = $(notdir $(shell pwd))
BUILD_ROOT = $(shell pwd)
BUILD_ID = $(shell date +%Y%m%d-%H:%M:%S)
COMMIT_MSG ?= "Automatic commit of successful build."

# Directory structure
SOURCE_DIR = Source_Files
HEADER_DIR = Header_Files
OBJECT_DIR = obj
BINARY_DIR = bin
DOCUMENT_DIR = docs

# File collections
SOURCE_FILES := $(wildcard $(SOURCE_DIR)/*.cpp)
OBJECT_FILES := $(patsubst $(SOURCE_DIR)/%.cpp,$(OBJECT_DIR)/%.o,$(SOURCE_FILES))
DEPENDENCY_FILES := $(OBJECT_FILES:.o=.d)

# Version extraction
VERSION := $(shell grep 'define VERSION_STRING' $(HEADER_DIR)/version.h | sed 's/.*VERSION_STRING "\(.*\)"/\1/')

# Platform-specific settings
ifeq ($(OS),Windows_NT)
	INSTALL_PATH = /c/Users/$(USERNAME)/AppData/Local/$(TARGET)
	CONFIG_PATH = $(INSTALL_PATH)/config
else
	INSTALL_PATH = $(HOME)/bin
	CONFIG_PATH = $(HOME)
endif

# Toolchain configuration
REMOVE = rm -f
CREATE_DIR = mkdir -p
COPY = install
FIND_UTIL = /usr/bin/find

CXX ?= g++
CXXFLAGS = -std=c++17 -I$(HEADER_DIR) -Wall -DBUILD_SYSTEM_OKAY -MMD -MP
LINKER ?= g++
LDFLAGS = -Wall -lm -lpthread

# Build type toggle
BUILD_MODE ?= debug
ifeq ($(BUILD_MODE),release)
	CXXFLAGS += -O2
else
	CXXFLAGS += -g -O0
endif

# Primary build target
all: verify-tools update-version $(BINARY_DIR)/$(TARGET)

# Linking rule
$(BINARY_DIR)/$(TARGET): $(OBJECT_FILES)
	@$(CREATE_DIR) $(BINARY_DIR)
	@$(LINKER) $(OBJECT_FILES) $(LDFLAGS) -o $@
	@echo "Linked $(TARGET) successfully!"

# Compilation rule
$(OBJECT_DIR)/%.o: $(SOURCE_DIR)/%.cpp
	@$(CREATE_DIR) $(OBJECT_DIR)
	@$(CXX) $(CXXFLAGS) -c $< -o $@
	@echo "Compiled $< into $@"

# Version management
update-version: $(HEADER_DIR)/version.h
	@CURRENT_VER=$$(grep 'define VERSION_STRING' $(HEADER_DIR)/version.h | sed 's/.*VERSION_STRING "\(.*\)"/\1/'); \
	MAJOR=$$(echo $$CURRENT_VER | cut -d'.' -f1); \
	MINOR=$$(echo $$CURRENT_VER | cut -d'.' -f2); \
	PATCH=$$(echo $$CURRENT_VER | cut -d'.' -f3); \
	NEW_PATCH=$$((PATCH + 1)); \
	NEW_VER="$$MAJOR.$$MINOR.$$NEW_PATCH"; \
	sed -i "s/VERSION_STRING \".*\"/VERSION_STRING \"$$NEW_VER\"/" $(HEADER_DIR)/version.h; \
	echo "Version updated to $$NEW_VER in $(HEADER_DIR)/version.h"

$(HEADER_DIR)/version.h:
	@$(CREATE_DIR) $(HEADER_DIR)
	@echo "/** @file version.h" > $@
	@echo " * @brief Auto-generated version file. Do not edit manually." >> $@
	@echo " */" >> $@
	@echo "#ifndef VERSION_H" >> $@
	@echo "#define VERSION_H" >> $@
	@echo "#define VERSION_STRING \"0.0.1\"" >> $@
	@echo "#endif" >> $@
	@echo "Initialized $(HEADER_DIR)/version.h with version 0.0.1"

# Cleanup target
clean:
	@$(REMOVE) $(OBJECT_FILES) $(DEPENDENCY_FILES)
	@echo "Cleared object and dependency files."
	@$(REMOVE) $(BINARY_DIR)/$(TARGET)
	@echo "Removed executable."

# Tool verification
verify-tools:
	@command -v $(CXX) >/dev/null 2>&1 || { echo "Error: $(CXX) not found"; exit 1; }
	@command -v doxygen >/dev/null 2>&1 || { echo "Warning: Doxygen not installed; 'docs' target will fail"; }

# Documentation cleanup
docs-clean:
	@test -d $(DOCUMENT_DIR) && cd $(DOCUMENT_DIR) && $(FIND_UTIL) . -type f -not -name "PlaceHolder.txt" -exec $(REMOVE) {} \;
	@test -d $(DOCUMENT_DIR) && cd $(DOCUMENT_DIR) && $(FIND_UTIL) . -type d -not -path . -exec rmdir {} \; 2>/dev/null || true
	@echo "Cleaned documentation, kept PlaceHolder.txt."

# Documentation initialization
docs-init:
	@test -d $(DOCUMENT_DIR) || $(CREATE_DIR) $(DOCUMENT_DIR)
	@test -f $(DOCUMENT_DIR)/PlaceHolder.txt || echo "Placeholder for documentation directory" > $(DOCUMENT_DIR)/PlaceHolder.txt
	@echo "$(DOCUMENT_DIR)/PlaceHolder.txt initialized."

# Documentation generation
docs: docs-clean docs-init
	@sed -i '/^INPUT[ \t]*=/c\INPUT = . $(SOURCE_DIR) $(HEADER_DIR)' Doxyfile || echo "INPUT = . $(SOURCE_DIR) $(HEADER_DIR)" >> Doxyfile
	@sed -i '/^OUTPUT_DIRECTORY[ \t]*=/c\OUTPUT_DIRECTORY = $(DOCUMENT_DIR)' Doxyfile || echo "OUTPUT_DIRECTORY = $(DOCUMENT_DIR)" >> Doxyfile
	@sed -i '/^ENABLE_PREPROCESSING[ \t]*=/c\ENABLE_PREPROCESSING = YES' Doxyfile || echo "ENABLE_PREPROCESSING = YES" >> Doxyfile
	@sed -i '/^MACRO_EXPANSION[ \t]*=/c\MACRO_EXPANSION = YES' Doxyfile || echo "MACRO_EXPANSION = YES" >> Doxyfile
	@sed -i '/^EXPAND_ONLY_PREDEF[ \t]*=/c\EXPAND_ONLY_PREDEF = YES' Doxyfile || echo "EXPAND_ONLY_PREDEF = YES" >> Doxyfile
	@sed -i '/^EXPAND_AS_DEFINED[ \t]*=/c\EXPAND_AS_DEFINED = VERSION_STRING' Doxyfile || echo "EXPAND_AS_DEFINED = VERSION_STRING" >> Doxyfile
	@sed -i '/^PREDEFINED[ \t]*=/c\PREDEFINED =' Doxyfile || echo "PREDEFINED =" >> Doxyfile
	@sed -i '/^PROJECT_NUMBER[ \t]*=/c\PROJECT_NUMBER = \"$(VERSION)\"' Doxyfile || echo "PROJECT_NUMBER = \"$(VERSION)\"" >> Doxyfile
	@sed -i '/^PROJECT_NAME[ \t]*=/c\PROJECT_NAME = $(PROJECT_NAME)' Doxyfile || echo "PROJECT_NAME = \"$(PROJECT_NAME)\"" >> Doxyfile
	@doxygen Doxyfile
	@echo "Generated documentation in $(DOCUMENT_DIR)/"

# Git operations
commit:
	@cd $(BUILD_ROOT) && \
	pwd && \
	git add -A . && \
	git commit -m "$(COMMIT_MSG) Build:$(BUILD_ID)"

push:
	@git push origin master

pull:
	@git pull origin master

# Run target
run: $(BINARY_DIR)/$(TARGET)
	@"$(BINARY_DIR)/$(TARGET)"

# Installation
install: $(BUILD_ROOT)/.$(TARGET)/$(TARGET).conf $(BINARY_DIR)/$(TARGET)
	@if [ "$(INSTALL_PATH)" = "$(HOME)/bin" ] && [ ! -w "$(INSTALL_PATH)" ]; then \
		echo "Warning: $(INSTALL_PATH) requires sudo; use 'sudo make install'"; \
		exit 1; \
	fi
	@$(CREATE_DIR) "$(INSTALL_PATH)" || { echo "Error: Could not create $(INSTALL_PATH)"; exit 1; }
	@$(COPY) $(BINARY_DIR)/$(TARGET) "$(INSTALL_PATH)/"
	@$(CREATE_DIR) "$(CONFIG_PATH)" || { echo "Error: Could not create $(CONFIG_PATH)"; exit 1; }
	@if [ -f "$(CONFIG_PATH)/$(TARGET).conf" ]; then \
		cp "$(CONFIG_PATH)/$(TARGET).conf" "$(CONFIG_PATH)/$(TARGET).conf.bak"; \
		echo "Backed up config to $(CONFIG_PATH)/$(TARGET).conf.bak"; \
	fi
	@$(COPY) $(BUILD_ROOT)/.$(TARGET)/$(TARGET).conf "$(CONFIG_PATH)/$(TARGET).conf" || \
		{ echo "Warning: No config file found to install"; }
	@echo "Installed $(TARGET) to $(INSTALL_PATH)"
	@echo "Config placed at $(CONFIG_PATH)/$(TARGET).conf"

# Uninstall
uninstall:
	@$(REMOVE) "$(INSTALL_PATH)/$(TARGET)"
	@$(REMOVE) "$(CONFIG_PATH)/$(TARGET).conf"
	@if [ -d "$(CONFIG_PATH)" ] && [ -z "$$(ls -A "$(CONFIG_PATH)")" ]; then \
		rmdir "$(CONFIG_PATH)"; \
		echo "Removed empty $(CONFIG_PATH)"; \
	fi
	@echo "Uninstalled $(TARGET) from $(INSTALL_PATH)"
	@echo "Removed config from $(CONFIG_PATH)"

# Config file generation
$(BUILD_ROOT)/.$(TARGET)/$(TARGET).conf:
	@$(CREATE_DIR) $(BUILD_ROOT)/.$(TARGET)
	@echo "# Default configuration for $(TARGET)" > $@
	@echo "Generated default config at $@"

# Include dependencies
-include $(DEPENDENCY_FILES)