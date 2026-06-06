require "tableutil"
require "stringutil"

local stylesheetutil = {
	styles = {},
	sizes = {}
 }

 -- Window titles
stylesheetutil.styles.uicouch_window_title_fontSize = 20
stylesheetutil.styles.uicouch_window_title_textTransform = "UPPERCASE"

-- Tab titles
stylesheetutil.styles.uicouch_tab_title_fontSize = 16
stylesheetutil.styles.uicouch_tab_title_textTransform = "UPPERCASE"

-- Subtitles
stylesheetutil.styles.uicouch_subtitle_fontSize = 20

-- Body
stylesheetutil.styles.uicouch_body_fontSize = 16

-- Primary button
stylesheetutil.styles.uicouch_primarybuttons_fontSize = 16
stylesheetutil.styles.uicouch_primarybuttons_textTransform = "UPPERCASE"

-- Secondary button
stylesheetutil.styles.uicouch_secondarybuttons_fontSize = 16
stylesheetutil.styles.uicouch_secondarybuttons_textTransform = "UPPERCASE"

-- In-game menu
stylesheetutil.styles.uicouch_ingamemenu_fontSize = 20
stylesheetutil.styles.uicouch_ingamemenu_textTransform = "UPPERCASE"

-- Main menu
stylesheetutil.styles.uicouch_mainmenu_fontSize = 20
stylesheetutil.styles.uicouch_mainmenu_textTransform = "UPPERCASE"

-- Tips
stylesheetutil.styles.uicouche_tips_fontSize = 22

-- Hints
stylesheetutil.styles.uicouche_hints_fontSize = 14

-- Cockpit view
stylesheetutil.styles.uicouche_cockpit_view_label_fontSize = 26

-- In-Game Extension Window sizes
stylesheetutil.sizes.ui_couch_extension_window_size = {450, 525}

-- Keybinding styles
stylesheetutil.styles.action_keybinding_scale = 0.65
stylesheetutil.styles.action_keybinding_gravity = { 0.9, 0.12 }

function stylesheetutil.makeColor(r, g, b, a)
	local f = 1.0 / 255.0
	local fa = a and f * a or 1.0
	return { f * r, f * g, f * b, fa }
end

function stylesheetutil.makeColorOffset(r, g, b, a, o)
	return stylesheetutil.makeColor(r + o, g + o, b + o, a)
end

function stylesheetutil.add2(selector, styleSheet, list)
	selector = selector:gsub("%s+", " ")
	selector = selector:gsub(" >", ">")

	--print("add2 " .. selector)
	for i, v in ipairs(string.split(selector, ",")) do
		local sel = string.strip(v)
		
		--print(sel)
		
		local ss = { }
		ss.levels = { }
		
		for j, w in ipairs(string.split(sel, " ")) do
			local level = string.strip(w)

			local childCombinatorMatch = level:ends(">")
			if childCombinatorMatch then
				level = level:gsub(">$", "");
			end
			
			--print("level " .. j)
			
			ss.levels[j] = { }
			ss.pseudoClassList = { }

			ss.levels[j].childCombinator = childCombinatorMatch;

			local idMatch = level:match("#[%a%d%-%.]+")
			
			if idMatch then
				ss.levels[j].id = idMatch:sub(2)

				local s, e = level:find(idMatch, nil, true)
				level = level:sub(e + 1)
			end
			
			-- note: lua does not support repetition of more than one character
			local elementMatch = level:match("^[%a%d%-]+") or level:match("^*")
			local subControlMatch = level:match("^[%a%d%-]+::[%a%d%-]+")
			local subControlMatch2 = level:match("^[%a%d%-]+::[%a%d%-]+::[%a%d%-]+")
			
			if subControlMatch2 then
				ss.levels[j].element = subControlMatch2
				
				local s, e = level:find(subControlMatch2, 1, true)
				level = level:sub(e + 1)
			elseif subControlMatch then
				ss.levels[j].element = subControlMatch
				
				local s, e = level:find(subControlMatch, 1, true)
				level = level:sub(e + 1)
			elseif elementMatch then
				ss.levels[j].element = elementMatch
				
				local s, e = level:find(elementMatch, 1, true)
				level = level:sub(e + 1)
			end
			
			ss.levels[j].classList = { }
			
			for c in level:gmatch("![%a%d%-]+") do
				table.insert(ss.levels[j].classList, c:sub(2))
			end
			for c in level:gmatch(":[%a%d%-]+") do
				table.insert(ss.pseudoClassList, c)
			end
			
			--[[
			if ss.levels[j].id then print("  id: " .. ss.levels[j].id) end
			if ss.levels[j].classList and #ss.levels[j].classList > 0 then
				print("  classList: ")
				for k, c in ipairs(ss.levels[j].classList) do
					print("    " .. c)
				end
			end
			if ss.levels[j].element then print("  element: " .. ss.levels[j].element) end]]--
		end
		
		ss.styleSheet = table.copy(styleSheet)
	
		table.insert(list, ss)
	end
end

function stylesheetutil.makeAdder(result)
	return function(selector, styleSheet) 
		stylesheetutil.add2(selector, styleSheet, result)
	end
end

return stylesheetutil
