//
//  MyTableViewCell.swift
//  Swift-POP
//
//  Created by Chris Hu on 17/1/13.
//  Copyright © 2017年 icetime17. All rights reserved.
//

import UIKit


class MyTableViewCell: UITableViewCell {

    
    @IBOutlet weak var myImageView: UIImageView!
    
    @IBOutlet weak var myLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}


protocol ReusableView {
    
}

extension ReusableView where Self: UIView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}


protocol NibLoadable {
    
}

extension NibLoadable where Self: UIView {
    static var nibName: String {
        return String(describing: self)
    }
}


extension MyTableViewCell: ReusableView {

}

extension MyTableViewCell: NibLoadable {

}
