MCS := mcs
MOD_NAME := CovidMod
MCS_ARGS := -target:library -out:$(BUILD_DIR)/$(MOD_NAME)
NUGET_PKGS := Pathoschild.Stardew.ModBuildConfig MonoGame
OUTPUT_DLL := CovidMod.dll
BUILD_DIR := build
LIB_DIR := $(BUILD_DIR)/lib
SDV_LIB_DIR := $(LIB_DIR)/assets
SMAPI_DIR := $(BUILD_DIR)/smapi

# We use this to copy the assets needed for the build
SDV_EXE = StardewValley.exe
#SDV_DIR := /var/lib/workshop/steamapps/steamapps/common/Stardew\ Valley
SDV_ASSETS := $(SDV_EXE) StardewValley.GameData.dll xTile.dll MonoGame.Framework.dll

MONO_LIBS := $(SDV_ASSETS:%=$(SDV_LIB_DIR)/%)
MONO_LIBS += $(SMAPI_DIR)/StardewModdingAPI.exe
MONO_LIBS += $(SMAPI_DIR)/smapi-internal/SMAPI.Toolkit.CoreInterfaces.dll

SOURCE_FILES = $(shell find . -maxdepth 1 -type f -name '*.cs')

null :=
space := $(null) $(null)
comma := ,

MCS_ARGS += -reference:$(subst $(space),$(comma),$(MONO_LIBS))

all:
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
	
tail-log:
	tail -f $(HOME)/.config/StardewValley/ErrorLogs/SMAPI-latest.txt

clean:
	rm -rf $(BUILD_DIR)

