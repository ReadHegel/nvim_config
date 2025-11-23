local categories = {
  'coding',
  'colors',
  'editor',
  'debug',
  'formating',
  'linting',
  'lsp',
  'treesitter',
  'ui',
  'utils',
}

local plugins = { require 'plugins.mason' }
for _, cat in ipairs(categories) do
  local ok, mod = pcall(require, 'plugins.' .. cat)
  if ok and type(mod) == 'table' then
    vim.list_extend(plugins, mod)
  end
end

-- -- debug: wypisz co jest w plugins
-- for i, p in ipairs(plugins) do
--   print(i, vim.inspect(p))
-- end

return plugins
