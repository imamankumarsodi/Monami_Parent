//
//  AboutTermsConditionVC.swift
//  Monami
//
//  Created by abc on 10/12/18.
//  Copyright © 2018 mobulous. All rights reserved.
//

import UIKit

class AboutTermsConditionVC: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var txtViewContents: UITextView!
    @IBOutlet weak var lblTitle: UILabel!
    //MARK: - Variables
    var isComing = ""
    let macroObj = MacrosForAll.sharedInstanceMacro
    let alamoFireObj = AlamofireWrapper.sharedInstance
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetUp()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Actions
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
//MARK: - Extension Methods
extension AboutTermsConditionVC{
    func initialSetUp(){
        if isComing == "ABOUT"{
            lblTitle.text = "About".localized()
        }
    }
}

//MARK: - Extension Web services
extension AboutTermsConditionVC{
    
    
}

