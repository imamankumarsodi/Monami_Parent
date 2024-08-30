//
//  ManageFamilyVC.swift
//  Monami
//
//  Created by Callsoft on 26/09/18.
//  Copyright © 2018 mobulous. All rights reserved.
//

import UIKit
import RealmSwift
import SDWebImage

class ManageFamilyVC: UIViewController {
    
    
    @IBOutlet weak var tblManageTableView: UITableView!
    
    //MARK: - Variables
    let macroObj = MacrosForAll.sharedInstanceMacro
    let alamoFireObj = AlamofireWrapper.sharedInstance
    let validation:Validation = Validation.validationManager() as! Validation
    let realm = try! Realm()
    var familyMemberList = [FamilyMemberDataModel]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var isComing = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetUP()
        
        // Do any additional setup after loading the view.
    }
    
    
    
    /////////////////////////////////////////////////////
    
    // MARK: - Actions, gestures, tableViewActions
    
    
    // TODO: Actions
    
    
    @IBAction func btnBackTapped(_ sender: Any) {
        if isComing == "NOTI"{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarVC") as! TabBarVC
            let navController = UINavigationController(rootViewController: vc)
            navController.navigationBar.isHidden = true
            self.appDelegate.window?.rootViewController = navController
            self.appDelegate.window?.makeKeyAndVisible()
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    // TODO: Gestures
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        getFamilyMembersList()
        refreshControl.endRefreshing()
    }
    
    @objc func reloadFamilyMemberApi(_ notification: Notification){
        getFamilyMembersList()
    }
    
    // TODO: TableView Actions
    
    @objc func actSwitchTappd(_ sender: UISwitch) {
        accessActivatedOrDeactivatedserviceOrDeleteService(serviceName:MacrosForAll.APINAME.accessforfamily.rawValue,access_id:familyMemberList[sender.tag].access_id, index: sender.tag)
        
        
    }
    @objc func btnDeleteAccessTapped(sender: UIButton){
        print(sender.tag)
        
        _ = SweetAlert().showAlert(macroObj.appName, subTitle: "\(MacrosForAll.VALIDMESSAGE.DeleteAccess.rawValue.localized())\(self.familyMemberList[sender.tag].fullname)!", style: AlertStyle.warning, buttonTitle:"Cancel".localized(), buttonColor:UIColor.colorFromRGB(0xD0D0D0) , otherButtonTitle:  "OK".localized(), otherButtonColor: UIColor.colorFromRGB(0xDD6B55)) { (isOtherButton) -> Void in
            if isOtherButton == true {
                print("Cancel Button  Pressed", terminator: "")
            }
            else
            {
                self.accessActivatedOrDeactivatedserviceOrDeleteService(serviceName:MacrosForAll.APINAME.deleteaccessoffamily.rawValue,access_id:self.familyMemberList[sender.tag].access_id, index: sender.tag)
            }
            
        }
    }
    
    
}



