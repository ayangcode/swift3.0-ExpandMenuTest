//
//  YExpendMenu.swift
//  test2
//
//  Created by smile on 2017/3/20.
//  Copyright © 2017年 ayang. All rights reserved.
//

import UIKit

enum ExpandDirection:Int {
    case left = 0
    case right
    case up
    case down
}

class YExpendMenu: UIView {
    // MARK:- | ****** 参数列表 ****** |
    
    private var expandedDrection:ExpandDirection!
    /**
     * 动画时长
     */
    private var animationDuration:TimeInterval!
    /**
     * 间隔
     */
    private var itemMargin:CGFloat!
    /**
     * 控件数组
     */
    private var itemArr:NSArray!
    /**
     * 菜单键
     */
    private var menuItem:UIButton!
    /**
     * 起始位置
     */
    private var originFrame:CGRect!
    /**
     * 存个item的宽
     */
    private var subItemWidth:CGFloat!
    /**
     * 是否展开
     */
    private var isExpand:Bool = false {
        willSet {
            self.isExpand = newValue
        }
    }
    

    // MARK:- | ****** 其他方法 ****** |

    /**
     * 当方向为 左/右 时,计算总宽度
     */
    private func expandedMenuTotalWidth() -> CGFloat {
        var totalWidth:CGFloat = 0
        for item in self.itemArr {
            totalWidth += (item as! UIButton).frame.size.width + self.itemMargin
            self.subItemWidth = (item as! UIButton).frame.size.width
        }
        return totalWidth
    }
    /**
     * 当方向为 上/下 时，计算总高度
     */
    private func expandedMenuTotalHeight() -> CGFloat {
        var totalHeight:CGFloat = 0
        for item in self.itemArr {
            totalHeight += (item as! UIButton).frame.size.height + self.itemMargin
            self.subItemWidth = (item as! UIButton).frame.size.height
        }
        return totalHeight
    }
    /**
     * 计算各个方向展开时的frame
     UIViewAutoresizingNone就是不自动调整。
     UIViewAutoresizingFlexibleLeftMargin 自动调整与superView左边的距离，保证与superView右边的距离不变。
     UIViewAutoresizingFlexibleRightMargin 自动调整与superView的右边距离，保证与superView左边的距离不变。
     UIViewAutoresizingFlexibleTopMargin 自动调整与superView顶部的距离，保证与superView底部的距离不变。
     UIViewAutoresizingFlexibleBottomMargin 自动调整与superView底部的距离，也就是说，与superView顶部的距离不变。
     UIViewAutoresizingFlexibleWidth 自动调整自己的宽度，保证与superView左边和右边的距离不变。
     UIViewAutoresizingFlexibleHeight 自动调整自己的高度，保证与superView顶部和底部的距离不变。
     UIViewAutoresizingFlexibleLeftMargin  |UIViewAutoresizingFlexibleRightMargin 自动调整与superView左边的距离，保证与左边的距离和右边的距离和原来距左边和右边的距离的比例不变。比如原来距离为20，30，调整后的距离应为68，102，即68/20=102/30。
     */
    private func prepareStatusForExpanded() -> Void {
        let totalWidth = expandedMenuTotalWidth()
        let totalHeight = expandedMenuTotalHeight()
        for item in self.itemArr {
            let button:UIButton = item as! UIButton
            button.isHidden = true
            self.addSubview(button)
        }
        self.bringSubview(toFront: menuItem) // 放在最前面
        let bufferAnimationDuration = 0.1
        
        switch (self.expandedDrection!) {
        case .left:
            self.menuItem.autoresizingMask = .flexibleLeftMargin                // 左边距自适应(固定开关按钮的位置)
            UIView.animate(withDuration: bufferAnimationDuration, animations: {
                var frame = self.frame
                frame.origin.x -= totalWidth
                frame.size.width += totalWidth
                self.frame = frame
            })
        case .right:
            self.menuItem.autoresizingMask = .flexibleRightMargin               // 右边距自适应
            UIView.animate(withDuration: bufferAnimationDuration, animations: {
                var frame = self.frame
                frame.size.width += totalWidth
                self.frame = frame
            })
        case .up:
            self.menuItem.autoresizingMask = .flexibleTopMargin                 // 上边距自适应
            UIView.animate(withDuration: bufferAnimationDuration, animations: {
                var frame = self.frame
                frame.origin.y -= totalHeight
                frame.size.height += totalHeight
                self.frame = frame
            })
        case .down:
            self.menuItem.autoresizingMask = .flexibleBottomMargin              // 底边距自适应
            UIView.animate(withDuration: bufferAnimationDuration, animations: {
                var frame = self.frame
                frame.size.height += totalHeight
                self.frame = frame
            })
        }
    }

