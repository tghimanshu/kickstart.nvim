--[[

=====================================================================
=========================== WELCOME ABOARD! =========================
=====================================================================
========                                    .-----.          ========
========         .----------------------.   | === |          ========
========         |.-""""""""""""""""""-.|   |-----|          ========
========         ||                    ||   | === |          ========
========         ||  Himanshu's NVIM   ||   |-----|          ========
========         ||                    ||   | === |          ========
========         ||                    ||   |-----|          ========
========         ||:Tutor              ||   |:::::|          ========
========         |'-..................-'|   |____o|          ========
========         `"")----------------(""`   ___________      ========
========        /::::::::::|  |::::::::::\  \ no mouse \     ========
========       /:::========|  |==hjkl==:::\  \ required \    ========
========      '""""""""""""'  '""""""""""""'  '""""""""""'   ========
========                                                     ========
=====================================================================
=====================================================================

  Himanshu's Kickstart.nvim

  If you don't know anything about Lua, I recommend taking some time to read through
  a guide. One possible example which will only take 10-15 minutes:
    - https://learnxinyminutes.com/docs/lua/

  After understanding a bit more about Lua, you can use `:help lua-guide` as a
  reference for how Neovim integrates Lua.
  - :help lua-guide
  - (or HTML version): https://neovim.io/doc/user/lua-guide.html
--]]

-- Custom Imports
require 'core.options'
require 'core.keymaps'
require 'core.snippets'

vim.g.have_nerd_font = true -- Set to true if you have a Nerd Font installed and selected in the terminal

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- [[ Install `lazy.nvim` plugin manager ]] See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins you can run
--    :Lazy update
--
require('lazy').setup({

  -- Installing Plugins from files
  require 'plugins.alpha',
  require 'plugins.autocompletion',
  require 'plugins.bufferline',
  require 'plugins.colortheme',
  require 'plugins.comment',
  require 'plugins.copilot',
  require 'plugins.debugger',
  -- require 'plugins.debugger-mappings',
  require 'plugins.gitsigns',
  require 'plugins.harpoon',
  require 'plugins.indent-blankline',
  require 'plugins.lsp',
  require 'plugins.lualine',
  require 'plugins.misc',
  require 'plugins.neotree',
  require 'plugins.none-ls',
  require 'plugins.obsidian',
  require 'plugins.telescope',
  require 'plugins.treesitter',

  -- LSP Plugins
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
}, {
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
--
-- Used `:TSInstall lua` to ensure that the lua error is resolved
