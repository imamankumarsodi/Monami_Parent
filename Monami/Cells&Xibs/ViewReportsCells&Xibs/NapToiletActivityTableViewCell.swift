//
//  NapToiletActivityTableViewCell.swift
//  Monami
//
//  Created by abc on 10/01/19.
//  Copyright © 2019 mobulous. All rights reserved.
//

import UIKit

class NapToiletActivityTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblMeals: UILabel!
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var lblTopic: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
