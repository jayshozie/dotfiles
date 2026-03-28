GREEN  := $(shell tput -Txterm setaf 2)
RESET  := $(shell tput -Txterm sgr0)
RED    := \033[0;31m
RST    := \033[0m
LUA_TARGETS := modules/neovim/payload/
STYLUA_TOML := modules/lua-stuff/.stylua.toml

lua_check_fmt:
	@echo "===> Checking"
	stylua $(LUA_TARGETS) --config-path=$(STYLUA_TOML) --check

lua_fmt:
	@echo "===> Formatting"
	stylua $(LUA_TARGETS) --config-path=$(STYLUA_TOML)

lua_lint:
	@echo "===> Linting"
	luacheck $(LUA_TARGETS) --globals vim

# i think i'll use it for building/rebuilding stuff
run:

install:

dry:

help:
	@echo -e '${RED}'
	@echo -e '!!! OUTDATED !!!'
	@echo -e '!!! DO NOT USE !!!${RST}'
	@echo -e 'Usage:'
	@echo -e "  ${GREEN}make run [module]${RESET}   copy module's config files"
	@echo -e "  ${GREEN}make dry [module]${RESET}   test config files (for available modules)"
	@echo -e '  ${GREEN}make install${RESET}        install/update all modules'
	@echo -e '  ${GREEN}make help${RESET}           show this help'
	@echo -e ''

.PHONY: help install run dry nvim_lua_check nvim_lua_fmt
