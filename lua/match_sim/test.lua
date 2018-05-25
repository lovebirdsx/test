require('sim')

local test = {}

function test.cal_init_rank()
    local power_min, power_max = POWER_SECTIONS_TO_RANK[1], POWER_SECTIONS_TO_RANK[#POWER_SECTIONS_TO_RANK]
    local rank_min, rank_max = INIT_RANK_RANGE[1], INIT_RANK_RANGE[2]
    assert(cal_init_rank(power_min * 0.9) == rank_min)
    assert(cal_init_rank(power_min) == rank_min)
    assert(cal_init_rank(power_max) == rank_max)
    assert(cal_init_rank(power_max * 1.1) == rank_max)

    for i = 2, #POWER_SECTIONS_TO_RANK do
        local power1 = POWER_SECTIONS_TO_RANK[i - 1]
        local power2 = POWER_SECTIONS_TO_RANK[i]
        assert(cal_init_rank(power1) < cal_init_rank(power2),
                string.format('%s[%s] %s[%s] ',
                        power1,
                        cal_init_rank(power1),
                        power2,
                        cal_init_rank(power2)
              )
        )
    end

    for i, power in ipairs(POWER_SECTIONS_TO_RANK) do
        local power1 = power * 0.9
        local power2 = power * 1.1
        assert(cal_init_rank(power1) < cal_init_rank(power2),
                string.format('%s[%s] %s[%s] ',
                        power1,
                        cal_init_rank(power1),
                        power2,
                        cal_init_rank(power2)
                )
        )
    end
end

function test.elo()
    local ra = 1500
    local rb = 1600
    local ra0, rb0 = cal_rank(ra, rb, 1, 0)
    print(ra, ra0)
    print(rb, rb0)
end

local function test_all()
    for name, fun in pairs(test) do
        fun()
        print('finish ', name)
    end
end

test_all()
