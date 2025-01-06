# Environment configuration
SHELL = /bin/sh

# Game configuration
GAME_CODE ?= game
GAME_NAME ?= Game
GAME_VERSION ?= 1.0.0

# Directory configuration
SRC_DIR ?= src
OUT_DIR ?= out
ASSETS_DIR ?= assets
ASSETS_FILES ?= $(shell find $(ASSETS_DIR) -type f)

# Odin configuration
ODIN ?= odin
ODIN_SOURCES ?= $(shell find $(SRC_DIR) -type f -name '*.odin')

ODIN_FLAGS ?= \
	-vet \
	-strict-style \
	-define:GAME_CODE="$(GAME_CODE)" \
	-define:GAME_NAME="$(GAME_NAME)" \
	-define:GAME_VERSION="$(GAME_VERSION)"

ifeq ($(DEBUG), true)
	ODIN_FLAGS += -debug
else
	ODIN_FLAGS += -o:speed
endif

# Docker configuration
DOCKER_ENGINE ?= podman
DOCKER_IMAGE ?= $(GAME_CODE)-devenv
DOCKER_OUT_DIR = $(OUT_DIR)/docker
DOCKER_RUN_FLAGS ?= --rm --volume $(PWD):/mnt --workdir /mnt

ifeq ($(notdir $(DOCKER_ENGINE)), docker)
	DOCKER_RUN_FLAGS += --user=$(id -u):$(id -g)
else ifeq ($(notdir $(DOCKER_ENGINE)), podman)
	DOCKER_RUN_FLAGS += --userns=keep-id:uid=1000,gid=1000
endif

DOCKER_RUN = $(DOCKER_ENGINE) run $(DOCKER_RUN_FLAGS) $(PLATFORM_DOCKER_IMAGE)

# Build base docker image
BASE_DOCKER_FILE = base.dockerfile
BASE_DOCKER_IMAGE = $(DOCKER_IMAGE):base
BASE_DOCKER_TARGET = $(DOCKER_OUT_DIR)/base

$(BASE_DOCKER_TARGET): $(BASE_DOCKER_FILE)
	mkdir -p $(DOCKER_OUT_DIR)
	$(DOCKER_ENGINE) build --file $(BASE_DOCKER_FILE) --tag $(BASE_DOCKER_IMAGE)
	$(DOCKER_ENGINE) image inspect --format '{{ .ID }}' $(BASE_DOCKER_IMAGE) >$(BASE_DOCKER_TARGET)

# Build platform specific docker image
PLATFORM_DOCKER_FILE = $(PLATFORM).dockerfile
PLATFORM_DOCKER_IMAGE = $(DOCKER_IMAGE):$(PLATFORM)
PLATFORM_DOCKER_TARGET = $(DOCKER_OUT_DIR)/$(PLATFORM)

$(PLATFORM_DOCKER_TARGET): $(PLATFORM_DOCKER_FILE) $(BASE_DOCKER_TARGET)
	mkdir -p $(DOCKER_OUT_DIR)
	$(DOCKER_ENGINE) build --file $(PLATFORM_DOCKER_FILE) --tag $(PLATFORM_DOCKER_IMAGE) --build-arg BASE_DOCKER_IMAGE=$(BASE_DOCKER_IMAGE)
	$(DOCKER_ENGINE) image inspect --format '{{ .ID }}' $(PLATFORM_DOCKER_IMAGE) >$(PLATFORM_DOCKER_TARGET)

# Link assets to output dir
PLATFORM_OUT_DIR = $(OUT_DIR)/$(PLATFORM)
PLATFORM_ASSETS_DIR = $(PLATFORM_OUT_DIR)/$(notdir $(ASSETS_DIR))

$(PLATFORM_ASSETS_DIR): $(ASSETS_DIR)
	mkdir -p $(PLATFORM_OUT_DIR)
	ln -sf $(abspath $(ASSETS_DIR)) $(PLATFORM_ASSETS_DIR)

# Clean platform output dir
clean:
	rm -rf $(PLATFORM_OUT_DIR)

# Clean whole output dir
clean-all:
	rm -rf $(OUT_DIR)

.PHONY: clean clean-all
