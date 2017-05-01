class Animal {
    static isAnimal(a):boolean {
        return a instanceof Animal
    }

    private _name:string

    constructor(name) {
        this._name = name
    }

    get name() {
        return this._name
    }

    set name(value) {
        this._name = value
    }

    sayHi(): string {
        return 'My name is ' + this._name
    }
}

class Cat extends Animal {
    constructor(name) {
        super(name)
        console.log(name)
    }

    sayHi(): string {
        return 'Meow, ' + super.sayHi()
    }
}

let animal = new Animal('Foo')
console.log(animal.sayHi())
console.log(animal.name)

let cat = new Cat('Tom')
console.log(cat.sayHi())

console.log(Animal.isAnimal(cat))
console.log(Animal.isAnimal(animal))
console.log(Animal.isAnimal('animal'))