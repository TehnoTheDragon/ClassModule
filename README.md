# ClassModule
Lua Module, I created this for roblox games, but I guess it's should work anywhere else.

# How to use
```lua
local class = ... // require or dofile to get access to class module

// create new class
local Entity = class.extend("Entity")

function Entity:init(name)
  self.name = name
end

function Entity:printName()
  print(self.name)
end

// create player class
local Player = Entity:extend("Player") // or class.extend("Player", Entity)

function Player:init(username)
  self.super:init(username)
  self.hp = 10
end

function Player:printHp()
  print(self.hp)
end

// create object based off player class
local player0 = Player("Player0")
player0:printName()
player0:printHp()
```
