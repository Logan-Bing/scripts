#!/bin/bash

cat <<'EOF' > Makefile
NAME = exec
CC = c++
CFLAGS = -std=c++98 -Wall -Wextra -Werror
BUILD_DIR = build
SRCS = main.cpp
OBJS = $(SRCS:%.cpp=$(BUILD_DIR)/%.o)

DEBUG ?= 0
ifeq ($(DEBUG),1)
	CFLAGS += -D DEBUG
endif

all: $(NAME)

$(NAME): $(OBJS)
	$(CC) $(CFLAGS) $(OBJS) -o $(NAME)

$(BUILD_DIR)/%.o: %.cpp | $(BUILD_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

debug:
	$(MAKE) re DEBUG=1

clean:
	rm -rf $(BUILD_DIR)

fclean: clean
	rm -rf $(NAME)

re: fclean all

.PHONY: re clean fclean all debug
EOF
