MOD_NAME := CovidMod
MOD_VERSION := 1.0.0

# Build Settings
MCS := mcs
BUILD_DIR := build
OUTPUT_DLL := $(BUILD_DIR)/$(MOD_NAME).dll
LIB_DIR := $(BUILD_DIR)/lib
SDV_LIB_DIR := $(LIB_DIR)/assets
SMAPI_DIR := $(BUILD_DIR)/smapi
MCS_ARGS := -target:library -out:$(OUTPUT_DLL)

# Packaging Settings
ASSET_DIR := assets
RELEASE_ARCHIVE := $(BUILD_DIR)/$(MOD_NAME)-$(MOD_VERSION).zip
RELEASE_FILES = $(BUILD_DIR)/conf $(OUTPUT_DLL) $(BUILD_DIR)/manifest.json

# We use this to copy the assets needed for the build
SDV_EXE = StardewValley.exe
SDV_ASSETS := $(SDV_EXE) StardewValley.GameData.dll xTile.dll MonoGame.Framework.dll StardewModdingAPI.exe

# We link against the assets and also the SMAPI library
MONO_LIBS := $(SDV_ASSETS:%=$(SDV_LIB_DIR)/%)
MONO_LIBS += $(SMAPI_DIR)/smapi-internal/SMAPI.Toolkit.CoreInterfaces.dll

SOURCE_FILES = $(shell find . -maxdepth 1 -type f -name '*.cs')

# Needed for join
null :=
space := $(null) $(null)
comma := ,

# Join the MONO_LIBS with comma
MCS_ARGS += -reference:$(subst $(space),$(comma),$(MONO_LIBS))

ifndef SDV_DIR
$(error "SDV_DIR should point to the game folder(SMAPI should be installed)")
endif

all: $(OUTPUT_DLL)

$(OUTPUT_DLL): $(SOURCE_FILES) $(SMAPI_DIR) $(SDV_LIB_DIR)
	$(MCS) $(MCS_ARGS) $(SOURCE_FILES)

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(LIB_DIR): $(BUILD_DIR)
	mkdir -p $(LIB_DIR)


$(SMAPI_DIR):
	mkdir -p $(SMAPI_DIR)
	SMAPI_DIR=$(SMAPI_DIR) \
	./scripts/smapi-install.sh


$(SDV_LIB_DIR):
	mkdir -p $(SDV_LIB_DIR)
	SDV_LIB_DIR="$(SDV_LIB_DIR)" \
	SDV_DIR="$(SDV_DIR)" \
	./scripts/sdv-rip.sh $(SDV_ASSETS)

$(RELEASE_ARCHIVE):
	ASSET_DIR=$(ASSET_DIR) \
	BUILD_DIR=$(BUILD_DIR) \
	RELEASE_ARCHIVE=$(RELEASE_ARCHIVE) \
	./scripts/build-release.sh $(RELEASE_FILES)

###############
# CLI targets #
###############

pkg-install: $(LIB_DIR)
	LIB_DIR=$(LIB_DIR) \
	./scripts/nuget-install.sh $(NUGET_PKGS)

smapi-install: $(SMAPI_DIR)

sdv-rip: $(SDV_LIB_DIR)

release: $(RELEASE_ARCHIVE)

.PHONY: run
run:
	"$(SDV_DIR)/StardewValley"

.PHONY: deploy
deploy: $(OUTPUT_DLL)
	cp -pv "$(OUTPUT_DLL)" "$(SDV_DIR)/Mods/$(MOD_NAME)"
	
.PHONY: tail-log
tail-log:
	tail -f $(HOME)/.config/StardewValley/ErrorLogs/SMAPI-latest.txt

.PHONY: clean
clean:
	rm -rf $(BUILD_DIR)

