// 基础类型

let b:boolean = true
let B:Boolean = new Boolean()

console.log(b)
console.log(B)

B = undefined
console.log(B)

let c = null
console.log(c)

let str = 'hello world'
console.log(str)


// any

let a:any = 7
console.log(a)
a = 'foo'
console.log(a)

let d1
d1 = 'hello'
d1 = 123

let d2 = 'hello'
// d2 = 123 这一句是不允许的,注意和上面d1的差别


