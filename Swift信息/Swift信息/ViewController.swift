//
//  ViewController.swift
//  Swift信息
//
//  Created by 我演示 on 2019/10/14.
//  Copyright © 2019 Jerry-Fu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    /// 懒加载处理信息
    lazy var titleLabel :UILabel = {
        let label = UILabel.init()
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
  
//    SQLiteManger.shareInstance()
    
    }

    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let http = HttopsTools.init()
        http.requestData {
            
        }
        
        /**
         给闭包赋值
         {
         (参数) ->(返回值) in
         /// 代码块
         
         
         }
         */
        
        
        /**
         闭包赋值的写法二： 闭包的括号可以卸载{} 之前
         */
        
        let person = Person.init()
        
//        weak var  weakSelf = self
//
//        person.request { () -> () in
//
//
//        }
//

        /// 第二种加载方法
//        person.request { [weak self] () ->  () in
//        }
        
        
        
    }
    deinit {
        print("销毁对应的控制器")
    }

}

