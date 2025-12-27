return {
    -- NOTE: Active
    {
        "bluz71/vim-moonfly-colors",
        name = "moonfly",
        lazy = false,
        priority = 1000,
        config = function()
            -- Toggle background transparency
            local bg_transparent = true

            local toggle_transparency = function()
                bg_transparent = not bg_transparent
                vim.g.moonflytransparent = bg_transparent
                vim.cmd [[colorscheme moonfly]]
            end

            vim.keymap.set('n', '<leader>bg', toggle_transparency, { noremap = true, silent = true })

            vim.cmd.colorscheme 'moonfly'
        end
    },
    -- Extra Color Schemes Tried
    -- {
    --     'folke/tokyonight.nvim',
    --     priority = 1000, -- Make sure to load this before all the other start plugins.
    --     config = function()
    --         ---@diagnostic disable-next-line: missing-fields
    --         require('tokyonight').setup {
    --             styles = {
    --                 comments = { italic = false }, -- Disable italics in comments
    --             },
    --         }
    --
    --         -- Load the colorscheme here.
    --         -- Like many other themes, this one has different styles, and you could load
    --         -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
    --     end,
    -- },
    -- {
    --     "navarasu/onedark.nvim",
    --     priority = 1000, -- make sure to load this before all the other start plugins
    --     config = function()
    --         require('onedark').setup {
    --             style = 'warmer'
    --         }
    --         require('onedark').load()
    --     end
    -- },
}
