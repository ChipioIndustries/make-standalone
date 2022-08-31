local t = require(script.Parent.t)

local typeCheck = t.tuple(t.callback, t.union(t.table, t.Instance))

local function makeStandalone(method, object)
	assert(typeCheck(method, object))
	return function(...)
		return method(object, ...)
	end
end

return makeStandalone