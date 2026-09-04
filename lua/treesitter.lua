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

-- Load a parser, warning instead of failing silently.
-- language.add returns nil, errmsg on failure rather than throwing,
-- so a bare pcall would swallow breakage (e.g. a parser .so with
-- missing external-scanner symbols after an upstream change).
local function add(lang)
  local ok, added, err = pcall(vim.treesitter.language.add, lang)
  if not ok then
    vim.notify(string.format('treesitter: error loading parser %q: %s', lang, added), vim.log.levels.WARN)
  elseif not added then
    vim.notify(string.format('treesitter: failed to load parser %q: %s', lang, err), vim.log.levels.WARN)
  end
end

for _, lang in ipairs(parsers) do
  add(lang)
end

-- Register the parser names; these must match the .so filenames
-- in /usr/local/lib/nvim/parser/
local extra = {
  'postgres',
  'plpgsql',
}

for _, lang in ipairs(extra) do
  add(lang)
end

-- Auto-start treesitter highlighting for custom filetypes.
-- Standard languages have built-in ftplugin support, but custom
-- filetypes need an explicit autocommand to call vim.treesitter.start().
vim.api.nvim_create_autocmd('FileType', {
  pattern = extra,
  callback = function(args)
    local ok, err = pcall(vim.treesitter.start)
    if not ok then
      vim.notify(string.format('treesitter: failed to start highlighting for %s: %s', args.match, err), vim.log.levels.WARN)
    end
  end,
})
