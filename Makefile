SRC_FILES := $(shell ls *.c)
TARGET := zizzania
CXXFLAGS := -std=gnu99 -O3 -Os -Wall

all:$(TARGET)

$(TARGET):$(SRC_FILES)
	@echo "Compile $@"
	@$(CXX) -o $@ $^ $(CXXFLAGS) $(LDFLAGS)
	@$(STRIP) $@

clean:
	rm -f zizzania

#默认无需修改本Makefile，如需交叉编译请修改以下变量
CXX := gcc
STRIP := strip
LDFLAGS := -lpthread -lpcap