//
//  L07_Closure.swift
//  LSwiftApp
//
//  Created by Jymn_Chen on 2022/6/9.
//

import Foundation

var g_num = 30

typealias Fn = (Int) -> Int
func getFn() -> Fn {
    var num = 20
    func plus(_ i: Int) -> Int {
        num += i
        return num
        
//        g_num += i
//        return g_num
    }
    return plus
} // 返回的 plus 和 num 形成了闭包

func closureTest() {
    let fn = getFn()
    let x = fn(100) + 40
    print(x)
}
