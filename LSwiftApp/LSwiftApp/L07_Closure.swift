//
//  L07_Closure.swift
//  LSwiftApp
//
//  Created by Jymn_Chen on 2022/6/9.
//

import Foundation

var g_num = 10

class Person {
    var age: Int = 11
}

typealias Fn = (Int) -> Int
typealias Fn_Int_IntInt = (Int) -> (Int, Int)

func getFn_normal() -> Fn {
    /*
     生成的闭包地址：
     第 0 - 8 个字节: 类型信息
     第 8 - 16 个字节: 引用计数
     第 16 - 24 个字节: 捕获的变量 num = 12
     
     返回的地址：
     LSwiftApp`partial apply forwarder for plus(Swift.Int) -> Swift.Int at <compiler-generated>
     闭包在 x1 返回
     */
    var num = 12
    func plus(_ i: Int) -> Int {
        num += i
        return num
    }
    return plus
}

func getFn_noCapture() -> Fn {
    /*
     没有生成闭包
     
     返回的地址：LSwiftApp`plus(Swift.Int) -> Swift.Int at L07_Closure.swift:43
     */
    func plus(_ i: Int) -> Int {
        return i
    }
    return plus
}

func getFn_global() -> Fn {
    /*
     没有生成闭包
     
     返回的地址：LSwiftApp`plusGlobal(Swift.Int) -> Swift.Int at L07_Closure.swift:55
     */
    func plusGlobal(_ i: Int) -> Int {
        g_num += i
        return g_num
    }
    return plusGlobal
}

func getFn_class() -> Fn {
    /*
     生成 Person 对象，没有生成闭包
     第 0 - 8 个字节: 类型信息
     第 8 - 16 个字节: 引用计数
     第 16 - 24 个字节: store property age = 13
     
     返回的地址：LSwiftApp`partial apply forwarder for plusAge1(Swift.Int) -> Swift.Int at <compiler-generated>
     Person 对象在 x1 返回
     */
    let person1 = Person()
    person1.age = 13
    func plusAge1(_ i: Int) -> Int {
        person1.age += i
        return person1.age
    }
    return plusAge1
}

func getFn_twoClass() -> Fn {
    /*
     生成的闭包地址：
     第 0 - 8 个字节: 类型信息
     第 8 - 16 个字节: 引用计数
     第 16 - 24 个字节: 捕获的类对象 person1
     第 24 - 32 个字节: 捕获的类对象 person2
     
     返回的地址：
     LSwiftApp`partial apply forwarder for plusAge2(Swift.Int) -> Swift.Int at <compiler-generated>
     闭包在 x1 返回
     */
    let person1 = Person()
    person1.age = 14
    let person2 = Person()
    person2.age = 15
    func plusAge2(_ i: Int) -> Int {
        person1.age += i
        person2.age += i
        return person1.age + person2.age
    }
    return plusAge2
}

func getFn_TwoNum() -> (Fn_Int_IntInt) {
    /*
     生成的闭包地址：
     第 0 - 8 个字节: 类型信息
     第 8 - 16 个字节: 引用计数
     第 16 - 24 个字节: 堆对象，对象本身占用 24 字节，第 16 - 24 字节存储 16
     第 24 - 32 个字节: 堆对象，对象本身占用 24 字节，第 16 - 24 字节存储 17
     
     返回的地址：
     LSwiftApp`partial apply forwarder for plus2(Swift.Int) -> (Swift.Int, Swift.Int) at <compiler-generated>
     */
    var num1 = 16
    var num2 = 17
    func plus2(_ i: Int) -> (Int, Int) {
        num1 += i
        num2 += i << 1
        return (num1, num2)
    }
    return plus2
}

func closureTest() {
    // 练习 1: 普通函数赋值
    /*
     fnSum 变量本身 16 个字节
     第 0 - 8 个字节: sum 的代码段地址
     第 8 - 16 个字节: 堆地址假设为 x
     
     x 对象本身 24 个字节
     第 0 - 16 个字节应该是 meta class 和引用计数信息（不确定）
     第 16 - 24 个字节: sum 的代码段地址
     */
//    func sum(_ v1: Int, _ v2: Int) -> Int { v1 + v2 }
//    let fnSum = sum
//    var x = MemoryLayout.stride(ofValue: fnSum)
//    x += 1
    /*
     调用是直接跳转代码段地址执行:
     0x10489fed4 <+156>: mov    w8, #0x15
     0x10489fed8 <+160>: mov    x0, x8
     0x10489fedc <+164>: mov    w8, #0x16
     0x10489fee0 <+168>: mov    x1, x8
     0x10489fee4 <+172>: mov    x20, #0x0
 ->  0x10489fee8 <+176>: bl     0x10489ff00               ; sum(Swift.Int, Swift.Int) -> Swift.Int at L07_Closure.swift:88
     */
//    fnSum(21, 22)
    
    // 练习 2: 普通的闭包
//    let fn = getFn_normal()
    /*
     调用是在获取 fn 的代码段地址、传参 23、闭包的地址后，跳转到 fn 的代码段地址执行
     */
//    fn(23)
    
    // 练习 3: 没有捕获外部变量
    /*
     没有生成闭包，只需要获取 fn 的代码段地址、传参 24，跳转到 fn 的代码段地址执行
     */
//    let fn = getFn_noCapture()
//    fn(24)

    // 练习 4: 捕获的是全局变量
//    let fn = getFn_global()
    /*
     没有生成闭包，只需要获取 fn 的代码段地址、传参 25，跳转到 fn 的代码段地址执行
     */
//    fn(25)
    
    // 练习 5: 捕获的类对象
//    let fn = getFn_class()
    /*
     调用是在获取 fn 的代码段地址、传参 26、Person class 对象的地址后，跳转到 fn 的代码段地址执行
     */
//    fn(26)
    
    // 练习 6: 捕获两个类对象
//    let fn = getFn_twoClass()
    /*
     调用是在获取 fn 的代码段地址、传参 27、闭包的地址后，跳转到 fn 的代码段地址执行
     */
//    fn(27)
    
//    print(MemoryLayout.stride(ofValue: fn))
//    print(MemoryLayout.size(ofValue: fn))
//    print(MemoryLayout.alignment(ofValue: fn))
    
    // 联系 7: 捕获两个数据，作为结果返回
//    let fn2 = getFn_TwoNum()
    /*
     调用是在获取 fn 的代码段地址、传参 28、闭包的地址后，跳转到 fn 的代码段地址执行
     */
//    let (a, b) = fn2(28)
}
