.PHONY: help install run dry nvim_lua_check nvim_lua_fmt

GREEN  := $(shell tput -Txterm setaf 2)
RESET  := $(shell tput -Txterm sgr0)
RED    := \033[0;31m
RST    := \033[0m
LUA_TARGETS := modules/neovim/payload/
STYLUA_TOML := modules/lua-stuff/.stylua.toml
LUACHECK_ARGS := --globals vim --max-line-length 80

help:
	@echo -e 'Usage:'
	@echo -e '  ${GREEN}make lua_check_fmt${RESET}   use stylua to check the format of lua code in the neovim module'
	@echo -e '  ${GREEN}make lua_fmt${RESET}         use stylua to format lua code in the neovim module'
	@echo -e '  ${GREEN}make lua_lint${RESET}        use luacheck to lint lua code in the neovim module'
	@echo -e '  ${GREEN}make help${RESET}            show this help'
	@echo

lua_check_fmt:
	@echo "===> Checking"
	stylua $(LUA_TARGETS) --config-path=$(STYLUA_TOML) --check

lua_fmt:
	@echo "===> Formatting"
	stylua $(LUA_TARGETS) --config-path=$(STYLUA_TOML)

lua_lint:
	@echo "===> Linting"
	luacheck $(LUA_TARGETS) $(LUACHECK_ARGS)

# i think i'll use it for building/rebuilding stuff
run:

install:

dry:
