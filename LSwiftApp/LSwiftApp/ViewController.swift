//
//  ViewController.swift
//  LSwiftApp
//
//  Created by Jymn_Chen on 2022/5/27.
//
//  http://wjhsh.net/guohai-stronger-p-12368185.html

import UIKit

enum TestEnum {
    case test1(Int, Int, Int)
    case test2(Int, Int)
    case test3(Int)
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        logEnumMemoryLayout()
        
//        let t = TestEnum.test1(1, 2, 3)
//        let t = TestEnum.test2(4, 5)
//        let t = TestEnum.test3(6)
//        switchCaseAsm(t)
        
//        printStructAndClassMemoryLayout()
    }
    
    func printStructAndClassMemoryLayout() -> Void {
        struct Point {
            var x: Int
            var b1: Bool
            var b2: Bool
            var y: Int
        }
        var p = Point(x: 10, b1: true, b2: true, y: 20)
        print("** struct **")
        print("stride = \(MemoryLayout<Point>.stride), size = \(MemoryLayout<Point>.size), align = \(MemoryLayout<Point>.alignment)")
        print("memory = \(Mems.memStr(ofVal: &p, alignment: .eight))")
        
        class Size {
            var width: Int
            var b1: Bool
            var b2: Bool
            var height: Int
            init(width: Int, b1: Bool, b2: Bool, height: Int) {
                self.width = width
                self.b1 = b1
                self.b2 = b2
                self.height = height
            }
        }
        var s = Size(width: 10, b1: true, b2: true, height: 20)
        print("** Class **")
        print("stride = \(MemoryLayout<Size>.stride), size = \(MemoryLayout<Size>.size), align = \(MemoryLayout<Size>.alignment)")
        print("ptr memory = \(Mems.memStr(ofVal: &s, alignment: .eight))")
        print("obj memory = \(Mems.memStr(ofRef: s, alignment: .eight))")
        print("ptr size = \(Mems.size(ofVal: &s))")
        print("obj malloc size = \(Mems.size(ofRef: s))") // malloc 按 16 字节对齐
        print("instance size = \(class_getInstanceSize(Size.self))") // 内存对齐规则按 8 字节对齐
        print("instance size = \(class_getInstanceSize(type(of: s)))")
    }
    
    func switchCaseAsm(_ t: TestEnum) -> Void {
        switch t {
        case .test1(let tmp1, let tmp2, let tmp3):
            print1(tmp1, tmp2, tmp3)
        case .test2(let tmp1, let tmp2):
            print2(tmp1, tmp2)
        case .test3(let tmp1):
            print3(tmp1)
        }
    }
    
    func print1(_ tmp1: Int, _ tmp2: Int, _ tmp3: Int) -> Void {
        print(tmp1, tmp2, tmp3)
    }
    func print2(_ tmp1: Int, _ tmp2: Int) -> Void {
        print(tmp1, tmp2)
    }
    func print3(_ tmp1: Int) -> Void {
        print(tmp1)
    }
    
    func logEnumMemoryLayout() -> Void {
        // enum1
        enum TestEnum {
            case test1(Int, Int, Int)
            case test2(Int, Int)
            case test3(Int)
            case test4(Bool)
            case test5
        }
        var t1 = TestEnum.test1(1, 2, 3)
        print(Mems.ptr(ofVal: &t1)) // 0x000000016d6fbdd8 -> 00 && 3 && 2 && 1
        var t2 = TestEnum.test2(4, 5)
        print(Mems.ptr(ofVal: &t2)) // 0x000000016d6fbdb8 -> 01 && 5 && 4 && 0
        var t3 = TestEnum.test3(6)
        print(Mems.ptr(ofVal: &t3)) // 0x000000016d6fbd98 -> 02 && 0 && 0 && 6
        var t4 = TestEnum.test4(true)
        print(Mems.ptr(ofVal: &t4)) // 0x000000016d6fbd78 -> 03 && 0 && 0 && 1
        var t5 = TestEnum.test5
        print(Mems.ptr(ofVal: &t5)) // 0x000000016d6fbd58 -> 04 && 0 && 0 && 0
        print(Mems.memStr(ofVal: &t1, alignment: MemAlign.eight))
        print(Mems.memStr(ofVal: &t2, alignment: MemAlign.eight))
        print(Mems.memStr(ofVal: &t3, alignment: MemAlign.eight))
        print(Mems.memStr(ofVal: &t4, alignment: MemAlign.eight))
        print(Mems.memStr(ofVal: &t5, alignment: MemAlign.eight))
        // stride 32, size 25, align 8
        // flags[1] && Int[8] && Int[8] && Int[8] or Bool[8]
        
        /*
        // enum2
        enum TestEnum {
            case test1
            case test2
            case test3
            case test4(Int)
            case test5(Int, Int)
            case test6(Int, Int, Int, Bool)
        }
        var t1 = TestEnum.test1
        print(Mems.ptr(ofVal: &t1)) // 0x000000016d4b3dd8 -> C0 && 0 && 0 && 0
        var t2 = TestEnum.test2
        print(Mems.ptr(ofVal: &t2)) // 0x000000016d4b3db8 -> C0 && 0 && 0 && 1
        var t3 = TestEnum.test3
        print(Mems.ptr(ofVal: &t3)) // 0x000000016d4b3d98 -> C0 && 0 && 0 && 2
        var t4 = TestEnum.test4(1)
        print(Mems.ptr(ofVal: &t4)) // 0x000000016d4b3d78 -> 00 && 0 && 0 && 1
        var t5 = TestEnum.test5(2, 3)
        print(Mems.ptr(ofVal: &t5)) // 0x000000016d4b3d58 -> 40 && 0 && 3 && 2
        var t6 = TestEnum.test6(4, 5, 6, true)
        print(Mems.ptr(ofVal: &t6)) // 0x000000016d4b3d38 -> 81 && 6 && 5 && 4
        // stride 32, size 25, align 8
        // flags-Bool[1] && Int[8] && Int[8] && Int[8]
         */
        
        /*
        // enum3
        enum TestEnum {
            case test1
            case test2
            case test3
            case test4(Int)
            case test5(Int, Int)
            case test6(Int, Int, Bool, Int)
        }
        var t1 = TestEnum.test1
        print(Mems.ptr(ofVal: &t1)) // 0x000000016f34fdd8 -> 00 && C0...00 && 0 && 0
        var t2 = TestEnum.test2
        print(Mems.ptr(ofVal: &t2)) // 0x000000016f34fdb8 -> 00 && C0...00 && 0 && 1
        var t3 = TestEnum.test3
        print(Mems.ptr(ofVal: &t3)) // 0x000000016f34fd98 -> 00 && C0...00 && 0 && 2
        var t4 = TestEnum.test4(1)
        print(Mems.ptr(ofVal: &t4)) // 0x000000016f34fd78 -> 00 && 00...00 && 0 && 1
        var t5 = TestEnum.test5(2, 3)
        print(Mems.ptr(ofVal: &t5)) // 0x000000016f34fd58 -> 00 && 40...00 && 3 && 2
        var t6 = TestEnum.test6(4, 5, true, 6)
        print(Mems.ptr(ofVal: &t6)) // 0x000000016f34fd38 -> 06 && 80...01 && 5 && 4
        // stride = 32, size = 32, align = 8
        // Int[8] && flags-Bool[8] && Int[8] && Int[8]
         */
        
        /*
        // enum4
        enum TestEnum {
            case test1
            case test2
            case test3
            case test4(Int)
            case test5(Int, Int)
            case test6(Int, Bool, Int)
        }
        var t1 = TestEnum.test1
        print(Mems.ptr(ofVal: &t1)) // 0x000000016f34fdd8 -> 03 && 0 && 0 && 0
        var t2 = TestEnum.test2
        print(Mems.ptr(ofVal: &t2)) // 0x000000016f34fdb8 -> 03 && 0 && 0 && 1
        var t3 = TestEnum.test3
        print(Mems.ptr(ofVal: &t3)) // 0x000000016f34fd98 -> 03 && 0 && 0 && 2
        var t4 = TestEnum.test4(1)
        print(Mems.ptr(ofVal: &t4)) // 0x000000016f34fd78 -> 00 && 0 && 0 && 1
        var t5 = TestEnum.test5(2, 3)
        print(Mems.ptr(ofVal: &t5)) // 0x000000016f34fd58 -> 01 && 0 && 3 && 2
        var t6 = TestEnum.test6(4, true, 5)
        print(Mems.ptr(ofVal: &t6)) // 0x000000016f34fd38 -> 02 && 5 && 1 && 4
        // stride = 32, size = 25, align = 8
        // flags[1] && Int[8] && Int[8] or Bool[8] && Int[8]
        // 注意：test5 是 2 个 Int 连续的，所以不能将右往左第 2 个 8 Bytes 做 flags-Bool, 至于为什么不将第 2 个 Int 放到第三个位置，从而将 flags 放到第 2 个位置，达到节约空间的目的，不理解
         */
        
        let stride = MemoryLayout<TestEnum>.stride
        let size = MemoryLayout<TestEnum>.size
        let alignment = MemoryLayout<TestEnum>.alignment
        print(stride, size, alignment)
        
        print("")
    }
}
