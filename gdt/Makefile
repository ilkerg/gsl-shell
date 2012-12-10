
# Makefile
#
# Copyright (C) 2009 Francesco Abbate
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or (at
# your option) any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
#

GSH_BASE_DIR = ..

include $(GSH_BASE_DIR)/makeconfig
include $(GSH_BASE_DIR)/make-system-detect
include $(GSH_BASE_DIR)/makepackages
include $(GSH_BASE_DIR)/makedefs

INCLUDES += -I$(GSH_BASE_DIR)

CFLAGS += -std=c99

GDT_SRC_FILES = gdt_index.c gdt_table.c
GDT_OBJ_FILES := $(GDT_SRC_FILES:%.c=%.o)

DEP_FILES := $(GDT_SRC_FILES:%.c=.deps/%.P)

DEPS_MAGIC := $(shell mkdir .deps > /dev/null 2>&1 || :)

COMPILE = $(CC) $(CFLAGS) $(LUA_CFLAGS) $(DEFS) $(INCLUDES)

TARGETS = libgdt$(DLL_EXT)

all: $(TARGETS)

libgdt$(DLL_EXT): $(GDT_OBJ_FILES)
	gcc -shared -o $@ $(GDT_OBJ_FILES)

include $(GSH_BASE_DIR)/makerules

.PHONY: clean all

clean:
	$(HOST_RM) *.o *.a *$(DLL_EXT) $(TARGETS)

-include $(DEP_FILES)