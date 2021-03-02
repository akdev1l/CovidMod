MCS := mcs
MOD_NAME := CovidMod
BUILD_DIR := build

OUTPUT_DLL := $(BUILD_DIR)/$(MOD_NAME).dll
LIB_DIR := $(BUILD_DIR)/lib
SDV_LIB_DIR := $(LIB_DIR)/assets
SMAPI_DIR := $(BUILD_DIR)/smapi
MCS_ARGS := -target:library -out:$(OUTPUT_DLL)

# We use this to copy the assets needed for the build
SDV_EXE = StardewValley.exe
SDV_ASSETS := $(SDV_EXE) StardewValley.GameData.dll xTile.dll MonoGame.Framework.dll StardewModdingAPI.exe

# We link against the assets and also the SMAPI library
MONO_LIBS := $(SDV_ASSETS:%=$(SDV_LIB_DIR)/%)
MONO_LIBS += $(SMAPI_DIR)/smapi-internal/SMAPI.Toolkit.CoreInterfaces.dll

SOURCE_FILES = $(shell find . -maxdepth 1 -type f -name '*.cs')

null :=
space := $(null) $(null)
comma := ,

MCS_ARGS += -reference:$(subst $(space),$(comma),$(MONO_LIBS))

all: $(OUTPUT_DLL)

$(OUTPUT_DLL): $(SOURCE_FILES)
	$(MCS) $(MCS_ARGS) $(SOURCE_FILES)

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(LIB_DIR): $(BUILD_DIR)
	mkdir -p $(LIB_DIR)

$(SDV_LIB_DIR): $(BUILD_DIR)
	mkdir -p $(SDV_LIB_DIR)

pkg-install: $(LIB_DIR)
	LIB_DIR=$(LIB_DIR) \
	./scripts/nuget-install.sh $(NUGET_PKGS)

$(SMAPI_DIR):
	mkdir -p $(SMAPI_DIR)

smapi-install: $(SMAPI_DIR)
	SMAPI_DIR=$(SMAPI_DIR) \
	./scripts/smapi-install.sh

sdv-rip: $(SDV_LIB_DIR)
	SDV_LIB_DIR="$(SDV_LIB_DIR)" \
	SDV_DIR="$(SDV_DIR)" \
	./scripts/sdv-rip.sh $(SDV_ASSETS)

run:
	"$(SDV_DIR)/StardewValley"

deploy: $(OUTPUT_DLL)
	cp -pv "$(OUTPUT_DLL)" "$(SDV_DIR)/Mods/$(MOD_NAME)"
	
tail-log:
	tail -f $(HOME)/.config/StardewValley/ErrorLogs/SMAPI-latest.txt

clean:
	rm -rf $(BUILD_DIR)

