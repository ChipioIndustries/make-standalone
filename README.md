# makeStandalone

makeStandalone is a utility function that accepts a method and its object and returns a standalone function that can be called on its own or passed as a callback to another function.

## Examples

Connecting a class member to a signal:
```lua
local Class = require(script.Parent.Class)
local makeStandalone = require(script.Parent.makeStandalone)

local myClass = Class.new()
local part = workspace.Part
local standaloneAction = makeStandalone(myClass.doThing, myClass)
part.Touched:Connect(standaloneAction)
```

Passing arguments:
```lua
local myObject = {}
function myObject:doThing(a, b, c)
	print(a, b, c) -- myObject, 1, 2
end
local standaloneAction = makeStandalone(myObject.doThing, myObject)
standaloneAction(1, 2)
```

Converting a Roblox Instance method:
```lua
local makeStandalone = require(script.Parent.makeStandalone)
local part = workspace.Part

local standaloneDestroy = makeStandalone(part.Destroy, part)
part.Touched:Connect(standaloneDestroy)
```

I personally use this most often to let an object connect its methods to events:

```lua
local makeStandalone = require(script.Parent.makeStandalone)

local Class = {}
Class.__index = Class

function Class.new(target)
	local self = setmetatable({
		_target = target;
	}, Class)
	self._standaloneDoThing = makeStandalone(self._doThing, self)
	return self
end

function Class:init()
	self._connection = target.Touched:Connect(self._standaloneDoThing)
end

function Class:_doThing(hit)
	print(("target was touched by %s"):format(tostring(hit)))
end

function Class:destroy()
	self._connection:Disconnect()
end
```