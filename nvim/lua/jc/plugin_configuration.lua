local M = {}

function M.setup_completion()
	local cmp = require("cmp")
	local luasnip = require("luasnip")
	luasnip.setup({
		update_events = { "TextChanged", "TextChangedI" },
	})
	require("luasnip.loaders.from_vscode").lazy_load()
	require("luasnip.loaders.from_lua").lazy_load({ paths = { vim.fn.stdpath("config") .. "/snippets" } })

	local has_words_before = function()
		unpack = unpack or table.unpack
		local line, col = unpack(vim.api.nvim_win_get_cursor(0))
		return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
	end

	require("cmp.types")
	cmp.setup({
		snippet = {
			expand = function(args)
				luasnip.lsp_expand(args.body)
			end,
		},
		mapping = cmp.mapping.preset.insert({
			["<C-PageUp>"] = cmp.mapping.scroll_docs(-4),
			["<C-PageDown>"] = cmp.mapping.scroll_docs(4),
			["<C-Space>"] = cmp.mapping.complete(),
			["<C-k>"] = cmp.mapping.confirm({
				behavior = cmp.ConfirmBehavior.Replace,
				select = true,
			}),
			["<Tab>"] = cmp.mapping(function(fallback)
				if luasnip.expand_or_locally_jumpable() then
					luasnip.expand_or_jump()
				elseif cmp.visible() then
					cmp.select_next_item()
				elseif has_words_before() then
					cmp.complete()
				else
					fallback()
				end
			end, { "i", "s" }),
			["<S-Tab>"] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.select_prev_item()
				elseif luasnip.jumpable(-1) then
					luasnip.jump(-1)
				else
					fallback()
				end
			end, { "i", "s" }),
			["<C-n>"] = cmp.mapping(function(fallback)
				if luasnip.choice_active() then
					luasnip.change_choice(1)
				else
					fallback()
				end
			end, { "i", "s" }),
			["<C-p>"] = cmp.mapping(function(fallback)
				if luasnip.choice_active() then
					luasnip.change_choice(-1)
				else
					fallback()
				end
			end, { "i", "s" }),
		}),
		sources = cmp.config.sources({
			{ name = "nvim_lsp", priority = 1 },
			{ name = "buffer", priority = 2 },
			{ name = "luasnip", priority = 3 },
		}),
		performance = {
			debounce = 200,
			throttle = 500,
			fetching_timeout = 500,
			confirm_resolve_timeout = 100,
			async_budget = 2,
			max_view_entries = 1000,
			filtering_context_budget = 100,
		},
	})
	-- cmp.setup.cmdline('/', {
	--   sources = {
	--     { name = 'buffer' }
	--   }
	-- })
	-- cmp.setup.cmdline(':', {
	--   sources = cmp.config.sources({
	--     { name = 'path' }
	--   }, {
	--     { name = 'cmdline' }
	--   })
	-- })
end

