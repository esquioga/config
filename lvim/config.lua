-- general
lvim.log.level = "warn"
lvim.format_on_save = false
lvim.colorscheme = "gruvbox"
vim.opt.relativenumber = true

-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"
-- add your own keymapping
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = false

-- if you don't want all the parsers change this to a table of the ones you want
lvim.builtin.treesitter.ensure_installed = {
  "bash",
  "c",
  "javascript",
  "json",
  "lua",
  "python",
  "typescript",
  "tsx",
  "css",
  "rust",
  "java",
  "yaml",
}

lvim.builtin.treesitter.highlight.enabled = true


-- Additional Plugins
lvim.plugins = {
  "ellisonleao/gruvbox.nvim",
  "mfussenegger/nvim-dap",
  {
    "mfussenegger/nvim-jdtls",
    dependencies = { "mfussenegger/nvim-dap" }
  },
  "vim-test/vim-test",
  "tpope/vim-surround",
}

table.insert(lvim.plugins, {
  "zbirenbaum/copilot-cmp",
  event = "InsertEnter",
  dependencies = { "zbirenbaum/copilot.lua" },
  config = function()
    vim.defer_fn(function()
      require("copilot").setup() -- https://github.com/zbirenbaum/copilot.lua/blob/master/README.md#setup-and-configuration
      require("copilot_cmp").setup() -- https://github.com/zbirenbaum/copilot-cmp/blob/master/README.md#configuration
    end, 100)
  end,
})

-- Autocommands (https://neovim.io/doc/user/autocmd.html)
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = { "*.json", "*.jsonc" },
  -- enable wrap mode for json files only
  command = "setlocal wrap",
})
vim.api.nvim_create_autocmd("FileType", {
  pattern = "zsh",
  callback = function()
    -- let treesitter use bash highlight for zsh files as well
    require("nvim-treesitter.highlight").attach(0, "bash")
  end,
})

local dap = require('dap')
dap.configurations.java = {
  {
     -- You need to extend the classPath to list your dependencies.
     -- `nvim-jdtls` would automatically add the `classPaths` property if it is missing
    classPaths = {},

    -- If using multi-module projects, remove otherwise.
    projectName = "yourProjectName",

    javaExec = "/path/to/your/bin/java",
    mainClass = "your.package.name.MainClassName",

    -- If using the JDK9+ module system, this needs to be extended
    -- `nvim-jdtls` would automatically populate this property
    modulePaths = {},
    name = "Launch YourClassName",
    request = "launch",
    type = "java"
  },
}

require('keybindings')



