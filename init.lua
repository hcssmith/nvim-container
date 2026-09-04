-- General Settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wrap = false
vim.opt.scrolloff = 10
vim.opt.sidescrolloff = 8
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.signcolumn = "yes"
vim.opt.winborder = "rounded"
vim.opt.exrc = true
vim.opt.secure = true

vim.g.mapleader = " "
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

vim.keymap.set('i', 'jk', '<Esc>')
vim.keymap.set('n', '<M-Tab>', ':bnext<CR>')

vim.filetype.add({
  extension = {
    psql = 'postgres',
    pgsql = 'postgres',
    sql = 'postgres',
    plsql = 'plpgsql',
  },
})


vim.cmd.colorscheme("tokyonight-storm")


require('telescope')
require('treesitter')
require('statusline')
require('tabline')
require('zen')
require('ui')
require('buffers')

