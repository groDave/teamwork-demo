//
//  TaskTableViewCell.swift
//  TeamworkDemo
//
//  Created by Dave Hannan on 10/10/2017.
//  Copyright © 2017 Gro. All rights reserved.
//

import UIKit
import SDWebImage

class TaskTableViewCell: BaseTableViewCell {
    
    var didSetupConstraints = false

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    let createdDateLabel : UILabel =
    {
        let label = UILabel()
        label.text = "Created: "
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .left
        label.sizeToFit()
        label.backgroundColor = UIColor.clear
        return label
    }()
    
    let createdByLabel : UILabel =
    {
        let label = UILabel()
        label.text = "Created by: "
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .left
        label.sizeToFit()
        label.backgroundColor = UIColor.clear
        return label
    }()
    
    let creatorAvatar : UIImageView =
    {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.clear
        imageView.layer.cornerRadius = 11
        imageView.layer.masksToBounds = true //puts the corner radius into effect
        return imageView
    }()
    
    let creatorName : UILabel =
    {
        let label = UILabel()
        label.text = "User Name"
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .left
        label.sizeToFit()
        label.backgroundColor = UIColor.clear
        return label
    }()
    
    /** Override BaseCell setupViews() **/
    
    override func setupViews()
    {
        self.backgroundColor = UIColor.clear
        addSubview(titleLabel)
        addSubview(createdDateLabel)
        addSubview(createdByLabel)
        addSubview(creatorAvatar)
        addSubview(creatorName)
        
        setNeedsUpdateConstraints()
    }
    
    override func updateConstraints()
    {
        if(!didSetupConstraints)
        {
            
            titleLabel.snp.makeConstraints{ (make) -> Void in
                make.left.equalTo(self.snp.left).offset(10)
                make.right.equalTo(self.snp.right).offset(-10)
                make.top.equalTo(self.snp.top).offset(5)
            }
            
            createdDateLabel.snp.makeConstraints({ (make) in
                make.left.equalTo(self.snp.left).offset(10)
                make.right.equalTo(self.snp.right).offset(-10)
                make.top.equalTo(titleLabel.snp.bottom).offset(2)
            })
            
            createdByLabel.snp.makeConstraints({ (make) in
                make.left.equalTo(self.snp.left).offset(10)
                make.right.equalTo(self.snp.right).offset(-10)
                make.top.equalTo(createdDateLabel.snp.bottom).offset(2)
            })
            
            creatorAvatar.snp.makeConstraints({ (make) in
                make.left.equalTo(self.snp.left).offset(10)
                make.width.equalTo(22)
                make.height.equalTo(22)
                make.top.equalTo(createdByLabel.snp.bottom).offset(2)
            })
            
            creatorName.snp.makeConstraints({ (make) in
                make.left.equalTo(creatorAvatar.snp.right).offset(10)
                make.right.equalTo(self.snp.right).offset(-10)
                make.centerY.equalTo(creatorAvatar.snp.centerY)
            })
            
            
            didSetupConstraints = true
        }
        
        super.updateConstraints()
    }

    
    
    
    var task : TWTask?
    {
        didSet{
            titleLabel.text = task!.content
            
            let formattedDate = self.formatDate(date: task!.createdOn!)
            
            createdDateLabel.text = "Created : " + formattedDate
            creatorAvatar.sd_setImage(with: URL(string: task!.creatorImageURL!), placeholderImage: UIImage(named: "placeholder.png"))
            creatorName.text = task!.creatorName
        }
    }
    
    private func formatDate(date: String) -> (String){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let startTime = formatter.date(from: date)
        
        let formatterB = DateFormatter()
        formatterB.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let timeString = formatterB.string(from: startTime!)
        return timeString
    }

}
