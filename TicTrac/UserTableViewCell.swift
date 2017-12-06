//
//  UserTableViewCell.swift
//  TicTrac
//
//  Created by Apple on 06/12/2017.
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

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