function M.setup_lsp()
	local on_attach = function(_, bufnr)
		local nmap = function(keys, func, desc)
			if desc then
				desc = "LSP: " .. desc
			end

			vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
		end

		nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
		nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

		nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
		nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
		nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
		nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
		nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
		nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

		-- See `:help K` for why this keymap
		nmap("K", vim.lsp.buf.hover, "Hover Documentation")
		nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

		-- Lesser used LSP functionality
		nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
		nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
		nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
		nmap("<leader>wl", function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, "[W]orkspace [L]ist Folders")
		nmap("<leader>xx", vim.lsp.buf.format)

		-- Create a command `:Format` local to the LSP buffer
		vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
			vim.lsp.buf.format()
		end, { desc = "Format current buffer with LSP" })
	end

	vim.diagnostic.config({
		underline = {
			severity = {
				vim.diagnostic.severity.WARN,
				vim.diagnostic.severity.ERROR,
			},
		},
		signs = {
			text = {
				[vim.diagnostic.severity.ERROR] = "󰅚 ",
				[vim.diagnostic.severity.WARN] = "󰀪 ",
				[vim.diagnostic.severity.INFO] = "󰋽 ",
				[vim.diagnostic.severity.HINT] = "󰌶 ",
			},
		},
		virtual_text = {
			source = false,
			spacing = 2,
			format = function(diagnostic)
				local diagnostic_message = {
					[vim.diagnostic.severity.ERROR] = "󰅚 ",
					[vim.diagnostic.severity.WARN] = "󰀪 ",
					[vim.diagnostic.severity.INFO] = "󰋽 ",
					[vim.diagnostic.severity.HINT] = "󰌶 ",
				}
				return diagnostic_message[diagnostic.severity]
			end,
		},
		virtual_lines = {
			current_line = true,
			format = function(diagnostic)
				if vim.bo.filetype == "lazy" or vim.o.diff == true then
					return nil
				end
				if diagnostic.code ~= nil then
					return "[" .. diagnostic.code .. "] " .. diagnostic.message
				else
					return diagnostic.message
				end
			end,
		},
		update_in_insert = false,
	})
	-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

	-- Setup mason so it can manage external tooling
	require("mason").setup()

	-- Ensure the servers above are installed
	local mason_lspconfig = require("mason-lspconfig")

	mason_lspconfig.setup({
		ensure_installed = { "pylsp", "rust_analyzer", "lua_ls", "ts_ls", "bashls" },
	})

	vim.lsp.config("*", {
		on_attach = on_attach,
		capabilities = capabilities,
	})

	vim.lsp.config("pylsp", {
		filetypes = { "python", "python.trpy", "trpy" },
		pylsp = {
			filetypes = { "python", "python.trpy", "trpy" },
			plugins = {
				-- pyls_mpypy = { enabled = true },
				flake8 = { enabled = true },
			},
		},
	})
	vim.lsp.config("rust_analyzer", {})
	vim.lsp.config("lua_ls", {
		Lua = {
			workspace = { checkThirdParty = false },
			telemetry = { enable = false },
		},
	})
	vim.lsp.config("ts_ls", {})
	vim.lsp.config("bashls", {})
	local configs = require("lspconfig.configs")
	if not configs.tryton_analyzer then
		local function analyzer_dev()
			local root_analyzer = require("lspconfig.util").root_pattern("tryton_analyzer")(vim.fn.getcwd())
			if root_analyzer ~= nil then
				return { root_analyzer .. "/.venv/bin/python", root_analyzer .. "/.venv/bin/tryton-ls" }
			else
				return { "tryton-ls" }
			end
		end
		configs.tryton_analyzer = {
			default_config = {
				cmd = analyzer_dev(),
				filetypes = { "python", "xml" },
				root_dir = require("lspconfig.util").root_pattern(".git"),
				settings = {},
			},
		}
	end
	vim.lsp.config("tryton_analyzer", {
		capabilities = capabilities,
		on_attach = on_attach,
	})
	require("mason-null-ls").setup({
		handlers = {},
		-- ensure_installed = { "sql_formatter", "xmlformatter", "jq", "mypy" },
		ensure_installed = { "sql_formatter", "xmlformatter", "jq", "stylua" },
		automatic_installation = true,
	})
	local null_ls = require("null-ls")
	null_ls.setup({
		sources = {
			null_ls.builtins.formatting.stylua,
			null_ls.builtins.formatting.sql_formatter,
			null_ls.builtins.formatting.xmllint.with({
				extra_args = { "--indent", "4" },
			}),
			null_ls.builtins.formatting.jq,
			-- null_ls.builtins.diagnostics.mypy,
		},
	})
end

function M.setup_formatting()
	local formatter_maker = function(params)
		return function(bufnr)
			if not require("jc.utils").must_auto_format(vim.api.nvim_buf_get_name(bufnr)) then
				return {}
			end
			return params
		end
	end
	conform = require("conform")
	conform.setup({
		log_level = vim.log.levels.INFO,
		formatters_by_ft = {
			css = formatter_maker({ "cssls", lsp_format = "fallback" }),
			less = formatter_maker({ "prettierd", "prettier", stop_after_first = true }),
			lua = { "stylua" },
			json = { "jq" },
			python = formatter_maker({ "black" }),
			rust = { "rustfmt", lsp_format = "fallback" },
			javascript = formatter_maker({ "prettierd", "prettier", stop_after_first = true }),
			xml = formatter_maker({ "xmllint" }),
			yaml = { "yq" },
		},
		notify_on_error = true,
		notify_no_formatters = true,
		format_on_save = {
			lsp_format = "never",
			timeout_ms = 4000,
		},
	})
	conform.formatters.xmllint = {
		env = {
			XMLLINT_INDENT = "    ",
		},
	}