    /**
     * 回到初始的frame
     */
    private func originWhenMenuClose() -> Void {
        UIView.animate(withDuration: 0.1) {
            self.frame = self.originFrame
        }
    }
    
    // MARK:- | ****** 展开 / 收起 ****** |
    func menuItemTaped(sender:UIButton) -> Void {
        isExpand == false ? showMenu() : closeMenu()
    }
    
    /**
     * 展开
     */
    private func showMenu() -> Void {
        self.isUserInteractionEnabled = false
        prepareStatusForExpanded()
        UIView.animate(withDuration: self.animationDuration, animations: { 
            self.menuItem.layer.setAffineTransform(CGAffineTransform.init(rotationAngle: CGFloat(M_PI_4)))
        })
        CATransaction.begin()
        CATransaction.setAnimationDuration(self.animationDuration)
        CATransaction.setCompletionBlock {
            for item in self.itemArr {
                let button = item as! UIButton
                button.transform = CGAffineTransform.identity
            }
            self.isUserInteractionEnabled = true
            self.isExpand = true
        }
        for (index,item) in self.itemArr.enumerated() {
            let button = item as! UIButton
            button.isHidden = false
            
            var startPosition = CGPoint.zero
            var endPosition = CGPoint.zero
            let subBtnWidth = self.subItemWidth!                    // 子按钮宽、高
            let margin = self.itemMargin!                           // 间距
            let menuItemWidth = self.menuItem.frame.size.width      // 开关按钮宽、高
            let menuWidth = self.frame.size.width                   // 菜单宽
            let menuHeight = self.frame.size.height                 // 菜单高
            let i = CGFloat(index)
            print(menuWidth,menuHeight)
            switch (self.expandedDrection!) {
            case .left:
                startPosition = CGPoint(x: menuWidth - menuItemWidth, y: menuHeight / 2)
                endPosition = CGPoint(x: subBtnWidth / 2 + (subBtnWidth + margin) * i, y: menuHeight / 2)
            case .right:
                startPosition = CGPoint(x: menuItemWidth, y: menuHeight / 2)
                endPosition = CGPoint(x: (menuWidth - subItemWidth / 2) - (subItemWidth + margin) * i, y: self.frame.size.height / 2)
            case .up:
                startPosition = CGPoint(x: menuWidth / 2, y: menuHeight - menuItemWidth)
                endPosition = CGPoint(x: menuWidth / 2, y: (subBtnWidth / 2) + (subBtnWidth + margin) * i)
               
            case .down:
                startPosition = CGPoint(x: menuWidth / 2, y: menuItemWidth)
                endPosition = CGPoint(x: menuWidth / 2, y: menuHeight - (subBtnWidth / 2 + (subBtnWidth + margin) * i ))
            }
            let posAnimation = CABasicAnimation(keyPath: "position")
            posAnimation.fromValue = startPosition
            posAnimation.toValue   = endPosition
            let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
            scaleAnimation.fromValue = 0.01
            scaleAnimation.toValue = 1
            let group = CAAnimationGroup()
            group.isRemovedOnCompletion = false
            group.animations = [posAnimation,scaleAnimation]
            group.fillMode = kCAFillModeForwards
            group.beginTime = CACurrentMediaTime() + self.animationDuration / TimeInterval(self.itemArr.count)  * Double(i)
            group.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
            group.duration  = self.animationDuration
            button.layer.add(group, forKey: "expandGroupAnim")
            button.layer.position = endPosition // 记录展开后的位置
            button.transform = CGAffineTransform.init(scaleX: 0.01, y: 0.01)
        }
        CATransaction.commit()
    }
    
