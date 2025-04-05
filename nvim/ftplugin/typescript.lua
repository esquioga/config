local home = os.getenv('HOME')
local jsDebugAdapter = home .. '/.local/share/nvim/mason/packages/js-debug-adapter/js-debug-adapter'
local dap = require('dap')

dap.set_log_level('TRACE')

dap.adapters['pwa-node'] = {
  type = 'server',
  host = 'localhost',
  port = '${port}',
  executable = {
    command = 'node',
    args = {
      home .. '/.local/share/nvim/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js',
      '${port}',
    },
  },
}


for _, lang in ipairs({ 'javascript', 'typescript' }) do
  dap.configurations[lang] = {
    {
      type = "pwa-node",
      request = "launch",
      name = "Launch JS File",
      program = "${file}",
      cwd = vim.fn.getcwd(),
      sourceMaps = true,
      protocol = "inspector",
      console = "integratedTerminal",
    },
    {
      type = "pwa-node",
      request = "attach",
      name = "Attach",
      processId = require 'dap.utils'.pick_process,
      cwd = "${workspaceFolder}",
      sourceMaps = true,
    },
    {
      type = "node",
      request = "attach",
      name = "Auto Attach",
      cwd = vim.fn.getcwd(),
      sourceMaps = true,
    },
  }
end
