TARGET     = zizzania

CC        ?= gcc
STRIP     ?= strip
INSTALL   ?= install
PREFIX    ?= /usr
BINDIR    ?= $(PREFIX)/sbin
CFLAGS    ?= -std=gnu99 -Wall -O3 -Os
LDFLAGS   ?= -lpthread -lpcap

SRCS = bsss.c clients.c dispatcher.c dissector.c handler.c handshake.c ieee802.c iface.c killer.c main.c members.c options.c terminal.c util.c

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

#交叉编译配置示例
#CC := mipsel-openwrt-linux-gcc
#STRIP := mipsel-openwrt-linux-strip
#CFLAGS := -std=gnu99 -Wall -O3 -Os -I/home/workspace/libpcap/include
#LDFLAGS := -ldl -lpthread -L/home/workspace/libpcap/lib/libpcap.so.1.7.4
