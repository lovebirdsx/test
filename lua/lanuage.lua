---------------------------------------------------
-- -- redifine funciton
-- function foo(a, b)
-- 	return a + b
-- end

-- function foo(a, b)
-- 	return a - b
-- end

-- print(foo(3, 2))

---------------------------------------------------
-- select
function test_select(...)
	print(select(2, ...))
end

test_select(1,2,3,4,5,6)
print(select(3, 1,2,3,4,5,6))
local a = select(2, 1,2,3)
print(a)