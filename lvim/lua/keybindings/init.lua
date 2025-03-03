-- Telescope keybindings
lvim.builtin.which_key.mappings["f"] = {
  name = "Telescope",
  f = { "<cmd>Telescope find_files<cr>", "Files" },
  r = { "<cmd>Telescope lsp_references<cr>", "References" },
  b = { "<cmd>Telescope buffers<cr>", "Buffers" },
}


-- Vim test
lvim.builtin.which_key.mappings["t"] = {
  name = "Vim test",
  t = { "<cmd>TestNearest<cr>", "Method" },
  T = { "<cmd>TestFile<cr>", "File" },
  a = { "<cmd>TestSuite<cr>", "All tests" },
  r = { "<cmd>TestLast<cr>", "Rerun last" },
  j = { "<cmd>TestVisit<cr>", "Jump to last visited test" },
}
