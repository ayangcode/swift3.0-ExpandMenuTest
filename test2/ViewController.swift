//
//  ViewController.swift
//  test2
//
//  Created by smile on 2017/3/20.
//  Copyright © 2017年 ayang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var menu:YExpendMenu!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let menu = YExpendMenu(frame: CGRect(x: self.view.frame.size.width - 60, y: 30, width: 40, height: 40), direction: .left, animateDuration: 0.2, items: configBtns(), itemMargin:8)
        menu.backgroundColor = UIColor.cyan
        self.view.addSubview(menu)
        
        let menu1 = YExpendMenu(frame: CGRect(x: 0, y: 90, width: 40, height: 40), direction: .right, animateDuration: 0.2, items: configBtns(), itemMargin:8)
        menu1.backgroundColor = UIColor.yellow
        
        self.view.addSubview(menu1)
        
        let menu2 = YExpendMenu(frame: CGRect(x: 0, y: self.view.frame.size.height - 40, width: 40, height: 40), direction: .up, animateDuration: 0.2, items: configBtns(), itemMargin:8)
        menu2.backgroundColor = UIColor.brown
        
        self.view.addSubview(menu2)
        
        let menu3 = YExpendMenu(frame: CGRect(x: self.view.frame.size.width - 60 , y: self.view.frame.size.height / 2 - 100, width: 40, height: 40), direction: .down, animateDuration: 0.2, items: configBtns(), itemMargin:8)
        menu3.backgroundColor = UIColor.green

        
        self.view.addSubview(menu3)
        
        
    }
    
    func configBtns() ->NSArray {
        let arr = NSMutableArray()
        for i in 0..<4 {
            let btn = UIButton(type: .system)
            btn.setTitle("\(i + 1)", for: .normal)
            btn.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            btn.backgroundColor = UIColor.darkText
            btn.layer.cornerRadius = btn.frame.size.width / 2
            btn.layer.masksToBounds = true
            btn.clipsToBounds = true
            btn.tag = 101 + i
            btn.addTarget(self, action: #selector(itemsTap(sender:)), for: .touchUpInside)
            btn.setTitleColor(UIColor.green, for: .normal)
            arr.add(btn)
        }
        return (arr as NSArray)
    }
    
    func itemsTap(sender:UIButton) -> Void {
        print("第\(sender.tag - 100)个item")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("点错了")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

