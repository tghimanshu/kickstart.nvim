return {
  {
    'obsidian-nvim/obsidian.nvim',
    version = '*',
    lazy = true,
    ft = 'markdown',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    ---@module 'obsidian'
    ---@type obsidian.config.ClientOpts
    opts = {
      workspaces = {
        {
          name = 'personal',
          -- Change this to wherever your vault lives, e.g. '~/notes'
          path = '~/notes',
        },
      },

      -- Daily notes drop into notes/daily/
      daily_notes = {
        folder = 'daily',
        date_format = '%Y-%m-%d',
        -- Uses the template below when creating a new daily note
        template = 'daily_template',
      },

      -- Completion via nvim-cmp
      completion = {
        nvim_cmp = true,
        min_chars = 2,
      },

      -- Note ID: timestamp + slugified title keeps filenames sortable
      note_id_func = function(title)
        local suffix = ''
        if title ~= nil then
          suffix = title:gsub(' ', '-'):gsub('[^A-Za-z0-9-]', ''):lower()
        else
          for _ = 1, 4 do
            suffix = suffix .. string.char(math.random(65, 90))
          end
        end
        return tostring(os.time()) .. '-' .. suffix
      end,

      -- Auto-generate frontmatter on new notes
      note_frontmatter_func = function(note)
        local out = { id = note.id, aliases = note.aliases, tags = note.tags }
        if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
          for k, v in pairs(note.metadata) do
            out[k] = v
          end
        end
        return out
      end,

      -- Templates folder inside the vault
      templates = {
        folder = 'templates',
        date_format = '%Y-%m-%d',
        time_format = '%H:%M',
      },

      -- Telescope as the picker
      picker = {
        name = 'telescope.nvim',
        note_mappings = {
          new = '<C-x>',
          insert_link = '<C-l>',
        },
        tag_mappings = {
          tag_note = '<C-x>',
          insert_tag = '<C-l>',
        },
      },

      -- Open URLs with xdg-open (Linux)
      follow_url_func = function(url)
        vim.fn.jobstart({ 'xdg-open', url })
      end,

      -- Rich UI — checkboxes, bullets, highlights
      ui = {
        enable = true,
        update_debounce = 200,
        max_file_length = 5000,
        checkboxes = {
          [' '] = { char = '󰄱', hl_group = 'ObsidianTodo' },
          ['x'] = { char = '', hl_group = 'ObsidianDone' },
          ['>'] = { char = '', hl_group = 'ObsidianRightArrow' },
          ['~'] = { char = '󰰱', hl_group = 'ObsidianTilde' },
          ['!'] = { char = '', hl_group = 'ObsidianImportant' },
        },
        bullets = { char = '•', hl_group = 'ObsidianBullet' },
        external_link_icon = { char = '', hl_group = 'ObsidianExtLinkIcon' },
        reference_text = { hl_group = 'ObsidianRefText' },
        highlight_text = { hl_group = 'ObsidianHighlightText' },
        tags = { hl_group = 'ObsidianTag' },
        block_ids = { hl_group = 'ObsidianBlockID' },
        hl_groups = {
          -- Matches moonfly colorscheme palette
          ObsidianTodo      = { bold = true, fg = '#f78c6c' },
          ObsidianDone      = { bold = true, fg = '#89ddff' },
          ObsidianRightArrow= { bold = true, fg = '#fc9867' },
          ObsidianTilde     = { bold = true, fg = '#ff5370' },
          ObsidianImportant = { bold = true, fg = '#d73128' },
          ObsidianBullet    = { bold = true, fg = '#89ddff' },
          ObsidianRefText   = { underline = true, fg = '#c3e88d' },
          ObsidianExtLinkIcon = { fg = '#c3e88d' },
          ObsidianTag       = { italic = true, fg = '#89ddff' },
          ObsidianBlockID   = { italic = true, fg = '#89ddff' },
          ObsidianHighlightText = { bg = '#75662e' },
        },
      },
    },

    config = function(_, opts)
      require('obsidian').setup(opts)

      -- Clean markdown rendering
      vim.opt.conceallevel = 2

      -- ─────────────────────────────────────────────────────────────
      -- All note keymaps under <leader>n  (Notes namespace)
      -- ─────────────────────────────────────────────────────────────
      local map = function(keys, func, desc)
        vim.keymap.set('n', keys, func, { desc = 'Notes: ' .. desc })
      end

      -- Daily notes
      map('<leader>nd', '<cmd>ObsidianToday<CR>',     'Open today\'s daily note')
      map('<leader>ny', '<cmd>ObsidianYesterday<CR>', 'Open yesterday\'s note')
      map('<leader>nm', '<cmd>ObsidianTomorrow<CR>',  'Open tomorrow\'s note')

      -- Create / Navigate
      map('<leader>nn', '<cmd>ObsidianNew<CR>',         'New note')
      map('<leader>nf', '<cmd>ObsidianSearch<CR>',      'Search notes (full-text grep)')
      map('<leader>no', '<cmd>ObsidianQuickSwitch<CR>', 'Quick switch note (fuzzy)')
      map('<leader>nb', '<cmd>ObsidianBacklinks<CR>',   'Show backlinks to this note')
      map('<leader>nt', '<cmd>ObsidianTags<CR>',        'Browse notes by tag')
      map('<leader>nl', '<cmd>ObsidianLinks<CR>',       'Show all links in note')
      map('<leader>ni', '<cmd>ObsidianTemplate<CR>',    'Insert a template')

      -- Linking (also visual mode)
      vim.keymap.set('v', '<leader>nk', '<cmd>ObsidianLink<CR>',    { desc = 'Notes: Link selection to existing note' })
      vim.keymap.set('n', '<leader>nk', '<cmd>ObsidianLinkNew<CR>', { desc = 'Notes: Create & link new note' })

      -- ─────────────────────────────────────────────────────────────
      -- LeetCode / DSA note creator  (restored + improved)
      -- Creates structured markdown notes in ~/notes/dsa/
      -- ─────────────────────────────────────────────────────────────
      local curl = require 'plenary.curl'
      local Path = require 'plenary.path'
      local DSA_PATH = vim.fn.expand '~/notes/dsa'

      local function build_lc_content(q, url, is_daily)
        local tag = is_daily and '#daily' or ''
        return {
          '# ' .. q.questionFrontendId .. '. ' .. q.title,
          '',
          '| Field      | Value |',
          '|------------|-------|',
          '| Difficulty | ' .. q.difficulty .. ' |',
          '| Date       | ' .. os.date '%Y-%m-%d' .. (is_daily and ' *(Daily)*' or '') .. ' |',
          '| URL        | [Open](' .. (url or 'https://leetcode.com/problems/' .. q.titleSlug) .. ') |',
          '| Tags       | #leetcode #dsa ' .. tag .. ' |',
          '',
          '---',
          '',
          '## Problem Statement',
          '',
          '> _Paste or summarise the problem here._',
          '',
          '## 🧠 Intuition',
          '',
          '<!-- What is the core insight? 1-2 sentences max. -->',
          '',
          '## 🔧 Approach',
          '',
          '- ',
          '',
          '## 💻 Solution',
          '',
          '```python',
          'class Solution:',
          '    def solve(self):',
          '        pass',
          '```',
          '',
          '## 🧪 Edge Cases',
          '',
          '- ',
          '',
          '## ⏱ Complexity',
          '',
          '| | |',
          '|-|-|',
          '| Time  | O() |',
          '| Space | O() |',
        }
      end

      -- <leader>nDd — fetch and open today's LeetCode daily
      map('<leader>nDd', function()
        print 'Fetching LeetCode daily...'
        curl.get('https://leetcode-api-pied.vercel.app/daily', {
          callback = function(response)
            vim.schedule(function()
              if response.status ~= 200 then
                vim.notify('LeetCode API error: ' .. tostring(response.status), vim.log.levels.ERROR)
                return
              end
              local ok, data = pcall(vim.json.decode, response.body)
              if not ok or not data then
                vim.notify('Failed to parse response', vim.log.levels.ERROR)
                return
              end
              local q = data.question
              local filename = string.format('%s/%03d-%s.md', DSA_PATH, q.questionFrontendId, q.titleSlug)
              local content = build_lc_content(q, data.url, true)
              Path:new(filename):write(table.concat(content, '\n'), 'w')
              vim.cmd('edit ' .. filename)
              vim.notify('📝 Daily: ' .. q.title, vim.log.levels.INFO)
            end)
          end,
        })
      end, 'LeetCode: Fetch daily problem note')
    end,
  },
}
