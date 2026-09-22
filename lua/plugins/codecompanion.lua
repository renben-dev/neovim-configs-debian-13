local models_providers = {
	openrouter = {
		-- OpenRouter values
		api_key = os.getenv("OPENROUTER_API_KEY"),
		models_url = "https://openrouter.ai/api/v1/models",
		cache_dir = vim.fn.stdpath("config") .. "/openrouter/",
		cache_file = "models.json",
		default_model = "poolside/laguna-xs-2.1:free",
		default_temperature = 0.1,
	},
	gemini = {
		-- Gemini values
		api_key = os.getenv("GEMINI_API_KEY"),
		models_url = "https://generativelanguage.googleapis.com/v1beta/models?key=",
		cache_dir = vim.fn.stdpath("config") .. "/gemini/",
		cache_file = "models.json",
		default_model = "gemini-3.5-flash-lite",
		default_temperature = 0.1,
	},
}
local sort_config = {
	{
		contains_in_order = { { "gemini", "flash" } }, -- each sub list says that each item exists in the target string and that order and not intersecting. All sub lists in the value have the same order precedence in sorting
		contains_case_sensitive = false,
		alpha_ascending = true,
		number_ascending = false,
	},
	{
		contains_in_order = { { "gemini", "flash", "lite" } },
		contains_case_sensitive = false,
		alpha_ascending = true,
		number_ascending = false,
	},
	{
		contains_in_order = { { "gemini", "pro" } },
		contains_case_sensitive = false,
		alpha_ascending = true,
		number_ascending = false,
	},

	{
		contains_in_order = { { "gemini" } },
		contains_case_sensitive = false,
		alpha_ascending = true,
		number_ascending = false,
	},
	{
		contains_in_order = {},
		contains_case_sensitive = false,
		alpha_ascending = true,
		number_ascending = false,
	},
}

-- general helper functions
local function ensure_dir(dir)
	if not dir or dir == "" then
		return false, "Invalid directory path"
	end

	if vim.fn.isdirectory(dir) == 1 then
		return true, nil
	end

	local ok, res = pcall(vim.fn.mkdir, dir, "p")
	if not ok or res == 0 then
		return false, "Failed to create directory: " .. dir
	end

	return true, nil
end

local sort_comparer = function(a, b, sort_config)
	local function contains_in_order(s, parts)
		s = s:lower()
		local pos = 1
		for _, part in ipairs(parts) do
			local start, finish = s:find(part:lower(), pos, true)
			if not start then
				return false
			end
			pos = finish + 1
		end
		return true
	end

	local function get_group(s)
		for group, group_rule in ipairs(sort_config) do
			for _, parts in ipairs(group_rule.contains_in_order) do
				local match = contains_in_order(s, parts)
				if match then
					return group, group_rule.alpha_ascending, group_rule.number_ascending
				end
			end
		end
		return #sort_config + 1, true, true
	end

	local function get_replace_digits_to_mirror(s)
		return s:gsub("%d", function(d)
			return tostring(9 - tonumber(d))
		end)
	end

	local gr_a, alpha_a, number_a = get_group(a)
	local gr_b, alpha_b, number_b = get_group(b)

	if gr_a ~= gr_b then
		return gr_a < gr_b
	end

	local a_alias, b_alias
	if alpha_a == number_a then
		a_alias, b_alias = a, b
	else
		a_alias, b_alias = get_replace_digits_to_mirror(a), get_replace_digits_to_mirror(b)
	end

	return (a_alias < b_alias) == alpha_a and a_alias ~= b_alias
end

