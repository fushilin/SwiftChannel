//
//  ShowViewController.swift
//  Swift信息
//
//  Created by 我演示 on 2019/10/14.
//  Copyright © 2019 Jerry-Fu. All rights reserved.
//

import UIKit

class ShowViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        /**
         数据库内容信息处理
         */
//        DBM_INSERT
        
    }
    
// Select name ,age from t_studelt
    /**
     
     /// 条件查询语句
     select name , age from t_student where age  > 25 ;
     
     /// 模糊查询内容 包含色彩功能
     
     select name , age from t_student where name like ''l%
     
     /// 两个条件处理的信息
     
     select name , age from t_student where name like ''l% or/and age >= 25
     
     /// 6: 计算个数
     select count (*) from student
     
     ///7: 数据排序
     SELECT *FROM T_STUDENT  bye age ,name DESC
     
     //     8: 起名信息
     select t_student name from t students as s
     
     ///9:分页查询
     limit
     
     select name ,age from t_student limet 4 . 2 ; /// 跳过两条数据 默认四条数据
     
     ///10 :
     
     select name ,age from t_student limet 5 ; /// 跳过0条数据 默认5条数据
     
     
     
     */


}
