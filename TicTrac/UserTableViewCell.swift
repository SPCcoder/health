//
//  UserTableViewCell.swift
//  TicTrac
//
//  Created by Sean on 06/12/2017.
//  Copyright © 2017 com.spcarlin. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    /*For bigger apps we might make a seperate XIB for a custom cell
     but we're just using the prototype cell in the storyboard table view to save time */
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        numberLabel.isHidden = true // we hide this and only show it once the cell is touched (not implemented)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