-- models_providers functions as their attributes
models_providers.gemini.models_fetch = function()
	local api_key = models_providers.gemini.api_key
	if not api_key or api_key == "" then
		vim.notify("GEMINI_API_KEY environment variable is not set", vim.log.levels.ERROR)
		return
	end

	local curl = require("plenary.curl")
	local url = models_providers.gemini.models_url .. api_key
	local res = curl.get(url, { headers = { ["Content-Type"] = "application/json" } })

	if res.status ~= 200 or not res.body then
		vim.notify("Failed to fetch Gemini models", vim.log.levels.ERROR)
		return
	end

	local ok, decoded = pcall(vim.fn.json_decode, res.body)
	if not ok or not decoded.models then
		return
	end

	local models = {}
	for _, item in ipairs(decoded.models) do
		local supports_generation = false
		if item.supportedGenerationMethods then
			for _, method in ipairs(item.supportedGenerationMethods) do
				if method == "generateContent" then
					supports_generation = true
					break
				end
			end
		end

		-- also strip models prefix
		if supports_generation and item.name then
			local clean_name = item.name:gsub("^models/", "")
			table.insert(models, clean_name)
		end
	end
	table.sort(models, function(a, b)
		return sort_comparer(a, b, sort_config)
	end)

	local cache_dir = models_providers.gemini.cache_dir
	ensure_dir(cache_dir)
	local cache_path = cache_dir .. models_providers.gemini.cache_file
	vim.fn.writefile({ vim.fn.json_encode(models) }, cache_path)
	vim.notify("Gemini models saved (" .. #models .. ")", vim.log.levels.INFO)
end

models_providers.openrouter.models_fetch = function(args)
	local curl = require("plenary.curl")
	local res = curl.get(models_providers.openrouter.models_url)

	if res.status ~= 200 or not res.body then
		vim.notify("Failed to fetch models", vim.log.levels.ERROR)
		return
	end

	local ok, decoded = pcall(vim.fn.json_decode, res.body)
	if not ok or not decoded.data then
		return
	end

	local models = {}
	for _, model in ipairs(decoded.data) do
		table.insert(models, model.id)
	end

	table.sort(models, function(a, b)
		return sort_comparer(a, b, sort_config)
	end)
	local cache_dir = models_providers.openrouter.cache_dir
	ensure_dir(cache_dir)
	local cache_path = cache_dir .. models_providers.openrouter.cache_file
	vim.fn.writefile({ vim.fn.json_encode(models) }, cache_path)
	vim.notify("Openrouter Models saved to " .. cache_path, vim.log.levels.INFO)
end

local function get_file_hash(file_path)
	if vim.fn.filereadable(file_path) == 0 then
		return nil
	end
	local content = table.concat(vim.fn.readfile(file_path), "\n")
	return vim.fn.sha256(content)
end

local function get_nvim_stack()
	-- 1. Neovim & LuaJIT Versions
	local nvim_ver = "NVIM v" .. tostring(vim.version())
	local luajit_ver = jit and jit.version or "Lua Engine Unknown"

	-- 2. Lazy.nvim (Plugins & Versions/Commits)
	local lazy_str = "Lazy.nvim: Not loaded"
	local ok_lazy, lazy = pcall(require, "lazy")
	if ok_lazy then
		local plugins = lazy.plugins()
		local plugin_items = {}
		for _, p in ipairs(plugins) do
			-- Get version tag, or fallback to the 7-character git commit hash
			local ver = p.version or (p._ and p._.commit and p._.commit:sub(1, 7))
			local entry = p.name .. (ver and (" (" .. ver .. ")") or "")
			table.insert(plugin_items, entry)
		end
		lazy_str =
			string.format("Lazy.nvim (%d plugins installed):\n  - %s", #plugins, table.concat(plugin_items, "\n  - "))
	end

	-- 3. Mason.nvim (Installed LSPs/Formatters/Linters)
	local mason_str = "Mason: Not loaded"
	local ok_mason, registry = pcall(require, "mason-registry")
	if ok_mason then
		local pkgs = registry.get_installed_packages()
		local pkg_items = {}
		for _, pkg in ipairs(pkgs) do
			local ok_ver, ver = pcall(function()
				return pkg:get_installed_version()
			end)
			local entry = pkg.name .. (ok_ver and ver and (" (" .. ver .. ")") or "")
			table.insert(pkg_items, entry)
		end
		mason_str = string.format("Mason (%d packages installed):\n  - %s", #pkgs, table.concat(pkg_items, "\n  - "))
	end

	-- Combine everything into a structured text block
	return string.format("%s\n%s\n\n%s\n\n%s", nvim_ver, luajit_ver, lazy_str, mason_str)
end

return {
	{
		"olimorris/codecompanion.nvim",
		version = "*",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"xinghe98/codecompanion-model-selector.nvim",
			"ravitemer/codecompanion-history.nvim", -- Add history plugin dependency
		},
		config = function()
			-- 1. Declare the local variable BEFORE using it

			-- fetches and caches al models from all providers registered in models_providers
			local fetcher = function()
				for key, provider in pairs(models_providers) do
					if type(provider.models_fetch) == "function" then
						provider.models_fetch()
					end
				end
			end

			local get_choice_map = function(models_provider)
				local choices_map = {}
				local cache_dir = models_provider.cache_dir
				local cache_file = models_provider.cache_file
				local cache_path = cache_dir .. cache_file

				if vim.fn.filereadable(cache_path) == 1 then
					local lines = vim.fn.readfile(cache_path)
					local json_str = table.concat(lines, "")
					local ok, models = pcall(vim.fn.json_decode, json_str)

					if ok and type(models) == "table" then
						return models
					end
				end

				-- Fallback if file doesn't exist or decoding fails
				return { models_provider.default_model }
			end

			local get_providers_string = function()
				local res = ""
				for key, param in pairs(models_providers) do
					if type(param.models_fetch) == "function" then
						if res ~= "" then
							res = res .. ", " .. key
						else
							res = key
						end
					end
				end
				return res
			end

			vim.api.nvim_create_autocmd("FileType", {
				pattern = "codecompanion",
				callback = function(args)
					local provider_list_string = get_providers_string()
					vim.keymap.set("n", "<Leader>cf", fetcher, {
						buffer = args.buf,
						desc = provider_list_string == "" and "No Models fetched: no Providers to fetch from"
							or ("Fecthed & Cached models for " .. provider_list_string),
					})
				end,
			})

			require("codecompanion").setup({

				interactions = {
					chat = {
						-- You can specify an adapter by name and model (both ACP and HTTP)
						adapter = {
							name = "gemini",
							model = models_providers.gemini.default_model,
						},
						opts = {
							-- system_prompt = "Start each response with a joke",

							system_prompt = function(ctx)
								local default_prompt = ctx.default_system_prompt
								local custom_file = vim.fn.getcwd() .. "/.codecompanion.md"
								if vim.fn.filereadable(custom_file) == 1 then
									local lines = vim.fn.readfile(custom_file)
									local instructions = table.concat(lines, "\n")

									vim.b.codecompanion_instruction_hash = vim.fn.sha256(instructions)

									-- print("Successfully loaded .codecompanion.md as system prompt:\n\n" .. instructions)
									print("Successfully loaded .codecompanion.md as system prompt")
									return default_prompt .. "\n\n# Local Project & Stack Rules:\n" .. instructions
								end

								-- print(
								-- 	"Failed to load .codecompanion.md as system prompt. Fallback to Codecompanion default system prompt:\n\n"
								-- 		.. default_prompt
								-- )
								print(
									"Failed to load .codecompanion.md as system prompt. Fallback to Codecompanion default system prompt"
								)
								return default_prompt
							end,
						},
						roles = {
							---The header name for the LLM's messages
							---@type string|fun(adapter: CodeCompanion.Adapter): string
							llm = function(adapter)
								return "🟠CodeCompanion (" .. adapter.formatted_name .. ")"
							end,

							---The header name for your messages
							---@type string
							user = "🟢Me",
						},
					},
					-- Or, just specify the adapter by name
					-- inline = {
					-- 	adapter = "anthropic",
					-- },
					-- cmd = {
					-- 	adapter = "openai",
					-- },
					-- background = {
					-- 	adapter = {
					-- 		name = "ollama",
					-- 		model = "qwen-7b-instruct",
					-- 	},
					-- },
				},
				adapters = {
					http = {
						extend = {
							openrouter = {
								env = {
									api_key = models_providers.openrouter.api_key,
								},
								schema = {
									model = {
										default = models_providers.openrouter.default_model,
										choices = get_choice_map(models_providers.openrouter),
									},
									temperature = {
										order = 2,
										mapping = "parameters",
										type = "number",
										default = models_providers.openrouter.default_temperature,
										enabled = function()
											return true
										end,
									},
								},
							},
							gemini = {
								env = {
									api_key = models_providers.gemini.api_key,
								},

								schema = {
									model = {
										default = models_providers.gemini.default_model,
										choices = get_choice_map(models_providers.gemini),
									},

									temperature = {
										default = models_providers.gemini.default_temperature,
									},
								},
							},
						},
					},
				},
				-- Register the history plugin inside extensions:
				extensions = {
					history = {
						enabled = true,
						opts = {
							-- Keymap to open history from chat buffer (default: gh)
							keymap = "gh",
							-- Keymap to save the current chat manually (when auto_save is disabled)
							save_chat_keymap = "sc",
							-- Save all chats by default (disable to save only manually using 'sc')
							auto_save = true,
							-- Number of days after which chats are automatically deleted (0 to disable)
							expiration_days = 0,
							-- Picker interface (auto resolved to a valid picker)
							picker = "fzf-lua", --- ("telescope", "snacks", "fzf-lua", or "default")
							---Optional filter function to control which chats are shown when browsing
							chat_filter = nil, -- function(chat_data) return boolean end
							-- Customize picker keymaps (optional)
							picker_keymaps = {
								rename = { n = "r", i = "<M-r>" },
								delete = { n = "d", i = "<M-d>" },
								duplicate = { n = "<C-y>", i = "<C-y>" },
							},
							---Automatically generate titles for new chats
							auto_generate_title = false,
							title_generation_opts = {
								---Adapter for generating titles (defaults to current chat adapter)
								adapter = nil, -- "copilot"
								---Model for generating titles (defaults to current chat model)
								model = nil, -- "gpt-4o"
								---Number of user prompts after which to refresh the title (0 to disable)
								refresh_every_n_prompts = 0, -- e.g., 3 to refresh after every 3rd user prompt
								---Maximum number of times to refresh the title (default: 3)
								max_refreshes = 3,
								format_title = function(original_title)
									-- this can be a custom function that applies some custom
									-- formatting to the title.
									return original_title
								end,
							},
							---On exiting and entering neovim, loads the last chat on opening chat
							continue_last_chat = false,
							---When chat is cleared with `gx` delete the chat from history
							delete_on_clearing_chat = false,
							---Directory path to save the chats
							dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
							---Enable detailed logging for history extension
							enable_logging = false,
							-- Summary system
							summary = {
								-- Keymap to generate summary for current chat (default: "gcs")
								create_summary_keymap = "gcs",
								-- Keymap to browse summaries (default: "gbs")
								browse_summaries_keymap = "gbs",

								generation_opts = {
									adapter = nil, -- defaults to current chat adapter
									model = nil, -- defaults to current chat model
									context_size = 90000, -- max tokens that the model supports
									include_references = true, -- include slash command content
									include_tool_outputs = true, -- include tool execution results
									system_prompt = nil, -- custom system prompt (string or function)
									format_summary = nil, -- custom function to format generated summary e.g to remove <think/> tags from summary
								},
							},
							-- Memory system (requires VectorCode CLI)
							memory = {
								-- Automatically index summaries when they are generated
								auto_create_memories_on_summary_generation = false,
								-- Path to the VectorCode executable
								vectorcode_exe = "vectorcode",
								-- Tool configuration
								tool_opts = {
									-- Default number of memories to retrieve
									default_num = 10,
								},
								-- Enable notifications for indexing progress
								notify = false,
								-- Index all existing memories on startup
								-- (requires VectorCode 0.6.12+ for efficient incremental indexing)
								index_on_startup = false,
							},
						},
					},
				},
				display = {
					chat = {
						auto_scroll = false,
					},
				},
			})

			-- Guard: Block resuming a chat if the system instruction signature changes
			vim.api.nvim_create_autocmd("User", {
				pattern = "CodeCompanionChatResumed",
				callback = function(args)
					local custom_file = vim.fn.getcwd() .. "/.codecompanion.md"
					local current_hash = get_file_hash(custom_file)
					local saved_hash = vim.b.codecompanion_instruction_hash

					if saved_hash and current_hash ~= saved_hash then
						vim.notify(
							"[CodeCompanion] Instruction signature mismatch! Session aborted to prevent prompt drift.",
							vim.log.levels.WARN
						)
						vim.cmd("bd!")
					end
				end,
			})

			-- Quick Keymaps for CodeCompanion
			vim.keymap.set(
				"n",
				"<Leader>cc",
				"<cmd>CodeCompanionChat Toggle<CR>",
				{ desc = "Toggle CodeCompanion Chat" }
			)
			vim.keymap.set(
				"v",
				"<Leader>ca",
				"<cmd>CodeCompanionActions<CR>",
				{ desc = "Open CodeCompanion Action Palette" }
			)
		end,
	},
}
