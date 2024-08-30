//
//  NotificationCell&Xib.swift
//  Monami
//
//  Created by abc on 24/09/18.
//  Copyright © 2018 mobulous. All rights reserved.
//

import UIKit

class NotificationCellAndXib: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var imgViewNotification: UIImageView!
    @IBOutlet weak var lblNotification: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
