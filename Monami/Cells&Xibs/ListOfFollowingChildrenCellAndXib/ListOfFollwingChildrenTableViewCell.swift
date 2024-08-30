//
//  ListOfFollwingChildrenTableViewCell.swift
//  Monami
//
//  Created by abc on 25/09/18.
//  Copyright © 2018 mobulous. All rights reserved.
//

import UIKit

class ListOfFollwingChildrenTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var lblChildCUID: UILabel!
    @IBOutlet weak var lblChild_name: UILabel!
    @IBOutlet weak var img_view_child: UIImageView!
    
    @IBOutlet weak var btnUnfollowRef: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
