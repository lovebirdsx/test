let ip: string | number
ip = '192.168.0.100'
ip = 0xffffff

// ip = true 这一句是不允许的

function getLength1(something: string | number) {
    // return something.length 这一句是不允许的
}

function getString(something: string | number) {
    return something.toString()
}

console.log(getString(ip))

let n: string | number
n = 'lovebird'
console.log(n.length)
n = 7
// console.log(n.length) 这一句是不允许的

let fuck:any = 7
fuck = 'hello'
console.log(fuck.length)
