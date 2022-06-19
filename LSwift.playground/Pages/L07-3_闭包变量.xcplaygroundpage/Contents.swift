// 闭包和闭包变量，内存布局是不一样的

typealias Fn = (Int) -> Int
func getFn() -> Fn {
    var num = 0
    func plus(_ i: Int) -> Int {
        num += i
        return num
    }
    return plus
} // 返回的 plus 和 num 形成了闭包
// 如果闭包捕获的 num 是全局变量，就不需要为闭包在堆上分配空间，返回的是代码段的地址

var fn1 = getFn()
fn1(1) // 1
fn1(2) // 3
fn1(3) // 6
fn1(4) // 10
fn1(5) // 15
fn1(6) // 21

MemoryLayout.stride(ofValue: fn1) // 16
MemoryLayout.size(ofValue: fn1) // 16
MemoryLayout.alignment(ofValue: fn1) // 8

func sum(_ v1: Int, _ v2: Int) -> Int { v1 + v2}
var fn2 = sum
MemoryLayout.stride(ofValue: fn2) // 16
MemoryLayout.size(ofValue: fn2) // 16
MemoryLayout.alignment(ofValue: fn2) // 8
