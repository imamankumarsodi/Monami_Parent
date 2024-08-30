//
//  SettingsTableViewCell.swift
//  Monami
//
//  Created by Callsoft on 26/09/18.
//  Copyright © 2018 mobulous. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

    @IBOutlet weak var lblSettings: UILabel!
    @IBOutlet weak var imgDropDowns: UIImageView!
    @IBOutlet weak var btnSwitch: UISwitch!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
