local function serialize_table(tbl, indent)
    indent = indent or ""
    local result = "{\n"

    for key, value in pairs(tbl) do
        local formatted_key = (type(key) == "string") and string.format("[%q]", key) or "[" .. key .. "]"
        if type(value) == "table" then
            result = result .. indent .. "  " .. formatted_key .. " = " .. serialize_table(value, indent .. "  ") .. ",\n"
        elseif type(value) == "string" then
            result = result .. indent .. "  " .. formatted_key .. " = " .. string.format("%q", value) .. ",\n"
        else
            result = result .. indent .. "  " .. formatted_key .. " = " .. tostring(value) .. ",\n"
        end
    end

    result = result .. indent .. "}"
    return result
end

local function dump_table_to_file(tbl, filename)
    local file = assert(io.open(filename, "w"))
    file:write("return " .. serialize_table(tbl) .. "\n")
    file:close()
end

local on_attach = function(client, bufnr)
  local jdtls = require('jdtls')
  jdtls.setup_dap()
  lvim.lsp.on_attach(client, bufnr)
  -- vim.keymap.set(
  --   'v',
  --   "<space>ca",
  --   "<ESC><CMD>lua vim.lsp.buf.range_code_action()<CR>",
  --   { noremap=true, silent=true, buffer=bufnr, desc = "Code actions" }
  -- )

  -- Java extensions provided by jdtls
  -- local bufopts = { noremap=true, silent=true, buffer=bufnr }
  -- nnoremap("<space>ev", jdtls.extract_variable, bufopts, "Extract variable")
  -- nnoremap("<space>ec", jdtls.extract_constant, bufopts, "Extract constant")
  -- vim.keymap.set(
  --   'v', "<space>em",
  --   [[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]],
  --   { noremap=true, silent=true, buffer=bufnr, desc = "Extract method" }
  -- )
  -- vim.keymap.set('n', "<A-o>", jdtls.organize_imports, bufopts)
  -- vim.keymap.set('n', "<leader>df", jdtls.test_class, bufopts)
  -- vim.keymap.set('n', "<leader>dn", jdtls.test_nearest_method, bufopts)
  -- vim.keymap.set('n', "crv", jdtls.extract_variable, bufopts)
  -- vim.keymap.set('v', 'crm', [[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]], bufopts)
  -- vim.keymap.set('n', "crc", jdtls.extract_constant, bufopts)
end

local home = os.getenv('HOME')

local mason_packages = home .. '/.local/share/lvim/mason/packages'

local jdtls_path = mason_packages .. '/jdtls'
local launcher_jar = jdtls_path .. '/plugins/org.eclipse.equinox.launcher_1.6.900.v20240613-2009.jar'
local env_config = jdtls_path .. '/config_mac_arm'

local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local data_path = home .. '/.local/share/lvim/jdtls_workspace/' .. project_name
local vscode_java_lsp = mason_packages .. '/java-debug-adapter/extension/server/*.jar'
local java_debug_path = mason_packages .. '/java-test/extension/server/*.jar'

-- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
local config = {
  -- The command that starts the language server
  -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
  cmd = {
    'java',
    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xmx1g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens', 'java.base/java.util=ALL-UNNAMED',
    '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
    '-jar', launcher_jar,
    '-configuration', env_config,
    '-data', data_path,
    '-javaagent:' .. jdtls_path .. '/lombok.jar',
  },

  root_dir = vim.fs.root(0, {".git", "mvnw", "gradlew", "pom.xml"}),

  -- Here you can configure eclipse.jdt.ls specific settings
  -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
  -- for a list of options
  settings = {
    java = {
    }
  },

  -- Language server `initializationOptions`
  -- You need to extend the `bundles` with paths to jar files
  -- if you want to use additional eclipse.jdt.ls plugins.
  --
  -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
  --
  -- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
  init_options = {
    bundles = {
      vim.fn.glob(vscode_java_lsp, true),
      vim.fn.glob(java_debug_path, true),
    }
  },
}

config.on_attach = on_attach

dump_table_to_file(config, home .. '/.local/state/jdtls_config.lua')
-- This starts a new client & server,
-- or attaches to an existing client & server depending on the `root_dir`.
require('jdtls').start_or_attach(config)
