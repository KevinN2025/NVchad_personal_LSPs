require("nvchad.configs.lspconfig").defaults()

local lspconfig = require("lspconfig")
local on_attach = custom_config.on_attach
local capabilities = custom_config.capabilities

local servers = { "html", "cssls" }
vim.lsp.enable(servers)


local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"
local util = require "lspconfig/util"

-- Java (jdtls)
lspconfig.jdtls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  root_dir = function(fname)
    return util.root_pattern("pom.xml", "gradle.build", ".git", "build.gradle", "build.gradle.kts")(fname)
      or util.path.dirname(fname)
  end,
}

-- C/C++ (clangd)
lspconfig.clangd.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--header-insertion=never",
    "--completion-style=detailed",
    "--function-arg-placeholders",
    "--fallback-style=llvm",
    "--cross-file-rename"
  },
  filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
  root_dir = function(fname)
    return util.root_pattern(
      "compile_commands.json",
      "compile_flags.txt",
      ".git",
      "build",
      "CMakeLists.txt",
      "Makefile"
    )(fname) or util.path.dirname(fname)
  end,
}

-- TypeScript/JavaScript configuration
lspconfig.tsserver.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
  root_dir = util.root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git"),
  init_options = {
    preferences = {
      disableSuggestions = false,
    }
  },
  settings = {
    typescript = {
      inlayHints = {
        includeInlayParameterNameHints = "all",
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
    },
    javascript = {
      inlayHints = {
        includeInlayParameterNameHints = "all",
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
    },
  },
}

-- ESLint configuration (optional)
lspconfig.eslint.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  root_dir = util.root_pattern(".eslintrc.js", ".eslintrc.json", ".eslintrc", "package.json", ".git"),
  settings = {
    codeAction = {
      showDocumentation = {
        enable = true,
      },
    },
  },
}

-- Rust (rust-analyzer)
lspconfig.rust_analyzer.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "rust" },
  root_dir = util.root_pattern("Cargo.toml", "rust-project.json"),
  settings = {
    ["rust-analyzer"] = {
      cargo = {
        allFeatures = true,
        loadOutDirsFromCheck = true,
        runBuildScripts = true,
      },
      checkOnSave = {
        allFeatures = true,
        command = "clippy",
        extraArgs = { "--no-deps" },
      },
      procMacro = {
        enable = true,
        ignored = {
          ["async-trait"] = { "async_trait" },
          ["napi-derive"] = { "napi" },
          ["async-recursion"] = { "async_recursion" },
        },
      },
    },
  },
}
