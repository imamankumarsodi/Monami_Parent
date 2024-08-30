//
//  ReportMenuCell.swift
//  Monami
//
//  Created by abc on 10/01/19.
//  Copyright © 2019 mobulous. All rights reserved.
//

import UIKit

class ReportMenuCell: UITableViewCell {
    @IBOutlet weak var lblBreakfast: UILabel!
    @IBOutlet weak var imgViewBreakfast: UIImageView!
    @IBOutlet weak var lblAfternoonLunch: UILabel!
    @IBOutlet weak var imgViewLunch: UIImageView!
    @IBOutlet weak var lblSnacks: UILabel!
    @IBOutlet weak var imgViewSnacks: UIImageView!
    
    //For Localization static Labels
    @IBOutlet weak var lbl_Break_Static: UILabel!
    @IBOutlet weak var lbl_Lunch_Static: UILabel!
    @IBOutlet weak var lbl_Snack_Static: UILabel!
    @IBOutlet weak var lblHeader: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
