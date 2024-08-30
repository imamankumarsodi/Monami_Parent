//
//  NotificationVC.swift
//  Monami
//
//  Created by abc on 24/09/18.
//  Copyright © 2018 mobulous. All rights reserved.
//

import UIKit
import RealmSwift
import SDWebImage

class NotificationVC: UIViewController {
    // MARK: - Outlets
    
    @IBOutlet weak var tblNotification: UITableView!
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var btnNavigationRef: UIButton!
    
    /////////////////////////////////////////////////////
    
    // MARK: - Global variables
    let realm = try! Realm()
    let macroObj = MacrosForAll.sharedInstanceMacro
    let alamoFireObj = AlamofireWrapper.sharedInstance
    var notificationLists = [NotificationDataModel]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    /////////////////////////////////////////////////////
    
    // MARK:- View life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        lblHeader.text = "Notifications".localized()
        self.tabBarController?.tabBar.items?[0].title = "Home".localized()
        self.tabBarController?.tabBar.items?[1].title = "My Chat".localized()
        self.tabBarController?.tabBar.items?[2].title = "Notifications".localized()
        self.tabBarController?.tabBar.items?[3].title = "Profile".localized()

    }
    
    /////////////////////////////////////////////////////
    
    // MARK: - User defined Methods
    
    // TODO: Methods
    
    var refreshControl: UIRefreshControl {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(NotificationVC.handleRefresh(_:)), for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor(red: 59.0/255, green: 208.0/255, blue: 214.0/255, alpha: 1.0)
        return refreshControl
    }
    
    
    // TODO: Web services
    
    
    /////////////////////////////////////////////////////
    
    // MARK: - Actions, gestures, tableViewActions
    
    
    // TODO: Actions
    
    @IBAction func btnNavigationTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // TODO: Gestures
    @objc func reloadNotificationApi(_ notification: Notification){
        notificationList()
    }
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        notificationList()
        refreshControl.endRefreshing()
    }
    // TODO: TableView Actions
    
    
    
}
//MARK: - Method extension
extension NotificationVC{
    
    func initialSetup(){
        if let userInfo = realm.objects(SignUpDataModel.self).first{
            print(userInfo.type)
            if userInfo.type == "parent"{
                btnNavigationRef.isHidden = true
                self.tabBarController?.tabBar.isHidden = false
            }else if userInfo.type == "family"{
                btnNavigationRef.isHidden = false
                self.tabBarController?.tabBar.isHidden = true
            }else{
                print("Do nothing")
            }
        }
        ScreeNNameClass.shareScreenInstance.screenName = "NotificationVC"
        NotificationCenter.default.addObserver(self,selector:#selector(NotificationVC.reloadNotificationApi(_:)),name:NSNotification.Name(rawValue: "NOTIFICATIONLISTNOTIFYRELOAD"),object: nil)
        self.tblNotification.addSubview(self.refreshControl)
        self.tblNotification.tableFooterView = UIView()
        notificationList()
    }
   
}
//MARK: - Web services extension
extension NotificationVC{
    // TODO: comment list API
    
    func notificationList(){
        if InternetConnection.internetshared.isConnectedToNetwork(){
            macroObj.showLoader(view: view)
            var user_id = String()
            if let userInfo = realm.objects(SignUpDataModel.self).first{
                user_id = userInfo.user_id
            }
            alamoFireObj.getRequestURL("\(MacrosForAll.APINAME.notificationList.rawValue)/\(user_id)", success: { (responseJASON) in
                self.macroObj.hideLoader(view: self.view)
                if responseJASON["status"].string == "SUCCESS"{
                    if self.notificationLists.count > 0{
                        self.notificationLists.removeAll()
                    }
                    print("Handle response notification")
                    if let notificationArray = responseJASON["response"].arrayObject as? NSArray{
                        for item in notificationArray{
                            if let dataDict = item as? NSDictionary{
                                guard let image = dataDict.value(forKey: "image") as? String else{
                                    print("No image")
                                    return
                                }
                                guard let msg = dataDict.value(forKey: "msg") as? String else{
                                    print("No msg")
                                    return
                                }
                                guard let time = dataDict.value(forKey: "time") as? String else{
                                    print("No time")
                                    return
                                }
                                
                                var timeArray = time.components(separatedBy: " ")
                                timeArray = timeArray.flatMap { $0.localized() as? String }
                                print(timeArray)
                                let timeTranlated = timeArray.joined(separator: " ")
                                guard let type = dataDict.value(forKey: "type") as? String else{
                                    print("No type")
                                    return
                                }
                                guard let child_id = dataDict.value(forKey: "child_id") as? String else{
                                    print("No child_id")
                                    return
                                }
                                guard let post_id = dataDict.value(forKey: "post_id") as? String else{
                                    print("No post_id")
                                    return
                                }
                                let notiItem = NotificationDataModel(image: image, msg: msg, time: timeTranlated,type: type, child_id: child_id, post_id: post_id)
                                self.notificationLists.append(notiItem)
                            }
                        }
                        self.tblNotification.reloadData()
                    }
             
                }else{
                    self.macroObj.hideLoader(view: self.view)
                    if let message = responseJASON["message"].string as? String{
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

/////////////////////////////////////////////////////

// MARK: - Table View Extension

extension NotificationVC:UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        self.tblNotification.register(UINib(nibName:"NotificationCellAndXib",bundle:nil), forCellReuseIdentifier: "NotificationCellAndXib")
        let cell = tblNotification.dequeueReusableCell(withIdentifier: "NotificationCellAndXib", for: indexPath) as! NotificationCellAndXib
        cell.lblNotification.text = notificationLists[indexPath.row].msg.localized()
        cell.lblTime.text = notificationLists[indexPath.row].time
        cell.imgViewNotification.sd_setImage(with: URL(string: notificationLists[indexPath.row].image), placeholderImage: UIImage(named: "user_signup"))
        return cell
        
        
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type = notificationLists[indexPath.row].type
        if type == "pav"{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarVC") as! TabBarVC
            let navController = UINavigationController(rootViewController: vc)
            navController.navigationBar.isHidden = true
            self.appDelegate.window?.rootViewController = navController
            self.appDelegate.window?.makeKeyAndVisible()
        }else if type == "chat"{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "TabBarVC") as! TabBarVC
            let nav = UINavigationController(rootViewController: vc)
            nav.isNavigationBarHidden = true
            vc.selectedIndex = 1
            (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController = nav
        }else if type == "report"{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ReportsVC") as! ReportsVC
            vc.children_id = notificationLists[indexPath.row].child_id
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else if type == "follow"{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ManageFamilyVC") as! ManageFamilyVC
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommentsVC") as! CommentsVC
            vc.post_id = notificationLists[indexPath.row].post_id
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}


