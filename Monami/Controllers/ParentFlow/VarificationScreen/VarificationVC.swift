//
//  VarificationVC.swift
//  Monami
//
//  Created by abc on 21/09/18.
//  Copyright © 2018 mobulous. All rights reserved.
//

import UIKit
import RealmSwift

class VarificationVC: UIViewController {
    
    
    // MARK: - Outlets
    
    
    @IBOutlet weak var lblResendCode: UILabel!
    @IBOutlet weak var otpView: VPMOTPView!
    
    
    /////////////////////////////////////////////////////
    
    // MARK: - Global variables
    var fUser_id: String = ""
    
    var enteredOtp: String = ""
    
    var isComing: String = ""
    
    var otpSting: String = ""
    
    var passDict = NSDictionary()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var email:String = ""
    
    let macroObj = MacrosForAll.sharedInstanceMacro
    
    let alamoFireObj = AlamofireWrapper.sharedInstance
    
    let realm = try! Realm()
    
    /////////////////////////////////////////////////////
    
    // MARK:- View life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initialMethod()
        
    }
    
    
    
    /////////////////////////////////////////////////////
    
    // MARK: - Actions, gestures
    
    
    // TODO: Gestures
    
    @objc func resendCodeAction(){
        resendOtp()
    }
    
    // TODO: Actions
    
    
    @IBAction func btnSubmitTapped(_ sender: Any) {
        
        //        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarVC") as! TabBarVC
        //        self.navigationController?.pushViewController(vc, animated: true)
        
        if isComing == "FORGOTPASSWORD"{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LogInVC") as! LogInVC
            let navController = UINavigationController(rootViewController: vc)
            navController.navigationBar.isHidden = true
            self.appDelegate.window?.rootViewController = navController
            self.appDelegate.window?.makeKeyAndVisible()
        }
            
            
            
        else{
            
            if enteredOtp == self.otpSting{
                
            }
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarVC") as! TabBarVC
            let navController = UINavigationController(rootViewController: vc)
            navController.navigationBar.isHidden = true
            vc.selectedIndex = 3
            self.appDelegate.window?.rootViewController = navController
            self.appDelegate.window?.makeKeyAndVisible()
            
        }
        
    }
    
    
    
    @IBAction func btnNavigationTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}



// MARK: - Extension OTP


extension VarificationVC: VPMOTPViewDelegate {
    func hasEnteredAllOTP(hasEntered: Bool) -> Bool {
        print("Has entered all OTP? \(hasEntered)")
        
        return enteredOtp == "1234"
    }
    
    func shouldBecomeFirstResponderForOTP(otpFieldIndex index: Int) -> Bool {
        return true
    }
    
    func enteredOTP(otpString: String) {
        enteredOtp = otpString
        print("OTPString: \(otpString)")
        
        if isComing == "FORGOTPASSWORD"{
            
            if enteredOtp == self.otpSting{
               let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
                vc.fUser_id = fUser_id
                vc.isComing = "FORGOTPASSWORD"
                self.navigationController?.pushViewController(vc, animated: true)
                
            }else{
                _ = SweetAlert().showAlert(self.macroObj.appName, subTitle: MacrosForAll.VALIDMESSAGE.IncorrectOTP.rawValue.localized(), style: AlertStyle.error)
            }
        }
  
        else{
            
            if enteredOtp == self.otpSting{
                signUp_service()
            }else{
                 _ = SweetAlert().showAlert(self.macroObj.appName, subTitle: MacrosForAll.VALIDMESSAGE.IncorrectOTP.rawValue.localized(), style: AlertStyle.error)
            }
        }
    }
    
}
// MARK: - Methods Extension

extension VarificationVC{
    /////////////////////////////////////////////////////
    
    // MARK: - User defined Methods
    
    // TODO: Methods
    
    
    func initialMethod(){
        
        // Label lblResendCode modifing and add action to it
        let text = lblResendCode.text
        let textRange = NSRange(location: 0, length: 11)
        let attributedText = NSMutableAttributedString(string: text!)
        attributedText.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: textRange)
        lblResendCode.attributedText = attributedText
        
        lblResendCode.isUserInteractionEnabled = true
        
