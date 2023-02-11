TARGET     = zizzania
PKG        = $(TARGET)
VERSION    = 0.3.0-1

CC        ?= gcc
STRIP     ?= strip
INSTALL   ?= install
PREFIX    ?= /usr
BINDIR    ?= $(PREFIX)/sbin
CFLAGS    ?= -std=gnu99 -Wall -O3 -Os
LDFLAGS   ?= -lpthread -lpcap

SRCS = bsss.c clients.c dispatcher.c dissector.c handler.c handshake.c ieee802.c iface.c killer.c members.c options.c terminal.c util.c zizzania.c

ifdef LIBS_BASE
CFLAGS += -I$(LIBS_BASE)/include
LDFLAGS += -L$(LIBS_BASE)/lib -Wl,-rpath -Wl,$(LIBS_BASE)/lib
endif

ifeq ($(CONFIG_STATIC), yes)
LDFLAGS += -static
endif

$(TARGET): $(SRCS)
	$(CC) $(CFLAGS) $(SRCS) $(LDFLAGS) -o $@

clean:
	rm -f $(TARGET)

strip: $(TARGET)
	$(STRIP) $(TARGET)

install: $(TARGET)
	mkdir -p $(DESTDIR)$(BINDIR)
	$(INSTALL) -m 0755 $(TARGET) $(DESTDIR)$(BINDIR)

debian/changelog:
	dch --create -v $(VERSION) --package $(PKG)

deb:
	dpkg-buildpackage -b -us -uc
.PHONY: install debian/changelog deb
