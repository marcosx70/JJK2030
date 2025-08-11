--!strict
export type Counter = { value: number, Inc: (Counter)->(), Destroy: (Counter)->() }
local C = {}; C.__index = C
function C.new(): Counter return setmetatable({ value = 0 }, C) end
function C:Inc() self.value += 1 end
function C:Destroy() end
return C
