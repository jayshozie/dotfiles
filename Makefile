GREEN  := $(shell tput -Txterm setaf 2)
RESET  := $(shell tput -Txterm sgr0)
LUA_TARGETS := modules/neovim/payload/

lua_fmt_check:
	echo "===> Checking"
	stylua $(LUA_TARGETS) --config-path=.stylua.toml --check

lua_fmt:
	echo "===> Formatting"
	stylua $(LUA_TARGETS) --config-path=.stylua.toml

lua_lint:
	echo "===> Linting"
	luacheck $(LUA_TARGETS) --globals vim


# i think i'll use it for building/rebuilding stuff
run:

install:

dry:

help:
	@echo ''
	@echo 'Usage:'
	@echo "  ${GREEN}make run [module]${RESET}   copy module's config files"
	@echo "  ${GREEN}make dry [module]${RESET}   test config files (for available modules)"
	@echo '  ${GREEN}make install${RESET}        install/update all modules'
	@echo '  ${GREEN}make help${RESET}           show this help'
	@echo ''

.PHONY: help install run dry nvim_lua_check nvim_lua_fmt
