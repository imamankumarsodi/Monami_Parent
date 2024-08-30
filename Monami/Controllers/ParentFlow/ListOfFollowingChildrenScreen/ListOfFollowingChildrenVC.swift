//
//  ListOfFollowingChildrenVC.swift
//  Monami
//
//  Created by abc on 25/09/18.
//  Copyright © 2018 mobulous. All rights reserved.
//

import UIKit
import RealmSwift
import SDWebImage

class ListOfFollowingChildrenVC: UIViewController {
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var tblListFollowingChildren: UITableView!
    
    
    /////////////////////////////////////////////////////
    
    // MARK: - Global variables
    
    let macroObj = MacrosForAll.sharedInstanceMacro
    let alamoFireObj = AlamofireWrapper.sharedInstance
    let validation:Validation = Validation.validationManager() as! Validation
    let realm = try! Realm()
    var followingChildrenList = [FollowingChildrenDataModel]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    /////////////////////////////////////////////////////
    
    // MARK:- View life cycle methods
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetUP()
        // Do any additional setup after loading the view.
    }
    /////////////////////////////////////////////////////
    
    // MARK: - User defined Methods
    
    // TODO: Methods
    
    
    
    
    // TODO: Web services
    
    
    /////////////////////////////////////////////////////
    
    // MARK: - Actions, gestures, tableViewActions
    
    
    // TODO: Actions
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    // TODO: Gestures
    
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        getFollowingChilderenLists()
        refreshControl.endRefreshing()
    }
    
    
    @objc func btnUnfollowTapped(sender: UIButton){
        print(sender.tag)
        _ = SweetAlert().showAlert(macroObj.appName, subTitle: "\(MacrosForAll.VALIDMESSAGE.UnfollowChild.rawValue.localized())\(self.followingChildrenList[sender.tag].name)!", style: AlertStyle.warning, buttonTitle:"Cancel".localized(), buttonColor:UIColor.colorFromRGB(0xD0D0D0) , otherButtonTitle:  "OK".localized(), otherButtonColor: UIColor.colorFromRGB(0xDD6B55)) { (isOtherButton) -> Void in
            if isOtherButton == true {
                print("Cancel Button  Pressed", terminator: "")
            }
            else
            {
                guard let childCUID = self.followingChildrenList[sender.tag].CUID as? String else{
                    print("No childCUID")
                    return
                }
                self.accessActivatedOrDeactivatedserviceOrDeleteService(serviceName:MacrosForAll.APINAME.followaction.rawValue,CUID:childCUID)
            }
            
        }
    }
    
}


/////////////////////////////////////////////////////

// MARK: - Table View Extension

extension ListOfFollowingChildrenVC:UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return followingChildrenList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.tblListFollowingChildren.register(UINib(nibName:"ListOfFollwingChildrenTableViewCell",bundle:nil), forCellReuseIdentifier: "ListOfFollwingChildrenTableViewCell")
        let cell = tblListFollowingChildren.dequeueReusableCell(withIdentifier: "ListOfFollwingChildrenTableViewCell", for: indexPath) as! ListOfFollwingChildrenTableViewCell
        cell.img_view_child.sd_setImage(with: URL(string: followingChildrenList[indexPath.row].image), placeholderImage: UIImage(named: "user_signup"))
        cell.lblChild_name.text = followingChildrenList[indexPath.row].name
        cell.lblChildCUID.text = followingChildrenList[indexPath.row].CUID
            if followingChildrenList[indexPath.row].child_flag == "1"{
                cell.btnUnfollowRef.isHidden = true
            }else{
                cell.btnUnfollowRef.isHidden = false
                cell.btnUnfollowRef.tag = indexPath.row
                cell.btnUnfollowRef.addTarget(self, action: #selector(btnUnfollowTapped), for: .touchUpInside)
            }
                
        return cell
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChildProfileVC") as! ChildProfileVC
        vc.children_id = followingChildrenList[indexPath.row].child_id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

// MARK: - Methods Extension
extension ListOfFollowingChildrenVC{
    func initialSetUP(){
        self.tblListFollowingChildren.addSubview(self.refreshControl)
       getFollowingChilderenLists()
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
        refreshControl.addTarget(self, action: #selector(ListOfFollowingChildrenVC.handleRefresh(_:)), for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor(red: 59.0/255, green: 208.0/255, blue: 214.0/255, alpha: 1.0)
        return refreshControl
    }
}


// MARK: - Web services Methods Extension
extension ListOfFollowingChildrenVC{
    
    
    // TODO: change password API
    
    func getFollowingChilderenLists(){
        if InternetConnection.internetshared.isConnectedToNetwork(){
            var user_id = String()
            if let userInfo = realm.objects(SignUpDataModel.self).first{
                user_id = userInfo.user_id
        
            }
            macroObj.showLoader(view: view)
            alamoFireObj.getRequestURL("\(MacrosForAll.APINAME.followinglist.rawValue)/\(user_id)", success: { (responseJASON) in
                self.macroObj.hideLoader(view: self.view)
                if responseJASON["status"].string == "SUCCESS"{
                    if self.followingChildrenList.count != 0{
                        self.followingChildrenList.removeAll()
                    }
                    if let responseArray = responseJASON["response"].arrayObject{
                        for post in responseArray{
                            if let postDict = post as? NSDictionary{
                                print(postDict)
                                
                                guard let child_id = postDict["child_id"] as? String else {
                                    print("No child_id")
                                    return
                                }
                                guard let image = postDict["image"] as? String else {
                                    print("No image")
                                    return
                                }
                                guard let name = postDict["name"] as? String else {
                                    print("No name")
                                    return
                                }
                                guard let CUID = postDict["CUID"] as? String else {
                                    print("No CUID")
                                    return
                                }
                                guard let SCUID = postDict["SCUID"] as? String else {
                                    print("No SCUID")
                                    return
                                }
                                guard let child_flag = postDict["child_flag"] as? String else {
                                    print("No child_flag")
                                    return
                                }
                                let followingItem = FollowingChildrenDataModel(child_id: child_id, image: image, name: name, CUID: CUID,SCUID:SCUID, child_flag: child_flag)
                                self.followingChildrenList.append(followingItem)
                            }
                        }
                        
                        self.tblListFollowingChildren.dataSource = self
                        self.tblListFollowingChildren.delegate = self
                        self.tblListFollowingChildren.reloadData()
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
    
    // TODO: Access activated or deactivated API
    
    func accessActivatedOrDeactivatedserviceOrDeleteService(serviceName:String,CUID:String){
        if InternetConnection.internetshared.isConnectedToNetwork(){
            var user_id = String()
            var token = String()
            if let userInfo = realm.objects(SignUpDataModel.self).first{
                user_id = userInfo.user_id
                token = userInfo.token
            }
            let passDict = ["follower_id":user_id,
                            "token":token,
                            "CUID":CUID] as [String:AnyObject]
            print(passDict)
            macroObj.showLoader(view: view)
            alamoFireObj.postRequestURL("\(serviceName)", params: passDict , headers: nil, success: { (responseJASON) in
                self.macroObj.hideLoader(view: self.view)
                if responseJASON["status"].string == "SUCCESS"{
                    let message = responseJASON["message"].string ?? ""
                    _ = SweetAlert().showAlert(self.macroObj.appName, subTitle: message, style: AlertStyle.success)
                            self.getFollowingChilderenLists()
                    
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

