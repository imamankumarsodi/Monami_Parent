//
//  ChangePasswordVC.swift
//  Monami
//
//  Created by abc on 29/11/18.
//  Copyright © 2018 mobulous. All rights reserved.
//

import UIKit
import RealmSwift

class ChangePasswordVC: UIViewController {
    
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var viewOldPassword: UIView!
    @IBOutlet weak var stackViewHeight: NSLayoutConstraint!
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var txtFieldOldPassword: UITextField!
    @IBOutlet weak var txtFieldNewPassword: UITextField!
    @IBOutlet weak var txtFieldConfirmPassword: UITextField!
    
    /////////////////////////////////////////////////////
    
    // MARK: - Global variables
    let macroObj = MacrosForAll.sharedInstanceMacro
    let alamoFireObj = AlamofireWrapper.sharedInstance
    let validation:Validation = Validation.validationManager() as! Validation
    let realm = try! Realm()
    var fUser_id: String = ""
    var isComing: String = ""
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    /////////////////////////////////////////////////////
    
    // MARK:- View life cycle methods
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialMethod()
        
        // Do any additional setup after loading the view.
    }
    /////////////////////////////////////////////////////
    
    
    
    
    // TODO: Web services
    
    
    /////////////////////////////////////////////////////
    
    // MARK: - Actions
    
    
    // TODO: Actions
    
    @IBAction func btnBackTappd(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)

//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarVC") as! TabBarVC
//        let navController = UINavigationController(rootViewController: vc)
//        navController.navigationBar.isHidden = true
//        self.appDelegate.window?.rootViewController = navController
//        self.appDelegate.window?.makeKeyAndVisible()
    }
    

    @IBAction func btnSubmitTapped(_ sender: UIButton) {
        
        if isComing == "FORGOTPASSWORD"{
            validationSetupForgotPassword()
        }else{
            validationSetup()
        }
        
    }
    
    
    
}

// MARK: - User defined Methods Extension
extension ChangePasswordVC{
   
    
    // TODO: Methods
    
    func initialMethod(){
        if isComing == "FORGOTPASSWORD"{
            lblHeader.text = "Reset Password".localized()
            stackViewHeight.constant = 110
            viewOldPassword.isHidden = true
        }else{
            lblHeader.text = "Change Password".localized()
            stackViewHeight.constant = 170
            viewOldPassword.isHidden = false
        }
        self.tabBarController?.tabBar.isHidden = true
    }
    
    // TODO: Validations for all input fields
    
    func validationSetup()->Void{
        
        var message = ""
        
        if !validation.validateBlankField(txtFieldOldPassword.text!){
            message = MacrosForAll.VALIDMESSAGE.OldPasswordNotBeBlank.rawValue.localized()
        }
        else if (txtFieldOldPassword.text!.characters.count < 6 ){
            message = MacrosForAll.VALIDMESSAGE.OldPasswordShouldBeLong.rawValue.localized()
        }
        else if !validation.validateBlankField(txtFieldNewPassword.text!){
            message = MacrosForAll.VALIDMESSAGE.NewPasswordNotBeBlank.rawValue.localized()
        }
        else if (txtFieldNewPassword.text!.characters.count < 6){
            message = MacrosForAll.VALIDMESSAGE.NewPasswordShouldBeLong.rawValue.localized()
        }
        else if txtFieldNewPassword.text! != txtFieldConfirmPassword.text!{
            message = MacrosForAll.VALIDMESSAGE.NewPasswordAndConfimePasswordNotMatched.rawValue.localized()
        }
 
        if message != "" {
            _ = SweetAlert().showAlert(macroObj.appName, subTitle: message, style: AlertStyle.error)
        }else{
            
            changePassword()
        }
        
        
    }
    
    
    func validationSetupForgotPassword()->Void{
        
        var message = ""
        
        if !validation.validateBlankField(txtFieldNewPassword.text!){
            message = MacrosForAll.VALIDMESSAGE.NewPasswordNotBeBlank.rawValue.localized()
        }
        else if (txtFieldNewPassword.text!.characters.count < 6){
            message = MacrosForAll.VALIDMESSAGE.NewPasswordShouldBeLong.rawValue.localized()
        }
        else if txtFieldNewPassword.text! != txtFieldConfirmPassword.text!{
            message = MacrosForAll.VALIDMESSAGE.NewPasswordAndConfimePasswordNotMatched.rawValue.localized()
        }
        
        if message != "" {
            _ = SweetAlert().showAlert(macroObj.appName, subTitle: message, style: AlertStyle.error)
        }else{
            
            resetPassword()
        }
        
        
    }
    
