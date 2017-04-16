TAR := zizzania
SRC := $(shell ls *.c)

all:$(TAR)

$(TAR):$(SRC)
	@$(CC) -o $@ $^ $(CFLAGS) $(LDFLAGS)
	@$(STRIP) $@

clean:
	rm -f $(TAR)

#默认无需修改本Makefile，如需交叉编译请参照下方示例修改
CC := gcc
STRIP := strip
CFLAGS := -std=gnu99 -Wall -O3 -Os
LDFLAGS := -lpthread -lpcap

#交叉编译配置示例
#CC := mipsel-openwrt-linux-gcc
#STRIP := mipsel-openwrt-linux-strip
#CFLAGS := -std=gnu99 -Wall -O3 -Os -I/home/workspace/libpcap/include
#LDFLAGS := -ldl -lpthread /home/workspace/libpcap/lib/libpcap.so.1.7.4
