local go = require("plugins.lang.go")
local python = require("plugins.lang.python")

local plugins = {}

table.move(go, 1, #go, 1, plugins)
table.move(python, 1, #python, #plugins + 1, plugins)

local nt = {
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
}
table.insert(plugins, nt)
return plugins
