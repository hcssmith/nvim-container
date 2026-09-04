require('zen-mode').setup {
  window = {
    options = {
      number = false,
      relativenumber = false,
    }
  }
}

vim.keymap.set('n', '<leader>z', function()
  require('zen-mode').toggle()
end, { desc = 'Toggle zen mode' })
