//
//  LogInVC.swift
//  Monami
//
//  Created by abc on 20/09/18.
//  Copyright © 2018 mobulous. All rights reserved.
//

import UIKit
import RealmSwift
import FBSDKLoginKit
import FBSDKCoreKit
import GoogleSignIn
import DropDown

class LogInVC: UIViewController {
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var viewDropDown: UIView!
    @IBOutlet weak var lblLanguage: UILabel!
    @IBOutlet weak var txtFieldEmailId: UITextField!
    @IBOutlet weak var txtFieldPassword: UITextField!
    @IBOutlet weak var btnLoginRef: UIButton!
    @IBOutlet weak var btnForgotPasswordRef: UIButton!
    @IBOutlet weak var btnSignUpRef: UIButton!
    /////////////////////////////////////////////////////
    @IBOutlet weak var btnContactMonamiRef: UIButton!
    
    
    
    
    // MARK: - Global variables
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let macroObj = MacrosForAll.sharedInstanceMacro
    let alamoFireObj = AlamofireWrapper.sharedInstance
    let validation:Validation = Validation.validationManager() as! Validation
    let realm = try! Realm()
    var emailString:String = ""
    var imageData = NSData()
    var isComingThrough = String()
    let dropDown = DropDown()
    var btnLanguageState = false
    /////////////////////////////////////////////////////
    
    // MARK:- View life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetUp()
        // Do any additional setup after loading the view.
        
