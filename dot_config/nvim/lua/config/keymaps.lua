-- Keymaps are automatically loaded on the VeryLazy event
local map = vim.keymap.set

-- 1. Guardar archivo con Ctrl+S (Normal, Insert, Visual)
map({ "n", "i", "v" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File (Ctrl+S)" })

-- 2. Barra lateral de archivos (Árbol de carpetas) con Ctrl+B
map({ "n", "i" }, "<C-b>", "<cmd>Neotree toggle<cr>", { desc = "Toggle Explorer Sidebar (Ctrl+B)" })

-- 3. Buscador de archivos (Quick Open) con Ctrl+P
map("n", "<C-p>", function()
  Snacks.picker.files()
end, { desc = "Quick Open File (Ctrl+P)" })

-- 4. Paleta de comandos con Ctrl+Shift+P
map("n", "<C-S-p>", function()
  Snacks.picker.commands()
end, { desc = "Command Palette (Ctrl+Shift+P)" })

-- 5. Buscar texto en todo el proyecto con Ctrl+Shift+F
map("n", "<C-S-f>", function()
  Snacks.picker.grep()
end, { desc = "Search in Project (Ctrl+Shift+F)" })

-- 6. Buscar en el archivo actual con Ctrl+F
map("n", "<C-f>", function()
  Snacks.picker.lines()
end, { desc = "Find in File (Ctrl+F)" })

-- 7. Panel de problemas / errores (Diagnostics) con Ctrl+Shift+M
map("n", "<C-S-m>", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Problems Panel (Ctrl+Shift+M)" })

-- 8. Terminal integrada con Ctrl+` (backtick) o Ctrl+~
map({ "n", "t" }, "<C-`>", function()
  Snacks.terminal()
end, { desc = "Toggle Terminal (Ctrl+`)" })

map({ "n", "t" }, "<C-~>", function()
  Snacks.terminal()
end, { desc = "Toggle Terminal (Ctrl+~)" })

-- 9. Comentar / descomentar con Ctrl+/ (o Ctrl+_ en terminal)
map({ "n", "v" }, "<C-/>", "gcc", { remap = true, desc = "Toggle Comment (Ctrl+/)" })
map({ "n", "v" }, "<C-_>", "gcc", { remap = true, desc = "Toggle Comment (Ctrl+/)" })

-- 10. Cerrar pestaña / archivo actual con Ctrl+W
map("n", "<C-w>", function()
  Snacks.bufdelete()
end, { desc = "Close Tab (Ctrl+W)" })

-- 11. Cambiar entre pestañas con Ctrl+Tab y Ctrl+Shift+Tab
map("n", "<C-Tab>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next Tab" })
map("n", "<C-S-Tab>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Previous Tab" })

-- 12. Seleccionar todo con Ctrl+A
map({ "n", "i", "v" }, "<C-a>", "<esc>ggVG", { desc = "Select All (Ctrl+A)" })

-- 13. Deshacer / Rehacer en modo insertar
map("i", "<C-z>", "<cmd>undo<cr>", { desc = "Undo" })
map({ "n", "i" }, "<C-y>", "<cmd>redo<cr>", { desc = "Redo" })

-- 14. Mover líneas con Alt + Flecha Arriba/Abajo
map("n", "<A-Up>", "<cmd>m .-2<cr>==", { desc = "Move Line Up" })
map("n", "<A-Down>", "<cmd>m .+1<cr>==", { desc = "Move Line Down" })
map("i", "<A-Up>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Line Up" })
map("i", "<A-Down>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Line Down" })
map("v", "<A-Up>", ":m '<-2<cr>gv=gv", { desc = "Move Line Up" })
map("v", "<A-Down>", ":m '>+1<cr>gv=gv", { desc = "Move Line Down" })

-- 15. Duplicar líneas con Shift + Alt + Flecha Arriba/Abajo
map("n", "<A-S-Down>", "<cmd>t.<cr>", { desc = "Duplicate Line Down" })
map("n", "<A-S-Up>", "<cmd>t.-1<cr>", { desc = "Duplicate Line Up" })
map("i", "<A-S-Down>", "<esc><cmd>t.<cr>gi", { desc = "Duplicate Line Down" })
map("i", "<A-S-Up>", "<esc><cmd>t.-1<cr>gi", { desc = "Duplicate Line Up" })
