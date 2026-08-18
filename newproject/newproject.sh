#!/bin/bash

# newproject
#
# Crée la structure de base d'un projet C++ dans le dossier courant :
#
#   srcs/main.cpp        point d'entrée
#   includes/header.hpp  header parapluie (inclut les headers de classes)
#   utils/Debug.hpp      macro DEBUG_MSG, activée par `make debug`
#   Makefile             build dans build/, règles all/debug/clean/fclean/re
#
# Les classes s'ajoutent ensuite avec newclass (les .cpp dans srcs/,
# les .hpp dans includes/), puis se déclarent dans SRCS et HEADERS.
#
# Un fichier déjà présent n'est jamais écrasé.

create()
{
	if [ -e "$1" ]; then
		cat > /dev/null
		echo "  skip    $1"
	else
		cat > "$1"
		echo "  create  $1"
	fi
}

mkdir -p srcs includes utils

create Makefile <<'EOF'
NAME = exec
CC = c++
SRCS_DIR = srcs/
INC_DIR = includes/
UTILS_DIR = utils/
BUILD_DIR = build/
CFLAGS = -std=c++98 -Wall -Wextra -Werror
SRCS = $(addprefix $(SRCS_DIR), main.cpp)
OBJS = $(addprefix $(BUILD_DIR), $(SRCS:.cpp=.o))
HEADERS = $(addprefix $(INC_DIR), header.hpp) $(UTILS_DIR)Debug.hpp

DEBUG ?= 0
ifeq ($(DEBUG),1)
	CFLAGS += -D DEBUG
endif

all: $(NAME)

$(NAME): $(OBJS)
	$(CC) $(CFLAGS) $(OBJS) -o $(NAME)

$(BUILD_DIR)%.o: %.cpp $(HEADERS)
	mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

debug:
	$(MAKE) re DEBUG=1

clean:
	rm -rf $(BUILD_DIR)

fclean: clean
	rm -rf $(NAME)

re: fclean all

.PHONY: re clean fclean all debug
EOF

create srcs/main.cpp <<'EOF'
#include "../includes/header.hpp"

#include <iostream>

int main()
{
	return 0;
}
EOF

create includes/header.hpp <<'EOF'
#ifndef __HEADER_HPP__
#define __HEADER_HPP__

// Inclure ici les headers des classes du projet.

#endif
EOF

create utils/Debug.hpp <<'EOF'
#ifndef __DEBUG_HPP__
#define __DEBUG_HPP__

#include <iostream>

// Compile with `make debug` (adds -D DEBUG) to enable the traces.
#ifdef DEBUG
# define DEBUG_MSG(x) std::cout << x
#else
# define DEBUG_MSG(x) ((void)0)
#endif

#endif
EOF
