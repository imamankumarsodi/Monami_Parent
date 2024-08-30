//
//  CommentsTableViewCell.swift
//  Monami
//
//  Created by abc on 25/09/18.
//  Copyright © 2018 mobulous. All rights reserved.
//

import UIKit

class CommentsTableViewCell: UITableViewCell {
    
    
    //MARK: - Outlets
    @IBOutlet weak var btnDeleteRef: UIButton!
    @IBOutlet weak var btnEditCommentRef: UIButton!
    @IBOutlet weak var lblCommnet: UILabel!
    
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
