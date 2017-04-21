-- 创建图
function createmap(rows, columns)
	local map = {rows = rows, columns = columns, grids = {}}

	for r=1, map.rows do
		for c=1, map.columns do
			local i = (r - 1) * map.columns + c
			map.grids[i] = 0
		end
	end

	function map:setUnwalkabled(row, column)
		self.grids[(row - 1) * self.columns + column] = -1
	end

	return map
end

-- 创建扩展图
function extendmap(map)
	local exmap = {rows = map.rows + 2, columns = map.columns + 2, grids = {}}

	for r=1, exmap.rows do
		for c=1, exmap.columns do
			local i = (r - 1) * exmap.columns + c
			if r == 1 or c == 1 or r == exmap.rows or c == exmap.columns then
				exmap.grids[i] = UNWALKABLE
			else
				local k = (r - 2) * map.columns + (c - 1)
				exmap.grids[i] = map.grids[k]
			end
		end
	end

	return exmap
end
