//
//  SignUpVC.swift
//  Monami
//
//  Created by abc on 21/09/18.
//  Copyright © 2018 mobulous. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController {
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var lblAgreeTermsAndCondiotions: UILabel!
    @IBOutlet weak var lblAlreadyHaveAccount: UILabel!
    @IBOutlet weak var btnAcceptTermsAndConditionsRef: UIButton!
    @IBOutlet weak var txtField_FullName: UITextField!
    @IBOutlet weak var txtField_ContactNumber: UITextField!
    @IBOutlet weak var txtField_EmailID: UITextField!
    @IBOutlet weak var txtField_Password: UITextField!
    @IBOutlet weak var txtField_ConfirmPassword: UITextField!
    @IBOutlet weak var lbl_AgreeTermsAndConditions: UILabel!
    @IBOutlet weak var btn_SignUp_Ref: UIButton!
    @IBOutlet weak var lbl_AlreadyHaveAnAccount: UILabel!
    
    /////////////////////////////////////////////////////
    
    
    // MARK: - Global variables
    let macroObj = MacrosForAll.sharedInstanceMacro
    let alamoFireObj = AlamofireWrapper.sharedInstance
    let validation:Validation = Validation.validationManager() as! Validation
    var btnAcceptTermsAndConditionState = false
    
    /////////////////////////////////////////////////////
    
    // MARK: - View life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        initialMethod()
    }
    
    
    
    // TODO: Web services
    
    
    /////////////////////////////////////////////////////
    
    // MARK: - Action and gestures
    
    // TODO: Gestures
    
    @objc func alreadyHaveAccountAction(){
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func termsAndConditionAction(){
        
        print("Send to terms and condition Page")
        //        let vc = self.storyboard?.instantiateViewController(withIdentifier: "") as!
        //        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    // TODO: Methods
    
    
    @IBAction func btnSignUpTapped(_ sender: UIButton) {
        validationSetup()
    }
    
    
    
    @IBAction func btnFBTapped(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarVC") as! TabBarVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    @IBAction func btnGoogleTapped(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarVC") as! TabBarVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnTermsAndConditionsTapped(_ sender: Any) {
        btnAcceptTermsAndConditionState = !btnAcceptTermsAndConditionState
        let image = btnAcceptTermsAndConditionState ? #imageLiteral(resourceName: "check"):#imageLiteral(resourceName: "uncheck")
        btnAcceptTermsAndConditionsRef.setImage(image, for: .normal)
        
    }
    
    
}




// MARK: - Methods Extension

extension SignUpVC{
    
    
    // MARK: - User defined methods
    
    // TODO: Initial Setup
    
    func initialMethod(){
        
        let langauge = UserDefaults.standard.value(forKey: "Language") as? String ?? "portg"
        
        if langauge == "Portuguese" || langauge == "portg" {
            
            // Label lblAgreeTermsAndCondiotions modifing and add action to it
            txtField_FullName.delegate = self
            var text = lblAgreeTermsAndCondiotions.text
            var textRange = NSRange(location: 10, length: 18)
            var attributedText = NSMutableAttributedString(string: text!)
            attributedText.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: textRange)
            attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(red: 231.0/255, green: 122.0/255, blue: 155.0/255, alpha: 1.0), range: textRange)
            lblAgreeTermsAndCondiotions.attributedText = attributedText
            
            lblAgreeTermsAndCondiotions.isUserInteractionEnabled = true
            
            let lblAgreeTermsAndCondiotionsTapped: UITapGestureRecognizer = UITapGestureRecognizer(
                target: self, action: #selector(termsAndConditionAction))
            
            lblAgreeTermsAndCondiotions.addGestureRecognizer(lblAgreeTermsAndCondiotionsTapped)
            
            
            // Label lblAlreadyHaveAccount modifing and add action to it
            
            text = lblAlreadyHaveAccount.text
            
            textRange = NSRange(location: 18, length: 11)

            attributedText = NSMutableAttributedString(string: text!)
            attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(red: 231.0/255, green: 122.0/255, blue: 155.0/255, alpha: 1.0), range: textRange)

            lblAlreadyHaveAccount.attributedText = attributedText
            
            lblAlreadyHaveAccount.isUserInteractionEnabled = true
            
            let lblAlreadyHaveAccountTapped: UITapGestureRecognizer = UITapGestureRecognizer(
                target: self, action: #selector(alreadyHaveAccountAction))
            
            lblAlreadyHaveAccount.addGestureRecognizer(lblAlreadyHaveAccountTapped)
            
        }
        else {
            // Label lblAgreeTermsAndCondiotions modifing and add action to it
            txtField_FullName.delegate = self
            var text = lblAgreeTermsAndCondiotions.text
            var textRange = NSRange(location: 15, length: 18)
            var attributedText = NSMutableAttributedString(string: text!)
            attributedText.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: textRange)
            attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(red: 231.0/255, green: 122.0/255, blue: 155.0/255, alpha: 1.0), range: textRange)
            lblAgreeTermsAndCondiotions.attributedText = attributedText
            
            lblAgreeTermsAndCondiotions.isUserInteractionEnabled = true
            
            let lblAgreeTermsAndCondiotionsTapped: UITapGestureRecognizer = UITapGestureRecognizer(
                target: self, action: #selector(termsAndConditionAction))
            
            lblAgreeTermsAndCondiotions.addGestureRecognizer(lblAgreeTermsAndCondiotionsTapped)
            
            
            // Label lblAlreadyHaveAccount modifing and add action to it
            
            text = lblAlreadyHaveAccount.text
            
            textRange = NSRange(location: 25, length: 6)
            
            attributedText = NSMutableAttributedString(string: text!)
            attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(red: 231.0/255, green: 122.0/255, blue: 155.0/255, alpha: 1.0), range: textRange)
            
            lblAlreadyHaveAccount.attributedText = attributedText
            
            lblAlreadyHaveAccount.isUserInteractionEnabled = true
            
            let lblAlreadyHaveAccountTapped: UITapGestureRecognizer = UITapGestureRecognizer(
                target: self, action: #selector(alreadyHaveAccountAction))
            
            lblAlreadyHaveAccount.addGestureRecognizer(lblAlreadyHaveAccountTapped)
        }
        
        
        
        
    }
    
    
    // TODO: Validation for valid full name
    
    func validationForFullName()->Bool{
        do {
            let regex = try NSRegularExpression(pattern: ".*[^A-Za-z ].*", options: .caseInsensitive)
            if let _ = regex.firstMatch(in: txtField_FullName.text!, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSMakeRange(0, txtField_FullName.text!.count)) {
                return true
            }
            
        } catch {
            debugPrint(error.localizedDescription)
            return false
        }
        
        return false
    }
    
    // TODO: Validations for all input fields
    
    func validationSetup()->Void{
        
        var message = ""
        
        if !validation.validateBlankField(txtField_FullName.text!){
            message = MacrosForAll.VALIDMESSAGE.EnterFullName.rawValue.localized()
        }
        else if validationForFullName() == true{
            message = MacrosForAll.VALIDMESSAGE.EnterValidFullName.rawValue.localized()
        }
        else if (txtField_FullName.text!.characters.count < 4 ){
            message = MacrosForAll.VALIDMESSAGE.EnterValidFullNameLength.rawValue.localized()
        }
        else if !validation.validateBlankField(txtField_ContactNumber.text!){
            message = MacrosForAll.VALIDMESSAGE.EnterMobileNumber.rawValue.localized()
        }
        else if !validation.validateBlankField(txtField_EmailID.text!){
            message = MacrosForAll.VALIDMESSAGE.EmailAddressNotBeBlank.rawValue.localized()
            
        }else if !validation.validateEmail(txtField_EmailID.text!){
            message = MacrosForAll.VALIDMESSAGE.EnterValidEmail.rawValue.localized()
        }
        else if !validation.validateBlankField(txtField_Password.text!){
            message = MacrosForAll.VALIDMESSAGE.PasswordNotBeBlank.rawValue.localized()
        }
        else if (txtField_Password.text!.characters.count < 6 ){
            message = MacrosForAll.VALIDMESSAGE.PasswordShouldBeLong.rawValue.localized()
        }
        else if !validation.validateBlankField(txtField_ConfirmPassword.text!){
            message = MacrosForAll.VALIDMESSAGE.ConfirmPasswordNotBeBlank.rawValue.localized()
        }
        else if (txtField_ConfirmPassword.text!.characters.count < 6){
            message = MacrosForAll.VALIDMESSAGE.ConfirmPasswordShouldBeLong.rawValue.localized()
        }
        else if txtField_Password.text! != txtField_ConfirmPassword.text!{
            message = MacrosForAll.VALIDMESSAGE.PasswordAndConfimePasswordNotMatched.rawValue.localized()
        }
        else if btnAcceptTermsAndConditionState == false{
            message =  MacrosForAll.VALIDMESSAGE.AcceptTermsAndConditions.rawValue.localized()
        }
        if message != "" {
            _ = SweetAlert().showAlert(macroObj.appName, subTitle: message, style: AlertStyle.error)
        }else{
            
            checkMail()
        }
        
        
    }
    
    //TODO: Data on SignUp
    
    func dataOnSignUp()->NSDictionary{
        
        let devicetoken = UserDefaults.standard.value(forKey: "devicetoken") as? String ?? "Simulaterwalatokenbb55d44bfc4492bd33aac79afeaee474e92c12138e18b021e2326"
        
        let langauge = UserDefaults.standard.value(forKey: "Language") as? String ?? "portg"
        var lang = String()
        if langauge == "Portuguese" || langauge == "portg" {
            lang = "portg"
        }else{
            lang = "eng"
        }
        
        let dataDict = ["fullname":txtField_FullName.text!,
                        "email":txtField_EmailID.text!,
                        "phone":txtField_ContactNumber.text!,
                        "deviceType":"ios",
                        "deviceToken":devicetoken,
                        "password":txtField_Password.text!,
                        "password_confirmation":txtField_ConfirmPassword.text!,
                        "type":"",
                        "lang":lang] as NSDictionary
        return dataDict
    }
    
    
}

