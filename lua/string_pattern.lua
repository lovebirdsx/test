function test_string_match()
	print(string.find('banana', 'an'))
	print(string.find('banaba', 'lua'))
	print(string.find('abcdefg', 'b..'))
	
	print(string.match('banana', 'ba'))
	print(string.match('foo 123 bar', '%d%d%d'))
	print(string.match('Hello World', '%u'))
	print(string.match('abcd', '[bc][bc]'))
	print(string.match('abcd', '[^ad]'))
	print(string.match('123', '[0-9]'))
	
	print(string.match('examples', 'examples?'))
	print(string.match('example', 'examples?'))
	print(string.match('example', 'examples'))
	
	print(string.match('hello, 1234, world', '%d+'))
	
	print(string.match('one | two | three', '|.*|'))
	print(string.match('one || three', '|.*|'))
	print(string.match('one || three', '|.+|'))
	
	-- * And -
	print(string.match('one | two | three | four | five', '|.*|'))
	print(string.match('one | two | three | four | five', '|.-|'))
	print(string.match('abc', 'a.*'))
	print(string.match('abc', 'a.-'))
	print(string.match('abc', 'a.-$'))
	print(string.match('abc', '^.-b'))
	
	-- Special characters
	print(string.match('%*^', '%%%*%^'))
	
	-- Return sevaral result
	print(string.match('foo: 123 bar:456', '(%a+):%s*(%d+)%s+(%a+):%s*(%d+)'))
	
	-- U can not use:
	-- '(foo)+' '(foo|bar)'
end

function test_get_api_line()
	function get_api_line(line)
		return string.match(line, 'function%s+%a+.-%(-%)')
	end

	print(get_api_line('function foo()'))
	print(get_api_line('function foo() end'))
	print(get_api_line('function  foo() end'))
	print(get_api_line('function foo()  end'))
	print(get_api_line('function ()  end'))
	print(get_api_line('function foo(bar) end'))
	print(get_api_line('function foo(bar, car) end'))
	print(get_api_line('function foo(bar, ...) end'))
end

test_get_api_line()
