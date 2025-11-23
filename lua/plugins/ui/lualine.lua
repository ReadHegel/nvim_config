return {
  'nvim-lualine/lualine.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    'echasnovski/mini.icons',
    'folke/snacks.nvim',
  },
  event = 'VeryLazy',

  init = function()
    vim.g.lualine_laststatus = vim.o.laststatus
    if vim.fn.argc(-1) > 0 then
      vim.o.statusline = ' '
    else
      vim.o.laststatus = 0
    end
  end,

  opts = function()
    -- === Mini helpers ===

    -- icon: filetype
    local function ft_icon(ft)
      local icon = MiniIcons.get('filetype', ft)
      return icon
    end

    -- icon: diagnostics (using MiniIcons LSP category)
    local function diag_icon(kind)
      local ico, _ = MiniIcons.get('lsp', kind)
      return ico or ''
    end

    -- fallback git icons
    local git_icons = {
      added = '+',
      modified = '~',
      removed = '-',
    }

    -- highlight color helper (replacement for Snacks.util.color)
    local function hl_fg(group)
      local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group })
      return ok and string.format('#%06x', hl.fg or 0xffffff) or nil
    end

    -- === Replacement for LazyVim.lualine.* ===

    local function root_dir()
      return vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
    end

    local function pretty_path()
      local file = vim.fn.expand '%:p'
      return vim.fn.fnamemodify(file, ':~:.')
    end

    -- === LUALINE CONFIG ===

    local opts = {
      options = {
        theme = 'auto',
        globalstatus = vim.o.laststatus == 3,
        disabled_filetypes = {
          statusline = { 'dashboard', 'alpha', 'ministarter', 'snacks_dashboard' },
        },
      },

      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch' },

        lualine_c = {
          root_dir,
          {
            'diagnostics',
            symbols = {
              error = diag_icon 'Error',
              warn = diag_icon 'Warning',
              info = diag_icon 'Information',
              hint = diag_icon 'Hint',
            },
          },
          {
            'filetype',
            icon_only = true,
            separator = '',
            padding = { left = 1, right = 0 },
          },
          pretty_path,
        },

        lualine_x = {
          Snacks.profiler.status(),

          -- Noice: command
          {
            function()
              return require('noice').api.status.command.get()
            end,
            cond = function()
              return package.loaded['noice'] and require('noice').api.status.command.has()
            end,
            color = function()
              return { fg = Snacks.util.color 'Statement' }
            end,
          },

          -- Noice: mode
          {
            function()
              return require('noice').api.status.mode.get()
            end,
            cond = function()
              return package.loaded['noice'] and require('noice').api.status.mode.has()
            end,
            color = function()
              return { fg = Snacks.util.color 'Constant' }
            end,
          },

          -- nvim-dap
          {
            function()
              return '  ' .. require('dap').status()
            end,
            cond = function()
              return package.loaded['dap'] and require('dap').status() ~= ''
            end,
            color = function()
              return { fg = Snacks.util.color 'Debug' }
            end,
          },

          -- Git diff
          {
            'diff',
            symbols = git_icons,
            source = function()
              local gitsigns = vim.b.gitsigns_status_dict
              if gitsigns then
                return {
                  added = gitsigns.added,
                  modified = gitsigns.changed,
                  removed = gitsigns.removed,
                }
              end
            end,
          },
        },

        lualine_y = {
          { 'progress', separator = ' ', padding = { left = 1, right = 0 } },
          { 'location', padding = { left = 0, right = 1 } },
        },

        lualine_z = {
          function()
            return ' ' .. os.date '%R'
          end,
        },
      },

      extensions = { 'neo-tree', 'fzf' },
    }

    return opts
  end,
}
