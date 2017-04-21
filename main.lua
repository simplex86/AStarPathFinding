require("map")
require("pathing")

-- 打印
function display(map)
	for r=1, map.rows do
		local txt = ""

		for c=1, map.columns do
			local i = (r - 1) * map.columns + c
			local v = map.grids[i]

			if v == 0 then
				txt = txt ..". "
			elseif v == 1 then
				txt = txt .."  "
			else
				txt = txt .."- "
			end
		end

		print(txt)
	end
end

-- 测试1
function test1()
	local map = createmap(10, 10)

	map:setUnwalkabled(3, 5)
	map:setUnwalkabled(4, 5)
	map:setUnwalkabled(5, 5)
	display(map)

	print("\n===================\n")

	local path = pathing(map, 4, 3, 4, 7)

	for _, v in ipairs(path) do
		local i = (v.row - 1) * map.columns + v.column
		map.grids[i] = 1
	end

	display(map)
end

-- 测试2
function test2()
	local map = createmap(10, 10)
	map:setUnwalkabled(3, 2)
	map:setUnwalkabled(3, 3)
	map:setUnwalkabled(3, 4)
	map:setUnwalkabled(4, 2)
	map:setUnwalkabled(4, 4)
	map:setUnwalkabled(5, 2)
	map:setUnwalkabled(5, 3)
	map:setUnwalkabled(5, 4)
	display(map)

	print("\n===================\n")

	local path = pathing(map, 4, 3, 4, 7)

	for _, v in ipairs(path) do
		local i = (v.row - 1) * map.columns + v.column
		map.grids[i] = 1
	end

	display(map)
end

-- 测试3
function test3()
	local map = createmap(10, 10)
	map:setUnwalkabled(3, 2)
	map:setUnwalkabled(3, 3)
	map:setUnwalkabled(3, 4)
	map:setUnwalkabled(4, 2)
	map:setUnwalkabled(4, 4)
	map:setUnwalkabled(5, 2)
	map:setUnwalkabled(5, 3)
	map:setUnwalkabled(5, 4)
	display(map)

	print("\n===================\n")

	local path = pathing(map, 4, 7, 4, 3)

	for _, v in ipairs(path) do
		local i = (v.row - 1) * map.columns + v.column
		map.grids[i] = 1
	end

	display(map)
end

test1()
print("\n===================\n")
test2()
print("\n===================\n")
test3()