        checkForLanguage()
        self.changeLanguage()
    }
    
    
    
    /////////////////////////////////////////////////////
    
    
    // TODO: Web services
    
    
    /////////////////////////////////////////////////////
    
    // MARK: - Actions, gestures
    
    
    // TODO: Gestures
    
    @objc func dontHaveAnAccountAction(){
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    // TODO: Actions
    
    
    @IBAction func btnForgotPasswordTapped(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    @IBAction func btnLoginTapped(_ sender: UIButton) {
        validationSetup()
    }
    
    
    @IBAction func btnFBTapped(_ sender: UIButton) {
        FBLoginSetup()
    }
    
    
    @IBAction func btnGoogleTapped(_ sender: UIButton) {
        if InternetConnection.internetshared.isConnectedToNetwork(){
            self.macroObj.showLoader(view: self.view)
            GIDSignIn.sharedInstance().signOut()
            GIDSignIn.sharedInstance().delegate=self
            GIDSignIn.sharedInstance().uiDelegate=self
            GIDSignIn.sharedInstance().signIn()
        }else{
            self.macroObj.hideLoader(view: self.view)
            _ = SweetAlert().showAlert(macroObj.appName, subTitle: MacrosForAll.ERRORMESSAGE.NoInternet.rawValue, style: AlertStyle.error)
        }
    }
    
    @IBAction func btnSignUpTapped(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    @IBAction func btnLanguageTapped(_ sender: UIButton) {
        if btnLanguageState == false{
            dropDown.show()
        }else{
            dropDown.hide()
        }
    }
    
    @IBAction func btnContactUsTapped(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContactUsVC") as! ContactUsVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - Extension methods

extension LogInVC{
    
    
    // TODO: Initial SetUp
    
    func initialSetUp(){
        dropDown.anchorView = viewDropDown
        dropDown.width = 158.0
        let language = UserDefaults.standard.value(forKey: "Language") as? String ?? "portg"
        if language == "Portuguese" || language == "portg"{
            lblLanguage.text = "Português"
            dropDown.dataSource = ["Português", "Inglês"]
        }else{
            lblLanguage.text = "English"
           dropDown.dataSource = ["Portuguese", "English"]
        }
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.lblLanguage.text = item
            
            if index == 0 {
                Localize.setCurrentLanguage(language: "pt-PT")
                Bundle.setLanguage("pt-PT")
                self.lblLanguage.text = "Portuguese".localized()
                UserDefaults.standard.set("Portuguese", forKey: "Language")
            }
            else {
                Localize.setCurrentLanguage(language: "en")
                Bundle.setLanguage("en")
                self.lblLanguage.text = "English".localized()
                UserDefaults.standard.set("English", forKey: "Language")
            }
            self.changeLanguage()
        }
        
    }
    
    func changeLanguage() {
        
        self.txtFieldEmailId.placeholder = "Email Id".localized()
        self.txtFieldPassword.placeholder = "Password".localized()
        self.btnLoginRef.setTitle("Login".localized(), for: .normal)
        self.btnForgotPasswordRef.setTitle("Forgot Password?".localized(), for: .normal)
        self.btnSignUpRef.setTitle("SIGN UP".localized(), for: .normal)
        self.btnContactMonamiRef.setTitle("Contact Monami Team".localized(), for: .normal)
        let language = UserDefaults.standard.value(forKey: "Language") as? String ?? "portg"
        if language == "Portuguese" || language == "portg"{
            dropDown.dataSource = ["Português", "Inglês"]
        }else{
            dropDown.dataSource = ["Portuguese", "English"]
        }
    }
    
    func checkForLanguage() {
        let selectLanguage = UserDefaults.standard.value(forKey: "Language") as? String ?? "portg"
        
        if selectLanguage == "English" {
            Localize.setCurrentLanguage(language: "en")
            Bundle.setLanguage("en")
            UserDefaults.standard.set("English", forKey: "Language")
        }
        else {
            Localize.setCurrentLanguage(language: "pt-PT")
            Bundle.setLanguage("pt-PT")
            UserDefaults.standard.set("Portuguese", forKey: "Language")
        }
    }
    
    // TODO: Validations for all input fields
    
    func validationSetup()->Void{
        
        var message = ""
        
        if !validation.validateBlankField(txtFieldEmailId.text!){
            message = MacrosForAll.VALIDMESSAGE.EmailAddressNotBeBlank.rawValue.localized()
            
        }else if !validation.validateEmail(txtFieldEmailId.text!){
            message = MacrosForAll.VALIDMESSAGE.EnterValidEmail.rawValue.localized()
        }
        else if !validation.validateBlankField(txtFieldPassword.text!){
            message = MacrosForAll.VALIDMESSAGE.PasswordNotBeBlank.rawValue.localized()
        }
        else if (txtFieldPassword.text!.characters.count < 6 ){
            message = MacrosForAll.VALIDMESSAGE.PasswordShouldBeLong.rawValue.localized()
        }
        if message != "" {
            _ = SweetAlert().showAlert(macroObj.appName, subTitle: message, style: AlertStyle.error)
        }else{
            
            logIn_service()
        }
        
        
    }
    
    //TODO: Save data to realm
    
    func save(userInfo:SignUpDataModel){
        if isComingThrough == "SOCIAL_LOGIN"{
            
            do{
                try realm.write {
                    
                    if let user = realm.objects(SignUpDataModel.self).first{
                        user.fullname = userInfo.fullname
                        user.email = userInfo.email
                        user.password = userInfo.password
                        user.phone = userInfo.phone
                        user.deviceType = userInfo.deviceType
                        user.deviceToken = userInfo.deviceToken
                        user.password_confimation = userInfo.password_confimation
                        user.user_id = userInfo.user_id
                        user.token = userInfo.token
                        user.type = userInfo.type
                        user.CUID = userInfo.CUID
                        user.image = userInfo.image
                        user.chat_status = userInfo.chat_status
                        user.pavr_status = userInfo.pavr_status
                        user.report_status = userInfo.report_status
                    }else{
                        realm.add(userInfo)
                    }
                    sendToControllers()
                }
            }catch{
                print("Error in saving data :- \(error.localizedDescription)")
            }
        }else{
            
            do{
                try realm.write {
                    
                    if let user = realm.objects(SignUpDataModel.self).first{
                        user.fullname = userInfo.fullname
                        user.email = userInfo.email
                        user.password = userInfo.password
                        user.phone = userInfo.phone
                        user.deviceType = userInfo.deviceType
                        user.deviceToken = userInfo.deviceToken
                        user.password_confimation = userInfo.password_confimation
                        user.user_id = userInfo.user_id
                        user.token = userInfo.token
                        user.type = userInfo.type
                        user.CUID = userInfo.CUID
                        user.image = userInfo.image
                    }else{
                        realm.add(userInfo)
                    }
                    
                    sendToControllers()
                }
            }catch{
                print("Error in saving data :- \(error.localizedDescription)")
            }
        }
    }
    
    //TODO: Login methods for sign in facebook
    func FBLoginSetup()
    {
        let fbloginManager:LoginManager = LoginManager()
        if InternetConnection.internetshared.isConnectedToNetwork(){
            
            
            fbloginManager.logIn(permissions: ["email","public_profile"], from: self) { (result, error) in
                 self.macroObj.showLoader(view: self.view)
                if error != nil{
                    self.macroObj.hideLoader(view: self.view)
                    print("Get an error\(error?.localizedDescription)")
                }else{
                    self.macroObj.hideLoader(view: self.view)
                    self.getFbData()
                    fbloginManager.logOut()
                }
            }
        }else{
            self.macroObj.hideLoader(view: self.view)
            _ = SweetAlert().showAlert(macroObj.appName, subTitle: MacrosForAll.ERRORMESSAGE.NoInternet.rawValue.localized(), style: AlertStyle.error)
        }
    }
    
    func getFbData()
    {
        if InternetConnection.internetshared.isConnectedToNetwork(){
           
            if (AccessToken.current != nil){
                GraphRequest(graphPath: "me", parameters: ["fields": "id ,name , first_name , last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) in
                      self.macroObj.showLoader(view: self.view)
                    if error != nil{
                        self.macroObj.hideLoader(view: self.view)
                        print("Get error\(error?.localizedDescription)")
                    }
                    else{
                        self.macroObj.hideLoader(view: self.view)
                        if let dataDict = result as? [String : AnyObject]{
                            print(dataDict)
                            
                            guard let socialID = dataDict["id"] as? String else {
                                print("No socialID")
                                return
                            }
                            guard let first_name = dataDict["first_name"] as? String else {
                                print("No first_name")
                                return
                            }
                            guard let last_name = dataDict["last_name"] as? String else {
                                print("No last_name")
                                return
                            }
                            guard let name = dataDict["name"] as? String else {
                                print("No name")
                                return
                            }
                            if let email = dataDict["email"] as? String{
                                self.emailString = email
                            }else{
                                print("No email")
                            }
                            
                            
                            if let pictureDict = dataDict["picture"] as? [String:AnyObject]{
                                if let pictureData = pictureDict["data"] as? [String:AnyObject]{
                                    guard let url = pictureData["url"] as? String else {
                                        print("No url")
                                        return
                                    }
//                                    let theProfileImageUrl:URL! = URL(string: url as! String)
//                                    do{
//                                        let imageData = try NSData(contentsOf: theProfileImageUrl as URL)
//                                        UserDefaults.standard.set(imageData, forKey: "imageData")
//                                    }catch{
//                                        print("Error :- \(error.localizedDescription)")
//                                    }
                                }
                            }
                            
                            self.isComingThrough = "SOCIAL_LOGIN"
                            self.apiCallForSocialLogin(fullname:name,socialID:socialID,isComing:"btnFB")
                        }
                        
                    }
                })
            }
        }else{
            self.macroObj.hideLoader(view: self.view)
            _ = SweetAlert().showAlert(macroObj.appName, subTitle: MacrosForAll.ERRORMESSAGE.NoInternet.rawValue.localized(), style: AlertStyle.error)
        }
    }
    
    //TODO: Redirections to classes
    func sendToControllers(){
        if let userInfo = realm.objects(SignUpDataModel.self).first{
            print(userInfo.type)
            
            if userInfo.type == ""{
                print(userInfo.type)
                _ = SweetAlert().showAlert(macroObj.appName, subTitle: MacrosForAll.VALIDMESSAGE.ContinueApp.rawValue.localized(), style: AlertStyle.warning, buttonTitle:"OK", buttonColor:UIColor.colorFromRGB(0xE77A9B)) { (isOtherButton) -> Void in
                    if isOtherButton == true {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarVC") as! TabBarVC
                        let navController = UINavigationController(rootViewController: vc)
                        navController.navigationBar.isHidden = true
                        vc.selectedIndex = 3
                        self.appDelegate.window?.rootViewController = navController
                        self.appDelegate.window?.makeKeyAndVisible()
                    }
                }
            }else if userInfo.type == "parent"{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarVC") as! TabBarVC
                let navController = UINavigationController(rootViewController: vc)
                navController.navigationBar.isHidden = true
                self.appDelegate.window?.rootViewController = navController
                self.appDelegate.window?.makeKeyAndVisible()
            }else if userInfo.type == "family"{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarVC") as! TabBarVC
                let navController = UINavigationController(rootViewController: vc)
                navController.navigationBar.isHidden = true
                self.appDelegate.window?.rootViewController = navController
                self.appDelegate.window?.makeKeyAndVisible()
            }else{
                print("Kahi nahi bhejna")
            }
        }
    }
    
}
//MARK: - Web services implementations

extension LogInVC{
    //TODO: Log up Service
    
    func logIn_service(){
        if InternetConnection.internetshared.isConnectedToNetwork(){
            let devicetoken = UserDefaults.standard.value(forKey: "devicetoken") as? String ?? "Simulaterwalatokenbb55d44bfc4492bd33aac79afeaee474e92c12138e18b021e2326"
            
            let langauge = UserDefaults.standard.value(forKey: "Language") as? String ?? "portg"
            var lang = String()
            if langauge == "Portuguese" || langauge == "portg" {
                lang = "portg"
            }else{
                lang = "eng"
            }
             let passDict = ["email":txtFieldEmailId.text!,
                            "password":txtFieldPassword.text!,
                            "deviceType":"ios",
                            "deviceToken":devicetoken,
                            "lang":lang] as [String:AnyObject]
            print(passDict)
            macroObj.showLoader(view: view)
            alamoFireObj.postRequestURL(MacrosForAll.APINAME.login.rawValue, params: passDict , headers: nil, success: { (responseJASON) in
                print(responseJASON)
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
    
    
    func apiCallForSocialLogin(fullname:String,socialID:String,isComing:String){
        if InternetConnection.internetshared.isConnectedToNetwork(){
            var passDict = [String:AnyObject]()
            let devicetoken = UserDefaults.standard.value(forKey: "devicetoken") as? String ?? "Simulaterwalatokenbb55d44bfc4492bd33aac79afeaee474e92c12138e18b021e2326"
            let langauge = UserDefaults.standard.value(forKey: "Language") as? String ?? "portg"
            var lang = String()
            if langauge == "Portuguese" || langauge == "portg" {
                lang = "portg"
            }else{
                lang = "eng"
            }
            
            if isComing == "btnFB"{
                passDict = ["email":emailString,
                            "fullname":fullname,
                            "deviceType":"ios",
                            "deviceToken":devicetoken,
                            "fsocialid":socialID,
                            "lang":lang] as [String:AnyObject]
                print(passDict)
            }else{
                passDict = ["email":emailString,
                            "fullname":fullname,
                            "deviceType":"ios",
                            "deviceToken":devicetoken,
                            "gsocialid":socialID,
                            "lang":lang] as [String:AnyObject]
            }

            print(passDict)
            macroObj.showLoader(view: view)
                //When we have no image data
                alamoFireObj.postRequestURL(MacrosForAll.APINAME.sociallogin.rawValue, params: passDict, headers:  nil, success: { (responseJASON) in
                    self.macroObj.hideLoader(view: self.view)
                    print(responseJASON)
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
                        self.macroObj.hideLoader(view: self.view)
                        let message = responseJASON["message"].string ?? ""
                        _ = SweetAlert().showAlert(self.macroObj.appName, subTitle: message, style: AlertStyle.error)
                    }
                }, failure: { (error) in
                    self.macroObj.hideLoader(view: self.view)
                    print(error.localizedDescription)
                    _ = SweetAlert().showAlert(self.macroObj.appName, subTitle: MacrosForAll.ERRORMESSAGE.ErrorMessage.rawValue.localized(), style: AlertStyle.error)
                })
     //       }
            
        }else{
            self.macroObj.hideLoader(view: self.view)
            _ = SweetAlert().showAlert(macroObj.appName, subTitle: MacrosForAll.ERRORMESSAGE.NoInternet.rawValue.localized(), style: AlertStyle.error)
        }
    }
    
    
    
    
}

//MARK: - Extension google signIn
extension LogInVC:GIDSignInDelegate,GIDSignInUIDelegate{
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,withError error: Error!) {
        if error != nil {
            self.macroObj.hideLoader(view: self.view)
            print("\(error.localizedDescription)")
        }
        else
        {
            self.macroObj.hideLoader(view: self.view)
            if let profilePicUrlString = user.profile.imageURL(withDimension: 300) as? String{
                let theProfileImageUrl:URL! = URL(string: profilePicUrlString )
                do{
                    let imageData = try NSData(contentsOf: theProfileImageUrl as URL)
                    UserDefaults.standard.set(imageData, forKey: "imageData")
                }catch{
                    print("Error :- \(error.localizedDescription)")
                }
            }
            guard let userId = user.userID  else{ return }              // For client-side use only!
            guard let idToken = user.authentication.idToken else{ return}// Safe to send to the server
            guard let fullName = user.profile.name else {return }
            guard let givenName = user.profile.givenName else { return}
            guard let familyName = user.profile.familyName else {return }
            guard let email = user.profile.email else { return }
            self.emailString = email
            self.isComingThrough = "SOCIAL_LOGIN"
            self.apiCallForSocialLogin(fullname:fullName,socialID:userId,isComing:"btnGoogle")
        }
    }
    // Present a view that prompts the user to sign in with Google
    func sign(_ signIn: GIDSignIn!,present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!,dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