    /**
     * 收起
     */
    private func closeMenu() -> Void {
        self.isUserInteractionEnabled = false
        UIView.animate(withDuration: self.animationDuration, animations: {
            self.menuItem.transform = CGAffineTransform.identity
        })
        CATransaction.begin()
        CATransaction.setAnimationDuration(self.animationDuration)
        CATransaction.setCompletionBlock { 
            for item in self.itemArr {
                let button = item as! UIButton
                button.transform = CGAffineTransform.identity
                button.isHidden = true
            }
            self.originWhenMenuClose()
            self.isExpand = false
            self.isUserInteractionEnabled = true
        }
        
        for (index,item) in self.itemArr.enumerated() {
            let button = item as! UIButton
            
            let menuItemWidth = self.menuItem.frame.size.width      // 开关按钮宽、高
            let menuWidth = self.frame.size.width                   // 菜单宽
            let menuHeight = self.frame.size.height                 // 菜单高
            let i = index
            
            let startPosition = button.layer.position               // 展开时给定了一个point
            var endPosition = CGPoint.zero
            
            switch (self.expandedDrection!) {
            case .left:
                endPosition = CGPoint(x: menuWidth - menuItemWidth / 2, y: menuHeight / 2)
            case .right:
                endPosition = CGPoint(x: menuItemWidth / 2, y: menuHeight / 2)
            case .up:
                endPosition = CGPoint(x: menuWidth / 2, y: menuHeight - menuItemWidth / 2)
            case .down:
                endPosition = CGPoint(x: menuWidth / 2, y: menuItemWidth / 2)
            }
            
            let posAnimation = CABasicAnimation(keyPath: "position")
            posAnimation.fromValue = startPosition
            posAnimation.toValue   = endPosition
            let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
            scaleAnimation.fromValue = 1
            scaleAnimation.toValue = 0.01
            let group = CAAnimationGroup()
            group.isRemovedOnCompletion = false
            group.animations = [posAnimation,scaleAnimation]
            group.fillMode = kCAFillModeForwards
            group.beginTime = CACurrentMediaTime() + self.animationDuration / TimeInterval(self.itemArr.count)  * Double(self.itemArr.count - i)
            group.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            group.duration  = self.animationDuration
            button.layer.add(group, forKey: "closeGroupAnim")
            button.layer.position = startPosition
            button.transform = CGAffineTransform.init(scaleX: 1, y: 1)
        }
        CATransaction.commit()
    }
    
    
    // MARK:- | ****** 初始化 ****** |
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    /// 菜单初始值(初始化后可重新赋值)
    ///
    /// - Parameters:
    ///   - frame: 一个按钮的Frame
    ///   - menuItem: 菜单按钮
    ///   - direction: 展开方向
    ///   - animateDuration: 动画时长
    ///   - items: 子按钮数组
    ///   - itemMargin: 间距
    init(frame: CGRect , direction : ExpandDirection , animateDuration:TimeInterval , items:NSArray , itemMargin:CGFloat) {
        super.init(frame: frame)
        
        /**
         * 配置参数
         */
        let menuBtn = UIButton(type: .custom)
        let scaleSize:CGFloat = 0.6
        menuBtn.frame = CGRect(x: frame.size.width / 2 - (frame.size.width * scaleSize) / 2, y: frame.size.height / 2 - (frame.size.height * scaleSize) / 2, width: frame.size.width * scaleSize, height: frame.size.height * scaleSize)
        menuBtn.setImage(#imageLiteral(resourceName: "menuItem.png"), for: .normal)
        menuBtn.backgroundColor = UIColor.purple
        menuBtn.layer.cornerRadius = menuBtn.frame.size.width / 2
        menuBtn.layer.masksToBounds = true
        self.addSubview(menuBtn)
        
        self.expandedDrection = direction               // 展开方向
        self.animationDuration = animateDuration        // 动画时长
        self.itemArr = items
        self.itemMargin = itemMargin
        self.originFrame = self.frame                   // 起始位置
        self.isExpand = false
        self.menuItem = menuBtn                         // 开关按钮
        self.menuItem.addTarget(self, action: #selector(YExpendMenu.menuItemTaped(sender:)), for: .touchUpInside)
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
