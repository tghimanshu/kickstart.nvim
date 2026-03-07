-- none-ls.lua — diagnostics and linting ONLY
-- Formatting is handled by conform.nvim (see conform.lua) for reliability and speed.
-- none-ls is kept for linters that don't have a native LSP (checkmake, eslint_d, etc.)
return {
  'nvimtools/none-ls.nvim',
  dependencies = {
    'nvimtools/none-ls-extras.nvim',
    'jayp0521/mason-null-ls.nvim',
  },
  config = function()
    local null_ls   = require 'null-ls'
    local diag      = null_ls.builtins.diagnostics

    -- Mason: only install linting tools here.
    -- Formatting tools (prettier, stylua, shfmt, ruff, clang-format) are
    -- declared in conform.lua so Mason installs them from one place.
    require('mason-null-ls').setup {
      ensure_installed = {
        'eslint_d',   -- TypeScript / JavaScript linter
        'checkmake',  -- Makefile linter
        'hadolint',   -- Dockerfile linter
      },
      automatic_installation = true,
    }

    null_ls.setup {
      sources = {
        diag.checkmake,
        diag.hadolint,                          -- Dockerfile
        require('none-ls.diagnostics.eslint_d'), -- TS/JS (fast daemon)
      },
    }
  end,
}
