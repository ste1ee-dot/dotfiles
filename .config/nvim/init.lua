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
-- VIM PACKAGES
-- =========================
vim.pack.add({
	"https://github.com/neovim/nvim-lspconfig",
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
vim.keymap.set('n', '<leader>p', ':update<CR> :Ex<CR>')
vim.keymap.set('n', '<leader>c', ':set colorcolumn=80<CR>')
vim.keymap.set('n', '<leader>x', ':set colorcolumn=0<CR>')
vim.keymap.set('n', '<leader>f', vim.lsp.buf.format)
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { noremap = true, silent = true })
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { noremap = true, silent = true })
