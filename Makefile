PACKAGE := doom
THIS_MK := $(abspath $(lastword $(MAKEFILE_LIST)))
REPO_DIR := $(patsubst %/,%,$(dir $(THIS_MK)))
TNU_ROOT ?= $(abspath $(REPO_DIR)/..)
ifeq ($(wildcard $(TNU_ROOT)/userspace/linker.ld),)
TNU_ROOT ?= $(abspath $(REPO_DIR)/../tnu)
endif
BUILD ?= build
UPSTREAM := src/doomgeneric

CC ?= gcc
TNU_ROOT := $(abspath $(TNU_ROOT))
ifeq ($(wildcard $(TNU_ROOT)/userspace/linker.ld),)
$(error doom: TNU_ROOT='$(TNU_ROOT)' does not look like a TNU checkout)
endif
USER_CRT := $(TNU_ROOT)/$(BUILD)/obj/userspace/libc/src/crt0.o
USER_LIB := $(TNU_ROOT)/$(BUILD)/user/libtnu.a

CFLAGS := -std=gnu11 -O2 -g \
          -ffreestanding -fno-stack-protector -fno-builtin -fno-pic \
          -m64 -mno-red-zone \
          -I$(TNU_ROOT)/userspace/libc/include \
          -I$(TNU_ROOT)/kernel/include \
          -Isrc \
          -Isrc/doomgeneric/doomgeneric
LDFLAGS := -T $(TNU_ROOT)/userspace/linker.ld -nostdlib -static -no-pie \
           -Wl,-z,max-page-size=0x1000

DOOM_SRCS := $(filter-out \
    $(UPSTREAM)/doomgeneric_sdl.c \
    $(UPSTREAM)/doomgeneric_allegro.c \
    $(UPSTREAM)/doomgeneric_win.c \
    $(UPSTREAM)/doomgeneric_xlib.c \
    $(UPSTREAM)/doomgeneric_emscripten.c \
    $(UPSTREAM)/doomgeneric_soso.c \
    $(UPSTREAM)/doomgeneric_sosox.c \
    $(UPSTREAM)/doomgeneric_linuxvt.c \
    $(UPSTREAM)/mus2mid.c \
    $(UPSTREAM)/i_allegromusic.c \
    $(UPSTREAM)/i_allegrosound.c \
    $(UPSTREAM)/i_sdlmusic.c \
    $(UPSTREAM)/i_sdlsound.c \
    $(UPSTREAM)/gusconf.c \
    $(UPSTREAM)/icon.c, \
    $(wildcard $(UPSTREAM)/*.c))

DOOM_OBJS := $(patsubst $(UPSTREAM)/%.c,$(BUILD)/obj/%.o,$(DOOM_SRCS))
TNU_OBJ := $(BUILD)/obj/doomgeneric_tnu.o

.PHONY: all build clean fetch

all: build

build: $(BUILD)/$(PACKAGE)

fetch: $(UPSTREAM)/doomgeneric.h

$(UPSTREAM)/doomgeneric.h:
	@mkdir -p $(UPSTREAM)
	@if [ ! -f "$@" ]; then \
		echo "doom: fetch upstream doomgeneric into $(UPSTREAM)"; \
		echo "doom: expected files under $(UPSTREAM)/"; \
		false; \
	fi

$(BUILD)/$(PACKAGE): $(DOOM_OBJS) $(TNU_OBJ) $(USER_LIB) $(USER_CRT)
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $(USER_CRT) $(DOOM_OBJS) $(TNU_OBJ) $(USER_LIB) -lgcc

$(BUILD)/obj/%.o: $(UPSTREAM)/%.c src/config.h
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -Wno-error -w -c $< -o $@

$(BUILD)/obj/doomgeneric_tnu.o: src/doomgeneric_tnu.c
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -rf $(BUILD)
