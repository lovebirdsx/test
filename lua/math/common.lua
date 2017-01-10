function distance(p1, p2)
	return ((p1.x - p2.x) ^ 2 + (p1.y - p2.y) ^ 2) ^ 0.5
end

function cal_angle(p1, p2, p3)
	return math.atan2(p3.y - p2.y, p3.x - p2.x) - math.atan2(p1.y - p2.y, p1.x - p2.x);
end

function cal_angle2(p1, p2, p3)
    local p12 = distance(p1, p2)
    local p23 = distance(p2, p3)
    local p13 = distance(p1, p3)
    return math.acos((p23*p23+p12*p12-p13*p13)/(2*p23*p12))
end

function test_cal_angle()
	local p1 = {x = 10, y = 0}
	local p2 = {x = 0, y = 0}
	local p3 = {x = 0, y = 10}

	local a = cal_angle(p1, p2, p3)
	print(a, math.deg(a))

	a = cal_angle(p3, p2, p1)
	print(a, math.deg(a))
end

test_cal_angle()

print(math.cos(math.rad(30)))
print(math.cos(math.rad(-30)))