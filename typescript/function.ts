function sum(x, y) {
    return x + y
}

console.log(sum(1, 2))

let mySum: (x:number, y:number) => number = function (x: number, y: number): number {
    return x + y
}

console.log(mySum(1, 2))

interface SearchFunc {
    (source: string, subString: string): boolean
}

let mySearch: SearchFunc;
mySearch = function(source: string, subString: string) {
    return source.search(subString) !== -1
}

console.log(mySearch('lovebird', 'love'))
console.log(mySearch('lovebird', 'love1'))

// 可选参数
function buildName(firstName:string, lastName?: string) {
    if (lastName) {
        return firstName + ' ' + lastName
    } else {
        return firstName
    }
}

console.log(buildName('Song', 'Xiao'))
console.log(buildName('Xiao'))

// 剩余参数
function push(array, ...items) {
    items.forEach(function(item){
        array.push(item)
    })
}

let a11 = []
push(a11, 1, 2, 3, 4, 'Lovebird')
console.log(a11)

//  重载
function reverse(x: number): number
function reverse(x: string): string
function reverse(x: number | string): number | string {
    if (typeof x == 'number') {
        return Number(x.toString().split('').reverse().join(''))
    }
    else if (typeof x == 'string') {
        return x.split('').reverse().join('')
    }
}

console.log(reverse(123))
console.log(reverse('lovebird'))
