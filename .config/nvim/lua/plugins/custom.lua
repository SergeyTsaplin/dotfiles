local golangci_config_filepath_cache = nil

local function golangci_config()
  if golangci_config_filepath_cache ~= nil then
    vim.notify_once("golangci-lint: " .. golangci_config_filepath_cache, vim.log.levels.INFO)
    return "--config=" .. golangci_config_filepath_cache
  end

  local found_bin = vim.fn.system("which golangci-lint")
  if not string.find(found_bin, "mason/bin") then
    vim.notify("golangci-lint binary not provided by mason: " .. found_bin, vim.log.levels.WARN)
  end

  local found_config
  found_config = vim.fs.find(
    { ".golangci.yml", ".golangci.yaml", ".golangci.toml", ".golangci.json" },
    { type = "file", limit = 1 }
  )
  if #found_config == 1 then
    local filepath = found_config[1]
    golangci_config_filepath_cache = filepath
    local arg = "--config=" .. golangci_config_filepath_cache
    return arg
  else
    return ""
    --local filepath = require("utils.environ").getenv("DOTFILES") .. "/templates/.golangci.yml"
    --golangci_config_filepath_cache = filepath
    --local arg = "--config=" .. golangci_config_filepath_cache
    --return arg
  end
end

local function golangci_filename()
  local filepath = vim.api.nvim_buf_get_name(0)
  local parent = vim.fn.fnamemodify(filepath, ":h")
  return parent
end

local function golangcilint_args()
  local ok, output = pcall(vim.fn.system, { "golangci-lint", "version" })
  if not ok then
    return
  end

  -- The golangci-lint install script and prebuilt binaries strip the v from the version
  --   tag so both strings must be checked
  if string.find(output, "version v1") or string.find(output, "version 1") then
    return {
      "run",
      "--out-format",
      "json",
      "--issues-exit-code=0",
      "--show-stats=false",
      "--print-issued-lines=false",
      "--print-linter-name=false",

      golangci_config,
      golangci_filename,
    }
  end

  return {
    "run",
    "--output.json.path=stdout",

    -- Overwrite values possibly set in .golangci.yml
    "--output.text.path=",
    "--output.tab.path=",
    "--output.html.path=",
    "--output.checkstyle.path=",
    "--output.code-climate.path=",
    "--output.junit-xml.path=",
    "--output.teamcity.path=",
    "--output.sarif.path=",

    "--issues-exit-code=0",
    "--show-stats=false",

    golangci_config,
    golangci_filename,
  }
end

