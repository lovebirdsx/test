class Solution(object):
    def __init__(self):
        n_map = {}
        key1 = 0
        key2 = 1
        add_n1 = 1
        add_n2 = 0
        for i in range(32):
            n_map[key1] = True
            n_map[key2] = True
            
            key1 = (key1 << 1) + add_n1
            add_n1 = 1 - add_n1
            key2 = (key2 << 1) + add_n2
            add_n2 = 1 - add_n2
        self.n_map = n_map

    def hasAlternatingBits(self, n):
        """
        :type n: int
        :rtype: bool
        """
        return self.n_map.has_key(n)

def test():
    s = Solution()
    for i in [0,1,2,3,4,5,7,10,11]:
        print i, s.hasAlternatingBits(i)

if __name__ == '__main__':
    test()
