//
//  ReportTableViewCell.swift
//  Monami
//
//  Created by abc on 26/09/18.
//  Copyright © 2018 mobulous. All rights reserved.
//

import UIKit

class ReportTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
     @IBOutlet weak var imgDoc: UIImageView!
    
    @IBOutlet weak var btnPdfRef: UIButton!
    @IBOutlet weak var btnViewRef: UIButton!
    
    @IBOutlet weak var lblTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
