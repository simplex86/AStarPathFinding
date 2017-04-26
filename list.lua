-- 列表
local list = {nodes = {}, length = 0}

-- 创建新对象
function list:new()
	local t = {}

	setmetatable(t, self)
	self.__index = self

	return t
end

-- 添加node
function list:add(node)
	table.insert(self.nodes, node)
	self.length = self.length + 1
end

-- 移除node
function list:remove(node)
	local index = 0

	for k, v in ipairs(self.nodes) do
		if v.row == node.row and v.column == node.column then
			index = k
			break
		end
	end

	if index > 0 then
		table.remove(self.nodes, index)
		self.length = math.max(0, self.length - 1)
	end
end

-- 判断node是否存在
function list:existed(node)
	for _, v in ipairs(self.nodes) do
		if v.row == node.row and v.column == node.column then
			return true
		end
	end

	return false
end

-- 清空列表
function list:clear()
	self.nodes = {}
	self.length = 0
end

------------------------------------------------------------

function createlist()
	return list:new()
end
