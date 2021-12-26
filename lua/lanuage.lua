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
-- function test_select(...)
-- 	print(select(2, ...))
-- end

-- test_select(1,2,3,4,5,6)
-- print(select(3, 1,2,3,4,5,6))
-- local a = select(2, 1,2,3)
-- print(a)

---------------------------------------------------
-- assert
-- assert(false, 'hello assert')

-- local i = 1
-- repeat
-- 	print('hello')
-- 	i = i + 1
-- until i > 5

print(false or false or 1)
print(false or 1 or 2)
print(1 or 2 or 3)
