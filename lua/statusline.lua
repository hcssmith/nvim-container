local bg = vim.api.nvim_get_hl(0, { name = 'Normal' }).bg

local function hex(color)
  if not color then return nil end
  return string.format('#%06x', color)
end

local transparent = { bg = hex(bg) }

vim.opt.laststatus = 0

--[[
require('lualine').setup {
  options = {
    icons_enabled = true,
    section_separators = '',
    component_separators = '',
    theme = {
      normal = {
        a = transparent, b = transparent, c = transparent,
        x = transparent, y = transparent, z = transparent,
      },
      inactive = {
        a = transparent, b = transparent, c = transparent,
        x = transparent, y = transparent, z = transparent,
      },
    },
  },
  sections = {
    lualine_a = { 'branch', 'filename' },
    lualine_b = {},
    lualine_c = {},
    lualine_x = { { 'filetype', icon_only = true } },
    lualine_y = {},
    lualine_z = {},
  },
}
--]]
