######################################################################
##################### Makefile template for C++ ######################
######################################################################
# Project settings - customizable
SRC_DIR		:= src
INC_DIR		:= inc
BUILD_DIR	:= build
OBJ_DIR		:= $(BUILD_DIR)/bin
TARGET_DIR	:= $(BUILD_DIR)/app
TARGET		:= program

# Compiler settings - customizable
CXX			:= g++
CXXFLAGS	:= -Wall -std=c++11
INCLUDE		:= -I. -I./$(INC_DIR)
LDFLAGS		:= 

################ Do not change anything on downwards! ################
SRCS		:= $(shell find $(SRC_DIR) -name *.cpp)
OBJS		:= $(addprefix $(OBJ_DIR)/, $(notdir $(SRCS:.cpp=.o)))
DEPS		:= $(addprefix $(BUILD_DIR)/, $(notdir $(OBJS:.o=.d)))

######################################################################
########################## Rules begin here ##########################
######################################################################
.PHONY: all build clean debug release

all: build $(DEPS) $(TARGET_DIR)/$(TARGET)

# Create dependency rules
$(BUILD_DIR)/%.d: $(SRC_DIR)/%.cpp
	@$(CC) -MM $(INCLUDE) $(CFLAGS) $< > $@
	@sed -i "s,$*\.o[ :]*,$(OBJ_DIR)\/$*\.o $@: ,g" $@

include $(DEPS)

# C++ source
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cpp
	$(CXX) $(CXXFLAGS) $(INCLUDE) -c $< -o $@

# Build target
$(TARGET_DIR)/$(TARGET): $(OBJS)
	$(CXX) $(CXXFLAGS) $^ -o $@ $(LDFLAGS)
	@ln -sf $(TARGET_DIR)/$(TARGET) exe
	@echo "\e[92mCOMPILATION COMPLETED SUCCESFULLY!"
	@echo "Run the executable by typing:\e[0m ./exe"

build:
	@mkdir -p $(BUILD_DIR)
	@mkdir -p $(OBJ_DIR)
	@mkdir -p $(TARGET_DIR)

debug: CXXFLAGS += -DDEBUG -g
debug: all

release: CXXFLAGS += -O2
release: all

################## Cleaning rules for Unix-based OS ##################
clean:
	@echo BINARIES
	@rm -rvf $(OBJS) $(TARGET_DIR)/* | sed "s,^r,  r,"
	@echo DEPENDENCIES
	@rm -rvf $(DEPS) | sed "s,^r,  r,"
	@rm -f exe
