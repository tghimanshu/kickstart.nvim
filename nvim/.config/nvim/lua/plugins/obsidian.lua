return {
  {
    'obsidian-nvim/obsidian.nvim',
    version = '*',
    ft = 'markdown',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    ---@module 'obsidian'
    ---@type obsidian.config
    opts = {
      legacy_commands = false,
      workspaces = {
        {
          name = 'personal',
          -- Change this to wherever your vault lives, e.g. '~/notes'
          path = '~/personal/notes',
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
      formatter = function(note)
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
      -- follow_url_func = function(url)
      --   vim.fn.jobstart { 'xdg-open', url }
      -- end,

      ---@class obsidian.config.CheckboxOpts
      ---
      ---@field enabled? boolean
      ---
      ---Order of checkbox state chars, e.g. { " ", "x" }
      ---@field order? string[]
      ---
      ---Whether to create new checkbox on paragraphs
      ---@field create_new? boolean
      checkbox = {
        enabled = true,
        create_new = true,
        order = { ' ', '/', 'x', '-' },
      },

      -- Rich UI — checkboxes, bullets, highlights
      --   ui = {
      --     enable = true,
      --     update_debounce = 200,
      --     max_file_length = 5000,
      --     -- checkboxes = {
      --     --   [' '] = { char = '', hl_group = 'none' }, -- these are just for checkbox toggling with <CR>
      --     --   ['x'] = { char = '', hl_group = 'none' }, -- icons here are handled by render-markdown.lua
      --     --   ['>'] = { char = '', hl_group = 'none' },
      --     --   ['<'] = { char = '', hl_group = 'none' },
      --     --   ['-'] = { char = '', hl_group = 'none' },
      --     --   ['!'] = { char = '', hl_group = 'none' },
      --     --   ['?'] = { char = '', hl_group = 'none' },
      --     --   ['/'] = { char = '', hl_group = 'none' },
      --     --   ['I'] = { char = '', hl_group = 'none' },
      --     --   ['f'] = { char = '', hl_group = 'none' },
      --     --   ['"'] = { char = '', hl_group = 'none' },
      --     --   ['p'] = { char = '', hl_group = 'none' },
      --     --   ['c'] = { char = '', hl_group = 'none' },
      --     --
      --     --   -- [' '] = { char = '󰄱', hl_group = 'ObsidianTodo' },
      --     --   -- ['x'] = { char = '', hl_group = 'ObsidianDone' },
      --     --   -- ['>'] = { char = '', hl_group = 'ObsidianRightArrow' },
      --     --   -- ['~'] = { char = '󰰱', hl_group = 'ObsidianTilde' },
      --     --   -- ['!'] = { char = '', hl_group = 'ObsidianImportant' },
      --     -- },
      --     bullets = { char = '•', hl_group = 'ObsidianBullet' },
      --     external_link_icon = { char = '', hl_group = 'ObsidianExtLinkIcon' },
      --     reference_text = { hl_group = 'ObsidianRefText' },
      --     highlight_text = { hl_group = 'ObsidianHighlightText' },
      --     tags = { hl_group = 'ObsidianTag' },
      --     block_ids = { hl_group = 'ObsidianBlockID' },
      --     hl_groups = {
      --       -- Matches moonfly colorscheme palette
      --       ObsidianTodo = { bold = true, fg = '#f78c6c' },
      --       ObsidianDone = { bold = true, fg = '#89ddff' },
      --       ObsidianRightArrow = { bold = true, fg = '#fc9867' },
      --       ObsidianTilde = { bold = true, fg = '#ff5370' },
      --       ObsidianImportant = { bold = true, fg = '#d73128' },
      --       ObsidianBullet = { bold = true, fg = '#89ddff' },
      --       ObsidianRefText = { underline = true, fg = '#c3e88d' },
      --       ObsidianExtLinkIcon = { fg = '#c3e88d' },
      --       ObsidianTag = { italic = true, fg = '#89ddff' },
      --       ObsidianBlockID = { italic = true, fg = '#89ddff' },
      --       ObsidianHighlightText = { bg = '#75662e' },
      --     },
      --   },
    },

    keys = {
      { '<leader><CR>', '<cmd>Obsidian toggle_checkbox<CR>', desc = 'Notes: Follow Obsidian link under cursor' },
      { '\x1b[13;2u', '<cmd>Obsidian toggle_checkbox<CR>', desc = 'Notes: Follow Obsidian link under cursor' },
      { '<leader>nd', '<cmd>ObsidianToday<CR>', desc = "Notes: Open today's daily note" },
      { '<leader>ny', '<cmd>ObsidianYesterday<CR>', desc = "Notes: Open yesterday's note" },
      { '<leader>nm', '<cmd>ObsidianTomorrow<CR>', desc = "Notes: Open tomorrow's note" },
      {
        '<leader>nw',
        function()
          local week = os.date '%Y-W%V'
          local path = vim.fn.expand '~/personal/notes/daily/' .. week .. '-weekly-review.md'
          vim.cmd('edit ' .. path)
          if vim.fn.filereadable(path) == 0 then
            vim.cmd 'ObsidianTemplate weekly_review_template'
          end
        end,
        desc = 'Notes: Open / create weekly review note',
      },
      { '<leader>nn', '<cmd>ObsidianNew<CR>', desc = 'Notes: New note' },
      { '<leader>nf', '<cmd>ObsidianSearch<CR>', desc = 'Notes: Search notes (full-text grep)' },
      { '<leader>no', '<cmd>ObsidianQuickSwitch<CR>', desc = 'Notes: Quick switch note (fuzzy)' },
      { '<leader>nb', '<cmd>ObsidianBacklinks<CR>', desc = 'Notes: Show backlinks to this note' },
      { '<leader>nt', '<cmd>ObsidianTags<CR>', desc = 'Notes: Browse notes by tag' },
      { '<leader>nl', '<cmd>ObsidianLinks<CR>', desc = 'Notes: Show all links in note' },
      { '<leader>ni', '<cmd>ObsidianTemplate<CR>', desc = 'Notes: Insert a template' },
      {
        '<leader>n.',
        function()
          vim.cmd('edit ' .. vim.fn.expand '~/personal/notes/tasks.md')
        end,
        desc = 'Notes: Open tasks.md',
      },
      { '<leader>nk', '<cmd>ObsidianLinkNew<CR>', desc = 'Notes: Create & link new note' },
      { '<leader>nk', '<cmd>ObsidianLink<CR>', mode = 'v', desc = 'Notes: Link selection to existing note' },
      {
        '<leader>nNp',
        function()
          local Path = require 'plenary.path'
          vim.ui.input({ prompt = 'Project title: ' }, function(title)
            if not title or title == '' then
              return
            end
            local slug = title:gsub('%s+', '-'):gsub('[^A-Za-z0-9-]', ''):lower()
            local ts = tostring(os.time())
            local filename = vim.fn.expand '~/personal/notes/projects/' .. ts .. '-' .. slug .. '.md'
            Path:new(filename):touch { parents = true }
            vim.cmd('edit ' .. filename)
            vim.cmd 'ObsidianTemplate project_template'
            vim.notify('New Project: ' .. title, vim.log.levels.INFO)
          end)
        end,
        desc = 'Notes: New project note',
      },
      {
        '<leader>nNl',
        function()
          local Path = require 'plenary.path'
          vim.ui.input({ prompt = 'Learning title: ' }, function(title)
            if not title or title == '' then
              return
            end
            local slug = title:gsub('%s+', '-'):gsub('[^A-Za-z0-9-]', ''):lower()
            local ts = tostring(os.time())
            local filename = vim.fn.expand '~/personal/notes/learning/' .. ts .. '-' .. slug .. '.md'
            Path:new(filename):touch { parents = true }
            vim.cmd('edit ' .. filename)
            vim.cmd 'ObsidianTemplate learning_template'
            vim.notify('New Learning: ' .. title, vim.log.levels.INFO)
          end)
        end,
        desc = 'Notes: New learning note',
      },
      {
        '<leader>nNa',
        function()
          local Path = require 'plenary.path'
          vim.ui.input({ prompt = 'Article title: ' }, function(title)
            if not title or title == '' then
              return
            end
            local slug = title:gsub('%s+', '-'):gsub('[^A-Za-z0-9-]', ''):lower()
            local ts = tostring(os.time())
            local filename = vim.fn.expand '~/personal/notes/ai/' .. ts .. '-' .. slug .. '.md'
            Path:new(filename):touch { parents = true }
            vim.cmd('edit ' .. filename)
            vim.cmd 'ObsidianTemplate article_template'
            vim.notify('New Article: ' .. title, vim.log.levels.INFO)
          end)
        end,
        desc = 'Notes: New article / reading note',
      },
      {
        '<leader>nNt',
        function()
          local Path = require 'plenary.path'
          vim.ui.input({ prompt = 'TIL title: ' }, function(title)
            if not title or title == '' then
              return
            end
            local slug = title:gsub('%s+', '-'):gsub('[^A-Za-z0-9-]', ''):lower()
            local ts = tostring(os.time())
            local filename = vim.fn.expand '~/personal/notes/daily/' .. ts .. '-' .. slug .. '.md'
            Path:new(filename):touch { parents = true }
            vim.cmd('edit ' .. filename)
            vim.cmd 'ObsidianTemplate til_template'
            vim.notify('New TIL: ' .. title, vim.log.levels.INFO)
          end)
        end,
        desc = 'Notes: New TIL note',
      },
      {
        '<leader>nNd',
        function()
          local Path = require 'plenary.path'
          local dsa_path = vim.fn.expand '~/personal/notes/dsa'
          local build_lc_content = function(q, url, is_daily)
            local date_label = is_daily and os.date '%Y-%m-%d' .. ' (Daily)' or os.date '%Y-%m-%d'
            return {
              '# ' .. q.questionFrontendId .. '. ' .. q.title,
              '',
              '---',
              '**Difficulty**: ' .. (q.difficulty or 'Unknown'),
              '**Date**: ' .. date_label,
              '**URL**: ' .. (url or 'https://leetcode.com/problems/' .. q.titleSlug),
              '**Tags**: #leetcode',
              '---',
              '',
              '## Problem Statement',
              '',
              '## Idea (1-2 sentences)',
              '<!-- What was the core insight? -->',
              '',
              '## Approach',
              '',
              '- ',
              '',
              '## Edge Cases',
              '',
              '- ',
              '',
              '## Complexity',
              '',
              '- Time: ',
              '- Space: ',
              '',
              '## Solution',
              '',
              '```',
              '```',
            }
          end
          vim.ui.input({ prompt = 'Problem number: ' }, function(num)
            if not num or num == '' then
              return
            end
            vim.ui.input({ prompt = 'Title slug (e.g. two-sum): ' }, function(slug)
              if not slug or slug == '' then
                return
              end
              local filename = string.format('%s/%03d-%s.md', dsa_path, tonumber(num) or 0, slug)
              local q = { questionFrontendId = num, title = slug:gsub('-', ' '), titleSlug = slug, difficulty = '' }
              local content = build_lc_content(q, nil, false)
              Path:new(filename):touch { parents = true }
              Path:new(filename):write(table.concat(content, '\n'), 'w')
              vim.cmd('edit ' .. filename)
              vim.notify('New DSA note: ' .. num .. '-' .. slug, vim.log.levels.INFO)
            end)
          end)
        end,
        desc = 'Notes: New manual DSA/LeetCode note',
      },
      {
        '<leader>nDd',
        function()
          local Path = require 'plenary.path'
          local curl = require 'plenary.curl'
          local dsa_path = vim.fn.expand '~/personal/notes/dsa'
          local build_lc_content = function(q, url, is_daily)
            local date_label = is_daily and os.date '%Y-%m-%d' .. ' (Daily)' or os.date '%Y-%m-%d'
            return {
              '# ' .. q.questionFrontendId .. '. ' .. q.title,
              '',
              '---',
              '**Difficulty**: ' .. (q.difficulty or 'Unknown'),
              '**Date**: ' .. date_label,
              '**URL**: ' .. (url or 'https://leetcode.com/problems/' .. q.titleSlug),
              '**Tags**: #leetcode',
              '---',
              '',
              '## Problem Statement',
              '',
              '## Idea (1-2 sentences)',
              '<!-- What was the core insight? -->',
              '',
              '## Approach',
              '',
              '- ',
              '',
              '## Edge Cases',
              '',
              '- ',
              '',
              '## Complexity',
              '',
              '- Time: ',
              '- Space: ',
              '',
              '## Solution',
              '',
              '```',
              '```',
            }
          end
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
                local filename = string.format('%s/%03d-%s.md', dsa_path, q.questionFrontendId, q.titleSlug)
                local content = build_lc_content(q, data.url, true)
                Path:new(filename):touch { parents = true }
                Path:new(filename):write(table.concat(content, '\n'), 'w')
                vim.cmd('edit ' .. filename)
                vim.notify('Daily: ' .. q.title, vim.log.levels.INFO)
              end)
            end,
          })
        end,
        desc = 'Notes: LeetCode: Fetch daily problem note',
      },
      {
        '<leader>nDn',
        function()
          local Path = require 'plenary.path'
          local curl = require 'plenary.curl'
          local dsa_path = vim.fn.expand '~/personal/notes/dsa'
          local build_lc_content = function(q, url, is_daily)
            local date_label = is_daily and os.date '%Y-%m-%d' .. ' (Daily)' or os.date '%Y-%m-%d'
            return {
              '# ' .. q.questionFrontendId .. '. ' .. q.title,
              '',
              '---',
              '**Difficulty**: ' .. (q.difficulty or 'Unknown'),
              '**Date**: ' .. date_label,
              '**URL**: ' .. (url or 'https://leetcode.com/problems/' .. q.titleSlug),
              '**Tags**: #leetcode',
              '---',
              '',
              '## Problem Statement',
              '',
              '## Idea (1-2 sentences)',
              '<!-- What was the core insight? -->',
              '',
              '## Approach',
              '',
              '- ',
              '',
              '## Edge Cases',
              '',
              '- ',
              '',
              '## Complexity',
              '',
              '- Time: ',
              '- Space: ',
              '',
              '## Solution',
              '',
              '```',
              '```',
            }
          end
          vim.ui.input({ prompt = 'LeetCode problem number: ' }, function(num)
            if not num or num == '' then
              return
            end
            print('Fetching problem #' .. num .. '...')
            curl.get('https://leetcode-api-pied.vercel.app/problems', {
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
                  local problem = nil
                  for _, p in ipairs(data) do
                    if tostring(p.questionFrontendId) == tostring(num) then
                      problem = p
                      break
                    end
                  end
                  if not problem then
                    vim.notify('Problem #' .. num .. ' not found', vim.log.levels.ERROR)
                    return
                  end
                  local filename = string.format('%s/%03d-%s.md', dsa_path, problem.questionFrontendId, problem.titleSlug)
                  if vim.fn.filereadable(filename) == 1 then
                    vim.cmd('edit ' .. filename)
                    vim.notify('Opened existing note: ' .. problem.title, vim.log.levels.INFO)
                    return
                  end
                  local content = build_lc_content(problem, nil, false)
                  Path:new(filename):touch { parents = true }
                  Path:new(filename):write(table.concat(content, '\n'), 'w')
                  vim.cmd('edit ' .. filename)
                  vim.notify('New note: ' .. problem.title, vim.log.levels.INFO)
                end)
              end,
            })
          end)
        end,
        desc = 'Notes: LeetCode: Fetch problem by number',
      },
      {
        '<leader>nDs',
        function()
          require('telescope.builtin').find_files {
            prompt_title = 'DSA Notes',
            cwd = vim.fn.expand '~/personal/notes/dsa',
            hidden = false,
          }
        end,
        desc = 'Notes: LeetCode: Browse DSA notes',
      },
      {
        '<leader>nDr',
        function()
          local dsa_path = vim.fn.expand '~/personal/notes/dsa'
          local files = vim.fn.globpath(dsa_path, '*.md', false, true)
          if #files == 0 then
            vim.notify('No DSA notes found', vim.log.levels.WARN)
            return
          end
          math.randomseed(os.time())
          local pick = files[math.random(#files)]
          vim.cmd('edit ' .. pick)
          vim.notify('Review: ' .. vim.fn.fnamemodify(pick, ':t'), vim.log.levels.INFO)
        end,
        desc = 'Notes: LeetCode: Open random DSA note',
      },
      {
        '<leader>nDx',
        function()
          local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
          for _, line in ipairs(lines) do
            if line:match '^%*%*Solved%*%*' then
              vim.notify('Already marked as solved', vim.log.levels.WARN)
              return
            end
          end
          local dash_count = 0
          local insert_at = nil
          for i, line in ipairs(lines) do
            if line == '---' then
              dash_count = dash_count + 1
              if dash_count == 2 then
                insert_at = i
                break
              end
            end
          end
          local solved_line = '**Solved**: ' .. os.date '%Y-%m-%d'
          if insert_at then
            vim.api.nvim_buf_set_lines(0, insert_at - 1, insert_at - 1, false, { solved_line })
          else
            vim.api.nvim_buf_set_lines(0, 1, 1, false, { '', solved_line })
          end
          vim.cmd 'write'
          vim.notify('Marked as solved', vim.log.levels.INFO)
        end,
        desc = 'Notes: LeetCode: Mark current note solved',
      },
      {
        '<leader>nDu',
        function()
          local Path = require 'plenary.path'
          local dsa_path = vim.fn.expand '~/personal/notes/dsa'
          local files = vim.fn.globpath(dsa_path, '*.md', false, true)
          local unsolved = {}
          for _, f in ipairs(files) do
            local content = Path:new(f):read()
            if not content:match '%*%*Solved%*%*' then
              table.insert(unsolved, f)
            end
          end
          if #unsolved == 0 then
            vim.notify('All DSA notes are marked solved!', vim.log.levels.INFO)
            return
          end
          local pickers = require 'telescope.pickers'
          local finders = require 'telescope.finders'
          local conf = require('telescope.config').values
          local actions = require 'telescope.actions'
          local action_state = require 'telescope.actions.state'
          pickers
            .new({}, {
              prompt_title = 'Unsolved DSA Notes (' .. #unsolved .. ')',
              finder = finders.new_table {
                results = unsolved,
                entry_maker = function(f)
                  return {
                    value = f,
                    display = vim.fn.fnamemodify(f, ':t'),
                    ordinal = vim.fn.fnamemodify(f, ':t'),
                    path = f,
                  }
                end,
              },
              sorter = conf.generic_sorter {},
              previewer = conf.file_previewer {},
              attach_mappings = function(prompt_bufnr)
                actions.select_default:replace(function()
                  actions.close(prompt_bufnr)
                  local entry = action_state.get_selected_entry()
                  vim.cmd('edit ' .. entry.path)
                end)
                return true
              end,
            })
            :find()
        end,
        desc = 'Notes: LeetCode: List unsolved DSA notes',
      },
      {
        '<leader>nDo',
        function()
          local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
          for _, line in ipairs(lines) do
            local url = line:match '%*%*URL%*%*:%s*(https?://%S+)'
            if url then
              vim.fn.jobstart { 'xdg-open', url }
              vim.notify('Opening: ' .. url, vim.log.levels.INFO)
              return
            end
          end
          vim.notify('No URL found in this note', vim.log.levels.WARN)
        end,
        desc = 'Notes: LeetCode: Open problem URL in browser',
      },
      {
        '<leader>nDT',
        function()
          local dsa_path = vim.fn.expand '~/personal/notes/dsa'
          local files = vim.fn.globpath(dsa_path, '*.md', false, true)
          local today_files = {}
          local today_str = os.date '%Y-%m-%d'
          for _, f in ipairs(files) do
            local mtime = vim.fn.getftime(f)
            if os.date('%Y-%m-%d', mtime) == today_str then
              table.insert(today_files, f)
            end
          end
          if #today_files == 0 then
            vim.notify('No DSA notes modified today', vim.log.levels.INFO)
            return
          end
          if #today_files == 1 then
            vim.cmd('edit ' .. today_files[1])
            return
          end
          local pickers = require 'telescope.pickers'
          local finders = require 'telescope.finders'
          local conf = require('telescope.config').values
          local actions = require 'telescope.actions'
          local action_state = require 'telescope.actions.state'
          pickers
            .new({}, {
              prompt_title = "Today's DSA Notes",
              finder = finders.new_table {
                results = today_files,
                entry_maker = function(f)
                  return {
                    value = f,
                    display = vim.fn.fnamemodify(f, ':t'),
                    ordinal = vim.fn.fnamemodify(f, ':t'),
                    path = f,
                  }
                end,
              },
              sorter = conf.generic_sorter {},
              previewer = conf.file_previewer {},
              attach_mappings = function(prompt_bufnr)
                actions.select_default:replace(function()
                  actions.close(prompt_bufnr)
                  local entry = action_state.get_selected_entry()
                  vim.cmd('edit ' .. entry.path)
                end)
                return true
              end,
            })
            :find()
        end,
        desc = "Notes: LeetCode: Jump to today's DSA note",
      },
      {
        '<leader>nDc',
        function()
          vim.ui.input({ prompt = 'Time complexity (e.g. O(n log n)): ' }, function(time_c)
            if not time_c or time_c == '' then
              return
            end
            vim.ui.input({ prompt = 'Space complexity (e.g. O(n)): ' }, function(space_c)
              if not space_c or space_c == '' then
                return
              end
              local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
              local replaced = false
              for i, line in ipairs(lines) do
                if line:match '^%- Time:' then
                  lines[i] = '- Time: ' .. time_c
                  replaced = true
                elseif line:match '^%- Space:' then
                  lines[i] = '- Space: ' .. space_c
                  replaced = true
                end
              end
              if replaced then
                vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
                vim.cmd 'write'
                vim.notify('Complexity updated', vim.log.levels.INFO)
              else
                vim.notify('No "- Time:" / "- Space:" lines found in note', vim.log.levels.WARN)
              end
            end)
          end)
        end,
        desc = 'Notes: LeetCode: Fill complexity section',
      },
      {
        '<leader>nSDn',
        function()
          local Path = require 'plenary.path'
          vim.ui.input({ prompt = 'System Design title: ' }, function(title)
            if not title or title == '' then
              return
            end
            local slug = title:gsub('%s+', '-'):gsub('[^A-Za-z0-9-]', ''):lower()
            local ts = tostring(os.time())
            local filename = vim.fn.expand '~/personal/notes/systems/' .. ts .. '-' .. slug .. '.md'
            Path:new(filename):touch { parents = true }
            vim.cmd('edit ' .. filename)
            vim.cmd 'ObsidianTemplate system_design_template'
            vim.notify('New System Design: ' .. title, vim.log.levels.INFO)
          end)
        end,
        desc = 'Notes: New system design note',
      },
      {
        '<leader>nSDs',
        function()
          require('telescope.builtin').find_files {
            prompt_title = 'System Design Notes',
            cwd = vim.fn.expand '~/personal/notes/systems',
            hidden = false,
          }
        end,
        desc = 'Notes: System Design: Browse notes',
      },
      {
        '<leader>nSDr',
        function()
          local sd_path = vim.fn.expand '~/personal/notes/systems'
          local files = vim.fn.globpath(sd_path, '*.md', false, true)
          if #files == 0 then
            vim.notify('No system design notes found', vim.log.levels.WARN)
            return
          end
          math.randomseed(os.time())
          local pick = files[math.random(#files)]
          vim.cmd('edit ' .. pick)
          vim.notify('Review: ' .. vim.fn.fnamemodify(pick, ':t'), vim.log.levels.INFO)
        end,
        desc = 'Notes: System Design: Open random note',
      },
      {
        '<leader>nPn',
        function()
          local Path = require 'plenary.path'
          vim.ui.input({ prompt = 'Design Pattern title: ' }, function(title)
            if not title or title == '' then
              return
            end
            local slug = title:gsub('%s+', '-'):gsub('[^A-Za-z0-9-]', ''):lower()
            local ts = tostring(os.time())
            local filename = vim.fn.expand '~/personal/notes/systems/patterns/' .. ts .. '-' .. slug .. '.md'
            Path:new(filename):touch { parents = true }
            vim.cmd('edit ' .. filename)
            vim.cmd 'ObsidianTemplate pattern_template'
            vim.notify('New Design Pattern: ' .. title, vim.log.levels.INFO)
          end)
        end,
        desc = 'Notes: New design pattern note',
      },
      {
        '<leader>nPs',
        function()
          require('telescope.builtin').find_files {
            prompt_title = 'Design Pattern Notes',
            cwd = vim.fn.expand '~/personal/notes/systems/patterns',
            hidden = false,
          }
        end,
        desc = 'Notes: Design Pattern: Browse notes',
      },
      {
        '<leader>nPr',
        function()
          local pat_path = vim.fn.expand '~/personal/notes/systems/patterns'
          local files = vim.fn.globpath(pat_path, '*.md', false, true)
          if #files == 0 then
            vim.notify('No design pattern notes found', vim.log.levels.WARN)
            return
          end
          math.randomseed(os.time())
          local pick = files[math.random(#files)]
          vim.cmd('edit ' .. pick)
          vim.notify('Review: ' .. vim.fn.fnamemodify(pick, ':t'), vim.log.levels.INFO)
        end,
        desc = 'Notes: Design Pattern: Open random note',
      },
      {
        '<leader>nN',
        function()
          local Path = require 'plenary.path'
          local dsa_path = vim.fn.expand '~/personal/notes/dsa'
          local build_lc_content = function(q, url, is_daily)
            local date_label = is_daily and os.date '%Y-%m-%d' .. ' (Daily)' or os.date '%Y-%m-%d'
            return {
              '# ' .. q.questionFrontendId .. '. ' .. q.title,
              '',
              '---',
              '**Difficulty**: ' .. (q.difficulty or 'Unknown'),
              '**Date**: ' .. date_label,
              '**URL**: ' .. (url or 'https://leetcode.com/problems/' .. q.titleSlug),
              '**Tags**: #leetcode',
              '---',
              '',
              '## Problem Statement',
              '',
              '## Idea (1-2 sentences)',
              '<!-- What was the core insight? -->',
              '',
              '## Approach',
              '',
              '- ',
              '',
              '## Edge Cases',
              '',
              '- ',
              '',
              '## Complexity',
              '',
              '- Time: ',
              '- Space: ',
              '',
              '## Solution',
              '',
              '```',
              '```',
            }
          end
          local new_typed_note = function(folder, template, label)
            return function()
              vim.ui.input({ prompt = label .. ' title: ' }, function(title)
                if not title or title == '' then
                  return
                end
                local slug = title:gsub('%s+', '-'):gsub('[^A-Za-z0-9-]', ''):lower()
                local ts = tostring(os.time())
                local filename = vim.fn.expand('~/personal/notes/' .. folder .. '/') .. ts .. '-' .. slug .. '.md'
                Path:new(filename):touch { parents = true }
                vim.cmd('edit ' .. filename)
                vim.cmd('ObsidianTemplate ' .. template)
                vim.notify('New ' .. label .. ': ' .. title, vim.log.levels.INFO)
              end)
            end
          end
          local pickers = require 'telescope.pickers'
          local finders = require 'telescope.finders'
          local conf = require('telescope.config').values
          local actions = require 'telescope.actions'
          local action_state = require 'telescope.actions.state'
          local note_types = {
            { label = 'Project', desc = 'projects/', creator = new_typed_note('projects', 'project_template', 'Project') },
            { label = 'Learning', desc = 'learning/', creator = new_typed_note('learning', 'learning_template', 'Learning') },
            { label = 'Article', desc = 'ai/', creator = new_typed_note('ai', 'article_template', 'Article') },
            { label = 'TIL', desc = 'daily/', creator = new_typed_note('daily', 'til_template', 'TIL') },
            { label = 'System Design', desc = 'systems/', creator = new_typed_note('systems', 'system_design_template', 'System Design') },
            { label = 'Pattern', desc = 'systems/patterns/', creator = new_typed_note('systems/patterns', 'pattern_template', 'Design Pattern') },
            {
              label = 'DSA (manual)',
              desc = 'dsa/  - no API',
              creator = function()
                vim.ui.input({ prompt = 'Problem number: ' }, function(num)
                  if not num or num == '' then
                    return
                  end
                  vim.ui.input({ prompt = 'Title slug (e.g. two-sum): ' }, function(slug)
                    if not slug or slug == '' then
                      return
                    end
                    local filename = string.format('%s/%03d-%s.md', dsa_path, tonumber(num) or 0, slug)
                    local q = { questionFrontendId = num, title = slug:gsub('-', ' '), titleSlug = slug, difficulty = '' }
                    local content = build_lc_content(q, nil, false)
                    Path:new(filename):touch { parents = true }
                    Path:new(filename):write(table.concat(content, '\n'), 'w')
                    vim.cmd('edit ' .. filename)
                    vim.notify('New DSA note: ' .. num .. '-' .. slug, vim.log.levels.INFO)
                  end)
                end)
              end,
            },
          }
          pickers
            .new({}, {
              prompt_title = 'New Note - pick a type',
              finder = finders.new_table {
                results = note_types,
                entry_maker = function(t)
                  return {
                    value = t,
                    display = string.format('%-16s  %s', t.label, t.desc),
                    ordinal = t.label,
                  }
                end,
              },
              sorter = conf.generic_sorter {},
              attach_mappings = function(prompt_bufnr)
                actions.select_default:replace(function()
                  actions.close(prompt_bufnr)
                  local entry = action_state.get_selected_entry()
                  entry.value.creator()
                end)
                return true
              end,
            })
            :find()
        end,
        desc = 'Notes: New note - pick type from picker',
      },
      {
        '<leader>nR',
        function()
          local dsa_path = vim.fn.expand '~/personal/notes/dsa'
          local sd_path = vim.fn.expand '~/personal/notes/systems'
          local pat_path = vim.fn.expand '~/personal/notes/systems/patterns'
          local pickers = require 'telescope.pickers'
          local finders = require 'telescope.finders'
          local conf = require('telescope.config').values
          local actions = require 'telescope.actions'
          local action_state = require 'telescope.actions.state'
          local domains = {
            { label = 'DSA', path = dsa_path, glob = '*.md' },
            { label = 'System Design', path = sd_path, glob = '*.md' },
            { label = 'Design Pattern', path = pat_path, glob = '*.md' },
            { label = 'Learning', path = vim.fn.expand '~/personal/notes/learning', glob = '*.md' },
            { label = 'Article / AI', path = vim.fn.expand '~/personal/notes/ai', glob = '*.md' },
          }
          pickers
            .new({}, {
              prompt_title = 'Random Review - pick a domain',
              finder = finders.new_table {
                results = domains,
                entry_maker = function(d)
                  return { value = d, display = d.label, ordinal = d.label }
                end,
              },
              sorter = conf.generic_sorter {},
              attach_mappings = function(prompt_bufnr)
                actions.select_default:replace(function()
                  actions.close(prompt_bufnr)
                  local domain = action_state.get_selected_entry().value
                  local files = vim.fn.globpath(domain.path, domain.glob, false, true)
                  if #files == 0 then
                    vim.notify('No notes in ' .. domain.label, vim.log.levels.WARN)
                    return
                  end
                  math.randomseed(os.time())
                  local pick = files[math.random(#files)]
                  vim.cmd('edit ' .. pick)
                  vim.notify('[' .. domain.label .. '] ' .. vim.fn.fnamemodify(pick, ':t'), vim.log.levels.INFO)
                end)
                return true
              end,
            })
            :find()
        end,
        desc = 'Notes: Random review - pick domain from picker',
      },
      {
        '<leader>nSt',
        function()
          local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
          local tag_line = ''
          for _, l in ipairs(lines) do
            if l:match '^tags:' then
              tag_line = l
              break
            end
          end
          local cycles = {
            ['system-design'] = { 'draft', 'in-progress', 'complete' },
            ['design-pattern'] = { 'draft', 'in-progress', 'complete' },
            ['learning'] = { 'in-progress', 'completed', 'paused' },
            ['project'] = { 'active', 'paused', 'shipped', 'abandoned' },
          }
          local cycle = { 'draft', 'in-progress', 'complete' }
          for tag, seq in pairs(cycles) do
            if tag_line:match(tag) then
              cycle = seq
              break
            end
          end
          local status_i = nil
          local cur_status = nil
          for i, l in ipairs(lines) do
            local s = l:match '^status:%s*(.+)$'
            if s then
              status_i = i
              cur_status = s:match '^([^%s#]+)'
              break
            end
          end
          if not status_i then
            vim.notify('No status: field found in frontmatter', vim.log.levels.WARN)
            return
          end
          local next_status = cycle[1]
          for idx, v in ipairs(cycle) do
            if v == cur_status then
              next_status = cycle[(idx % #cycle) + 1]
              break
            end
          end
          lines[status_i] = 'status: ' .. next_status
          vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
          vim.cmd 'write'
          vim.notify('Status: ' .. (cur_status or '?') .. ' -> ' .. next_status, vim.log.levels.INFO)
        end,
        desc = 'Notes: Cycle status field in frontmatter',
      },
      {
        '<leader>nDg',
        function()
          local dsa_path = vim.fn.expand '~/personal/notes/dsa'
          local sd_path = vim.fn.expand '~/personal/notes/systems'
          local pat_path = vim.fn.expand '~/personal/notes/systems/patterns'
          local vault = vim.fn.expand '~/personal/notes'
          local pickers = require 'telescope.pickers'
          local finders = require 'telescope.finders'
          local conf = require('telescope.config').values
          local actions = require 'telescope.actions'
          local action_state = require 'telescope.actions.state'
          local domains = {
            { label = 'DSA', path = dsa_path },
            { label = 'System Design', path = sd_path },
            { label = 'Design Pattern', path = pat_path },
            { label = 'Learning', path = vault .. '/learning' },
            { label = 'Article / AI', path = vault .. '/ai' },
            { label = 'Projects', path = vault .. '/projects' },
            { label = 'All Notes', path = vault },
          }
          pickers
            .new({}, {
              prompt_title = 'Grep in domain - pick one',
              finder = finders.new_table {
                results = domains,
                entry_maker = function(d)
                  return { value = d, display = d.label, ordinal = d.label }
                end,
              },
              sorter = conf.generic_sorter {},
              attach_mappings = function(prompt_bufnr)
                actions.select_default:replace(function()
                  actions.close(prompt_bufnr)
                  local domain = action_state.get_selected_entry().value
                  require('telescope.builtin').live_grep {
                    prompt_title = 'Grep: ' .. domain.label,
                    search_dirs = { domain.path },
                  }
                end)
                return true
              end,
            })
            :find()
        end,
        desc = 'Notes: Domain-scoped live grep - pick domain then search',
      },
      {
        '<leader>ngs',
        function()
          local vault = vim.fn.expand '~/personal/notes'
          local lines = vim.fn.systemlist('git -C ' .. vault .. ' status -s')
          if #lines == 0 then
            lines = { '(nothing to commit, working tree clean)' }
          end
          local buf = vim.api.nvim_create_buf(false, true)
          vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.list_extend({ '# Vault git status', '' }, lines))
          vim.bo[buf].filetype = 'markdown'
          vim.bo[buf].modifiable = false
          local w = math.min(60, vim.o.columns - 4)
          local h = math.min(#lines + 4, vim.o.lines - 6)
          vim.api.nvim_open_win(buf, true, {
            relative = 'editor',
            style = 'minimal',
            border = 'rounded',
            width = w,
            height = h,
            row = math.floor((vim.o.lines - h) / 2),
            col = math.floor((vim.o.columns - w) / 2),
          })
          vim.keymap.set('n', 'q', '<cmd>close<CR>', { buffer = buf, silent = true })
          vim.keymap.set('n', '<Esc>', '<cmd>close<CR>', { buffer = buf, silent = true })
        end,
        desc = 'Notes: Vault: git status',
      },
      {
        '<leader>ngp',
        function()
          local vault = vim.fn.expand '~/personal/notes'
          local ts = os.date '%Y-%m-%d %H:%M'
          local msg = 'vault: sync ' .. ts
          vim.ui.input({ prompt = 'Commit message: ', default = msg }, function(input)
            if not input or input == '' then
              return
            end
            local out = vim.fn.system(
              'git -C ' .. vault .. ' add -A && git -C ' .. vault .. ' commit -m ' .. vim.fn.shellescape(input) .. ' ; git -C ' .. vault .. ' push 2>&1'
            )
            vim.notify(out, vim.log.levels.INFO)
          end)
        end,
        desc = 'Notes: Vault: stage all, commit and push',
      },
      { '<leader>ngl', function() require('telescope.builtin').git_commits { cwd = vim.fn.expand '~/personal/notes' } end, desc = 'Notes: Vault: git log in Telescope' },
      {
        '<leader>n<leader>',
        function()
          local Path = require 'plenary.path'
          local vault = vim.fn.expand '~/personal/notes'
          local dsa_path = vault .. '/dsa'
          local sd_path = vault .. '/systems'
          local pat_path = vault .. '/systems/patterns'
          local today = os.date '%Y-%m-%d'
          local week = os.date '%Y-W%V'
          local daily_path = vault .. '/daily/' .. today .. '.md'
          local weekly_path = vault .. '/daily/' .. week .. '-weekly-review.md'
          local function count_matching(glob_path, pattern)
            local files = vim.fn.globpath(glob_path, '*.md', false, true)
            local n = 0
            for _, f in ipairs(files) do
              local ok, txt = pcall(function()
                return Path:new(f):read()
              end)
              if ok and txt:match(pattern) then
                n = n + 1
              end
            end
            return n
          end
          local function count_files(glob_path)
            return #vim.fn.globpath(glob_path, '*.md', false, true)
          end
          local daily_done = vim.fn.filereadable(daily_path) == 1
          local weekly_done = vim.fn.filereadable(weekly_path) == 1
          local dsa_total = count_files(dsa_path)
          local dsa_solved = count_matching(dsa_path, '%*%*Solved%*%*')
          local dsa_unsolved = dsa_total - dsa_solved
          local sd_ip = count_matching(sd_path, 'status:%s*in%-progress')
          local pat_ip = count_matching(pat_path, 'status:%s*in%-progress')
          local learn_ip = count_matching(vault .. '/learning', 'status:%s*in%-progress')
          local proj_active = count_matching(vault .. '/projects', 'status:%s*active')
          local git_lines = vim.fn.systemlist('git -C ' .. vault .. ' status -s')
          local git_summary = #git_lines == 0 and 'clean' or (#git_lines .. ' change' .. (#git_lines == 1 and '' or 's'))
          local function tick(v)
            return v and '✓' or '✗'
          end
          local lines = {
            '  Note Dashboard - ' .. today,
            '  ----------------------------------------',
            ('  Daily note      %s  %s'):format(tick(daily_done), daily_done and today or 'not created'),
            ('  Weekly review   %s  %s'):format(tick(weekly_done), weekly_done and week or 'pending'),
            '  ----------------------------------------',
            ('  DSA             %d total  /  %d solved  /  %d unsolved'):format(dsa_total, dsa_solved, dsa_unsolved),
            ('  System Design   %d in-progress'):format(sd_ip),
            ('  Design Pattern  %d in-progress'):format(pat_ip),
            ('  Learning        %d in-progress'):format(learn_ip),
            ('  Projects        %d active'):format(proj_active),
            '  ----------------------------------------',
            ('  Vault git       %s'):format(git_summary),
            '',
            '  q / <Esc> to close',
          }
          local w = 52
          local h = #lines + 2
          local buf = vim.api.nvim_create_buf(false, true)
          vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
          vim.bo[buf].modifiable = false
          vim.bo[buf].filetype = 'markdown'
          local ns = vim.api.nvim_create_namespace 'note_dashboard'
          for i, line in ipairs(lines) do
            if line:match '✓' then
              vim.api.nvim_buf_add_highlight(buf, ns, 'DiagnosticOk', i - 1, 0, -1)
            elseif line:match '✗' then
              vim.api.nvim_buf_add_highlight(buf, ns, 'DiagnosticWarn', i - 1, 0, -1)
            end
          end
          vim.api.nvim_open_win(buf, true, {
            relative = 'editor',
            style = 'minimal',
            border = 'rounded',
            width = w,
            height = h,
            row = math.floor((vim.o.lines - h) / 2),
            col = math.floor((vim.o.columns - w) / 2),
          })
          vim.keymap.set('n', 'q', '<cmd>close<CR>', { buffer = buf, silent = true })
          vim.keymap.set('n', '<Esc>', '<cmd>close<CR>', { buffer = buf, silent = true })
        end,
        desc = 'Notes: Open note dashboard',
      },
      {
        '<leader>nhl',
        function()
          local Path = require 'plenary.path'
          local dsa_path = vim.fn.expand '~/personal/notes/dsa'
          local sd_path = vim.fn.expand '~/personal/notes/systems'
          local pat_path = vim.fn.expand '~/personal/notes/systems/patterns'
          vim.notify('Linting vault…', vim.log.levels.INFO)
          local scan_dirs = {
            vim.fn.expand '~/personal/notes/projects',
            vim.fn.expand '~/personal/notes/learning',
            vim.fn.expand '~/personal/notes/ai',
            dsa_path,
            sd_path,
            pat_path,
          }
          local issues = {}
          local stale_days = 14
          local now = os.time()
          local function short(f)
            return f:gsub(vim.fn.expand '~/personal/notes/', '')
          end
          for _, dir in ipairs(scan_dirs) do
            local files = vim.fn.globpath(dir, '*.md', false, true)
            for _, f in ipairs(files) do
              local ok, txt = pcall(function()
                return Path:new(f):read()
              end)
              if not ok then
                goto continue
              end
              local fname = short(f)
              if not txt:match 'tags:%s*%[.+%]' and not txt:match 'tags:%s*%[%]' == false then
                if not txt:match 'tags:' or txt:match 'tags:%s*%[%]' then
                  table.insert(issues, { file = f, display = fname, issue = 'no tags' })
                end
              end
              if txt:match 'status:%s*draft' then
                local mtime = vim.fn.getftime(f)
                local age = math.floor((now - mtime) / 86400)
                if age >= stale_days then
                  table.insert(issues, { file = f, display = fname, issue = 'draft for ' .. age .. ' days' })
                end
              end
              local prev_heading = nil
              for line in txt:gmatch '[^\n]+' do
                if line:match '^##+ ' then
                  if prev_heading then
                    table.insert(issues, { file = f, display = fname, issue = 'empty section: ' .. prev_heading })
                    prev_heading = nil
                  end
                  prev_heading = line:match '^(##+ .-)%s*$'
                elseif line:match '%S' then
                  prev_heading = nil
                end
              end
              if prev_heading then
                table.insert(issues, { file = f, display = fname, issue = 'empty section: ' .. prev_heading })
              end
              ::continue::
            end
          end
          if #issues == 0 then
            vim.notify('Vault is healthy - no issues found', vim.log.levels.INFO)
            return
          end
          local pickers = require 'telescope.pickers'
          local finders = require 'telescope.finders'
          local conf = require('telescope.config').values
          local actions = require 'telescope.actions'
          local action_state = require 'telescope.actions.state'
          pickers
            .new({}, {
              prompt_title = 'Vault Health (' .. #issues .. ' issues)',
              finder = finders.new_table {
                results = issues,
                entry_maker = function(issue)
                  local display = string.format('%-40s  %s', issue.display, issue.issue)
                  return {
                    value = issue,
                    display = display,
                    ordinal = display,
                    path = issue.file,
                  }
                end,
              },
              sorter = conf.generic_sorter {},
              previewer = conf.file_previewer {},
              attach_mappings = function(prompt_bufnr)
                actions.select_default:replace(function()
                  actions.close(prompt_bufnr)
                  local entry = action_state.get_selected_entry()
                  vim.cmd('edit ' .. entry.value.file)
                end)
                return true
              end,
            })
            :find()
        end,
        desc = 'Notes: Vault health lint - show issues in Telescope',
      },
    },

    config = function(_, opts)
      require('obsidian').setup(opts)

      -- Clean markdown rendering
      vim.opt.conceallevel = 2
    end,
  },
}
