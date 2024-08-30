//
//  ChatListTableViewCell.swift
//  Monami
//
//  Created by abc on 12/10/18.
//  Copyright © 2018 mobulous. All rights reserved.
//

import UIKit

class ChatListTableViewCell: UITableViewCell {
    
     // MARK: - Outlets
    
    @IBOutlet weak var lblMessageBody: UILabel!
    @IBOutlet weak var lblTimeStamp: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgViewProfile: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
