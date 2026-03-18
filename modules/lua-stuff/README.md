# How to Use

1. Copy the [.stylua.toml](./.stylua.toml) file into your lua project's root.
2. Add these to your Makefile:
```makefile
lua_fmt_check: # or the phony you want
	stylua modules/neovim/payload/ --config-path=.stylua.toml --check

lua_fmt: # or the phony you want
	stylua path/to/your/lua/files/ --config-path=.stylua.toml
```
3. You're ready!
