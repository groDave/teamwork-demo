//
//  ProjectTableViewCell.swift
//  TeamworkDemo
//
//  Created by Dave Hannan on 09/10/2017.
//  Copyright © 2017 Gro. All rights reserved.
//

import UIKit
import SDWebImage

class ProjectTableViewCell: BaseTableViewCell {
    
    var didSetupConstraints = false

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    /** Views **/
    
    let thumbnailImageView : UIImageView =
    {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.clear
        imageView.layer.cornerRadius = 33
        imageView.layer.masksToBounds = true //puts the corner radius into effect
        return imageView
    }()
    
    /** Override BaseCell setupViews() **/
    
    override func setupViews()
    {
        self.backgroundColor = UIColor.clear
        addSubview(thumbnailImageView)
        addSubview(titleLabel)
    
        setNeedsUpdateConstraints()
    }
    
    override func updateConstraints()
    {
        if(!didSetupConstraints)
        {
            thumbnailImageView.snp.makeConstraints { (make) -> Void in
                make.height.equalTo(66)
                make.width.equalTo(66)
                make.left.equalTo(self.snp.left).offset(5)
                make.centerY.equalTo(self.snp.centerY)
            }
            
            titleLabel.snp.makeConstraints{ (make) -> Void in
                make.left.equalTo(thumbnailImageView.snp.right).offset(10)
                make.right.equalTo(self.snp.right).offset(-10)
                make.centerY.equalTo(thumbnailImageView.snp.centerY)
            }
            didSetupConstraints = true
        }
        
        super.updateConstraints()
    }
    
    
    var twProject : TWProject?
    {
        didSet{
            titleLabel.text = twProject?.name
            thumbnailImageView.sd_setImage(with: URL(string: (twProject?.logoUrl)!), placeholderImage: UIImage(named: "placeholder.png"))
        }
    }
    
    
    
}
