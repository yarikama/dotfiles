-- Monokai Pro, to match Ghostty and tmux. The background is left transparent so
-- Ghostty's background-opacity still shows through inside Neovim; with an
-- opaque colorscheme background the window turns solid as soon as nvim opens.
return {
  {
    "loctvl842/monokai-pro.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      filter = "pro",
      transparent_background = true,
    },
  },
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "monokai-pro" },
  },
}
