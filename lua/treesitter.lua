local parsers = {
  'bash',
  'c',
  'cmake',
  'comment',
  'cpp',
  'css',
  'go',
  'gomod',
  'html',
  'java',
  'javascript',
  'json',
  'lua',
  'markdown',
  'markdown_inline',
  'python',
  'query',
  'regex',
  'rust',
  'toml',
  'typescript',
  'vim',
  'vimdoc',
  'yaml',
}

for _, lang in ipairs(parsers) do
  pcall(vim.treesitter.language.add, lang)
end

-- Register the parser names; these must match the .so filenames
-- in /usr/local/lib/nvim/parser/
local extra = {
  'postgres',
  'plpgsql',
}

for _, lang in ipairs(extra) do
  pcall(vim.treesitter.language.add, lang)
end

-- Auto-start treesitter highlighting for custom filetypes.
-- Standard languages have built-in ftplugin support, but custom
-- filetypes need an explicit autocommand to call vim.treesitter.start().
vim.api.nvim_create_autocmd('FileType', {
  pattern = extra,
  callback = function()
    pcall(vim.treesitter.start)
  end,
})
