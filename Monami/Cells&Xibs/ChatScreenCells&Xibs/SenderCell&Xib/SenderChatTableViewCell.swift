//
//  SenderChatTableViewCell.swift
//  Monami
//
//  Created by abc on 24/09/18.
//  Copyright © 2018 mobulous. All rights reserved.
//

import UIKit

class SenderChatTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var lblTimeStamp: UILabel!
    @IBOutlet weak var lblMessageBody: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
