//
//  ChatVC.swift
//  Monami
//
//  Created by abc on 24/09/18.
//  Copyright © 2018 mobulous. All rights reserved.
//

import UIKit
import RealmSwift
import RSKPlaceholderTextView

class ChatVC: UIViewController {
    
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var tblChat: UITableView!
    @IBOutlet weak var txtFieldMsgRef: RSKPlaceholderTextView!
    
    
    /////////////////////////////////////////////////////
    
    // MARK: - Global variables
    
    var chatList = [MessageDataModel]()
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

    
    
    
    // MARK: - Actions, gestures, tableViewActions
    
    
    // TODO: Actions
    
    @IBAction func btnBackTappd(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    @IBAction func btnSendTapped(_ sender: UIButton) {
        if txtFieldMsgRef.text != "" || txtFieldMsgRef.text != "Write your message...".localized(){
            sendMessgeService()
        }
    }
    // TODO: Gestures
    @objc func reloadChatApi(_ notification: Notification){
        chatLists()
    }
    
    // TODO: TableView Actions
    
    
    
}
/////////////////////////////////////////////////////

// MARK: - Methods Extension

extension ChatVC{
    func initialMethod(){
        ScreeNNameClass.shareScreenInstance.screenName = "ChatVC"
        self.scrollToBottom()
        txtFieldMsgRef.text = "Write your message...".localized() as String;
        txtFieldMsgRef.delegate = self
        NotificationCenter.default.addObserver(self,selector:#selector(ChatVC.reloadChatApi(_:)),name:NSNotification.Name(rawValue: "CHATNOTIFYRELOAD"),object: nil)
        self.tabBarController?.tabBar.isHidden = true
        self.tblChat.tableFooterView = UIView()
        chatLists()
    }
    func scrollToBottom(){
        if chatList.count > 0{
            DispatchQueue.main.async {
                let indexPath = IndexPath(row: self.chatList.count-1, section: 0)
                self.tblChat.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
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


/////////////////////////////////////////////////////

// MARK: - Web services extensions

extension ChatVC{
    
    // TODO: comment list API
    
    func chatLists(){
        if InternetConnection.internetshared.isConnectedToNetwork(){
            macroObj.showLoader(view: view)
            var user_id = String()
            if let userInfo = realm.objects(SignUpDataModel.self).first{
                user_id = userInfo.user_id
            }
            alamoFireObj.getRequestURL("\(MacrosForAll.APINAME.chatlist.rawValue)/\(user_id)", success: { (responseJASON) in
                self.macroObj.hideLoader(view: self.view)
                
                print(responseJASON)
                
                if responseJASON["status"].string == "SUCCESS"{
                    if self.chatList.count != 0{
                        self.chatList.removeAll()
                    }
                    if let responseArray = responseJASON["response"].arrayObject{
                        for chat in responseArray{
                            if let chatDict = chat as? NSDictionary{
                                print(chatDict)
                                guard let flag = chatDict["flag"] as? String else {
                                    print("No flag")
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
                                let chatItem = MessageDataModel(time: timeTranlated, msg: msg, flag: flag)
                                self.chatList.append(chatItem)
                            }
                        }
      
                            self.tblChat.dataSource = self
                            self.tblChat.delegate = self
                            self.tblChat.reloadData()
                            self.scrollToBottom()
             
                        
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
    
    
    func sendMessgeService(){
        if InternetConnection.internetshared.isConnectedToNetwork(){
            var user_id = String()
            var token = String()
            if let userInfo = realm.objects(SignUpDataModel.self).first{
                user_id = userInfo.user_id
                token = userInfo.token
            }
            
            let passDict = ["parent_id":user_id,
                            "token":token,
                            "msg":txtFieldMsgRef.text!] as [String:AnyObject]
            print(passDict)
            macroObj.showLoader(view: view)
            alamoFireObj.postRequestURL(MacrosForAll.APINAME.sendmsg.rawValue, params: passDict , headers: nil, success: { (responseJASON) in
                self.macroObj.hideLoader(view: self.view)
                if responseJASON["status"].string == "SUCCESS"{
                    print(responseJASON)
                    self.txtFieldMsgRef.text! = ""
                    self.chatLists()
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


/////////////////////////////////////////////////////

// MARK: - Table View Extension

extension ChatVC:UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if chatList[indexPath.row].flag == "1"{
           
            self.tblChat.register(UINib(nibName:"SenderChatTableViewCell",bundle:nil), forCellReuseIdentifier: "SenderChatTableViewCell")
            let cell = tblChat.dequeueReusableCell(withIdentifier: "SenderChatTableViewCell", for: indexPath) as! SenderChatTableViewCell
            cell.lblMessageBody.text = chatList[indexPath.row].msg
            cell.lblTimeStamp.text = chatList[indexPath.row].time
            return cell
            
        }else{
            
            self.tblChat.register(UINib(nibName:"RecieverChatTableViewCell",bundle:nil), forCellReuseIdentifier: "RecieverChatTableViewCell")
            let cell = tblChat.dequeueReusableCell(withIdentifier: "RecieverChatTableViewCell", for: indexPath) as! RecieverChatTableViewCell
            cell.lblMessageBody.text = chatList[indexPath.row].msg
            cell.lblTimeStamp.text = chatList[indexPath.row].time
            
            return cell
        }
    

    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}



//MARK:- UITextFields Delegates
//MARK:-

extension ChatVC: UITextViewDelegate {
    
    //for limiting the Character to 250 in textView.
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.characters.count // for Swift use count(newText)
        return numberOfChars < 450;
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if txtFieldMsgRef.text == "Write your message...".localized() {
            txtFieldMsgRef.text = ""
        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if txtFieldMsgRef.text == "" {
            txtFieldMsgRef.text = "Write your message...".localized()
        }
        
    }
    
    func validationForDetailText(inputstring: String)->Bool{
        
        do {
            let regex = try NSRegularExpression(pattern: "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{2,450}$", options: .caseInsensitive)
            
            if let _ = regex.firstMatch(in: inputstring, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSMakeRange(0, inputstring.count)) {
                return true
            }
            
        } catch {
            debugPrint(error.localizedDescription)
            return false
        }
        
        return false
        
    }
    
    
}


