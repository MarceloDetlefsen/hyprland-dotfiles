-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

-- Numeración normal de líneas como en VS Code (no relativa)
vim.opt.relativenumber = false
vim.opt.number = true

-- Habilitar ratón al 100% (hacer clic, arrastrar divisiones, scroll, pestañas)
vim.opt.mouse = "a"

-- Portapapeles del sistema (Ctrl+C y Ctrl+V compatibles con el resto de tus apps)
vim.opt.clipboard = "unnamedplus"

-- Mantener unas líneas visibles arriba y abajo al hacer scroll
vim.opt.scrolloff = 5

-- Desactivar ajuste de línea por defecto (como en VS Code)
vim.opt.wrap = false
