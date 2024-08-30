//
//  ManageFamilyTableViewCell.swift
//  Monami
//
//  Created by Callsoft on 26/09/18.
//  Copyright © 2018 mobulous. All rights reserved.
//

import UIKit

class ManageFamilyTableViewCell: UITableViewCell {
    
    //MARK: - Outlet
    
    
    @IBOutlet weak var btnDeleteRef: UIButton!
    
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAccessType: UILabel!
    @IBOutlet weak var actSwiftch: UISwitch!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
