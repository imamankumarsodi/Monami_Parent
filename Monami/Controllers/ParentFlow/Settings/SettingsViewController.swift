//
//  SettingsViewController.swift
//  Monami
//
//  Created by Callsoft on 26/09/18.
//  Copyright © 2018 mobulous. All rights reserved.
//

import UIKit
import RealmSwift
import DropDown

class SettingsViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var tblSettings: UITableView!
    @IBOutlet weak var lblHeader: UILabel!
    //MARK: - Variables
     let realm = try! Realm()
    let alamoFireObj = AlamofireWrapper.sharedInstance
    let validation:Validation = Validation.validationManager() as! Validation
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let macroObj = MacrosForAll.sharedInstanceMacro
    var settingsNames = ["PAVR Notifications", "Chat Notifications", "Report Notifications", "Change Language", "Change Password", "About Us","Contact Monami Team", "Logout"]
    
    var settingsNamesPort = ["Notificações", "Notificação de Mensagens", "Notificação de relatórios", "Mudar lingua", "Mudar palavra passe", "Sobre nós","Contactar a equipa Monami", "Sair"]
    let dropDown = DropDown()
    var btnLanguageState = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
       
    }
    override func viewDidAppear(_ animated: Bool) {
        openDropDown()
    }
    
    
    
    /////////////////////////////////////////////////////
    
    // MARK: - Actions, gestures, tableViewActions
    
    
    // TODO: Actions
    
    
    @IBAction func btnBackTapped(_ sender: Any) {
        
        
        
        self.navigationController?.popViewController(animated: true)
        
        
        
    }
    
    
    
    
    
    
    
    
    // TODO: Gestures
    
    
    // TODO: TableView Actions
    
    @objc func btnSwitchTappd(_ sender: UISwitch) {
        var param = String()
        if sender.tag == 0{
            param = "pavr_status"
        }else if sender.tag == 1{
            param = "chat_status"
        }else{
            param = "report_status"
        }
        accessActivatedOrDeactivatedserviceOrDeleteService(param: param, index: sender.tag)


    }
    
}

/////////////////////////////////////////////////////

// MARK: - Table View Extension



extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 8
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        self.tblSettings.register(UINib(nibName:"SettingsTableViewCell",bundle:nil), forCellReuseIdentifier: "SettingsTableViewCell")
        let cell = tblSettings.dequeueReusableCell(withIdentifier: "SettingsTableViewCell", for: indexPath) as! SettingsTableViewCell
        
        
        let langauge = UserDefaults.standard.value(forKey: "Language") as? String ?? "portg"
        
        if langauge == "Portuguese" || langauge == "portg"{
            cell.lblSettings.text = settingsNamesPort[indexPath.row]
        }else{
           cell.lblSettings.text = settingsNames[indexPath.row]
        }
        
        
        
        if indexPath.row == 0 {
            if let userInfo = realm.objects(SignUpDataModel.self).first{
              let pavr_status = userInfo.pavr_status
                if pavr_status == "1"{
                    cell.btnSwitch.setOn(true, animated:true)
                }else{
                    cell.btnSwitch.setOn(false, animated:true)
                }
            }
            cell.imgDropDowns.isHidden = true
        }
        else if indexPath.row == 1{
            if let userInfo = realm.objects(SignUpDataModel.self).first{
                let chat_status = userInfo.chat_status
                if chat_status == "1"{
                   cell.btnSwitch.setOn(true, animated:true)
                }else{
                    cell.btnSwitch.setOn(false, animated:true)
                }
            }
            
            cell.imgDropDowns.isHidden = true
        }
        else if indexPath.row == 2{
            if let userInfo = realm.objects(SignUpDataModel.self).first{
                let report_status = userInfo.report_status
                if report_status == "1"{
                    cell.btnSwitch.setOn(true, animated:true)
                }else{
                    cell.btnSwitch.setOn(false, animated:true)
                }
            }
            
            cell.imgDropDowns.isHidden = true
        }
            
        else if indexPath.row == 3 {
            cell.btnSwitch.isHidden = true
            cell.imgDropDowns.image = #imageLiteral(resourceName: "monami_login_dropdown")
            
        }
            
        else if indexPath.row == 4 {
            cell.btnSwitch.isHidden = true
            cell.imgDropDowns.image = #imageLiteral(resourceName: "setting_arrow_forward")
        }
        else if indexPath.row == 5 {
            cell.btnSwitch.isHidden = true
            cell.imgDropDowns.image = #imageLiteral(resourceName: "setting_arrow_forward")
        }else if indexPath.row == 6{
            cell.btnSwitch.isHidden = true
            cell.imgDropDowns.image = #imageLiteral(resourceName: "setting_arrow_forward")
        }
        else if indexPath.row == 7 {
            cell.btnSwitch.isHidden = true
            cell.imgDropDowns.image = #imageLiteral(resourceName: "setting_logout")
        }
        
        cell.btnSwitch.tag = indexPath.row
        cell.btnSwitch.addTarget(self, action: #selector(btnSwitchTappd), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        return 70
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 4{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if indexPath.row == 3 {
            //Change Language
            print("INDEX 3")
            if btnLanguageState == false{
                dropDown.show()
            }else{
                dropDown.hide()
            }
        }
        else if indexPath.row == 5{
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AboutTermsConditionVC") as! AboutTermsConditionVC
            vc.isComing = "ABOUT"
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else if indexPath.row == 6{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContactUsVC") as! ContactUsVC
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 7{
            
            _ = SweetAlert().showAlert(macroObj.appName, subTitle: MacrosForAll.VALIDMESSAGE.WantToLogout.rawValue.localized(), style: AlertStyle.warning, buttonTitle:"Cancel".localized(), buttonColor:UIColor.colorFromRGB(0xD0D0D0) , otherButtonTitle:  "OK".localized(), otherButtonColor: UIColor.colorFromRGB(0xDD6B55)) { (isOtherButton) -> Void in
                if isOtherButton == true {
                    print("Cancel Button  Pressed", terminator: "")
                }
                else
                {
                    if let userInfo = self.realm.objects(SignUpDataModel.self).first{
                        self.deleteUser(userInfo:userInfo)
                    }
                }
                
            }


        }
    }
    
}

/////////////////////////////////////////////////////

// MARK: - Extentions methods

extension SettingsViewController{
    func deleteUser(userInfo:SignUpDataModel){
        do{
            try realm.write {
                realm.delete(userInfo)
                UIApplication.shared.applicationIconBadgeNumber = 0
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
    
    func openDropDown() {
        
        let indexPath = IndexPath(row: 3, section: 0)
        if let cell = tblSettings.cellForRow(at: indexPath) as? SettingsTableViewCell{
            dropDown.anchorView = cell.lblSettings
            dropDown.width = 158.0
            dropDown.dataSource = ["English".localized(), "Portuguese".localized()]
            dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                
                if index == 0 {
                    self.changeLanguageService(lang:"eng",index:index)
                }
                else {
                    self.changeLanguageService(lang:"portg",index:index)
                }
            }
            
            
        }
        
        
    }

   
    
}

/////////////////////////////////////////////////////

// MARK: - Extentions web services

extension SettingsViewController{
    
    func accessActivatedOrDeactivatedserviceOrDeleteService(param:String,index:Int){
        if InternetConnection.internetshared.isConnectedToNetwork(){
            var user_id = String()
            var token = String()
            if let userInfo = realm.objects(SignUpDataModel.self).first{
                user_id = userInfo.user_id
                token = userInfo.token
            }
            let passDict = ["user_id":user_id,
                            "token":token,
                            "param":param] as [String:AnyObject]
            print(passDict)
            macroObj.showLoader(view: view)
            alamoFireObj.postRequestURL(MacrosForAll.APINAME.notificationtrigger.rawValue, params: passDict , headers: nil, success: { (responseJASON) in
                self.macroObj.hideLoader(view: self.view)
                if responseJASON["status"].string == "SUCCESS"{
                    print(responseJASON)
                    if let responseDict = responseJASON["response"].dictionary{
                        if let status = responseDict["status"]?.string{
                            if index == 0{
                                do{
                                    try self.realm.write {
                                        if let user = self.realm.objects(SignUpDataModel.self).first{
                                            user.pavr_status = status
                                        }
                                    }
                                }catch{
                                    print("Error in saving data :- \(error.localizedDescription)")
                                }
                                
                            }else if index == 1{
                                do{
                                    try self.realm.write {
                                        if let user = self.realm.objects(SignUpDataModel.self).first{
                                            user.chat_status = status
                                        }
                                    }
                                }catch{
                                    print("Error in saving data :- \(error.localizedDescription)")
                                }
                            }else{
                                do{
                                    try self.realm.write {
                                        if let user = self.realm.objects(SignUpDataModel.self).first{
                                            user.report_status = status
                                        }
                                    }
                                }catch{
                                    print("Error in saving data :- \(error.localizedDescription)")
                                }
                            }
                        }
                    }
                    let message = responseJASON["message"].string ?? ""
                    _ = SweetAlert().showAlert(self.macroObj.appName, subTitle: message, style: AlertStyle.success)
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
    
    
    
    func changeLanguageService(lang:String,index:Int){
        if InternetConnection.internetshared.isConnectedToNetwork(){
            var user_id = String()
            if let userInfo = realm.objects(SignUpDataModel.self).first{
                user_id = userInfo.user_id
            }
            macroObj.showLoader(view: view)
            alamoFireObj.getRequestURL("\(MacrosForAll.APINAME.changelang.rawValue)/\(user_id)/\(lang)",success: { (responseJASON) in
                self.macroObj.hideLoader(view: self.view)
                if responseJASON["status"].string == "SUCCESS"{
                    print(responseJASON)
                    
                    if index == 0 {
                        Localize.setCurrentLanguage(language: "en")
                        Bundle.setLanguage("en")
                        UserDefaults.standard.set("English", forKey: "Language")
                        self.tblSettings.reloadData()
                        self.lblHeader.text = "Settings"
                    }
                    else {
                        Localize.setCurrentLanguage(language: "pt-PT")
                        Bundle.setLanguage("pt-PT")
                        UserDefaults.standard.set("Portuguese", forKey: "Language")
                        self.tblSettings.reloadData()
                        self.lblHeader.text = "Configurações"
                    }
               
                    let message = responseJASON["message"].string ?? ""
                    _ = SweetAlert().showAlert(self.macroObj.appName, subTitle: message, style: AlertStyle.success)
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


