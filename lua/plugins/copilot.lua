return {
  'zbirenbaum/copilot.lua',
  cmd = 'Copilot',
  build = ':Copilot auth',
  event = 'BufReadPost',
  dependencies = {
    'copilotlsp-nvim/copilot-lsp',
  },
  config = function()
    require('copilot').setup {}
  end,
}