// MARK: - Methods Extension
extension ManageFamilyVC{
    func initialSetUP(){
        
        ScreeNNameClass.shareScreenInstance.screenName = "ManageFamilyVC"
    NotificationCenter.default.addObserver(self,selector:#selector(ManageFamilyVC.reloadFamilyMemberApi(_:)),name:NSNotification.Name(rawValue: "MANAGENOTIFYRELOAD"),object: nil)
        self.tblManageTableView.addSubview(self.refreshControl)
        getFamilyMembersList()
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
    var refreshControl: UIRefreshControl {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(ManageFamilyVC.handleRefresh(_:)), for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor(red: 59.0/255, green: 208.0/255, blue: 214.0/255, alpha: 1.0)
        return refreshControl
    }
}




/////////////////////////////////////////////////////

// MARK: - Table View Extension



extension ManageFamilyVC: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return familyMemberList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        self.tblManageTableView.register(UINib(nibName:"ManageFamilyTableViewCell",bundle:nil), forCellReuseIdentifier: "ManageFamilyTableViewCell")
        let cell = tblManageTableView.dequeueReusableCell(withIdentifier: "ManageFamilyTableViewCell", for: indexPath) as! ManageFamilyTableViewCell
        
        cell.imgUser.sd_setImage(with: URL(string: familyMemberList[indexPath.row].image), placeholderImage: UIImage(named: "user_signup"))
        cell.lblName.text = familyMemberList[indexPath.row].fullname
        if familyMemberList[indexPath.row].status == "1"{
            cell.lblAccessType.text = "Access activated".localized()
            cell.lblAccessType.textColor = UIColor(red: 193/255, green: 227/255, blue: 128/255, alpha: 1)
            cell.actSwiftch.setOn(true, animated:true)
        }else{
            cell.lblAccessType.text = "Access deactivated".localized()
            cell.lblAccessType.textColor = UIColor.red
            cell.actSwiftch.setOn(false, animated:true)
        }
        cell.actSwiftch.tag = indexPath.row
        cell.actSwiftch.addTarget(self, action: #selector(actSwitchTappd), for: .touchUpInside)
        cell.btnDeleteRef.tag = indexPath.row
        cell.btnDeleteRef.addTarget(self, action: #selector(btnDeleteAccessTapped), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}

// MARK: - Web services Methods Extension
extension ManageFamilyVC{
    
    
    // TODO: get family list API
    
    func getFamilyMembersList(){
        if InternetConnection.internetshared.isConnectedToNetwork(){
            var CUID = String()
            if let userInfo = realm.objects(SignUpDataModel.self).first{
                CUID = userInfo.CUID
            }
            macroObj.showLoader(view: view)
            alamoFireObj.getRequestURL("\(MacrosForAll.APINAME.familylist.rawValue)/\(CUID)", success: { (responseJASON) in
                self.macroObj.hideLoader(view: self.view)
                if responseJASON["status"].string == "SUCCESS"{
                    if self.familyMemberList.count != 0{
                        self.familyMemberList.removeAll()
                    }
                    if let responseArray = responseJASON["response"].arrayObject{
                        for post in responseArray{
                            if let postDict = post as? NSDictionary{
                                print(postDict)
                                
                                guard let image = postDict["image"] as? String else {
                                    print("No image")
                                    return
                                }
                                guard let fullname = postDict["fullname"] as? String else {
                                    print("No fullname")
                                    return
                                }
                                guard let member_id = postDict["member_id"] as? Int else {
                                    print("No member_id")
                                    return
                                }
                                guard let status = postDict["status"] as? String else {
                                    print("No status")
                                    return
                                }
                                guard let access_id = postDict["access_id"] as? Int else {
                                    print("No access_id")
                                    return
                                }
                                
                                let familyItem = FamilyMemberDataModel(member_id: member_id, image: image, fullname: fullname, status: status, access_id: access_id)
                                self.familyMemberList.append(familyItem)
                            }
                        }
                        
                        self.tblManageTableView.dataSource = self
                        self.tblManageTableView.delegate = self
                        self.tblManageTableView.reloadData()
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
    
    
    // TODO: Access activated or deactivated API
    
    func accessActivatedOrDeactivatedserviceOrDeleteService(serviceName:String,access_id:Int,index:Int){
        if InternetConnection.internetshared.isConnectedToNetwork(){
            var user_id = String()
            var token = String()
            if let userInfo = realm.objects(SignUpDataModel.self).first{
                user_id = userInfo.user_id
                token = userInfo.token
            }
            let passDict = ["user_id":user_id,
                            "token":token] as [String:AnyObject]
            print(passDict)
            macroObj.showLoader(view: view)
            alamoFireObj.postRequestURL("\(serviceName)/\(access_id)", params: passDict , headers: nil, success: { (responseJASON) in
                self.macroObj.hideLoader(view: self.view)
                if responseJASON["status"].string == "SUCCESS"{
                    if let responseDict = responseJASON["response"].dictionaryObject{
                        if serviceName == "accessforfamily"{
                            if let status = responseDict["status"] as? String{
                                let indexPath = IndexPath(row: index, section: 0)
                                guard let cell = self.tblManageTableView.cellForRow(at: indexPath) as? ManageFamilyTableViewCell else {
                                    
                                    return
                                }
                                if  status == "1"{
                                    cell.lblAccessType.text = "Access activated".localized()
                                    cell.lblAccessType.textColor = UIColor(red: 193/255, green: 227/255, blue: 128/255, alpha: 1)
                                    cell.actSwiftch.setOn(true, animated:true)
                                }else{
                                    cell.lblAccessType.text = "Access deactivated".localized()
                                    cell.lblAccessType.textColor = UIColor.red
                                    cell.actSwiftch.setOn(false, animated:true)
                                }
                            }
                        }else{
                            self.getFamilyMembersList()
                        }
                        let message = responseJASON["message"].string ?? ""
                        _ = SweetAlert().showAlert(self.macroObj.appName, subTitle: message, style: AlertStyle.success)
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


