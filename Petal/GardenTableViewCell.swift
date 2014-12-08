//
//  GardenTableViewCell.swift
//  Petal
//
//  Created by Jing Xiao on 12/7/14.
//  Copyright (c) 2014 Jing Xiao. All rights reserved.
//

import UIKit

class GardenTableViewCell: UITableViewCell {

    
    @IBOutlet var flowerButton: UIButton!
    @IBOutlet var friendName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
