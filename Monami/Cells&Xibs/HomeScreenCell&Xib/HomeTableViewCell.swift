//
//  HomeTableViewCell.swift
//  Monami
//
//  Created by abc on 21/09/18.
//  Copyright © 2018 mobulous. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    
     // MARK: - Outlets
    
    @IBOutlet weak var lblDateTime: UILabel!
  //  @IBOutlet weak var btnPlayRef: UIButton!
  
    @IBOutlet weak var btnPlay: UIButton!
    
    
    @IBOutlet weak var imgViewPlay: UIImageView!
    @IBOutlet weak var img_view_child: UIImageView!
    @IBOutlet weak var lblDescription: UILabel!
    
    @IBOutlet weak var lblChild_name: UILabel!
    
    @IBOutlet weak var lblChildCUID: UILabel!
    @IBOutlet weak var btnImageRef: UIButton!
    
    @IBOutlet weak var btnProfileRef: UIButton!
    
    
    @IBOutlet weak var btnCommentRef: UIButton!
    
    @IBOutlet weak var btnShareRef: UIButton!
    
    @IBOutlet weak var image_Post: UIImageView!
    
    @IBOutlet weak var btnDeleteRef: UIButton!
    
    @IBOutlet weak var stackViewWidthConstraints: NSLayoutConstraint!
    
    @IBOutlet weak var btnDownloadRef: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