// MARK: - Extension web services
extension SignUpVC{
    //TODO: Check mail service
    
    func checkMail(){
        if InternetConnection.internetshared.isConnectedToNetwork(){
            let passDict = ["email":txtField_EmailID.text!,
                            "devicetype":"ios"]
            macroObj.showLoader(view: view)
            alamoFireObj.postRequestURL(MacrosForAll.APINAME.CheckEmailId.rawValue, params: passDict as [String : AnyObject], headers: nil, success: { (responseJASON) in
                self.macroObj.hideLoader(view: self.view)
                print(responseJASON)
                if responseJASON["status"].string == "SUCCESS"{
                    if let responseDict = responseJASON["response"].dictionaryObject{
                        if let otpString = responseDict["otp"]{
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "VarificationVC") as! VarificationVC
                            vc.otpSting = "\(otpString)"
                            vc.passDict = self.dataOnSignUp()
                            vc.email = self.txtField_EmailID.text!
                            self.navigationController?.pushViewController(vc, animated: true)
                            
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
}


// MARK: - Extension textField delegate

extension SignUpVC:UITextFieldDelegate{

func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
    if textField == txtField_FullName  {
        let allowedCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "
        let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacters)
        let typedCharacterSet = CharacterSet(charactersIn: string)
        let alphabet = allowedCharacterSet.isSuperset(of: typedCharacterSet)
        return alphabet
    }
    return true
}
}
