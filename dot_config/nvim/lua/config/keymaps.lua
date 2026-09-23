-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- Invertir 'j' (arriba) y 'k' (abajo)
map({ "n", "x", "o" }, "j", "v:count == 0 ? 'gk' : 'k'", { desc = "Move Up (remapped)", expr = true, silent = true })
map({ "n", "x", "o" }, "k", "v:count == 0 ? 'gj' : 'j'", { desc = "Move Down (remapped)", expr = true, silent = true })
