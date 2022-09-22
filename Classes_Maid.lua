--[[
	Maid Class
	© Written by metry
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

local Class = require(ReplicatedStorage.Libraries.Class)

local Maid = Class.new("Maid")

local MaidCache = {}

local Methods = {
	["function"] = true,
	["RBXScriptConnection"] = "Disconnect",
	["Instance"] = "Destroy",
}

function Maid.new(name, methods)
	local Proxy = newproxy(true)
	local MT = getmetatable(Proxy)

	MaidCache[Proxy] = {
		_methods = methods or Methods,
	}

	function MT:__index(i)
		return MaidCache[self][i] or Maid[i]

	end

	function MT:__newindex(i, v)
		if MaidCache[self][i] then
			self:Cleanup(v)
		end

		MaidCache[self][i] = v
	end

	function MT:__tostring()
		return name or "Maid"
	end

	return Proxy
end

function Maid:Clean(v)
	local Method = self._methods[typeof(v)]

	if Method == true then
		v()
	else
		v[Method](v)
	end

	Maid[table.find(MaidCache[self], v)] = nil
end

function Maid:Cleanup()
	assert(MaidCache[self], string.format("%s is missing from MaidCache", tostring(self)))

	for i,v in pairs(MaidCache[self]) do
		if v == "_methods" then
			continue
		end

		self:Clean(v)
	end
end

function Maid:Destroy()
	self:Cleanup()
	MaidCache[self] = nil
end


return Maid
