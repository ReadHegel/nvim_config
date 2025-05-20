return {
  'f4z3r/gruvbox-material.nvim',
  name = 'gruvbox-material',
  lazy = false,
  config = function()
    vim.cmd 'colorscheme gruvbox-material'
    local colors = require('gruvbox-material.colors').get(vim.o.background, 'medium')

    require('gruvbox-material').setup {
      contrast = 'medium',
      customize = function(g, o)
        if g == 'CursorLineNr' then
          o.link = nil -- wipe a potential link, which would take precedence over other
          -- attributes
          o.fg = colors.orange -- or use any color in "#rrggbb" hex format
          o.bold = true
        end
        return o
      end,
    }
  end,
  priority = 1000,
  opts = {},
}
