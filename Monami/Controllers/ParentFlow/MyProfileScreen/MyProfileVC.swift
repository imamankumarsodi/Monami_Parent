//
//  MyProfileVC.swift
//  Monami
//
//  Created by abc on 24/09/18.
//  Copyright © 2018 mobulous. All rights reserved.
//

import UIKit
import RealmSwift
import SDWebImage

class MyProfileVC: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var btnMailRef: UIButton!
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var imgProfilePicture: UIImageView!
    @IBOutlet weak var txtFullName: UITextField!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var txtFieldEmail: UITextField!
    @IBOutlet weak var lblPhoneNumber: UILabel!
    @IBOutlet weak var txtFieldPhoneNumber: UITextField!
    @IBOutlet weak var imgViewProfile: UIImageView!
    @IBOutlet weak var btnNavigationRef: UIButton!
    @IBOutlet weak var btnFamilyRef: UIButton!
    @IBOutlet weak var HeaderBtnStackWidth: NSLayoutConstraint!
    @IBOutlet weak var btnFollowingChildRef: UIButton!
    @IBOutlet weak var btnSaveRef: UIButton!
    @IBOutlet weak var txtEnterCUID: UITextField!
    @IBOutlet weak var txtWantToFollow: UITextField!
    
    //MARK: - Variables
    let realm = try! Realm()
    var imagePicker = UIImagePickerController()
    var imageData = NSData()
    let macroObj = MacrosForAll.sharedInstanceMacro
    let alamoFireObj = AlamofireWrapper.sharedInstance
    let validation:Validation = Validation.validationManager() as! Validation
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        initialMethod()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.items?[0].title = "Home".localized()
        self.tabBarController?.tabBar.items?[1].title = "My Chat".localized()
        self.tabBarController?.tabBar.items?[2].title = "Notifications".localized()
        self.tabBarController?.tabBar.items?[3].title = "Profile".localized()
        lblHeader.text = "Profile".localized()
        txtFullName.placeholder = "Full Name".localized()
        lblEmail.text = "Email Id".localized()
        lblPhoneNumber.text = "Phone Number".localized()
        txtFieldPhoneNumber.text = "Enter Contact Number".localized()
        btnFollowingChildRef.setTitle(" Following".localized(), for: .normal)
        btnSaveRef.setTitle("Save".localized(), for: .normal)
        txtWantToFollow.placeholder = "Want to follow new child?".localized()
        txtEnterCUID.placeholder = "Enter CUID".localized()
        txtFieldEmail.placeholder = "Enter Email Id".localized()
        
        viewUser()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /////////////////////////////////////////////////////
    
    // MARK: - Actions, gestures, tableViewActions
    
    
    // TODO: Actions
    
    
    @IBAction func btnFollowingTapped(_ sender: Any) {
        
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ListOfFollowingChildrenVC") as! ListOfFollowingChildrenVC
        
        self.navigationController?.pushViewController(vc, animated: true)
        
        
        
    }
    
    
    @IBAction func btnSettingsTapped(_ sender: UIButton) {
        
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
        
        
        
    }
    
    @IBAction func btnFamilyTapped(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ManageFamilyVC") as! ManageFamilyVC
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    @IBAction func btnCameraTapped(_ sender: Any) {
        openActionSheet()
    }
    
    @IBAction func btnSaveTapped(_ sender: Any) {
        validationSetup()
    }
    @IBAction func btnNavigationTapped(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarVC") as! TabBarVC
        let navController = UINavigationController(rootViewController: vc)
        navController.navigationBar.isHidden = true
        self.appDelegate.window?.rootViewController = navController
        self.appDelegate.window?.makeKeyAndVisible()
    }
    
    @IBAction func btnEnterCUIDTapped(_ sender: UIButton) {
        
        var textFeild = UITextField()
        
        let alert = UIAlertController(title: macroObj.appName, message: "Enter CUID".localized(), preferredStyle: .alert)
        let action = UIAlertAction(title: "Submit".localized(), style: .default) { (action) in
            
            if textFeild.text != ""{
                if (textFeild.text?.characters.count)! >= 6{
                    let firstChar = textFeild.text?.prefix(1)
                    if firstChar == "p" || firstChar == "P"{
                        self.CUID_service(CUID:textFeild.text!, serviceName: MacrosForAll.APINAME.mapparentcuid.rawValue, userKey: "user_id")
                    }else if firstChar == "s" || firstChar == "S"{
                        self.CUID_service(CUID:textFeild.text!, serviceName: MacrosForAll.APINAME.followaction.rawValue, userKey: "follower_id")
                    }else{
                        _ = SweetAlert().showAlert(self.macroObj.appName, subTitle: MacrosForAll.VALIDMESSAGE.invalidCUIDAlert.rawValue.localized(), style: AlertStyle.error)
                    }
                }else{
                    _ = SweetAlert().showAlert(self.macroObj.appName, subTitle: MacrosForAll.VALIDMESSAGE.CUIDMaxLength.rawValue.localized(), style: AlertStyle.error)
                }
                
            }else{
                _ = SweetAlert().showAlert(self.macroObj.appName, subTitle: MacrosForAll.VALIDMESSAGE.CUIDAlert.rawValue.localized(), style: .error)
            }
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel".localized(), style: .cancel,handler: nil)
        cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
        
        alert.addTextField { (alertTextFeild) in
            alertTextFeild.placeholder = "CUID"
            
            textFeild = alertTextFeild
        }
        alert.addAction(cancelAction)
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    
    
    // TODO: Gestures
    
    
    // TODO: TableView Actions
    
}


// MARK: - Methods Extension

extension MyProfileVC{
    /////////////////////////////////////////////////////
    
    // MARK: - User defined Methods
    
    // TODO: Methods initial
    
    
    // TODO: Validation for valid full name
    
    func validationForFullName()->Bool{
        do {
            let regex = try NSRegularExpression(pattern: ".*[^A-Za-z ].*", options: .caseInsensitive)
            if let _ = regex.firstMatch(in: txtFullName.text!, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSMakeRange(0, txtFullName.text!.count)) {
                return true
            }
            
        } catch {
            debugPrint(error.localizedDescription)
            return false
        }
        
        return false
    }
    
    
    
    func initialMethod(){
        imagePicker.allowsEditing =  true
        txtFullName.delegate = self
        viewUser()
        
    }
    
    func validationSetup()->Void{
        var message = ""
        
        if !validation.validateBlankField(txtFullName.text!){
            message = MacrosForAll.VALIDMESSAGE.EnterFullName.rawValue.localized()
        }
        else if validationForFullName() == true{
            message = MacrosForAll.VALIDMESSAGE.EnterValidFullName.rawValue.localized()
        }
        else if (txtFullName.text!.characters.count < 4 ){
            message = MacrosForAll.VALIDMESSAGE.EnterValidFullNameLength.rawValue.localized()
        }
        else if !validation.validateBlankField(txtFieldPhoneNumber.text!){
            message = MacrosForAll.VALIDMESSAGE.EnterMobileNumber.rawValue.localized()
        }
        else if !validation.validateBlankField(txtFieldEmail.text!){
            message = MacrosForAll.VALIDMESSAGE.EmailAddressNotBeBlank.rawValue.localized()
            
        }else if !validation.validateEmail(txtFieldEmail.text!){
            message = MacrosForAll.VALIDMESSAGE.EnterValidEmail.rawValue.localized()
        }
        if message != "" {
            _ = SweetAlert().showAlert(macroObj.appName, subTitle: message, style: AlertStyle.error)
        }else{
            
            editProfile_service()
        }
    }
    
    func updateUser(phone:String,fullname:String,email:String,user_id:String,image:String){
        do{
            try realm.write {
                
                if let user = realm.objects(SignUpDataModel.self).first{
                    user.fullname = fullname
                    user.email = email
                    user.phone = phone
                    user.user_id = user_id
                    user.image = image
                    self.viewUser()
                    
                    if UserDefaults.standard.value(forKey: "imageData") != nil{
                        UserDefaults.standard.removeObject(forKey: "imageData")
                    }else{
                        print("do not remove from imageData key")
                    }
                    
                }
            }
        }catch{
            print("Error in saving data :- \(error.localizedDescription)")
        }
    }
    
    func viewUser(){
        
        
        if let userInfo = realm.objects(SignUpDataModel.self).first{
            if userInfo.type == "family"{
                btnFamilyRef.isHidden = true
                HeaderBtnStackWidth.constant = 54
                self.tabBarController?.tabBar.isHidden = true
                btnNavigationRef.isHidden = false
            }else if userInfo.type == "parent"{
                btnFamilyRef.isHidden = false
                HeaderBtnStackWidth.constant = 108
                self.tabBarController?.tabBar.isHidden = false
                btnNavigationRef.isHidden = true
            }else{
                
                self.btnFamilyRef.isHidden = true
                self.HeaderBtnStackWidth.constant = 54
                self.tabBarController?.tabBar.isHidden = true
                self.btnNavigationRef.isHidden = true
                
            }
            
            if userInfo.email == ""{
                txtFieldEmail.isUserInteractionEnabled = true
               btnMailRef.isHidden = false
                
            }else{
                txtFieldEmail.isUserInteractionEnabled = false
                btnMailRef.isHidden = true
            }
            
            self.txtFullName.text = userInfo.fullname
            self.txtFieldEmail.text = userInfo.email
            self.txtFieldPhoneNumber.text = userInfo.phone
            self.imgProfilePicture.sd_setImage(with: URL(string: userInfo.image), placeholderImage: UIImage(named: "user_signup"))
        }
    }
    
    func viewUserAndSetFlow(){
        
        
        if let userInfo = realm.objects(SignUpDataModel.self).first{
            if userInfo.type == "family"{
                btnFamilyRef.isHidden = false
                HeaderBtnStackWidth.constant = 108
                self.tabBarController?.tabBar.isHidden = true
                btnNavigationRef.isHidden = false
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                let navController = UINavigationController(rootViewController: vc)
                navController.navigationBar.isHidden = true
                self.appDelegate.window?.rootViewController = navController
                self.appDelegate.window?.makeKeyAndVisible()
                
            }else if userInfo.type == "parent"{
                btnFamilyRef.isHidden = false
                HeaderBtnStackWidth.constant = 108
                self.tabBarController?.tabBar.isHidden = false
                btnNavigationRef.isHidden = true
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarVC") as! TabBarVC
                let navController = UINavigationController(rootViewController: vc)
                navController.navigationBar.isHidden = true
                self.appDelegate.window?.rootViewController = navController
                self.appDelegate.window?.makeKeyAndVisible()
            }else{
                btnFamilyRef.isHidden = true
                HeaderBtnStackWidth.constant = 54
                self.tabBarController?.tabBar.isHidden = true
                btnNavigationRef.isHidden = true
            }
            txtFullName.text = userInfo.fullname
            txtFieldEmail.text = userInfo.email
            txtFieldPhoneNumber.text = userInfo.phone
            imgProfilePicture.sd_setImage(with: URL(string: userInfo.image), placeholderImage: UIImage(named: "user_signup"))
            
        }
    }
    
    
    func updateCUID(CUID:String,type:String){
        do{
            try realm.write {
                if let user = realm.objects(SignUpDataModel.self).first{
                    if user.type == "" || user.type == "family"{
                        user.CUID = CUID
                        user.type = type
                    }else{
                        
                    }
                    viewUser()
                }
            }
        }catch{
            print("Error in saving data :- \(error.localizedDescription)")
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
// MARK: - Web services Extension

extension MyProfileVC{
    
    func editProfile_service(){
        if InternetConnection.internetshared.isConnectedToNetwork(){
            var user_id = String()
            var token = String()
            if let userInfo = realm.objects(SignUpDataModel.self).first{
                user_id = userInfo.user_id
                token = userInfo.token
            }
            let passDict = ["email":txtFieldEmail.text!,
                            "phone":txtFieldPhoneNumber.text!,
                            "devicetype":"ios",
                            "user_id":String(user_id),
                            "fullname":txtFullName.text!,
                            "token":token] as [String:AnyObject]
            macroObj.showLoader(view: view)
            if UserDefaults.standard.value(forKey: "imageData") != nil{
                
                alamoFireObj.postRequestURLWithFile(imageData: imageData, fileName: "image.jpg", imageparam: "image", urlString: MacrosForAll.APINAME.editprofile.rawValue, parameters: passDict, headers: nil, success: { (responseJASON) in
                    self.macroObj.hideLoader(view: self.view)
                    print(responseJASON)
                    if responseJASON["status"].string == "SUCCESS"{
                        if let responseDict = responseJASON["response"].dictionaryObject{
                            print(responseDict)
                            guard let phone = responseDict["phone"] as? String else {
                                print("No phone")
                                return
                            }
                            guard let fullname = responseDict["fullname"] as? String else {
                                print("No fullname")
                                return
                            }
                            guard let email = responseDict["email"] as? String else {
                                print("No email")
                                return
                            }
                            guard let user_id = responseDict["user_id"] as? String else {
                                print("No user_id")
                                return
                            }
                            guard let image = responseDict["image"] as? String else {
                                print("No image")
                                return
                            }
                            _ = SweetAlert().showAlert(self.macroObj.appName, subTitle: MacrosForAll.VALIDMESSAGE.ProfileUpdate.rawValue.localized(), style: AlertStyle.success)
                            self.updateUser(phone: phone, fullname: fullname, email: email, user_id: user_id, image: image)
                            
                        }
                        
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
                
                //When we have no image data
                
                alamoFireObj.postRequestURL(MacrosForAll.APINAME.editprofile.rawValue, params: passDict, headers:  nil, success: { (responseJASON) in
                    self.macroObj.hideLoader(view: self.view)
                    print(responseJASON)
                    if responseJASON["status"].string == "SUCCESS"{
                        if let responseDict = responseJASON["response"].dictionaryObject{
                            print(responseDict)
                            guard let phone = responseDict["phone"] as? String else {
                                print("No phone")
                                return
                            }
                            guard let fullname = responseDict["fullname"] as? String else {
                                print("No fullname")
                                return
                            }
                            guard let email = responseDict["email"] as? String else {
                                print("No email")
                                return
                            }
                            guard let user_id = responseDict["user_id"] as? String else {
                                print("No user_id")
                                return
                            }
                            guard let image = responseDict["image"] as? String else {
                                print("No image")
                                return
                            }
                            _ = SweetAlert().showAlert(self.macroObj.appName, subTitle: MacrosForAll.VALIDMESSAGE.ProfileUpdate.rawValue.localized(), style: AlertStyle.success)
                            self.updateUser(phone: phone, fullname: fullname, email: email, user_id: user_id, image: image)
                        }
                    }else{
                        self.macroObj.hideLoader(view: self.view)
                        let message = responseJASON["message"].string ?? ""
                        if message == "Login Token Expire"{
                            if let userInfo = self.realm.objects(SignUpDataModel.self).first{
                                self.deleteUser(userInfo:userInfo)
                            }
                            _ = SweetAlert().showAlert(self.macroObj.appName, subTitle: MacrosForAll.VALIDMESSAGE.LoginTokenExpire.rawValue.localized(), style: AlertStyle.error)
                        }else{
                            _ = SweetAlert().showAlert(self.macroObj.appName, subTitle: message, style: AlertStyle.error)
                        }
                    }
                }, failure: { (error) in
                    self.macroObj.hideLoader(view: self.view)
                    print(error.localizedDescription)
                    _ = SweetAlert().showAlert(self.macroObj.appName, subTitle: MacrosForAll.ERRORMESSAGE.ErrorMessage.rawValue.localized(), style: AlertStyle.error)
                })
            }
            
        }else{
            self.macroObj.hideLoader(view: self.view)
            _ = SweetAlert().showAlert(macroObj.appName, subTitle: MacrosForAll.ERRORMESSAGE.NoInternet.rawValue.localized(), style: AlertStyle.error)
        }
    }
    
    
    func CUID_service(CUID:String,serviceName:String,userKey:String){
        if InternetConnection.internetshared.isConnectedToNetwork(){
            var user_id = String()
            var token = String()
            if let userInfo = realm.objects(SignUpDataModel.self).first{
                user_id = userInfo.user_id
                token = userInfo.token
            }
            let passDict = ["CUID":CUID,
                            userKey:user_id,
                            "token":token] as [String:AnyObject]
            print(passDict)
            macroObj.showLoader(view: view)
            alamoFireObj.postRequestURL(serviceName, params: passDict , headers: nil, success: { (responseJASON) in
                self.macroObj.hideLoader(view: self.view)
                print(responseJASON)
                if responseJASON["status"].string == "SUCCESS"{
                    if let responseDict = responseJASON["response"].dictionaryObject{
                        guard let CUID = responseDict["CUID"] as? String else {
                            print("No CUID")
                            return
                        }
                        guard let type = responseDict["type"] as? String else {
                            print("No type")
                            return
                        }
                        if let message = responseJASON["message"].string as? String{
                             _ = SweetAlert().showAlert(self.macroObj.appName, subTitle: message, style: AlertStyle.success)
                        }
                        
                        self.updateCUID(CUID:CUID,type: type)
                    }
                    
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
    
    
}


// MARK: - Camera and Library action sheet delegates

extension MyProfileVC:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func openActionSheet() {
        
        let alert:UIAlertController=UIAlertController(title: "Choose Image".localized(), message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let cameraAction = UIAlertAction(title: "Camera".localized(), style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            self.openCamera()
        }
        let gallaryAction = UIAlertAction(title: "Gallery".localized(), style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            self.openGallery()
        }
        let cancelAction = UIAlertAction(title: "Cancel".localized(), style: UIAlertAction.Style.cancel)
        {
            UIAlertAction in
        }
        imagePicker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    func openCamera() {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            self .present(imagePicker, animated: true, completion: nil)
        }else {
            let alert = UIAlertController(title: macroObj.appName, message: "You don't have camera".localized(), preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok".localized(), style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallery() {
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        let chosenImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        if let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
//            imageData = UIImageJPEGRepresentation(chosenImage, 0.5) as NSData!
            
            imageData = chosenImage.jpegData(compressionQuality: 0.5) as! NSData
            print(imageData)
        } else{
            print("Something went wrong")
        }
        self.dismiss(animated: true, completion: nil)
        imgViewProfile.image = chosenImage
        imgViewProfile.clipsToBounds = true
        UserDefaults.standard.set(imageData, forKey: "imageData")
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Extension textField delegate

extension MyProfileVC:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtFullName  {
            let allowedCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "
            let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacters)
            let typedCharacterSet = CharacterSet(charactersIn: string)
            let alphabet = allowedCharacterSet.isSuperset(of: typedCharacterSet)
            return alphabet
        }
        return true
    }
}

