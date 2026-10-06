require('vis')

-- config --

-- per-window
vis.events.subscribe(vis.events.WIN_OPEN, function(win)
	vis:command("set tabwidth 2")
	vis:command("set numbers true") vis:command("set autoindent true")
	vis:command("set showspaces false")
	vis:command("set showtabs true")
	vis:command("set expandtab off")
	vis:command("set shell /usr/bin/env sh")
	vis:map(vis.modes.VISUAL," y", '"+y"')
	vis:map(vis.modes.NORMAL, " fm", function()
		vis:command("open .")
		vis:feedkeys("<C-w>k")
		vis:command("wq!")
	end, "")
end)

-- plugins --
require('plugins/vis-cursormode')
-- vis-autoclose
require('plugins/vis-autoclose')
-- colorizer
local colorizer = require('plugins/vis-colorizer')
colorizer.three = false
colorizer.six   = true
-- vis-lspc
local lsp = require('plugins/vis-lspc')

lsp.ls_map.lua = {
	name = 'lua-language-server',
	cmd = 'lua-language-server',
	settings = {
		Lua = {diagnostics = { globals = {'vis'}}, telemetry = {enable = false}},
	},
	formatting_options = {tabSize = 2, insertSpaces = true},
}

