require "tableutil"
local ssu = require "stylesheetutil"

local hp = 10
local vp = 5

local horizontal_line_color = { 1.0, 1.0, 1.0, 0.4 }

local classicRichTextFontSize = 13
local couchRichTextFontSize = 13

function data()
    local result = { }
    local a = ssu.makeAdder(result)


	-- new RichTextView
    a("RichTextView::Text", {
		fontSize = classicRichTextFontSize,
        textAutoWrap = true,
    })
    a("!ui-couch RichTextView::Text", {
		fontSize = couchRichTextFontSize,
        textAutoWrap = true,
    })
    a("RichTextView::Text!quote, RichTextView::Text!code", {
		borderWidth = {1,1,1,1},
		borderColor = {0.6,0.6,0.6,1},
		padding = {vp, hp, vp, hp},
    })
    a("RichTextView::HorizontalRule", {
        backgroundColor = horizontal_line_color,
        size = { -1, classicRichTextFontSize * 1.6 / 10 },
    })
    a("!ui-couch RichTextView::HorizontalRule", {
        size = { -1, couchRichTextFontSize * 1.6 / 10 },
    })
    a("RichTextView::List", {
        padding = {0, 0, 0, 0},
    })
    a("RichTextView RichTextView::List > BoxLayout", {
        innerSpacing = {0, 0},
    })
	a("RichTextView::ListItem > !list-bullet", {
		gravity = {1, 0},
		textAlignment = {1, 0},
        minSize = {3 * hp, -1},
		fontSize = classicRichTextFontSize,
	})
	a("!ui-couch RichTextView::ListItem > !list-bullet", {
		fontSize = couchRichTextFontSize,
	})
	a("RichTextView::ListItem > !list-bullet!number", {
		padding = {0, hp, 0, 0},
		fontFamily = "Noto/NotoSansCJKsc-Regular.otf",
	})
    a("RichTextView::ListItem > !list-bullet!bullet", {
		padding = {1, hp, 0, 0},
        fontFamily = "Lato2OFL/Lato-Regular.ttf",
    })
    a("!ui-couch RichTextView::ListItem > !list-bullet!bullet", {
		padding = {2, hp, 0, 0},
    })
    a("RichTextView::Table, RichTextView::TableCell", {
        borderColor = {1,1,1,1},
    })
    a("RichTextView::Table", {
        borderWidth = {0,0,1,1},
    })
    a("RichTextView::TableCell", {
        borderWidth = {1,1,0,0},
		padding = { 0, 0, 0, 2 },
    })
    a("RichTextView::Table!noborder, RichTextView::Table!noborder > Table::Content > RichTextView::TableCell", {
        borderWidth = {0,0,0,0},
    })
    a("RichTextView::Table", {
        gravity = {-1, 0},
    })
    a("RichTextView", {
        gravity = {-1, 0},
		padding = {vp, hp, vp, 0},
    })
    a("RichTextView BoxLayout", {
        innerSpacing = {0,0},
    })
    a("RichTextView BoxLayout", {
        innerSpacing = {0, 6},
    })
    return result
end
