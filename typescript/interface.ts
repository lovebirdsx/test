interface Person {
    name: string
    age: number
}

let lovebird: Person = {
    name: 'Lovebird',
    age: 33
}

console.log(lovebird)

interface MyWorker {
    readonly id: number
    name: string
    age?: number
    [propName1: string]: any
}

let w: MyWorker = {
    id: 12345,
    name: 'Foo',
    age: 33,
    website: 'https://lovebirdsx.github.io',
    home: 'guangzhou',
    firstName: 'Song',
    lastName: 'Xiao'
}

// w.id = 123 因为是readonly,所以只能在初始化的时候赋值

console.log(w)

interface IAlarm {
    alert(): void
}

interface ILight {
    on(): void
    off(): void
}

class Car implements IAlarm, ILight {
    alert(): void {
        console.log('Car alear')
    }

    on() : void {
        console.log('Car light on')
    }

    off() : void {
        console.log('Car light off')
    }
}
