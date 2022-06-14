/* 1. 闭包表达式 */
/*
{
    (参数列表) -> 返回类型 in 函数体代码
}
*/
// 函数
func sum(_ v1: Int, _ v2: Int) -> Int { v1 + v2 }
// 闭包表达式
var fn = {
    (v1: Int, v2: Int) -> Int in
    return v1 + v2
}
fn(10, 20)

//--------------------------------------------------

/* 2. 闭包表达式的简写 */
func exec(v1: Int, v2: Int, fn: (Int, Int) -> Int) {
    print("exec", fn(v1, v2))
}
// 完整写法
exec(v1: 1, v2: 2, fn: {
    (v1: Int, v2: Int) in
    return v1 + v2
})
// 简写 1: 由编译器推断参数类型
exec(v1: 3, v2: 4, fn: {
    v1, v2 in return v1 + v2
})
// 简写 2: 忽略 return
exec(v1: 5, v2: 6, fn: {
    v1, v2 in v1 + v2
})
// 简写 3: 忽略参数列表和 in, 直接返回函数体代码
exec(v1: 7, v2: 8, fn: { $0 + $1 })
// 简写 4
exec(v1: 9, v2: 10, fn: +)

//--------------------------------------------------

/* 3. 尾随闭包 */
exec(v1: 11, v2: 12) {
    // return $0 + $1
    $0 + $1
}
// 如果闭包表达式是函数的唯一实参
func execOnly(fn: (Int, Int) -> Int) {
    print("execOnly", fn(13, 14))
}
execOnly(fn: { $0 + $1 }) // 正常写法
execOnly() { $0 + $1 } // 尾随闭包写法 1
execOnly { $0 + $1 } // 尾随闭包写法 2, 忽略括号

//--------------------------------------------------

/* 4. 示例: 数组排序 */
// 个人理解，闭包表达式其实就是匿名函数

//func sort(by areIncreasingOrder: (Element, Element) -> Bool)
func cmp(i1: Int, i2: Int) -> Bool {
    return i1 > i2
}
var nums = [11, 2, 18, 6, 5, 68, 45]
// 传入函数
nums.sort(by: cmp)
// 传入闭包表达式
nums.sort(by: {
    (i1: Int, i2: Int) -> Bool in
    i1 < i2
})
nums
// 闭包表达式简写 1
nums.sort(by: { i1, i2 in return i1 > i2 })
nums
// 闭包表达式简写 2
nums.sort(by: { i1, i2 in i1 < i2 })
nums
// 闭包表达式简写 3
nums.sort(by: { $0 > $1 })
nums
// 闭包表达式简写 4
nums.sort(by: <)
nums
// 尾随闭包 1
nums.sort() { $0 < $1 }
nums
// 尾随闭包 2
nums.sort { $0 > $1 }
nums

/* 5. 忽略参数的闭包表达式 */
var ignoreParamsFn: (Int, Int) -> Int = {
    _,_ in 10
}
ignoreParamsFn(1, 2)