        let lblResendCodeTapped: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(resendCodeAction))
        
        lblResendCode.addGestureRecognizer(lblResendCodeTapped)
        // Set OTPView
        otpView.otpFieldsCount = 4
        otpView.otpFieldDefaultBorderColor = UIColor(red: 237.0/255, green: 237.0/255, blue: 237.0/255, alpha: 1.0)
        otpView.otpFieldEnteredBackgroundColor = UIColor(red: 200.0/255, green: 233.0/255, blue: 122.0/255, alpha: 1.0)
        otpView.otpFieldEnteredBorderColor = UIColor(red: 200.0/255, green: 233.0/255, blue: 122.0/255, alpha: 1.0)
        otpView.otpFieldErrorBorderColor = UIColor(red: 200.0/255, green: 233.0/255, blue: 122.0/255, alpha: 1.0)
        otpView.otpFieldBorderWidth = 2
        otpView.delegate = self
        
        // Create the UI
        otpView.initalizeUI()
    }
    
    func save(userInfo:SignUpDataModel){
        do{
            try realm.write {
                realm.add(userInfo)
                
                _ = SweetAlert().showAlert(macroObj.appName, subTitle: MacrosForAll.VALIDMESSAGE.ContinueApp.rawValue.localized(), style: AlertStyle.success, buttonTitle:"OK", buttonColor:UIColor.colorFromRGB(0xE77A9B)) { (isOtherButton) -> Void in
                    if isOtherButton == true {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarVC") as! TabBarVC
                        let navController = UINavigationController(rootViewController: vc)
                        navController.navigationBar.isHidden = true
                        vc.selectedIndex = 3
                        self.appDelegate.window?.rootViewController = navController
                        self.appDelegate.window?.makeKeyAndVisible()
                    }
                    
                }
                
            }
        }catch{
            print("Error in saving data :- \(error.localizedDescription)")
        }
    }
    
    
}

// MARK: - Extension web services

extension VarificationVC{
    
    //TODO: Resend OTP Service
    
    func resendOtp(){
        if InternetConnection.internetshared.isConnectedToNetwork(){
            let passDict = ["email":self.email,
                            "devicetype":"ios"]
            macroObj.showLoader(view: view)
            alamoFireObj.postRequestURL(MacrosForAll.APINAME.CheckEmailId.rawValue, params: passDict as [String : AnyObject], headers: nil, success: { (responseJASON) in
                self.macroObj.hideLoader(view: self.view)
                print(responseJASON)
                if responseJASON["status"].string == "SUCCESS"{
                    if let responseDict = responseJASON["response"].dictionaryObject{
                        if let otpString = responseDict["otp"]{
                            self.otpSting = "\(otpString)"
                        }
                    }
                }else{
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
    
    
    //TODO: Sign up Service
    
    func signUp_service(){
        if InternetConnection.internetshared.isConnectedToNetwork(){
            macroObj.showLoader(view: view)
            alamoFireObj.postRequestURL(MacrosForAll.APINAME.ParentSignUp.rawValue, params: self.passDict as! [String : AnyObject], headers: nil, success: { (responseJASON) in
                self.macroObj.hideLoader(view: self.view)
                if responseJASON["status"].string == "SUCCESS"{
                    let signup_data = SignUpDataModel()
                    if let responseDict = responseJASON["response"].dictionaryObject{
                        
                        if let fullname = responseDict["fullname"] as? String{
                            signup_data.fullname = fullname
                        }
                        if let email = responseDict["email"] as? String{
                            signup_data.email = email
                        }
                        if let password = responseDict["password"] as? String{
                            signup_data.password = password
                        }
                        if let phone = responseDict["phone"] as? String{
                            signup_data.phone = phone
                        }
                        if let deviceType = responseDict["deviceType"] as? String{
                            signup_data.deviceType = deviceType
                        }
                        if let deviceToken = responseDict["deviceToken"] as? String{
                            signup_data.deviceToken = deviceToken
                        }
                        if let password_confimation = responseDict["password_confimation"] as? String{
                            signup_data.password_confimation = password_confimation
                        }
                        if let user_id = responseDict["user_id"] as? String{
                            signup_data.user_id = user_id
                        }
                        if let token = responseDict["token"] as? String{
                            signup_data.token = token
                        }
                        if let type = responseDict["type"] as? String{
                            signup_data.type = type
                        }
                        if let CUID = responseDict["CUID"] as? String{
                            signup_data.CUID = CUID
                        }
                        if let image = responseDict["image"] as? String{
                            signup_data.image = image
                        }
                        if let chat_status = responseDict["chat_status"] as? String{
                            signup_data.chat_status = chat_status
                        }
                        if let pavr_status = responseDict["pavr_status"] as? String{
                            signup_data.pavr_status = pavr_status
                        }
                        if let report_status = responseDict["report_status"] as? String{
                            signup_data.report_status = report_status
                        }
                        self.save(userInfo: signup_data)
                    }
                   
                }else{
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
