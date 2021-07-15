//
//  CustomOperatorViewController.swift
//  SLProjectModuleComm
//
//  Created by 孙梁 on 2021/7/9.
//

import UIKit

class CustomOperatorViewController: BaseViewController {

}

// MARK: - LifeCyle
extension CustomOperatorViewController {
    override func setMasterView() {
        super.setMasterView()
        title = SLLocalText.discover_customOperator.text
    }
}

/**
 prefix: 运算符在运算值的前方； postfix：运算符在运算值的后方；infix：运算符在运算值之间
 */

/// 返回2的n次方
prefix operator ^
prefix func ^ (vector: Double) -> Double {
    pow(2, vector)
}

/// 返回n的2次方
postfix operator ^-
postfix func ^- (vector: Int) -> Int {
    vector * vector
}

/// 定义优先级组
precedencegroup MinePrecedence {
//    lowerThan: AdditionPrecedence // 优先级, 比加法运算低
    higherThan: AdditionPrecedence // 优先级,比加法运算高
    associativity: left // 结合方向:left, right or none
    assignment: false // true=赋值运算符,false=非赋值运算符
}

infix operator ^^: MinePrecedence // 继承 MyPrecedence 优先级组
// infix operator ^^: AdditionPrecedence // 也可以直接继承加法优先级组(AdditionPrecedence)或其他优先级组
func ^^ (left: Int, right: Int) -> Int {
    left + right * 2
}

/// 重载操作符
struct Vector2D {
    var x = 0.0
    var y = 0.0
}
func + (left: Vector2D, right: Vector2D) -> Vector2D {
    Vector2D(x: left.x + right.x, y: left.y + right.y)
}