    func deleteUser(userInfo:SignUpDataModel){
        do{
            try realm.write {
                UIApplication.shared.applicationIconBadgeNumber = 0
                realm.delete(userInfo)
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "LogInVC") as! LogInVC
                let navController = UINavigationController(rootViewController: vc)
                navController.navigationBar.isHidden = true
                self.appDelegate.window?.rootViewController = navController
                self.appDelegate.window?.makeKeyAndVisible()
            }
        }catch{
            print("Error in saving data :- \(error.localizedDescription)")
        }
    }
    
    
}

// MARK: - Web services Methods Extension
extension ChangePasswordVC{
    
    
    // TODO: change password API

    func changePassword(){
        if InternetConnection.internetshared.isConnectedToNetwork(){
            var user_id = String()
            var token = String()
            if let userInfo = realm.objects(SignUpDataModel.self).first{
                user_id = userInfo.user_id
                token = userInfo.token
            }
            let passDict = ["oldpassword":txtFieldOldPassword.text!,
                            "password":txtFieldNewPassword.text!,
                            "password_confirmation":txtFieldConfirmPassword.text!,
                            "user_id":user_id,
                            "token":token] as [String:AnyObject]
            macroObj.showLoader(view: view)
            alamoFireObj.postRequestURL(MacrosForAll.APINAME.changepassword.rawValue, params: passDict , headers: nil, success: { (responseJASON) in
                self.macroObj.hideLoader(view: self.view)
                if responseJASON["status"].string == "SUCCESS"{
                    if let message = responseJASON["message"].string as? String{
                        _ = SweetAlert().showAlert(self.macroObj.appName, subTitle: message, style: AlertStyle.success)
                    }
                   
                    self.navigationController?.popViewController(animated: true)
                    
                }else{
                    self.macroObj.hideLoader(view: self.view)
                    let message = responseJASON["message"].string ?? ""
                    if message == "Login Token Expire"{
                        if let userInfo = self.realm.objects(SignUpDataModel.self).first{
                            self.deleteUser(userInfo:userInfo)
                        }
                    _ = SweetAlert().showAlert(self.macroObj.appName, subTitle: MacrosForAll.VALIDMESSAGE.LoginTokenExpire.rawValue.localized(), style: AlertStyle.error)
                    }
                    else{
                        _ = SweetAlert().showAlert(self.macroObj.appName, subTitle: message, style: AlertStyle.error)
                    }
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
    
    func resetPassword(){
        if InternetConnection.internetshared.isConnectedToNetwork(){
      
            let passDict = ["type":"members",
                            "password":txtFieldNewPassword.text!,
                            "password_confirmation":txtFieldConfirmPassword.text!,
                            "user_id":self.fUser_id] as [String:AnyObject]
            macroObj.showLoader(view: view)
            alamoFireObj.postRequestURL(MacrosForAll.APINAME.resetpassword.rawValue, params: passDict , headers: nil, success: { (responseJASON) in
                self.macroObj.hideLoader(view: self.view)
                if responseJASON["status"].string == "SUCCESS"{
                    self.navigationController?.popToRootViewController(animated: true)
                    let message = responseJASON["message"].string ?? ""
                    _ = SweetAlert().showAlert(self.macroObj.appName, subTitle: message, style: AlertStyle.success)
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "LogInVC") as! LogInVC
                    let navController = UINavigationController(rootViewController: vc)
                    navController.navigationBar.isHidden = true
                    self.appDelegate.window?.rootViewController = navController
                    self.appDelegate.window?.makeKeyAndVisible()
                    
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

