-- Initialize mason.nvim
require('mason').setup()

-- Initialize mason-lspconfig
require('mason-lspconfig').setup({
    -- List the language servers you want to install
    ensure_installed = {
        'gopls',
        'lua_ls',
        'eslint',
        'html',
        'cssls',
        'bashls',
        'jsonls',
    },
    handlers = {
        -- Default handler for all language servers
        function(server_name)
            require('lspconfig')[server_name].setup({})
        end,
        -- Custom handler for lua_ls
        lua_ls = function()
            local lua_opts = {
                settings = {
                    Lua = {
                        runtime = {
                            version = 'LuaJIT',
                        },
                        diagnostics = {
                            globals = { 'vim' },
                        },
                        workspace = {
                            library = vim.api.nvim_get_runtime_file("", true),
                        },
                    },
                },
            }
            require('lspconfig').lua_ls.setup(lua_opts)
        end,
    },
})
