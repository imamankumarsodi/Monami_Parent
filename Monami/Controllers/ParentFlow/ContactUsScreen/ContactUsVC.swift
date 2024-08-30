//
//  ContactUsVC.swift
//  Monami
//
//  Created by abc on 19/12/18.
//  Copyright © 2018 mobulous. All rights reserved.
//

import UIKit

class ContactUsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    //MARK: - Actions
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

}
