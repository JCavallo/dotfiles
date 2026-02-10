local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local extras = require("luasnip.extras")
local l = extras.lambda
local rep = extras.rep
local p = extras.partial
local m = extras.match
local n = extras.nonempty
local dl = extras.dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local conds = require("luasnip.extras.expand_conditions")
local postfix = require("luasnip.extras.postfix").postfix
local types = require("luasnip.util.types")
local parse = require("luasnip.util.parser").parse_snippet
local ms = ls.multi_snippet
local ts_utils = vim.treesitter

local get_current_function_node = function()
	local current_node = ts_utils.get_node()
	if not current_node then
		return ""
	end

	local expr = current_node
	while expr do
		if expr:type() == "function_definition" then
			break
		end
		expr = expr:parent()
	end
	return expr
end

local get_super_call = function()
	local function_node = get_current_function_node()
	if not function_node then
		return ""
	end
	-- Function name
	if not function_node:child() then
		return ""
	end
	local result = (ts_utils.get_node_text(function_node:child(1)))[1] .. "("
	local args = (ts_utils.get_node_text(function_node:child(2)))[1]
	print(args)
	for idx, arg in pairs(vim.split(args, ",")) do
		if idx >= 3 then
			result = result .. ", "
		end
		if idx >= 2 then
			print("#######")
			print(arg)
			print(result)
			result = result .. vim.trim(arg)
		end
	end

	return result
end

return {
	s({ trig = "tr_pp", name = "pool = Pool()" }, {
		t({ "pool = Pool()" }),
		t({ "", "" }),
		i(1, "ModelName"),
		t({ " = pool.get('" }),
		i(2, "model.__name__"),
		t({ "')" }),
		i(0),
	}),
	s({ trig = "tr_pg", name = "Model = pool.get()" }, {
		t({ "" }),
		i(1, "ModelName"),
		t({ " = " }),
		c(2, { t({ "pool" }), t({ "Pool()" }) }),
		t({ ".get('" }),
		i(3, "model.__name__"),
		t({ "')" }),
		t({ "" }),
		i(0),
	}),
	s({ trig = "super", name = "super()" }, {
		c(1, { t({ "return " }), t({ "" }), t({ "result = " }) }),
		t({ "super()." }),
		f(get_super_call),
		i(0),
	}),
	s({ trig = "cursor", name = "cursor = Transaction..." }, {
		t({ "cursor = " }),
		c(1, { t({ "Transaction()" }), t({ "transaction" }) }),
		t({ ".connection.cursor()" }),
		t({ "", "" }),
		i(0),
	}),
	s({ trig = "tr_setup", name = "__setup__" }, {
		t({
			"@classmethod",
			"def __setup__(cls):",
			"    super().__setup__()",
			"    ",
		}),
		i(0),
	}),
	s({ trig = "tr_register", name = "__register__" }, {
		t({
			"@classmethod",
			"def __register__(cls, module):",
			"    super().__register__(module)",
			"    ",
		}),
		i(0),
	}),
	s({ trig = "tr_post_setup", name = "__post_setup__" }, {
		t({
			"@classmethod",
			"def __post_setup__(cls):",
			"    super().__post_setup__()",
			"    ",
		}),
		i(0),
	}),
	s({ trig = "tr_meta", name = "class metaclass=PoolMeta" }, {
		t({ "class " }),
		i(1, "<ClassName>"),
		t({ "(metaclass=PoolMeta):" }),
		t({ "", "    __name__ = '" }),
		i(2, "<model.name>"),
		t({ "'" }),
		t({ "", "" }),
		t({ "", "    " }),
		i(0),
	}),
	s({ trig = "tr_on_change", name = "def on_change_..." }, {
		t({ "@fields.depends(" }),
		i(2),
		t({ ")" }),
		t({ "", "def on_change_" }),
		i(1, "<field_name>"),
		t({ "(self):" }),
		t({ "", "    " }),
		i(0),
	}),
	s({ trig = "tr_brq", name = "##### ... #####" }, {
		t({ "##" }),
		l(l._1:gsub(".", "#"), 1),
		t({ "##" }),
		t({ "", "# " }),
		i(1),
		t({ " #" }),
		t({ "", "##" }),
		l(l._1:gsub(".", "#"), 1),
		t({ "##" }),
		i(0),
	}),
}
