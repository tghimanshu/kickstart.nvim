-- alpha.lua — Dashboard shown on `nvim` with no file argument
-- Improvements over original:
--   • Added Notes shortcuts (daily note, search)
--   • Shows a random motivational dev quote in the footer
--   • Cleaner button icons using nerd font glyphs
return {
  'goolord/alpha-nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    local alpha     = require 'alpha'
    local dashboard = require 'alpha.themes.dashboard'

    -- ─── Header ──────────────────────────────────────────────────────
    dashboard.section.header.val = {
      '                                                     ',
      '  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ',
      '  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ',
      '  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ',
      '  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ',
      '  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ',
      '  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ',
      '                                                     ',
    }

    -- ─── Buttons ─────────────────────────────────────────────────────
    dashboard.section.buttons.val = {
      -- File ops
      dashboard.button('e', '  New file',          ':ene <BAR> startinsert<CR>'),
      dashboard.button('f', '  Find file',          ':cd $HOME/Workspace | Telescope find_files<CR>'),
      dashboard.button('r', '  Recent files',       ':Telescope oldfiles<CR>'),
      dashboard.button('g', '  Live grep',          ':Telescope live_grep<CR>'),

      dashboard.button('', ''),   -- spacer

      -- Notes
      dashboard.button('d', '  Today\'s daily note', ':ObsidianToday<CR>'),
      dashboard.button('n', '  New note',            ':ObsidianNew<CR>'),
      dashboard.button('s', '  Search notes',        ':ObsidianSearch<CR>'),

      dashboard.button('', ''),   -- spacer

      -- Config / quit
      dashboard.button('c', '  Neovim config',     ':e $MYVIMRC | :cd %:p:h<CR>'),
      dashboard.button('l', '󰒲  Lazy plugin manager', ':Lazy<CR>'),
      dashboard.button('q', '  Quit',               ':qa<CR>'),
    }

    -- ─── Footer — rotating dev quotes ────────────────────────────────
    local quotes = {
      '"First, solve the problem. Then, write the code." — John Johnson',
      '"Make it work, make it right, make it fast." — Kent Beck',
      '"Programs must be written for people to read." — Abelson & Sussman',
      '"Simplicity is the soul of efficiency." — Austin Freeman',
      '"Code is like humor. When you have to explain it, it\'s bad." — Cory House',
      '"The best code is no code at all." — Jeff Atwood',
      '"An idiot admires complexity, a genius admires simplicity." — Terry Davis',
      '"Talk is cheap. Show me the code." — Linus Torvalds',
      '"Debugging is twice as hard as writing code." — Brian Kernighan',
      '"You ship it, you own it." — Werner Vogels',
    }
    math.randomseed(os.time())
    dashboard.section.footer.val = quotes[math.random(#quotes)]
    dashboard.section.footer.opts.hl = 'Comment'

    -- ─── Layout tweaks ────────────────────────────────────────────────
    dashboard.config.layout = {
      { type = 'padding', val = 2 },
      dashboard.section.header,
      { type = 'padding', val = 1 },
      dashboard.section.buttons,
      { type = 'padding', val = 1 },
      dashboard.section.footer,
    }

    alpha.setup(dashboard.config)
  end,
}
