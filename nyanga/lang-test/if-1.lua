local function foo(x, y)
	if x == {} then
		return x + y
	else
		return x - y
	end
end

print(foo(3,7), foo(7,3))