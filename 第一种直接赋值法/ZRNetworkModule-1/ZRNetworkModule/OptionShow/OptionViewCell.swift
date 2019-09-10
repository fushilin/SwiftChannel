//
//  OptionViewCell.swift
//  ZRNetworkModule
//
//  Created by 1230 on 2019/7/31.
//  Copyright © 2019 lam. All rights reserved.
//

import UIKit



public class OptionViewCell: UITableViewCell {

    var label:UILabel!
    var selectBtn: UIButton!
    var model: OptionData!
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        self.model = model
        setUpUI()
    }
    func setUpUI(){
        
        label = UILabel.init(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        label.text = model?.name
        label.textAlignment = .center
        label.textColor = .black
        self.addSubview(label)
        
        
        ///添加按钮，改变事件
        selectBtn = UIButton.init(frame: CGRect(x: 200, y: 0, width: 100, height: 44))
        selectBtn.backgroundColor = .gray
     
        selectBtn.setTitleColor(.red, for: UIControl.State.normal)
        selectBtn.addTarget(self, action: #selector(pressBtn(button:)), for:UIControl.Event.touchUpInside)
        
        self.addSubview(selectBtn)
    }
    func setValuesModel(model: OptionData){
        label.text = model.name
        
        if model.option == false {
               selectBtn.setTitle("添加", for: UIControl.State.normal)
        }else{
            selectBtn.setTitle("已添加", for: UIControl.State.normal)
        }
        
        
        
    }
    @objc func  pressBtn(button:UIButton){
   
      
        if self.model.option == false {
            selectBtn.setTitle("已添加", for: UIControl.State.normal)
//                   OptionModelPlist.default.add(model)
            /// 读取数据库，看是不是已经存在，如果已经存在，删除数据库中的这部分数据
        }else{
            selectBtn.setTitle("添加", for: UIControl.State.normal)
            //   OptionModelPlist.default.remove(model)
            /// 把这部分数据写入数据库
        }

         self.model!.option = !self.model!.option
       self.creatFilePlist(model: self.model )
  }
    
 
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension OptionViewCell {
    public static let didDBChangeNotion: Notification.Name = Notification.Name("didDBChangeNotion")
    func   creatFilePlist(model: OptionData){
        
  
//        NotificationCenter.default.post(name: OptionViewCell.didDBChangeNotion, object: self, userInfo: ["userInfo": model])
        print(model.option)
    }
    
}
