local part1 = require "part1"
local part2 = require "part2"
local part3 = require "part3"
local part4 = require "part4"
local part5 = require "part5"
local medal1 = require "medal1ponderosa"
local medal2 = require "medal2grandopening"
local medal3 = require "medal3bigfoot"

return function(taskutil)
	part1(taskutil)
	part2(taskutil)
	part3(taskutil)
	part4(taskutil)
	part5(taskutil)
	medal1(taskutil)
	medal2(taskutil)
	medal3(taskutil)
end
