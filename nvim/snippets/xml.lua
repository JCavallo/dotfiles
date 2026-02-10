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

return {
	s({ trig = "tr_version", name = "xml version" }, {
		t({ '<?xml version="1.0"?>' }),
		i(0),
	}),
	s({ trig = "tr_mess", name = "ir.message" }, {
		t({ '<record model="ir.message" id="msg_' }),
		i(1),
		t({ '">' }),
		t({ "", '    <field name="text">' }),
		i(2),
		t({ "</field>" }),
		t({ "", "</record>" }),
		i(0),
	}),
	s({ trig = "tr_tree", name = "<tree>" }, {
		t({ "<tree>" }),
		t({ "", "    " }),
		i(0),
		t({ "", "</tree>" }),
	}),
	s({ trig = "tr_tree_mod", name = "<tree..." }, {
		t({ "<tree" }),
		i(1),
		t({ ">" }),
		t({ "", "    " }),
		i(0),
		t({ "", "</tree>" }),
	}),
	s({ trig = "tr_form", name = "<form>" }, {
		t({ "<form>" }),
		t({ "", "    " }),
		i(0),
		t({ "", "</form>" }),
	}),
	s({ trig = "tr_form_mod", name = "<form..." }, {
		t({ "<form" }),
		i(1),
		t({ ">" }),
		t({ "    " }),
		i(0),
		t({ "", "</form>" }),
	}),
	s({ trig = "trfile", name = "Full Tryton File header" }, {
		t({ '<?xml version="1.0"?>' }),
		t({ "", "<tryton>" }),
		t({ "", "    <data>" }),
		t({ "", "        " }),
		i(0),
		t({ "", "    </data>" }),
		t({ "", "</tryton>" }),
	}),
	s({ trig = "tr_data", name = "<data..." }, {
		t({ "<data>" }),
		t({ "", "    " }),
		i(0),
		t({ "", "</data>" }),
	}),
	s({ trig = "tr_xpath", name = "<xpath ..." }, {
		t({ '<xpath expr="/' }),
		i(2, "path_to_elem"),
		t({ '" position="' }),
		c(1, { t("after"), t("before"), t("replace") }),
		t({ '">' }),
		t({ "", "    " }),
		i(0),
		t({ "", "</xpath>" }),
	}),
	s({ trig = "tr_xdesc", name = "field_name[@...: '...']" }, {
		i(1, "field"),
		t({ "[@" }),
		i(2, "name"),
		t({ "='" }),
		i(3, "field_value"),
		t({ "']" }),
		i(0),
	}),
	s({ trig = "tr_section_brq", name = "<!-- ##### ... ##### -->" }, {
		t({ "<!-- ##" }),
		l(l._1:gsub(".", "#"), 1),
		t({ "## -->" }),
		t({ "", "<!-- # " }),
		i(1),
		t({ " # -->" }),
		t({ "", "<!-- ##" }),
		l(l._1:gsub(".", "#"), 1),
		t({ "## -->" }),
		i(0),
	}),
	s({ trig = "tr_section_documentation", name = "Documentation for Configuration Section" }, {
		t({ "<!-- " }),
		i(1),
		t({ " -->" }),
		t({ "", '<record model="ir.message" id="msg_server_configuration_section_name_' }),
		rep(1),
		t({ '">' }),
		t({ "", '    <field name="text">' }),
		i(2),
		t({ "</field>" }),
		t({ "", "</record>" }),
		t({ "", '<record model="ir.message" id="msg_server_configuration_section_description_' }),
		rep(1),
		t({ '">' }),
		t({ "", '    <field name="text">' }),
		i(3),
		t({ "</field>" }),
		t({ "", "</record>" }),
		i(0),
	}),
	s({ trig = "tr_variable_documentation", name = "Documentation for Configuration Variable" }, {
		t({ "<!-- " }),
		i(1),
		t({ " -->" }),
		t({ "", '<record model="ir.message" id="msg_server_configuration_variable_name_' }),
		rep(1),
		t({ '">' }),
		t({ "", '    <field name="text">' }),
		i(2),
		t({ "</field>" }),
		t({ "", "</record>" }),
		t({ "", '<record model="ir.message" id="msg_server_configuration_variable_help_' }),
		rep(1),
		t({ '">' }),
		t({ "", '    <field name="text">' }),
		i(3),
		t({ "</field>" }),
		t({ "", "</record>" }),
		i(0),
	}),
}
