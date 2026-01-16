return {
  'obsidian-nvim/obsidian.nvim',
  version = '*',
  lazy = false,
  ft = 'markdown',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
  },
  config = function()
    local curl = require 'plenary.curl'
    local Path = require 'plenary.path'

    -------------------------------------------------------------------------
    -- Dynamic Path Setup (Current Working Directory)
    -------------------------------------------------------------------------
    -- This gets the directory where you started Neovim
    local CWD = vim.fn.getcwd()
    local PROBLEMS_PATH = CWD

    -- Ensure the leetcode subdirectory exists
    -- if vim.fn.isdirectory(PROBLEMS_PATH) == 0 then
    --   vim.fn.mkdir(PROBLEMS_PATH, 'p')
    -- end

    -------------------------------------------------------------------------
    -- LeetCode Problem Creator
    -------------------------------------------------------------------------
    local function create_leetcode_daily_problem()
      print 'Fetching daily problem data...'

      curl.get('https://leetcode-api-pied.vercel.app/daily', {
        callback = function(response)
          vim.schedule(function()
            if response.status ~= 200 then
              print('Error: API returned ' .. response.status)
              return
            end

            local ok, problem = pcall(vim.json.decode, response.body)
            if not ok then
              return
            end

            if not problem then
              print('Problem ' .. problem_id .. ' not found')
              return
            end

            local problem_id = problem.question.questionFrontendId

            -- File setup
            local filename = string.format('%s/%03d-%s.md', PROBLEMS_PATH, problem.question.questionFrontendId, problem.question.titleSlug)

            local content = {
              '# ' .. problem.question.questionFrontendId .. '. ' .. problem.question.title,
              '---',
              '**Difficulty**: ' .. problem.question.difficulty,
              '**Date**: ' .. os.date '%Y-%m-%d' .. ' (Daily)',
              '**url**: ' .. (problem.url or 'https://leetcode.com/problems/' .. problem.question.titleSlug),
              '**tags**: [leetcode]',
              '---',
              '## Problem Statement',
              '',
              '## 🧠 Idea (1–2 sentences)',
              '<!-- What was the core insight? -->',
              '',
              '## 🔧 Approach',
              '<!-- Bullets. No paragraphs. -->',
              '',
              '- ',
              '',
              '## 🧪 Edge Cases',
              '- ',
              '',
              '## ⌚ Complexities',
              '- Time Complexity: ',
              '- Space Complexity: ',
            }

            Path:new(filename):write(table.concat(content, '\n'), 'w')
            vim.cmd('edit ' .. filename)
            print('Saved to: ./' .. problem.question.questionFrontendId .. '-' .. problem.question.titleSlug .. '.md')
          end)
        end,
      })
    end
    local function create_leetcode_problem()
      vim.ui.input({ prompt = 'Enter LeetCode problem number: ' }, function(problem_id)
        if not problem_id or problem_id == '' then
          return
        end

        print 'Fetching problem data...'

        curl.get('https://leetcode-api-pied.vercel.app/problems', {
          callback = function(response)
            vim.schedule(function()
              if response.status ~= 200 then
                print('Error: API returned ' .. response.status)
                return
              end

              local ok, data = pcall(vim.json.decode, response.body)
              if not ok then
                return
              end

              local problem = nil
              for _, p in ipairs(data) do
                if tostring(p.frontend_id) == tostring(problem_id) then
                  problem = p
                  break
                end
              end

              if not problem then
                print('Problem ' .. problem_id .. ' not found')
                return
              end

              -- File setup
              local filename = string.format('%s/%03d-%s.md', PROBLEMS_PATH, problem.frontend_id, problem.title_slug)

              local content = {
                '# ' .. problem.frontend_id .. '. ' .. problem.title,
                '---',
                '**Difficulty**: ' .. problem.difficulty,
                '**Date**: ' .. os.date '%Y-%m-%d',
                '**url**: ' .. (problem.url or 'https://leetcode.com/problems/' .. problem.title_slug),
                '**tags**: [leetcode]',
                '---',
                '## Problem Statement',
                problem.url,
                '',
                '## 🧠 Idea (1–2 sentences)',
                '<!-- What was the core insight? -->',
                '',
                '## 🔧 Approach',
                '<!-- Bullets. No paragraphs. -->',
                '',
                '- ',
                '',
                '## 🧪 Edge Cases',
                '- ',
                '',
                '## ⌚ Complexities',
                '- Time Complexity: ',
                '- Space Complexity: ',
              }

              Path:new(filename):write(table.concat(content, '\n'), 'w')
              vim.cmd('edit ' .. filename)
              print('Saved to: ./' .. problem.frontend_id .. '-' .. problem.title_slug .. '.md')
            end)
          end,
        })
      end)
    end

    -------------------------------------------------------------------------
    -- Obsidian.nvim Minimal Setup
    -------------------------------------------------------------------------
    require('obsidian').setup {
      workspaces = {
        {
          name = 'leetcode-local',
          path = CWD, -- Set workspace to current folder
        },
      },
      legacy_commands = false,
      ui = { enable = true },
      completion = { nvim_cmp = true },
    }

    -- Keymaps
    vim.keymap.set('n', '<leader>nl', create_leetcode_problem, { desc = 'LeetCode: New Note' })
    vim.keymap.set('n', '<leader>nd', create_leetcode_daily_problem, { desc = 'LeetCode: New Daily' })
    -- Search specifically within the leetcode folder
    vim.keymap.set('n', '<leader>ns', ':Telescope find_files cwd=' .. PROBLEMS_PATH .. '<CR>', { desc = 'LeetCode: Search Notes' })

    vim.opt.conceallevel = 2
  end,
}
