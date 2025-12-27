--[[

=====================================================================
==================== READ THIS BEFORE CONTINUING ====================
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

-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`
-- See `:help vim.o`

vim.o.number = true -- Make line numbers default
vim.o.relativenumber = true -- Add relative line numbers
vim.o.mouse = 'a' -- enable mouse mode

vim.o.showmode = false -- Don't show the mode, since it's already in the status line

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

vim.o.breakindent = true -- Enable break indent

vim.o.undofile = true -- Save undo history

vim.o.ignorecase = true -- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.smartcase = true

vim.o.shiftwidth = 4 -- default indentation and use spaces when tab is used
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.expandtab = true

vim.o.signcolumn = 'yes' -- Keep signcolumn on by default

vim.o.updatetime = 250 -- Decrease update time

vim.o.timeoutlen = 300 -- Decrease mapped sequence wait time

vim.o.splitright = true -- Configure how new splits should be opened
vim.o.splitbelow = true

vim.o.list = true -- Sets how neovim will display certain whitespace characters in the editor.
vim.opt.listchars = {
  tab = '» ',
  trail = '·',
  nbsp = '␣',
} --  vim.opt is very similar to `vim.o` but offers an interface for conveniently interacting with tables.

vim.o.inccommand = 'split' -- Preview substitutions live, as you type!

vim.o.cursorline = true -- Show which line your cursor is on

vim.o.scrolloff = 12 -- Minimal number of screen lines to keep above and below the cursor.
vim.o.sidescrolloff = 10

vim.o.confirm = true -- asks to save on :q

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
  require 'plugins.autocompletion',
  require 'plugins.bufferline',
  require 'plugins.colortheme',
  require 'plugins.comment',
  require 'plugins.gitsigns',
  require 'plugins.indent-blankline',
  require 'plugins.lsp',
  require 'plugins.lualine',
  require 'plugins.misc',
  require 'plugins.neotree',
  require 'plugins.none-ls',
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
