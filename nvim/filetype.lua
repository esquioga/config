vim.filetype.add({
  extension = {
    tfbackend = "terraform-vars",
  },
  pattern = {
    [".*%.conf.j2"] = "nginx",
    [".*%.tf.j2"] = "terraform",
  }
})
