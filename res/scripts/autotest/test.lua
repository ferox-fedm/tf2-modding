-- run using command-line argument "--script res/scripts/autotest/test.lua"
function data()

local testcases = {"TF-1146-test-example.sav"}

local state = {
	stop = false,
	inGame = false,
    currentTest = 1,
}

return {
	update = function()
		if state.stop then return end

        local menuUI = api.gui.util.getById("menuUI")
        if menuUI ~= nil and menuUI:isVisible() then
            -- came (back) to main menu

            if state.currentTest > #testcases then
                app.quit()
                state.stop = true
            else
                local testcase = testcases[state.currentTest]
                print("Load " .. state.currentTest .. ": " .. testcase)
                state.currentTest = state.currentTest+1
                app.loadGame(testcase)
            end
        end
	end,

	handleEvent = function(id, name, param)
	    print("Event: " .. id .. " " .. name)
        state.inGame = true

        -- Catch clicking of quit button and immediately stop
        -- (the testcase can click this button programmatically)
        local ingameMenu = api.gui.util.getById("ingameMenu")
        ingameMenu:onVisibilityChange(function()
            if ingameMenu:isVisible() then
                local quitButton = api.gui.util.getById("ingameMenu.quitButton")
                if quitButton then
                    quitButton:onClick(function()
                        print ("quitButton triggered, will stop game without asking")
                        state.inGame = false
                        app.stopGame();
                    end)
                end
            end
        end)
	end
}
end