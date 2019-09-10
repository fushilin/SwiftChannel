//
//  JerryTextTableViewCell.swift
//  moyo-ceshi-01
//
//  Created by 我演示 on 2019/7/9.
//  Copyright © 2019 世霖mac. All rights reserved.
//

import UIKit
import SnapKit

class JerryTextTableViewCell: UITableViewCell {
    var icon = UIImageView()
    var nameLabel = UILabel()
    
    
    
public class  func cellWithTableView(tableView: UITableView) -> JerryTextTableViewCell{
    
    
    let reuseIdentifier = "string"
    var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
    
    if (cell == nil){
        
        cell = JerryTextTableViewCell(style: .default, reuseIdentifier: reuseIdentifier)
    }
    
    return cell as! JerryTextTableViewCell
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let label = UILabel()
        label.textColor = UIColor.red
        label.text = "hahaha"
//        label.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        
        self.contentView.addSubview(label)
        
        nameLabel = label
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func layoutSubviews() {
//        nameLabel
//        nameLabel.
        super.layoutSubviews()
   
        
//        box.snp
        nameLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(self.contentView.snp.left).offset(100)
            make.width.equalTo(100)
            make.top.equalTo(self.contentView.snp.top)
            make.height.equalTo(50)
            
        }
        
        
    }
}
