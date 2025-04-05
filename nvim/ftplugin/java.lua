local status, jdtls = pcall(require, "jdtls")
if not status then
  return
end

local home = os.getenv "HOME"
local workspace_path = home .. "/.local/share/jdtls-workspace/"
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = workspace_path .. project_name

local os_config = "linux"
if vim.fn.has "mac" == 1 then
  os_config = "mac_arm"
end


-- setup debuggers
local mason_path = home .. '/.local/share/nvim/mason/packages'
local java_debug_jar = home .. '/.local/share/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-0.53.1.jar'
local vscode_java_test_jars = home .. '/.local/share/vscode-java-test/server/*.jar'
local bundles = {
  java_debug_jar,
}
vim.list_extend(
  bundles,
  vim.split(
    vim.fn.glob(vscode_java_test_jars, true),
    "\n"
  )
)
--

local config = {
  cmd = {
    "java",
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-Xms1g",
    "--add-modules=ALL-SYSTEM",
    "--add-opens",
    "java.base/java.util=ALL-UNNAMED",
    "--add-opens",
    "java.base/java.lang=ALL-UNNAMED",
    "-javaagent:" .. mason_path .. "/jdtls/lombok.jar",
    "-jar",
    vim.fn.glob(mason_path .. "/jdtls/plugins/org.eclipse.equinox.launcher_*.jar"),
    "-configuration",
    mason_path .. "/jdtls/config_" .. os_config,
    "-data",
    workspace_dir,
  },
  root_dir = jdtls.setup.find_root { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" },

  settings = {
    java = {
      eclipse = {
        downloadSources = true,
      },
      configuration = {
        updateBuildConfiguration = "interactive",
        runtimes = {
          {
            name = "JavaSE-17",
            path = home .. "/.sdkman/candidates/java/17.0.4-amzn",
          },
        },
      },
      maven = {
        downloadSources = true,
      },
      referencesCodeLens = {
        enabled = true,
      },
      references = {
        includeDecompiledSources = true,
      },
      inlayHints = {
        parameterNames = {
          enabled = "all", -- literals, all, none
        },
      },
      format = {
        enabled = false,
      },
    },
    signatureHelp = { enabled = true },
  },
  init_options = {
    bundles = bundles,
  },
}

config["on_attach"] = function(client, bufnr)
  jdtls.setup_dap()

  local wk = require('which-key')

  wk.add({
    { "<leader>C",  group = "Java" },
    { "<leader>Co", jdtls.organize_imports,    desc = "Organize imports" },
    { "<leader>Cv", jdtls.extract_variable,    desc = "Extract variable", mode = { "n", "v" } },
    { "<leader>Cm", jdtls.extract_method,      desc = "Extract method",   mode = { "n", "v" } },
    { "<leader>Cc", jdtls.extract_constant,    desc = "Extract constant", mode = { "n", "v" } },
    { "<leader>Ct", jdtls.test_nearest_method, desc = "Test method" },
    { "<leader>CT", jdtls.test_class,          desc = "Test class" },
  })
end

jdtls.start_or_attach(config)
