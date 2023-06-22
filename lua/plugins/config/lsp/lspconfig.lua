local lspconfig_status, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status then
	return
end

local cmp_nvim_lsp_status, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not cmp_nvim_lsp_status then
	return
end

local typescript_setup, typescript = pcall(require, "typescript")
if not typescript_setup then
	return
end

local on_attach = function(client, bufnr)
	local opts = { noremap = true, silent = true, buffer = bufnr }
	--client.server_capabilities.semanticTokensProvider = nil
	client.server_capabilities.documentFormattingProvider = false
	vim.keymap.set("n", "<C-F12>", "<cmd>Lspsaga lsp_finder<CR>", opts) -- show definition, references
	vim.keymap.set("n", "<F12>", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts) -- go to implementation
	vim.keymap.set("n", "<S-F12>", "<cmd>Lspsaga hover_doc<CR>", opts) -- show documentation for what is under cursor
	vim.keymap.set("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", opts) -- see available code actions
	vim.keymap.set("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", opts) -- smart rename
	vim.keymap.set("n", "<leader>fm", "<cmd>lua vim.lsp.buf.format({ async = true })<CR>", {}) -- format
end

local signs = { Error = " ", Warn = " ", Hint = "ﴞ ", Info = " " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

local capabilities = cmp_nvim_lsp.default_capabilities()

lspconfig["lua_ls"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				library = {
					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
					[vim.fn.stdpath("config") .. "/lua"] = true,
				},
			},
		},
	},
})

lspconfig["emmet_ls"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
	filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
})

lspconfig["angularls"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

lspconfig["clangd"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

lspconfig["jsonls"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
	filetypes = { "json" },
})

lspconfig["sqlls"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
	filetypes = { "sql" },
})

typescript.setup({
	server = {
		capabilities = capabilities,
		on_attach = on_attach,
	},
})
