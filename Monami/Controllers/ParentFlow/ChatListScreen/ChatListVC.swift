//
//  ChatListVC.swift
//  Monami
//
//  Created by abc on 12/10/18.
//  Copyright © 2018 mobulous. All rights reserved.
//

import UIKit
import RealmSwift

class ChatListVC: UIViewController {
    // MARK: - Outlets
    
    @IBOutlet weak var tblChat: UITableView!
    @IBOutlet weak var lblHeader: UILabel!

    /////////////////////////////////////////////////////
    
    // MARK: - Global variables
    
    var chatList = [CommentDataModel]()
    let macroObj = MacrosForAll.sharedInstanceMacro
    let alamoFireObj = AlamofireWrapper.sharedInstance
    let realm = try! Realm()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    /////////////////////////////////////////////////////
    
    // MARK:- View life cycle methods
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialMethod()
        
        // Do any additional setup after loading the view.
    }

    
    override func viewWillAppear(_ animated: Bool) {
        lblHeader.text = "My Chat".localized()
        self.tabBarController?.tabBar.items?[0].title = "Home".localized()
        self.tabBarController?.tabBar.items?[1].title = "My Chat".localized()
        self.tabBarController?.tabBar.items?[2].title = "Notifications".localized()
        self.tabBarController?.tabBar.items?[3].title = "Profile".localized()
    }
    
    // MARK: - Actions, gestures, tableViewActions
    
    
    // TODO: Actions
    
    @IBAction func btnBackTappd(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarVC") as! TabBarVC
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    // TODO: Gestures
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        chatLists()
        refreshControl.endRefreshing()
    }
    
    @objc func reloadChatListApi(_ notification: Notification){
        chatLists()
    }
    // TODO: TableView Actions
    
    
    
}


/////////////////////////////////////////////////////

// MARK: - Methods Extension

extension ChatListVC{
    func initialMethod(){
        ScreeNNameClass.shareScreenInstance.screenName = "ChatListVC"
        NotificationCenter.default.addObserver(self,selector:#selector(ChatListVC.reloadChatListApi(_:)),name:NSNotification.Name(rawValue: "CHATLISTNOTIFYRELOAD"),object: nil)
        self.tblChat.addSubview(self.refreshControl)
        
        self.tblChat.tableFooterView = UIView()
        chatLists()
    }
    var refreshControl: UIRefreshControl {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(ChatListVC.handleRefresh(_:)), for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor(red: 59.0/255, green: 208.0/255, blue: 214.0/255, alpha: 1.0)
        return refreshControl
    }
}

/////////////////////////////////////////////////////

// MARK: - Table View Extension

extension ChatListVC:UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.tblChat.register(UINib(nibName:"ChatListTableViewCell",bundle:nil), forCellReuseIdentifier: "ChatListTableViewCell")
        let cell = tblChat.dequeueReusableCell(withIdentifier: "ChatListTableViewCell", for: indexPath) as! ChatListTableViewCell
        cell.lblMessageBody.text = chatList[indexPath.row].msg
        cell.imgViewProfile.sd_setImage(with: URL(string: chatList[indexPath.row].image), placeholderImage: UIImage(named: "user_signup"))
        cell.lblName.text = chatList[indexPath.row].name
        cell.lblTimeStamp.text = chatList[indexPath.row].time
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}


/////////////////////////////////////////////////////

// MARK: - Web services extensions

extension ChatListVC{

    // TODO: chat list API
    
    func chatLists(){
        if InternetConnection.internetshared.isConnectedToNetwork(){
            macroObj.showLoader(view: view)
            var user_id = String()
            if let userInfo = realm.objects(SignUpDataModel.self).first{
                user_id = userInfo.user_id
            }
            alamoFireObj.getRequestURL("\(MacrosForAll.APINAME.commonsection.rawValue)/\(user_id)", success: { (responseJASON) in
                self.macroObj.hideLoader(view: self.view)
                
                print(responseJASON)
                
                if responseJASON["status"].string == "SUCCESS"{
                    if self.chatList.count != 0{
                        self.chatList.removeAll()
                    }
                    if let chatDict = responseJASON["response"].dictionaryObject{
                                guard let image = chatDict["image"] as? String else {
                                    print("No image")
                                    return
                                }
                                guard let name = chatDict["name"] as? String else {
                                    print("No name")
                                    return
                                }
                                guard let msg = chatDict["msg"] as? String else {
                                    print("No msg")
                                    return
                                }
                                guard let time = chatDict["time"] as? String else {
                                    print("No time")
                                    return
                                }
                        
                        var timeArray = time.components(separatedBy: " ")
                        timeArray = timeArray.flatMap { $0.localized() as? String }
                        print(timeArray)
                        let timeTranlated = timeArray.joined(separator: " ")
                        let chatItem = CommentDataModel(image: image, name: name, msg: msg, time: timeTranlated, comment_id: "comment_id", user_id: "user_id")
                                self.chatList.append(chatItem)
                        self.tblChat.dataSource = self
                        self.tblChat.delegate = self
                        self.tblChat.reloadData()
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

