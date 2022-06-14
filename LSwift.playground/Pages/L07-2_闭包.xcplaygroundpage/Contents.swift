/* 1. Closure 闭包的定义 */
// 一个函数和它所捕获的变量/常量环境组合起来，称为闭包
// - 一般指定义在函数内部的函数
// - 一般它捕获的是外层函数的局部变量/常量

// 可以把闭包想象成一个类的实例对象
// - 内存在堆空间
// - 捕获的局部变量/常量就是对象的成员（存储属性）
// - 组成闭包的函数就是类内部定义的方法

typealias Fn = (Int) -> Int
func getFn() -> Fn {
    var num = 0
    func plus(_ i: Int) -> Int {
        num += i
        return num
    }
    return plus
} // 返回的 plus 和 num 形成了闭包

var fn1 = getFn()
fn1(1) // 1
fn1(2) // 3
fn1(3) // 6
fn1(4) // 10
fn1(5) // 15
fn1(6) // 21

//--------------------------------------------------

/* 2. Exercise 1 */
typealias Fn_Int_IntInt = (Int) -> (Int, Int)
func getFns() -> (Fn_Int_IntInt, Fn_Int_IntInt) {
    var num1 = 0
    var num2 = 0
    func plus(_ i: Int) -> (Int, Int) {
        num1 += i
        num2 += i << 1
        return (num1, num2)
    }
    func minus(_ i: Int) -> (Int, Int) {
        num1 -= i
        num2 -= i << 1
        return (num1, num2)
    }
    return (plus, minus)
}
let (p, m) = getFns()
p(5) // 5, 10
m(4) // 1, 2
p(3) // 4, 8
m(2) // 2, 4

// 闭包类似下面的 Class
class Closure_Int_IntInt {
    var num1 = 0
    var num2 = 0
    func plus(_ i: Int) -> (Int, Int) {
        num1 += i
        num2 += i << 1
        return (num1, num2)
    }
    func minus(_ i: Int) -> (Int, Int) {
        num1 -= i
        num2 -= i << 1
        return (num1, num2)
    }
}
let cls = Closure_Int_IntInt()
cls.plus(5) // 5, 10
cls.minus(4) // 1, 2
cls.plus(3) // 4, 8
cls.minus(2) // 2, 4

//--------------------------------------------------

/* 3. Exercise 2 */
var functions: [() -> Int] = []
for i in 1...3 {
    functions.append { i }
}
for f in functions {
    print(f())
}

// 闭包类似下面的 Class
class Closure_functions {
    var i: Int
    init (_ i: Int) {
        self.i = i
    }
    func get() -> Int {
        return self.i
    }
}
var clses: [Closure_functions] = []
for i in 1...3 {
    clses.append(Closure_functions(i))
}
for cls in clses {
    print(cls.get())
}

//--------------------------------------------------

/* 4. 自动闭包 autoclosure */
// autoclosure
// - 会将 20 自动封装成闭包 { 20 }
// - 只支持 () -> T 格式的参数
// - 不是只支持最后一个参数
// - 空合并运算符 ?? 使用了 @autoclosure 技术
// - 有 @autoclosure 和无 @autoclosure 构成了函数重载

func getFirstPostive(_ v1: Int, _ v2: Int) -> Int {
    return v1 > 0 ? v1 : v2
}
getFirstPostive(10, 20)
getFirstPostive(-2, 20)
getFirstPostive(0, -4)

// 改成函数参数类型的参数，可以让 v2 延迟加载
func getFirstPostiveWithClosure(_ v1: Int, _ v2: () -> Int) -> Int? {
    return v1 > 0 ? v1 : v2()
}
print(getFirstPostiveWithClosure(-4) { 20 }!)
//print(getFirstPostiveWithClosure(-4, 20)) // compile error

func getFirstPostiveWithAutoClosure(_ v1: Int, _ v2: @autoclosure () -> Int) -> Int? {
    return v1 > 0 ? v1 : v2()
}
print(getFirstPostiveWithAutoClosure(-4, 20)!)
