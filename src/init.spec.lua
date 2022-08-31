return function()
	local makeStandalone = require(script.Parent)

	describe("makeStandalone.lua", function()
		describe("type checking", function()
			it("should not accept a non-function method", function()
				local badMethod = true
				local object = {}
				expect(function()
					makeStandalone(badMethod, object)
				end).to.throw()
			end)
			it("should not accept a non-class object", function()
				local method = function() end
				local badObject = true
				expect(function()
					makeStandalone(method, badObject)
				end).to.throw()
			end)
			it("should support Instances", function()
				local object = Instance.new("Part", script)
				local method = object.Destroy
				local standalone = makeStandalone(method, object)
				standalone()
				expect(object.Parent).to.equal(nil)
			end)
		end)

		describe("argument behavior", function()
			it("should provide method with an object as the first parameter", function()
				local result
				local function method(self)
					result = self
				end
				local object = {}
				local standalone = makeStandalone(method, object)
				standalone()
				expect(result).to.equal(object)
			end)
			it("should pass all arguments through to the method", function()
				local result1, result2
				local function method(_self, argument1, argument2)
					result1, result2 = argument1, argument2
				end
				local value1, value2 = "test1", "test2"
				local object = {}
				local standalone = makeStandalone(method, object)
				standalone(value1, value2)
				expect(result1).to.equal(value1)
				expect(result2).to.equal(value2)
			end)
		end)

		describe("return behavior", function()
			it("should return the method's result to the calling point", function()
				local value = 5
				local function method(_self)
					return value
				end
				local object = {}
				local standalone = makeStandalone(method, object)
				local result = standalone()
				expect(result).to.equal(value)
			end)
		end)
	end)
end