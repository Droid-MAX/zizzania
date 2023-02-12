TARGET     = zizzania
PKG        = $(TARGET)
VERSION    = 0.3.0-1

CC        ?= gcc
STRIP     ?= strip
INSTALL   ?= install
WINDRES   ?= windres
PREFIX    ?= /usr
BINDIR    ?= $(PREFIX)/sbin
CFLAGS    ?= -std=gnu99 -Wall -O3 -Os
LDFLAGS   ?= -pthread -lpcap
RES       ?= res.bin

SRCS = bsss.c clients.c dispatcher.c dissector.c handler.c handshake.c ieee802.c iface.c killer.c members.c options.c terminal.c util.c zizzania.c

ifdef LIBS_BASE
CFLAGS += -I$(LIBS_BASE)/include
LDFLAGS += -L$(LIBS_BASE)/lib -Wl,-rpath -Wl,$(LIBS_BASE)/lib
endif

ifeq ($(CONFIG_STATIC), yes)
LDFLAGS += -static
endif

ifeq ($(TARGET_OS), MinGW)
EXEC_SUFFIX := .exe
SRCS += $(RES)
CFLAGS += -posix
CFLAGS += -Dffs=__builtin_ffs
CFLAGS += -D__USE_MINGW_ANSI_STDIO=1
endif

ifeq ($(TARGET_OS), Darwin)
CFLAGS += -Wno-gnu-designator
LDFLAGS += -lobjc -Wl,-framework,IOKit -Wl,-framework,CoreFoundation -Wl,-framework,Security
endif

$(PKG): $(TARGET)$(EXEC_SUFFIX)

$(TARGET)$(EXEC_SUFFIX): $(SRCS)
	$(CC) $(CFLAGS) $(SRCS) $(LDFLAGS) -o $@

$(RES):
	$(WINDRES) -i $(TARGET).rc -o $@

clean:
	rm -f $(TARGET)

strip: $(TARGET)$(EXEC_SUFFIX)
	$(STRIP) $(TARGET)$(EXEC_SUFFIX)

install: $(TARGET)
	mkdir -p $(DESTDIR)$(BINDIR)
	$(INSTALL) -m 0755 $(TARGET) $(DESTDIR)$(BINDIR)

debian/changelog:
	dch --create -v $(VERSION) --package $(PKG)

deb:
	dpkg-buildpackage -b -us -uc
.PHONY: install debian/changelog deb
