return {
    -- { -- Copilot
    --     'github/copilot.vim',
    --     event = 'VeryLazy',
    --     config = function()
    --         vim.api.nvim_create_user_command('COPTOG', function()
    --                 local is_on = vim.b.copilot_enabled
    --                 if is_on or is_on == nil then
    --                     vim.cmd('Copilot disable')
    --                 else
    --                     vim.cmd('Copilot enable')
    --                 end
    --             end,
    --             { desc = 'Toggle Copilot' })
    --         vim.keymap.set('n', '<leader>c', vim.cmd('COPTOG'))
    --     end
    -- }
}
