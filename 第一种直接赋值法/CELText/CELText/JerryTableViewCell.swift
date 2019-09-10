//
//  JerryTableViewCell.swift
//  CELText
//
//  Created by 我演示 on 2019/8/4.
//  Copyright © 2019 我演示. All rights reserved.
//

import UIKit

public class JerryTableViewCell: UITableViewCell {

    var nameLabel:UILabel = UILabel()
    var tsLabel : UILabel = UILabel()
    var newPriceLabel: UILabel = UILabel()
    var UpLable: UILabel = UILabel()
    
    /// 计算属性
  var viewModel: PriceDataMdoel? {
        didSet{
            /// 空值校验
            guard let model = viewModel else {
                return
            }
            /// 赋值
            nameLabel.text = model.nameString
            tsLabel.text = model.tsString
            newPriceLabel.text = model.newPriceString
            UpLable.text = model.UpString
        }
    }
    
public    func cellWithTableView(tableView: UITableView) -> (UITableViewCell) {
    
    let string = "string"
    
    var cell = tableView.dequeueReusableCell(withIdentifier: string)
    if cell == nil {
        cell = JerryTableViewCell.init(style:.default, reuseIdentifier: string)
    }
    return cell ?? JerryTableViewCell()
    }
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
       super.init(style: style, reuseIdentifier: reuseIdentifier)
        nameLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        nameLabel.text = "道琼斯"
        nameLabel.textColor = .red
        nameLabel.backgroundColor = .gray
        self.contentView.addSubview(nameLabel)
        
        tsLabel.frame = CGRect(x: 0, y: 30, width: 100, height: 20)
        tsLabel.text = "00001"
        tsLabel.textColor = .red
       tsLabel.backgroundColor = .gray
        self.contentView.addSubview(tsLabel)
        
        newPriceLabel.frame = CGRect(x: 120, y: 10, width: 80, height: 20)
        newPriceLabel.text = "2745"
        newPriceLabel.textColor = .red
        newPriceLabel.backgroundColor = .gray
        self.contentView.addSubview(newPriceLabel)
        
        UpLable.frame = CGRect(x: 220, y:10, width: 100, height: 30)
        UpLable.text = "123"
        UpLable.textColor = .red
        UpLable.backgroundColor = .gray
        self.contentView.addSubview(UpLable)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
