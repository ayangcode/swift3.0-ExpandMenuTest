//
//  YExtension.swift
//  test
//
//  Created by smile on 2017/3/20.
//  Copyright © 2017年 ayang. All rights reserved.
//

import Foundation
import UIKit

// MARK:- | ****** Int扩展 ****** |
extension Int {
    /**
     * Int 转换为 OC的CGFloat
     */
    func toCGFloat() -> CGFloat {
        return CGFloat(self)
    }
    /**
     * Int -> Float
     */
    func toFloat() -> Float {
        return Float(self)
    }
}
// MARK:- | ****** Float扩展 ****** |
extension Float {
    /**
     * Float 转换为 OC的CGFloat
     */
    func toCGFloat() -> CGFloat {
        return CGFloat(self)
    }
}



