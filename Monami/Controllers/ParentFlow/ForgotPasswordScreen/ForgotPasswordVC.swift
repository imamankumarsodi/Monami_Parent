//
//  ForgotPasswordVC.swift
//  Monami
//
//  Created by abc on 21/09/18.
//  Copyright © 2018 mobulous. All rights reserved.
//

import UIKit

class ForgotPasswordVC: UIViewController {
    

    // MARK: - Outlets
    
    @IBOutlet weak var txtFieldEmail: UITextField!
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var viewRoundBottomCorner: UIView!
    
    /////////////////////////////////////////////////////
    
    // MARK: - Global variables
    let macroObj = MacrosForAll.sharedInstanceMacro
    let alamoFireObj = AlamofireWrapper.sharedInstance
    let validation:Validation = Validation.validationManager() as! Validation
    /////////////////////////////////////////////////////
    
    // MARK:- View life cycle methods
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initailSetUp()

        // Do any additional setup after loading the view.
    }

    /////////////////////////////////////////////////////
    
    // MARK: - Methods
    
    // TODO: Initial Setup
    
    func initailSetUp(){
        
    viewRoundBottomCorner.layer.cornerRadius = (viewBackground.frame.height - viewRoundBottomCorner.frame.height)/2 - 46
        if #available(iOS 11.0, *) {
            viewRoundBottomCorner.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } else {
            // Fallback on earlier versions
        }
        
    }
    
  
    

    /////////////////////////////////////////////////////
    
    // MARK: - Action and gestures
    
    // TODO: Action
    
    @IBAction func btnNavigationTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func btnResetPasswordTapped(_ sender: UIButton) {
        validationSetup()
       
    }
    
}
//MARK: - Extension methods

extension ForgotPasswordVC{
    // TODO: Validations for all input fields
    
    func validationSetup()->Void{
        
        var message = ""
        
        if !validation.validateBlankField(txtFieldEmail.text!){
            message = MacrosForAll.VALIDMESSAGE.EmailAddressNotBeBlank.rawValue.localized()
            
        }else if !validation.validateEmail(txtFieldEmail.text!){
            message = MacrosForAll.VALIDMESSAGE.EnterValidEmail.rawValue.localized()
        }
        if message != "" {
            _ = SweetAlert().showAlert(macroObj.appName, subTitle: message, style: AlertStyle.error)
        }else{
            
            forgotPassword_service()
        }
    }
}


//MARK: - Extension web services methods

extension ForgotPasswordVC{
    func forgotPassword_service(){
        if InternetConnection.internetshared.isConnectedToNetwork(){
            let passDict = ["email":txtFieldEmail.text!,
                            "type":"members"] as [String:AnyObject]
            print(passDict)
            macroObj.showLoader(view: view)
            alamoFireObj.postRequestURL(MacrosForAll.APINAME.forgotpassword.rawValue, params: passDict , headers: nil, success: { (responseJASON) in
                self.macroObj.hideLoader(view: self.view)
                if responseJASON["status"].string == "SUCCESS"{
                    if let responseDict = responseJASON["response"].dictionaryObject{
                        guard let otp = responseDict["otp"] as? String else {
                            print("No otp")
                            return
                        }
                        guard let user_id = responseDict["user_id"] as? String else {
                            print("No user_id")
                            return
                        }
                        
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "VarificationVC") as! VarificationVC
                        vc.isComing = "FORGOTPASSWORD"
                        vc.email = self.txtFieldEmail.text!
                        vc.otpSting = otp
                        vc.fUser_id = user_id
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    
                }else{
                    self.macroObj.hideLoader(view: self.view)
                    let message = responseJASON["message"].string ?? ""
                    _ = SweetAlert().showAlert(self.macroObj.appName, subTitle: message, style: AlertStyle.error)
                }
                
                
            }, failure: { (error) in
                self.macroObj.hideLoader(view: self.view)
                print(error.localizedDescription)
                _ = SweetAlert().showAlert(self.macroObj.appName, subTitle: MacrosForAll.ERRORMESSAGE.ErrorMessage.rawValue.localized(), style: AlertStyle.error)
            })
            
        }else{
            self.macroObj.hideLoader(view: self.view)
            _ = SweetAlert().showAlert(macroObj.appName, subTitle: MacrosForAll.ERRORMESSAGE.NoInternet.rawValue.localized(), style: AlertStyle.error)
        }
    }
}

