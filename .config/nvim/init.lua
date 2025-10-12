-- =========================
-- VIM OPTIONS
-- =========================

vim.o.number = true
vim.o.signcolumn = "yes"
vim.o.wrap = false
vim.o.swapfile = false
vim.o.winborder = "rounded"
vim.o.expandtab = false
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 0


-- =========================
-- CUSTOM HIGHLIGHTS
-- =========================

-- define highlights
vim.cmd('highlight TodoHighlight guifg=#000000 guibg=#FFCC00 gui=bold ctermfg=220 ctermbg=NONE cterm=bold')
vim.cmd('highlight FixHighlight guifg=#000000 guibg=#F21832 gui=bold ctermfg=220 ctermbg=NONE cterm=bold')

-- add match for words
vim.fn.matchadd('TodoHighlight', '\\<TODO\\>')
vim.fn.matchadd('FixHighlight', '\\<FIXME\\>')

-- reapply on buffer enter
vim.api.nvim_create_autocmd('BufEnter', {
	callback = function()
		if vim.w._todo_matches then
			for _, id in ipairs(vim.w._todo_matches) do pcall(vim.fn.matchdelete, id) end
		end
		vim.w._todo_matches = {}

		table.insert(vim.w._todo_matches, vim.fn.matchadd('TodoHighlight', '\\<TODO\\>'))
		table.insert(vim.w._todo_matches, vim.fn.matchadd('FixHighlight', '\\<FIXME\\>'))
	end,
})


-- =========================
-- VIM PACKAGES
-- =========================

vim.pack.add({
	"github.com/neovim/nvim-lspconfig",
	"github.com/stevearc/oil.nvim",
	"github.com/ibhagwan/fzf-lua",
	"https://github.com/folke/lazydev.nvim",
})


-- =========================
-- PACKAGE CONFIG
-- =========================

require "lazydev".setup({})
require "oil".setup({
	view_options = {
		show_hidden = true,
	},
})


-- =========================
-- LSP CONFIG
-- =========================

vim.lsp.enable({ "lua_ls", "clangd", "basedpyright", "bashls" })

vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('my.lsp', {}),
	callback = function(args)
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
		if client:supports_method('textDocument/completion') then
			-- Optional: trigger autocompletion on EVERY keypress. May be slow!
			local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
			client.server_capabilities.completionProvider.triggerCharacters = chars
			vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
		end
	end,
})
vim.cmd [[set completeopt+=menuone,noselect,popup]]


-- =========================
-- DIAGNOSTICS
-- =========================

vim.diagnostic.config({
	virtual_text = {
		prefix = "●",
		spacing = 2,
	},
	signs = true,
	underline = true,
	update_in_insert = false,
})


-- =========================
-- KEY BINDINGS
-- =========================

vim.g.mapleader = " "
vim.keymap.set('n', '<leader>p', ':Oil<CR>')
vim.keymap.set('n', '<leader>c', ':set colorcolumn=80<CR>')
vim.keymap.set('n', '<leader>x', ':set colorcolumn=0<CR>')
vim.keymap.set('n', '<leader>f', ':FzfLua global<CR>')
vim.keymap.set('n', '<leader>o', vim.lsp.buf.format)
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { noremap = true, silent = true })
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { noremap = true, silent = true })
