return {
    'nvim-treesitter/nvim-treesitter',
    -- branch = 'main',
    build = ':TSUpdate',
    lazy = false,

    opts = {
        ensure_installed = {
            'c',
            'lua',
            'vim',
            'vimdoc',
            'query',
            'cpp',
            'cmake',
            'make',
            'python',
            'markdown',
            -- 'markdown-inline',
            'latex',
            'asm',
            -- 'x86asm',
        },
        sync_install = false,
        auto_install = true,
        ignore_install = { '' },
        highlight = {
            enable = true,

            -- list of languages to be disabled
            -- disable = function(lang, buf)
            --     local max_filesize = 100 * 1024
            --     local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            --     if ok and stats and stats.size > max_filesize then
            --         return true
            --     end
            -- end,

            additional_vim_regex_highlighting = false,
        },
        -- local treesitter_parser_config = require('nvim-treesitter.parsers').get_parser_configs()
        -- tresitter_parser_config.templ = {
        --     install_info = {
        --         url = 'https://github.com/vrischmann/tree-sitter-templ.git',
        --         files = { 'src/parser.c', 'src/scanner.c' },
        --         branch = 'master',
        --     },
        -- }
    },
    config = function(_, opts)
        require("nvim-treesitter.configs").setup(opts)
    end,
}