local plugins = {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "go", "gomod", "gosum", "gowork", "python", "toml", "typespec" },
    },
  },
  {
    "stevearc/conform.nvim",
    dependencies = {
      {
        "mason-org/mason.nvim",
        opts = function(_, opts)
          opts.ensure_installed = opts.ensure_installed or {}
          vim.list_extend(opts.ensure_installed, { "gofumpt", "goimports", "gci", "golines", "ruff", "tsp-server" })
        end,
      },
    },
    opts = {
      formatters_by_ft = {
        go = { "goimports", "gci", "gofumpt", "golines" },
        python = { "ruff_format", "ruff_organize_imports" },
        typespec = { "tsp" },
      },
      formatters = {
        goimports = {
          -- https://github.com/stevearc/conform.nvim/blob/master/lua/conform/formatters/goimports.lua
          args = { "-srcdir", "$FILENAME" },
        },
        gci = {
          -- https://github.com/stevearc/conform.nvim/blob/master/lua/conform/formatters/gci.lua
          args = { "write", "--skip-generated", "-s", "standard", "-s", "default", "--skip-vendor", "$FILENAME" },
        },
        gofumpt = {
          -- https://github.com/stevearc/conform.nvim/blob/master/lua/conform/formatters/gofumpt.lua
          prepend_args = { "-extra", "-w", "$FILENAME" },
          stdin = false,
        },
        golines = {
          -- https://github.com/stevearc/conform.nvim/blob/master/lua/conform/formatters/golines.lua
          -- NOTE: golines will use goimports as base formatter by default which can be slow.
          -- see https://github.com/segmentio/golines/issues/33
          prepend_args = { "--base-formatter=gofumpt", "--ignore-generated", "--tab-len=1", "--max-len=120" },
        },
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    dependencies = {
      {
        "mason-org/mason.nvim",
        opts = function(_, opts)
          opts.ensure_installed = opts.ensure_installed or {}
          vim.list_extend(opts.ensure_installed, { "golangci-lint", "ruff", "mypy", "basedpyright", "tsp-server" })
        end,
      },
    },
    opts = function(_, opts)
      opts.linters_by_ft = opts.linters_by_ft or {}
      opts.linters = opts.linters or {}

      opts.linters_by_ft["go"] = { "golangcilint" }
      opts.linters["golangcilint"] = {
        args = golangcilint_args(),
        ignore_exitcode = true, -- NOTE: https://github.com/mfussenegger/nvim-lint/commit/3d5190d318e802de3a503b74844aa87c2cd97ef0

        -- For debugging; to see the same output as the parser sees
        -- Important: make sure you don't have another golangci-lint biniary on $PATH
        -- parser = function(output, bufnr, cwd)
        --   vim.notify(vim.inspect(output))
        -- end,
      }
      opts.linters_by_ft["python"] = { "basedpyright", "ruff", "mypy" }
    end,
  },
  -- Go specific plugins
  {
    "maxandron/goplements.nvim",
    lazy = true,
    ft = "go",
    opts = {},
  },
  {
    "fang2hou/go-impl.nvim",
    ft = "go",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "folke/snacks.nvim",
    },
    opts = {},
    cmd = { "GoImplOpen" },
  },
  {
    "zgs225/gomodifytags.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      {
        "mason-org/mason.nvim",
        opts = function(_, opts)
          opts.ensure_installed = opts.ensure_installed or {}
          vim.list_extend(opts.ensure_installed, { "gomodifytags" })
        end,
      },
    },
    config = function(_, opts)
      require("gomodifytags").setup(opts) -- Optional: You can add any specific configuration here if needed.
    end,
    cmd = { "GoAddTags", "GoRemoveTags", "GoInstallModifyTagsBin" },
  },
  {
    "ray-x/go.nvim",
    lazy = true,
    ft = { "go", "gomod" },
    enabled = false,
    dependencies = { -- optional packages
      "ray-x/guihua.lua",
      "virtual-lsp-config",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("go").setup({
        remap_commands = { GoDoc = false }, -- NOTE: clashes with godoc.nvim
        lsp_cfg = false, -- handled with nvim-lspconfig instead
        lsp_inlay_hints = {
          enable = false, -- handled with LSP keymap toggle instead
        },
        dap_debug = false, -- handled by nvim-dap instead
        luasnip = false,
      })
    end,
    event = { "CmdlineEnter" },
  },
  {
    "nvim-neotest/neotest",
    ft = "python",
    lazy = true,
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-neotest/neotest-python",
      "nvim-treesitter/nvim-treesitter",
      {
        "fredrikaverpil/neotest-golang",
        version = "*",
        dependencies = {
          "andythigpen/nvim-coverage",
        },
      },
    },
    config = function()
      local neotest_python_opts = {
        runner = "pytest",
        python = ".venv/bin/python",
        is_test_file = function(file_path)
          return file_path:match("test_.*%.py$")
        end,
        pytest_discover_instances = true,
      }
      local neotest_golang_opts = {
        runner = "go",
        go_test_args = {
          "-v",
          "-race",
          "-count=1",
          "-coverprofile=" .. vim.fn.getcwd() .. "/coverage.out",
        },
      }
      require("neotest").setup({
        adapters = {
          require("neotest-python")({
            dap = { justMyCode = false },
            python = neotest_python_opts.python,
            args = {
              "--cov=.",
              "--cov-report=json:" .. vim.fn.getcwd() .. "/coverage.out",
              "--cov-report=term-missing",
              "--disable-warnings",
            },
          }),
          require("neotest-golang")(neotest_golang_opts),
        },
      })
    end,
  },
  {
    "andythigpen/nvim-coverage",
    lazy = true,
    ft = { "go", "python" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      auto_reload = true,
    },
  },
  {
    "saghen/blink.cmp",
    dependencies = {
      "edte/blink-go-import.nvim",
      ft = "go",
      config = function()
        require("blink-go-import").setup()
      end,
    },
    opts = {
      sources = {
        default = {
          "go_pkgs",
        },
        providers = {
          go_pkgs = {
            module = "blink-go-import",
            name = "Import",
          },
        },
      },
    },
    opts_extend = {
      "sources.default",
    },
  },
  {
    "CRAG666/code_runner.nvim",
    lazy = true,
    opts = {
      filetype = {
        go = {
          "go run",
        },
      },
    },
  },
  -- DAP
  {
    "mfussenegger/nvim-dap",
    lazy = true,
    dependencies = {
      {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = {
          "mason-org/mason.nvim",
        },
        opts = {
          ensure_installed = { "debugpy" },
        },
      },
      "leoluz/nvim-dap-go",
      "mfussenegger/nvim-dap-python",
    },
    --   opts = {
    --     -- configurations = {
    --     --   go = {},
    --     -- },
    --   },
  },
}

return plugins
