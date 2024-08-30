//
//  CommentsVC.swift
//  Monami
//
//  Created by abc on 25/09/18.
//  Copyright © 2018 mobulous. All rights reserved.
//

import UIKit
import RealmSwift
import RSKPlaceholderTextView

class CommentsVC: UIViewController {
    
    
    // MARK: - Outlets
    @IBOutlet weak var tblComments: UITableView!
    
    @IBOutlet weak var imgViewBottom: UIImageView!
    
    @IBOutlet weak var txtFieldCommentRef: RSKPlaceholderTextView!
    
    /////////////////////////////////////////////////////
    
    // MARK: - Global variables
    
    var post_id = String()
    var commentList = [CommentDataModel]()
    let macroObj = MacrosForAll.sharedInstanceMacro
    let alamoFireObj = AlamofireWrapper.sharedInstance
    let validation:Validation = Validation.validationManager() as! Validation
    let realm = try! Realm()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var isComing = String()
    /////////////////////////////////////////////////////
    
    // MARK:- View life cycle methods
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initialSetUp()
    }
    /////////////////////////////////////////////////////
    
    // MARK: - User defined Methods
    
    // TODO: Methods
    
    
    
    
    // TODO: Web services
    
    
    /////////////////////////////////////////////////////
    
    // MARK: - Actions, gestures, tableViewActions
    
    
    // TODO: Actions
    
    @IBAction func btnBackTapped(_ sender: UIButton) {
        
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
    
    
    @IBAction func btnCommentTapped(_ sender: UIButton) {
        if txtFieldCommentRef.text != "" || txtFieldCommentRef.text != "Write your comment...".localized(){
            postCommentService(tag: sender.tag)
        }
    }
    
    
    // TODO: Gestures
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        commentsLists(isComing: "home", msg: "")
        refreshControl.endRefreshing()
    }
    @objc func reloadCommentApi(_ notification: Notification){
        commentsLists(isComing: "home", msg: "")
    }
    // TODO: TableView Actions
    
    @objc func btnDeleteCommentTapped(sender: UIButton){
        print(sender.tag)
        
        _ = SweetAlert().showAlert(macroObj.appName, subTitle: "\(MacrosForAll.VALIDMESSAGE.DeleteComment.rawValue.localized())!", style: AlertStyle.warning, buttonTitle:"Cancel".localized(), buttonColor:UIColor.colorFromRGB(0xD0D0D0) , otherButtonTitle:  "OK".localized(), otherButtonColor: UIColor.colorFromRGB(0xDD6B55)) { (isOtherButton) -> Void in
            if isOtherButton == true {
                print("Cancel Button  Pressed", terminator: "")
            }
            else
            {
                self.deleteCommentAPI(comment_id:self.commentList[sender.tag].comment_id, index: sender.tag)
            }
            
        }
    }
    
    @objc func btnEditCommentTapped(sender: UIButton){
        
        var textFeild = UITextField()
        
        let alert = UIAlertController(title: macroObj.appName, message: "Edit Comment".localized(), preferredStyle: .alert)
        let action = UIAlertAction(title: "Submit".localized(), style: .default) { (action) in
            
            if textFeild.text != ""{
                print(textFeild.text!)
                self.postEditedCommentService(comment_id: self.commentList[sender.tag].comment_id,message:textFeild.text!)
                
            }else{
                _ = SweetAlert().showAlert(self.macroObj.appName, subTitle: MacrosForAll.VALIDMESSAGE.CommentAlert.rawValue.localized(), style: .error)
            }
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel".localized(), style: .cancel,handler: nil)
        cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
        
        alert.addTextField { (alertTextFeild) in
            alertTextFeild.text = self.commentList[sender.tag].msg
            alertTextFeild.placeholder = "Write your comment...".localized()
            textFeild = alertTextFeild
        }
        alert.addAction(cancelAction)
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    
    
}
/////////////////////////////////////////////////////

// MARK: - methods extensions

extension CommentsVC{
    func initialSetUp(){
        txtFieldCommentRef.delegate = self
        ScreeNNameClass.shareScreenInstance.screenName = "CommentsVC"
        txtFieldCommentRef.text = "Write your comment...".localized() as String; NotificationCenter.default.addObserver(self,selector:#selector(CommentsVC.reloadCommentApi(_:)),name:NSNotification.Name(rawValue: "COMMENTNOTIFYRELOAD"),object: nil)
        
        if let userInfo = realm.objects(SignUpDataModel.self).first{
            imgViewBottom.sd_setImage(with: URL(string: userInfo.image), placeholderImage: UIImage(named: "user_signup"))
        }
        self.tblComments.addSubview(self.refreshControl)
        commentsLists(isComing: "home", msg: "")
    }
    var refreshControl: UIRefreshControl {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(CommentsVC.handleRefresh(_:)), for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor(red: 59.0/255, green: 208.0/255, blue: 214.0/255, alpha: 1.0)
        return refreshControl
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
    
    
    func scrollToBottom(){
        if commentList.count > 0{
            DispatchQueue.main.async {
                let indexPath = IndexPath(row: self.commentList.count-1, section: 0)
                self.tblComments.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }
    
    func isLoginUser(user_id:String)->Bool{
        var isCurrentUser = Bool()
        if let userInfo = realm.objects(SignUpDataModel.self).first{
            if userInfo.user_id == user_id{
                isCurrentUser = true
            }else{
                isCurrentUser = true
            }
        }
        return isCurrentUser
    }
}

/////////////////////////////////////////////////////

// MARK: - Web services extensions

extension CommentsVC{
    
    
    // TODO: comment list API
    
    func commentsLists(isComing:String,msg:String){
        if InternetConnection.internetshared.isConnectedToNetwork(){
            macroObj.showLoader(view: view)
            alamoFireObj.getRequestURL("\(MacrosForAll.APINAME.commentlist.rawValue)/\(post_id)", success: { (responseJASON) in
                self.macroObj.hideLoader(view: self.view)
                if responseJASON["status"].string == "SUCCESS"{
                    if self.commentList.count != 0{
                        self.commentList.removeAll()
                    }
                    if let responseArray = responseJASON["response"].arrayObject{
                        for comment in responseArray{
                            if let commentDict = comment as? NSDictionary{
                                print(commentDict)
                                
                                guard let image = commentDict["image"] as? String else {
                                    print("No image")
                                    return
                                }
                                guard let name = commentDict["name"] as? String else {
                                    print("No name")
                                    return
                                }
                                guard let msg = commentDict["msg"] as? String else {
                                    print("No msg")
                                    return
                                }
                                guard let time = commentDict["time"] as? String else {
                                    print("No time")
                                    return
                                }
                                guard let comment_id = commentDict["comment_id"] as? String else {
                                    print("No comment_id")
                                    return
                                }
                                guard let user_id = commentDict["user_id"] as? String else {
                                    print("No user_id")
                                    return
                                }
                                let commentItem = CommentDataModel(image: image, name: name, msg: msg, time: time, comment_id: comment_id, user_id: user_id)
                                print(commentItem.image)
                                self.commentList.append(commentItem)
                            }
                        }
                        if isComing == "home"{
                                self.tblComments.dataSource = self
                                self.tblComments.delegate = self
                                self.tblComments.reloadData()
                                self.scrollToBottom()
                        }else if isComing == "post_comment"{
                            self.tblComments.dataSource = self
                            self.tblComments.delegate = self
                            self.tblComments.reloadData()
                            self.navigationController?.popViewController(animated: true)
                        }else{
                            _ = SweetAlert().showAlert(self.macroObj.appName, subTitle: msg, style: AlertStyle.success)
                            self.tblComments.dataSource = self
                            self.tblComments.delegate = self
                            self.tblComments.reloadData()
                        }
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
    
    
    func postCommentService(tag: Int){
        if InternetConnection.internetshared.isConnectedToNetwork(){
            var user_id = String()
            var token = String()
            if let userInfo = realm.objects(SignUpDataModel.self).first{
                user_id = userInfo.user_id
                token = userInfo.token
            }
            
            let passDict = ["user_id":user_id,
                            "token":token,
                            "post_id":post_id,
                            "msg":txtFieldCommentRef.text!] as [String:AnyObject]
            print(passDict)
            macroObj.showLoader(view: view)
            alamoFireObj.postRequestURL(MacrosForAll.APINAME.commentonpost.rawValue, params: passDict , headers: nil, success: { (responseJASON) in
                self.macroObj.hideLoader(view: self.view)
                if responseJASON["status"].string == "SUCCESS"{
                    print(responseJASON)
                    self.commentsLists(isComing: "post_comment", msg: "")
                    
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
    
    
    
    func deleteCommentAPI(comment_id:String,index:Int){
        if InternetConnection.internetshared.isConnectedToNetwork(){
            macroObj.showLoader(view: view)
            alamoFireObj.getRequestURL("\(MacrosForAll.APINAME.deletecomment.rawValue)/\(comment_id)", success: { (responseJASON) in
                self.macroObj.hideLoader(view: self.view)
                if responseJASON["status"].string == "SUCCESS"{
                    print(responseJASON)
                    guard let message = responseJASON["message"].string else{
                        print("NO message")
                        return
                    }
                    
                    self.commentList.remove(at: index)
                    self.tblComments.reloadData()
                    _ = SweetAlert().showAlert(self.macroObj.appName, subTitle: message, style: AlertStyle.success)
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
    
    
    func postEditedCommentService(comment_id:String,message:String){
        if InternetConnection.internetshared.isConnectedToNetwork(){
            var user_id = String()
            var token = String()
            if let userInfo = realm.objects(SignUpDataModel.self).first{
                user_id = userInfo.user_id
                token = userInfo.token
            }
            
            let passDict = ["user_id":user_id,
                            "token":token,
                            "post_id":post_id,
                            "msg":message] as [String:AnyObject]
            print(passDict)
            macroObj.showLoader(view: view)
            alamoFireObj.postRequestURL("\(MacrosForAll.APINAME.editcomment.rawValue)/\(comment_id)", params: passDict , headers: nil, success: { (responseJASON) in
                self.macroObj.hideLoader(view: self.view)
                if responseJASON["status"].string == "SUCCESS"{
                    print(responseJASON)
                    guard let message = responseJASON["message"].string else{
                        print("NO message")
                        return
                    }
                    self.commentsLists(isComing: "edit_comment", msg: message)
                    
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

extension CommentsVC:UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.tblComments.register(UINib(nibName:"CommentsTableViewCell",bundle:nil), forCellReuseIdentifier: "CommentsTableViewCell")
        let cell = tblComments.dequeueReusableCell(withIdentifier: "CommentsTableViewCell", for: indexPath) as! CommentsTableViewCell
        cell.imgViewProfile.sd_setImage(with: URL(string: commentList[indexPath.row].image), placeholderImage: UIImage(named: "user_signup"))
        cell.lblCommnet.text = commentList[indexPath.row].msg
        cell.lblName.text = commentList[indexPath.row].name
        cell.lblTimeStamp.text = commentList[indexPath.row].time
        if isLoginUser(user_id: commentList[indexPath.row].user_id){
            cell.btnDeleteRef.isHidden = false
            cell.btnDeleteRef.tag = indexPath.row
            cell.btnDeleteRef.addTarget(self, action: #selector(btnDeleteCommentTapped), for: .touchUpInside)
            cell.btnEditCommentRef.isHidden = false
            cell.btnEditCommentRef.tag = indexPath.row
            cell.btnEditCommentRef.addTarget(self, action: #selector(btnEditCommentTapped), for: .touchUpInside)
        }else{
            cell.btnEditCommentRef.isHidden = true
            cell.btnDeleteRef.isHidden = true
        }
        return cell
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

extension CommentsVC: UITextViewDelegate {
    
    //for limiting the Character to 250 in textView.
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.characters.count // for Swift use count(newText)
        return numberOfChars < 450;
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if txtFieldCommentRef.text == "Write your comment...".localized() {
            txtFieldCommentRef.text = ""
        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if txtFieldCommentRef.text == "" {
            txtFieldCommentRef.text = "Write your comment...".localized()
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