end

function M.setup_telescope()
	local actions = require("telescope.actions")
	require("telescope").setup({
		defaults = {
			layout_strategy = "flex",
			prompt_prefix = "❯ ",
			selection_caret = "❯ ",
			winblend = 10,
			color_devicons = true,
			use_less = true,
			sorting_strategy = "ascending",
			borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
			file_previewer = require("telescope.previewers").vim_buffer_cat.new,
			grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
			qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
			mappings = {
				n = {
					["q"] = actions.close,
					["<M-a>"] = actions.smart_add_to_qflist,
					["<M-q>"] = actions.smart_send_to_qflist,
				},
				i = {
					["<M-a>"] = actions.smart_add_to_qflist,
					["<M-q>"] = actions.smart_send_to_qflist,
				},
			},
			extensions = {
				fzf_native = {
					override_generic_sorter = true,
					override_file_sorter = true,
					case_mode = "smart_case",
				},
				fzf_writer = {
					use_highlighter = false,
					minimum_grep_characters = 3,
				},
				["ui-select"] = {
					require("telescope.themes").get_dropdown({}),
				},
			},
		},
	})
	-- require('telescope').load_extension('fzf')
	-- require('telescope').load_extension('dap')
	require("telescope").load_extension("notify")
	require("telescope").load_extension("ui-select")
end

