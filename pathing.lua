require("map")
require("list")

-- 获取权值
local function G(row, column, parent_row, parent_column)
	if row == parent_row or column == parent_column then
		return 10
	end

	return 14
end

-- 曼哈顿距离
local function manhatton_valuation(row, column, target_row, target_column)
	return (target_row - row) + (target_column - column)
end

-- 获取距离估值
local function H(row, column, target_row, target_column)
	return manhatton_valuation(row, column, target_row, target_column) * 10
end

-- 将table转换为string，调试用
local function table2string(list, s)
	s = s or 0
	local txt = "{\n"

	for k, v in pairs(list) do
		local exp = txt .. string.rep("\t", s + 1) .. k .. "="
		local tp = type(v)

		if tp == "number" then
			txt = exp .. v .. ",\n"
		elseif tp == "boolean" then
			txt = exp .. tostring(v) .. ",\n"
		elseif tp == "string" then
			txt = exp .. string.format("%q,\n", v)
		elseif tp == "table" then
			txt = exp .. table2string(v, s + 1) .. ",\n"
		else
			-- error("can not serialize a value with [" .. tp .. "] type")
		end
	end 

	txt = txt .. string.rep("\t", s) .. "}"
	return txt
end

-- 获取4连通邻点
local function neighbour4(row, column)
	local nodes = {{row = row,     column = column + 1},
				   {row = row + 1, column = column},
				   {row = row,     column = column - 1},
				   {row = row - 1, column = column}}

	return nodes
end

-- 获取8连通邻点
local function neighbour8(row, column)
	local nodes = {}

	for r=row-1, row+1 do
		for c=column-1, column+1 do
			table.insert(nodes, {row = r, column = c})
		end
	end

	return nodes
end

---------------------------------------------------------------------

local openlist = createlist()
local closelist = createlist()

-- 探索下一步
local function seek(map, target_row, target_column)
	-- 获取openlist中F值最小的节点
	local node = openlist.nodes[1]

	for _, v in ipairs(openlist.nodes) do
		if v.F < node.F then
			node = v
		end
	end

	local current_row	 = node.row
	local current_column = node.column

	-- 获取连通区域
	local neighbours = neighbour4(current_row, current_column)

	-- 处理连通区域
	for _, v in ipairs(neighbours) do
		local r = v.row
		local c = v.column

		local mapgrid = map.grids[(r - 1) * map.columns + c]
		-- 只处理map中可行走的格子 以及 不存在于closelist的格子
		if mapgrid == 0 and not closelist:existed(node) then
			-- print("r=" .. r .. " | c=" .. c .. " | v=" .. mapgrid)
			local connected_node = {}
			local weight = G(r, c, current_row, current_column)

			connected_node.row 		= r
			connected_node.column 	= c
			connected_node.G 		= node.G + weight
			connected_node.H 		= H(r, c, target_row, target_column)
			connected_node.F 		= connected_node.G + connected_node.H

			if not openlist:existed(connected_node) then
				connected_node.parent = node
				openlist:add(connected_node)
			else
				local g = G(r, c, node.row, node.column) + node.G
				if g < connected_node.G then
					connected_node.G = g
					connected_node.F = connected_node.G + connected_node.H
				end
			end

			if connected_node.row == target_row and connected_node.column == target_column then
				return connected_node
			end
		end
	end

	openlist:remove(node)
	if not closelist:existed(node) then
		closelist:add(node)
	end

	-- 寻路失败，结束
	-- print("openlist.length=" .. openlist.length)
	if openlist.length == 0 then
		return nil
	end

	return seek(map, target_row, target_column)
end

-----------------------------------------------------------------------

-- 寻路
function pathing(map, from_row, from_column, to_row, to_column)
	-- 初始化扩展图
	local exmap = extendmap(map)

	-- 开始寻路
	openlist:clear()
	closelist:clear()

	-- 将起点加入到openlist中
	local from 	= {}

	from.row 	= from_row + 1
	from.column = from_column + 1
	from.G 		= 0
	from.H 		= 0
	from.F 		= 0

	openlist:add(from)

	-- 进行下一步
	local to = seek(exmap, to_row + 1, to_column + 1)

	-- 获取路径
	local path = {}

	while to ~= nil do
		local pathnode = {row = to.row - 1, column = to.column - 1}
		table.insert(path, pathnode)

		to = to.parent
	end

	return path
end
