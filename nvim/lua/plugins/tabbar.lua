return {
  'romgrk/barbar.nvim',
  dependencies = {
    'lewis6991/gitsigns.nvim', 
    'nvim-tree/nvim-web-devicons', 
  },
  lazy = false,
  init = function() vim.g.barbar_auto_setup = false end,
  keys = {
    { '<leader>bc', ':BufferClose<CR>', desc = 'Close current buffer' },
    { '<leader>bn', ':BufferNext<CR>', desc = 'Next buffer' },
    { '<leader>bb', ':BufferPrevious<CR>', desc = 'Previous buffer' },
    { '<leader>bj', ':BufferPick<CR>', desc = 'Jump to buffer' },
  },
  opts = {
    insert_at_start = true,
  },
  version = '^1.0.0', -- optional: only update when a new 1.x version is released
}

