function createArray<T>(length: number, value: T): Array<T> {
    let result = []
    for (let i = 0; i < length; i++) {
        result[i] = value
    }
    return result
}

let a4 = createArray(4, 'wahaha')
console.log(a4)