let fibonacci: number[] = [1, 1, 2, 3, 5]
// let fibonacci2: number[] = [1, '1', 2, 3, 5] 不允许出现其他类型

console.log(fibonacci)

// 利用泛型类表示数组
let fibonacci3: Array<number> = [1, 1, 2, 3, 5]
console.log(fibonacci)

// 用接口表示数组

interface NumberArray {
    [index:number]: number
}
let fibonacci4 = [1, 1, 2, 3, 5]
console.log(fibonacci4)

let list: any[] = ['Lovebird', 25, {firstName:'Song', lastName:'Xiao'}]
console.log(list)

function sum1(): number {
    console.log(arguments)
    // let args: number[] = arguments 类数组不是数组类型
    return 0
}

sum1()