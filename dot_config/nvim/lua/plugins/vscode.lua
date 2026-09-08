return {
  -- 1. Tema oficial Dracula
  {
    "Mofiqul/dracula.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      italic_comment = true,
      transparent_bg = false,
    },
    config = function(_, opts)
      require("dracula").setup(opts)
      vim.cmd.colorscheme("dracula")
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "dracula",
    },
  },

  -- 2. Desactivar el explorer flotante de Snacks para usar el árbol lateral permanente (Neo-tree)
  {
    "folke/snacks.nvim",
    opts = {
      explorer = { enabled = false },
    },
  },

  -- 3. Explorador de archivos en barra lateral (Neo-tree estilo VS Code)
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      close_if_last_window = true,
      filesystem = {
        bind_to_cwd = false,
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
        hijack_netrw_behavior = "open_default",
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = false,
        },
      },
      window = {
        width = 32,
        mappings = {
          ["<space>"] = "none",
        },
      },
    },
  },

  -- 4. Pestañas fijas estilo VS Code arriba
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        always_show_bufferline = true,
        show_buffer_close_icons = true,
        show_close_icon = true,
        separator_style = "thin",
      },
    },
  },

  -- 5. Multi-cursor con Ctrl+D como en VS Code
  {
    "mg979/vim-visual-multi",
    event = "VeryLazy",
    init = function()
      vim.g.VM_maps = {
        ["Find Under"] = "<C-d>",
        ["Find Subword Under"] = "<C-d>",
      }
    end,
  },
}
