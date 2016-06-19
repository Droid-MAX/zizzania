SRC_FILES := $(shell ls *.c)
OBJ_FILES := $(SRC_FILES:.c=.o)
TARGET := zizzania
CXX := gcc
CXXFLAGS := -std=gnu99 -O3 -Os -Wall
LDFLAGS := -lpthread -lpcap

all:$(TARGET)

$(TARGET):$(OBJ_FILES)
	@echo "Compile $@"
	@$(CXX) -o $@ $^ $(CXXFLAGS) $(LDFLAGS)

$(OBJ_FILES):$(SRC_FILES)
	@$(CXX) $(CXXFLAGS) -c $^

.PHONY:clean

clean:
	rm -rf *.o zizzania
