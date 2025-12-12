return {
    { -- Copilot
        'github/copilot.vim',
        event = 'VeryLazy',
        config = function()
            --- User command to toggle Copilot correctly ---
            vim.api.nvim_create_user_command('AION', function()
                vim.b.copilot_enabled = not vim.b.copilot_enabled
                if vim.b.copilot_enabled then
                    vim.cmd('Copilot enable')
                    print('Copilot Enabled')
                else
                    vim.cmd('Copilot disable')
                    print('Copilot Disabled')
                end
            end,
            { desc = 'User command to toggle Copilot correctly.' })

            --- Initialize Copilot based on buffer variable ---
            local copilot_on = vim.b.copilot_enabled or false
            if copilot_on == true or copilot_on == nil then
                vim.cmd('AION')
            elseif copilot_on == false then
                vim.cmd('AION')
            end

            --- Keymap to toggle Copilot ---
            vim.keymap.set('n', '<leader>c',
                function()
                    vim.cmd('AION')
                end,
            { desc = 'Toggle Copilot' })

            --- Autocommand to conditionally toggle Copilot ---
            local state_file = vim.fn.stdpath('data') .. '/copilot_last_popup_date'
            local function get_cur_date()
                return os.date('%Y%m')
            end
            local function get_sto_date()
                local f = io.open(state_file, 'r')
                if f then
                    -- Trim whitespace/newline characters
                    local stored_date = f:read('*a'):gsub('%s+', '')
                    f:close()
                    return stored_date
                end
                return '' -- return empty string if file doesn't exist
            end
            local function set_sto_date()
                local current_date = get_sto_date()
                local f = io.open(state_file, 'w')
                if f then
                    f:write(current_date)
                    f:close()
                end
            end

            vim.api.nvim_create_autocmd('BufEnter', {
                callback = function()
                    local current_date = get_cur_date()
                    local stored_date = get_sto_date()
                    if current_date > stored_date then
                        -- Toggle Copilot on
                        -- is it off?
                        local copilot_on = vim.b.copilot_enabled or false
                        if copilot_on == false then
                            vim.cmd('AION')
                        end
                    elseif current_date <= stored_date then
                        -- Toggle Copilot off
                        -- is it on?
                        local copilot_on = vim.b.copilot_enabled or false
                        if copilot_on == true or copilot_on == nil then
                            vim.cmd('AION')
                        end
                    end
                end,
            })
        end
    }
}
