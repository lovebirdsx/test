class Hero {
    constructor(
        public id: number, 
        public name: string) {}
}

let heroes = [
    new Hero(1001, 'String'),
    new Hero(1002, 'Math'),
    new Hero(1003, 'Pack'),
]

for (let hero of heroes) {
    console.log(hero.id, hero.name)
}