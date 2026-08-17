#!/bin/bash

cat <<'EOF' > Makefile
NAME = exec
CC = c++
CFLAGS = -std=c++98 -Wall -Wextra -Werror
SRCS = main.cpp
OBJS = $(SRCS:.cpp=.o)

DEBUG ?= 0
ifeq ($(DEBUG),1)
	CFLAGS += -D DEBUG
endif

all: $(NAME)

$(NAME): $(OBJS)
	$(CC) $(CFLAGS) $(OBJS) -o $(NAME)

%.o: %.cpp
	$(CC) $(CFLAGS) -c $< -o $@

debug:
	$(MAKE) re DEBUG=1

clean:
	rm -rf $(OBJS)

fclean: clean
	rm -rf $(NAME)

re: fclean all

.PHONY: re clean fclean all debug
EOF
