@logClass
class Hero {
    public name: string
    public power: string

    constructor(name: string, power: string) {
        this.name = name
        this.power = power
    }

    showPower() {
        return this.name + ' has special power: ' + this.power
    }
}

let h = new Hero('Lovebird', 'think')
console.log(h.showPower())

function logClass(target:any) {
    // 保存原始构造器
    var original = target;
    // 工具函数，生成类的实例
    function construct(constructor, args) {
        var c : any = function () {
        return constructor.apply(this, args);
        }
        c.prototype = constructor.prototype;
        return new c();
    }
    // 添加行为到构造器调用时
    var f : any = function (...args) {
        console.log("God bless " + args[0]); 
        return construct(original, args);
    }
    // 复制原始构造器的原型
    f.prototype = original.prototype;
    // 返回新的构造器
    return f;
}