function M.setup_treesitter()
	require("nvim-treesitter.configs").setup({
		ensure_installed = {
			"lua",
			"c",
			"rust",
			"javascript",
			"python",
			"go",
			"json",
			"yaml",
			"bash",
			"xml",
			"css",
			"html",
			"po",
		},
		highlight = {
			enable = true, -- false will disable the whole extension
		},
		autotag = { -- Auto close tags
			enable = true,
			filetypes = { "html", "xml" },
		},
		incremental_selection = {
			enable = true,
			keymaps = { -- mappings for incremental selection (visual mappings)
				init_selection = "<M-w>", -- maps in normal mode to init the node/scope selection
				node_incremental = "<M-w>", -- increment to the upper named parent
				scope_incremental = "<M-e>", -- increment to the upper scope (as defined in locals.scm)
				node_decremental = "<M-C-w>", -- decrement to the previous node
			},
		},
		textobjects = {
			select = {
				enable = true,
				lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
				keymaps = {
					["af"] = "@function.outer",
					["if"] = "@function.inner",
					["ac"] = "@class.outer",
					["ic"] = "@class.inner",
					["aa"] = "@parameter.outer",
					["ia"] = "@parameter.inner",
				},
				selection_modes = {
					["@parameter.outer"] = "v",
					["@function.outer"] = "V",
					["@class.outer"] = "V",
				},
				include_surrounding_whitespace = true,
			},
			move = {
				enable = true,
				set_jumps = true, -- whether to set jumps in the jumplist
				goto_next_start = {
					["]{"] = "@function.outer",
					["]]"] = "@class.outer",
				},
				goto_next_end = {
					["]}"] = "@function.outer",
					["]["] = "@class.outer",
				},
				goto_previous_start = {
					["[{"] = "@function.outer",
					["[["] = "@class.outer",
				},
				goto_previous_end = {
					["[}"] = "@function.outer",
					["[]"] = "@class.outer",
				},
			},
			swap = {
				enable = true,
				swap_next = {
					["<leader>a"] = "@parameter.inner",
				},
				swap_previous = {
					["<leader>A"] = "@parameter.inner",
				},
			},
		},
		playground = {
			enable = true,
		},
	})
	-- nvim ufo for folding now...
	-- vim.o.foldmethod = 'expr'
	-- vim.cmd[[set foldexpr=nvim_treesitter#foldexpr()]]
end

function M.setup_git()
	require("gitsigns").setup({
		current_line_blame = true,
	})
	vim.cmd([[highlight GitSignsCurrentLineBlame guifg=#666677 cterm=italic gui=italic]])
	require("octo").setup({
		suppress_missing_scope = {
			projects_v2 = true,
		},
	})
end

function M.setup_navigation()
	require("leap").add_default_mappings()
	require("flit").setup()
	require("leap-spooky").setup({
		paste_on_remote_yank = false,
	})
	vim.g.tmux_navigator_no_mappings = 1
	require("harpoon").setup({
		mark_branch = false,
	})
end

function M.setup_tools()
	require("Comment").setup()
	require("colorizer").setup()
	require("notify").setup({
		background_colour = "#000000",
	})
	require("noice").setup({
		lsp = {
			override = {
				["vim.lsp.util.convert_input_to_markdown_lines"] = true,
				["vim.lsp.util.stylize_markdown"] = true,
				["cmp.entry.get_documentation"] = true,
			},
		},
	})
	vim.g.localvimrc_persistent = 1
	vim.g.suda_smart_edit = 1
end

local function _setup_lualine()
	require("lualine").setup({
		options = {
			theme = "auto",
			icons_enabled = true,
			section_separators = { left = "", right = "" },
			component_separators = { left = "", right = "" },
			padding = 1,
			disabled_filetypes = {},
			globalstatus = true,
		},
		sections = {
			lualine_a = { "mode" },
			lualine_b = { "branch" },
			lualine_c = { { "filename", file_status = true } },
			lualine_x = { "encoding", "fileformat", "filetype" },
			lualine_y = {
				{
					"diagnostics",
					sources = { "nvim_diagnostic" },
					color_error = "#FF0000",
					color_warn = "#FFC600",
					color_info = "#00AAFF",
				},
				"progress",
			},
			lualine_z = { "location" },
		},
		inactive_sections = {
			lualine_a = {},
			lualine_b = { { "filename", path = 1 } },
			lualine_c = {},
			lualine_x = { "location" },
			lualine_y = { "filetype" },
			lualine_z = {},
		},
		tabline = {
			lualine_a = { { "filename", file_status = true, path = 2 } },
			lualine_b = {},
			lualine_c = {},
			lualine_x = {},
			lualine_y = {},
			lualine_z = {},
		},
		extensions = {},
	})
end

local function _setup_colorschemes()
	require("twilight").setup({ context = 20 })
	vim.g.tender_italic = 1
	vim.g.tender_bold = 1
	require("tokyonight").setup({
		style = "storm",
		transparent = true,
	})
end

function M.setup_appearance()
	_setup_lualine()
	_setup_colorschemes()
	vim.g.startify_change_to_dir = 0
	vim.g.startify_change_to_vcs_root = 1
	require("ibl").setup({
		whitespace = { remove_blankline_trail = true },
	})
end

function M.setup_dap()
	local dap = require("dap")
	local dapui = require("dapui")
	require("mason-nvim-dap").setup({
		automatic_installation = true,
		ensure_installed = {
			"debugpy",
		},
	})
	dapui.setup({
		icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
		controls = {
			icons = {
				pause = "⏸",
				play = "c",
				step_into = "s",
				step_over = "n",
				step_out = "r",
				step_back = "u",
				run_last = "▶▶",
				terminate = "q",
				disconnect = "⏏",
			},
		},
	})
	require("nvim-dap-virtual-text").setup({ commented = true })

	-- Change breakpoint icons
	vim.api.nvim_set_hl(0, "DapBreak", { fg = "#e51400" })
	vim.api.nvim_set_hl(0, "DapStop", { fg = "#ffcc00" })
	local breakpoint_icons = {
		Breakpoint = "",
		BreakpointCondition = "",
		BreakpointRejected = "",
		LogPoint = "",
		Stopped = "",
	}
	for type, icon in pairs(breakpoint_icons) do
		local tp = "Dap" .. type
		local hl = (type == "Stopped") and "DapStop" or "DapBreak"
		vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
	end

	dap.listeners.after.event_initialized["dapui_config"] = dapui.open
	dap.listeners.before.event_terminated["dapui_config"] = dapui.close
	dap.listeners.before.event_exited["dapui_config"] = dapui.close
	require("dap-python").setup("python", {})
	table.insert(require("dap").configurations.python, {
		justMyCode = true,
	})
end

return M
