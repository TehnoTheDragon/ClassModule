local HTTPService = game:GetService("HttpService")

local ClassMetatable = {}
local Class = {}

function Class.allocate(extendClass)
	return setmetatable({}, { __index = Class, __newindex = extendClass })
end

ClassMetatable.__class = "Class"
ClassMetatable.__index = Class
ClassMetatable.__tostring = function()
	return ClassMetatable.__class
end
ClassMetatable.__call = Class.allocate

function Class.extend(className: string, extendClass)
	extendClass = extendClass or Class
	
	local newClassMetatable = {}
	local newClass = {}
	
	function newClass.allocate(class)
		local newObject = { super = extendClass.allocate(class) }
		setmetatable(newObject, { __index = newClass, __newindex = class })
		return newObject
	end

	function newClass.new(...)
		local newObjectMetatable = {}
		local newObject = {}
		newObject.super = extendClass.allocate(newObject)
		
		newObjectMetatable.__guid = HTTPService:GenerateGUID(false)
		newObjectMetatable.__object = className
		newObjectMetatable.__index = newClass
		newObjectMetatable.__tostring = newClass.__tostring or function()
			return ("(Object: %s) %s"):format(newObjectMetatable.__object, newObjectMetatable.__guid)
		end
		
		setmetatable(newObject, newObjectMetatable)
		
		newObject:init(...)
		return newObject
	end
	
	function newClass.extend(className: string)
		return Class.extend(className, newClass)
	end
	
	newClassMetatable.__guid = HTTPService:GenerateGUID(false)
	newClassMetatable.__object = className
	newClassMetatable.__index = function(_, name)
		return rawget(extendClass, name)
	end
	newClassMetatable.__tostring = function()
		return ("(Class) %s"):format(newClassMetatable.__object)
	end
	newClassMetatable.__call = function(_,...)
		return newClass.new(...)
	end
	newClassMetatable.__eq = function(L, R)
		return rawequal(getmetatable(L).__guid, getmetatable(R).__guid)
	end
	
	setmetatable(newClass, newClassMetatable)
	
	return newClass
end

setmetatable(Class, ClassMetatable)
return Class
