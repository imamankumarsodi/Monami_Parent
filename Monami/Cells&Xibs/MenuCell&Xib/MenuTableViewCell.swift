//
//  MenuTableViewCell.swift
//  Monami
//
//  Created by abc on 26/09/18.
//  Copyright © 2018 mobulous. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var lblBreakfast: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblAfternoonLunch: UILabel!
    @IBOutlet weak var lblSnacks: UILabel!
    
    
    //For Localization static Labels
    @IBOutlet weak var lbl_Break_Static: UILabel!
    @IBOutlet weak var lbl_Lunch_Static: UILabel!
    @IBOutlet weak var lbl_Snack_Static: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
