//
//  ChildProfileVC.swift
//  Monami
//
//  Created by abc on 25/09/18.
//  Copyright © 2018 mobulous. All rights reserved.
//

import UIKit
import RealmSwift
import SDWebImage
import AVKit
import AVFoundation

class ChildProfileVC: UIViewController {
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var tblChildProfile: UITableView!
    
    @IBOutlet weak var btnsStackview: UIStackView!
    
    @IBOutlet weak var imgViewChild: UIImageView!
    
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblCUID: UILabel!
    /////////////////////////////////////////////////////
    
    // MARK: - Global variables
    let macroObj = MacrosForAll.sharedInstanceMacro
    let alamoFireObj = AlamofireWrapper.sharedInstance
    let validation:Validation = Validation.validationManager() as! Validation
    var children_id = String()
    let realm = try! Realm()
    var postList = [PostDataModel]()
    var flag = String()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    /////////////////////////////////////////////////////
    
    // MARK:- View life cycle methods
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        // Do any additional setup after loading the view.
    }
    
    
    /////////////////////////////////////////////////////
    
    // MARK: - Actions, gestures, tableViewActions
    
    
    // TODO: Actions
    
    
    @IBAction func btnBackTappedNew(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnReportTappedNew(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ReportsVC") as! ReportsVC
        vc.children_id = children_id
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    @IBAction func btnMenuTappedNew(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MenuVC") as! MenuVC
        vc.children_id = children_id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    // TODO: Gestures
    
    
    // TODO: TableView Actions
    @objc func btnShareRefTapped(sender: UIButton){
        print(sender.tag)
        
            if postList[sender.tag].post_type == "image"{
                shareApp(media: "image", link: postList[sender.tag].post_media)
                
            }else if postList[sender.tag].post_type == "video"{
                shareApp(media: "video", link: postList[sender.tag].post_media)
                
            }else{
                shareApp(media: "audio", link: postList[sender.tag].post_media)
                
            }
        
        
    }
    
    func shareApp(media: String, link: String) {
        let items: [Any] = ["Check this".localized() + " \(media.localized()) \n\n\n" + "\(link)"]
        
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        
        ac.completionWithItemsHandler = { (activity, success, items, error) in
            print(success ? "SUCCESS!" : "FAILURE")
            
            //            if success == true {
            //
            //                if activity == UIActivityType.postToFacebook {
            //                    self.shareAppAPICall(shareWith: "facebook")
            //                }
            //                else if activity == UIActivityType.postToTwitter {
            //                    self.shareAppAPICall(shareWith: "twitter")
            //                }
            //                else if activity == UIActivityType.mail {
            //                    self.shareAppAPICall(shareWith: "mail")
            //                }
            //                else {
            //                    self.shareAppAPICall(shareWith: "Others")
            //                }
            //
            //            }
            //            else {
            //                print("NOT SUCCESS")
            //            }
            
            
        }
        present(ac, animated: true)
    }
    
    @objc func btnDeleteRefTapped(sender: UIButton){
        print(sender.tag)
        let name = postList[sender.tag].children_name
        let postID = postList[sender.tag].post_id
          
        _ = SweetAlert().showAlert(macroObj.appName, subTitle: "\(MacrosForAll.VALIDMESSAGE.DeletePost.rawValue.localized())\(name)!", style: AlertStyle.warning, buttonTitle:"Cancel".localized(), buttonColor:UIColor.colorFromRGB(0xD0D0D0) , otherButtonTitle:  "OK".localized(), otherButtonColor: UIColor.colorFromRGB(0xDD6B55)) { (isOtherButton) -> Void in
            if isOtherButton == true {
                print("Cancel Button  Pressed", terminator: "")
            }
            else
            {
                self.deletePostService(post_id:postID)
            }
            
        }
    }
    
    @objc func btnDownloadRefTapped(sender: UIButton){
        print(sender.tag)
            downloadImageInGallary(imageUrl:postList[sender.tag].post_media)
    }
    
    @objc func btnCommentTapped(sender: UIButton){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommentsVC") as! CommentsVC
        vc.post_id = postList[sender.tag].post_id
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        childProfileAPI()
        refreshControl.endRefreshing()
    }
    
    @objc func cellBtnPlayTapped(sender: UIButton){
        if postList[sender.tag].post_type == "image"{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ShowImageVC") as! ShowImageVC
            vc.imageUrl = postList[sender.tag].post_media
            self.navigationController?.pushViewController(vc, animated: true)
        }else if postList[sender.tag].post_type == "video"{
            let avPlayerViewController = AVPlayerViewController()
            var avPlayer:AVPlayer? = nil
            let url = URL(string: postList[sender.tag].post_media)
            avPlayer = AVPlayer.init(url: url!)
            avPlayerViewController.player = avPlayer
            print("downloadUrl obtained and set")
            self.present(avPlayerViewController, animated: true) { () -> Void in
                avPlayerViewController.player?.play()
            }
        }else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PlayAudioVC") as! PlayAudioVC
            vc.audioURLString = postList[sender.tag].post_media
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

// MARK: - Methods Extension

extension ChildProfileVC{
    
    func initialSetup(){
        
        self.tblChildProfile.tableFooterView = UIView()
        self.tblChildProfile.addSubview(self.refreshControl)
       childProfileAPI()
    }
    func downloadImageInGallary(imageUrl:String){
        let yourImageURLString = imageUrl
        
        guard let yourImageURL = URL(string: yourImageURLString) else { return }
        
        getDataFromUrl(url: yourImageURL) { (data, response, error) in
            
            guard let data = data, let imageFromData = UIImage(data: data) else { return }
            
            DispatchQueue.main.async() {
                UIImageWriteToSavedPhotosAlbum(imageFromData, nil, nil, nil)
                let alert = UIAlertController(title: "Saved".localized(), message: "Your image has been saved".localized(), preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok".localized(), style: .default)
                alert.addAction(okAction)
                self.present(alert, animated: true)
            }
        }
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    func updateUI(){
        if let userInfo = realm.objects(SignUpDataModel.self).first{
            print(userInfo.type)
            if userInfo.type == "parent"{
                if flag == "family"{
                    btnsStackview.isHidden = true
                }else{
                    btnsStackview.isHidden = false
                }
            }else if userInfo.type == "family"{
                btnsStackview.isHidden = true
            }else{
                print("Do nothing")
            }
        }
        self.tblChildProfile.reloadData()
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
        refreshControl.addTarget(self, action: #selector(ChildProfileVC.handleRefresh(_:)), for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor(red: 59.0/255, green: 208.0/255, blue: 214.0/255, alpha: 1.0)
        return refreshControl
    }
}

// MARK: - Web services extension
extension ChildProfileVC{
    
    
    func deletePostService(post_id:String){
        if InternetConnection.internetshared.isConnectedToNetwork(){
            var user_id = String()
            var token = String()
            if let userInfo = realm.objects(SignUpDataModel.self).first{
                user_id = userInfo.user_id
                token = userInfo.token
            }
            let passDict = ["user_id":user_id,
                            "post_id":post_id,
                            "token":token] as [String:AnyObject]
            print(passDict)
            macroObj.showLoader(view: view)
            alamoFireObj.postRequestURL(MacrosForAll.APINAME.deletepostbyparent.rawValue, params: passDict , headers: nil, success: { (responseJASON) in
                self.macroObj.hideLoader(view: self.view)
                if responseJASON["status"].string == "SUCCESS"{
                    self.childProfileAPI()
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
    
    
    
    
    
    func childProfileAPI(){
        var user_id = String()
        if let userInfo = realm.objects(SignUpDataModel.self).first{
            print(userInfo.user_id)
            user_id = userInfo.user_id
        }
        
        if InternetConnection.internetshared.isConnectedToNetwork(){
            macroObj.showLoader(view: view)
            alamoFireObj.getRequestURL("\(MacrosForAll.APINAME.childprofile.rawValue)/\(children_id)/\(user_id)", success: { (responseJASON) in
                self.macroObj.hideLoader(view: self.view)
                if responseJASON["status"].string == "SUCCESS"{
            
                    if self.postList.count > 0{
                        self.postList.removeAll()
                    }
                    if let responseDict = responseJASON["response"].dictionaryObject{
                        guard let name = responseDict["name"] as? String else {
                            print("No name")
                            return
                        }
                        guard let CUID = responseDict["CUID"] as? String else {
                            print("No CUID")
                            return
                        }
                        guard let image = responseDict["image"] as? String else {
                            print("No image")
                            return
                        }
                        guard let flag = responseDict["flag"] as? String else {
                            print("No flag")
                            return
                        }
                        guard let report_list = responseDict["report_list"] as? NSArray else {
                            print("No report_list")
                            return
                        }
                        guard let menu_list = responseDict["menu_list"] as? NSArray else {
                            print("No menu_list")
                            return
                        }
                        guard let post_list = responseDict["post_list"] as? NSArray else {
                            print("No post_list")
                            return
                        }
                      
                        
                        
                        for item in post_list{
                          if let postDict = item as? NSDictionary{
                            guard let post_id = postDict.value(forKey: "post_id") as? String else {
                                print("No post_id")
                                return
                            }
                            guard let post_media = postDict.value(forKey: "post_media") as? String else {
                                print("No post_media")
                                return
                            }
                            guard let post_type = postDict.value(forKey: "post_type") as? String else {
                                print("No post_type")
                                return
                            }
                            guard let children_image = postDict.value(forKey: "children_image") as? String else {
                                print("No children_image")
                                return
                            }
                            guard let children_name = postDict.value(forKey: "children_name") as? String else {
                                print("No children_name")
                                return
                            }
                            guard let children_cuid = postDict.value(forKey: "children_cuid") as? String else {
                                print("No children_cuid")
                                return
                            }
                            guard let post_descrption = postDict.value(forKey: "post_descrption") as? String else {
                                print("No post_descrption")
                                return
                            }
                            guard let children_id = postDict.value(forKey: "children_id") as? String else {
                                print("No children_id")
                                return
                            }
                            guard let thumbnail = postDict.value(forKey: "thumbnail") as? String else {
                                print("No thumbnail")
                                return
                            }
                            guard let created_on = postDict.value(forKey: "created_on") as? String else {
                                print("No created_on")
                                return
                            }
                            
                            var timeArray = created_on.components(separatedBy: " ")
                            timeArray = timeArray.flatMap { $0.localized() as? String }
                            print(timeArray)
                            let timeTranlated = timeArray.joined(separator: " ")
                            
                            guard let display_flag = postDict.value(forKey: "display_flag") as? String else {
                                print("No display_flag")
                                return
                            }
                           
                            let postItem = PostDataModel(post_id: post_id, post_media: post_media, post_type: post_type, children_image: children_image, children_name: children_name, children_cuid: children_cuid, post_descrption: post_descrption, children_id: children_id, thumbnail: thumbnail, created_on: timeTranlated, display_flag:display_flag, type: "")
                            self.postList.append(postItem)
                          }else{
                            print("Aman")
                            }
                        }
                        print(self.postList.count)
                        
                        self.lblName.text = name
                        self.lblCUID.text = CUID
                        self.flag = flag
                        self.imgViewChild.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "user_signup"))
                        self.updateUI()
                        
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


/////////////////////////////////////////////////////

// MARK: - Table View Extension

extension ChildProfileVC:UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        self.tblChildProfile.register(UINib(nibName:"HomeTableViewCell",bundle:nil), forCellReuseIdentifier: "HomeTableViewCell")
        let cell = tblChildProfile.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
      
        cell.lblDescription.text = postList[indexPath.row].post_descrption
        cell.img_view_child.sd_setImage(with: URL(string: postList[indexPath.row].children_image), placeholderImage: UIImage(named: "user_signup"))
        cell.lblChild_name.text = postList[indexPath.row].children_name
        cell.lblChildCUID.text = postList[indexPath.row].children_cuid
        cell.lblDateTime.text = postList[indexPath.row].created_on
     
        
        if let media_type = postList[indexPath.row].post_type as? String{
            if media_type == "video"{
                cell.imgViewPlay.isHidden = false
                cell.image_Post.sd_setImage(with: URL(string: postList[indexPath.row].thumbnail), placeholderImage: UIImage(named: "user_signup"))
                cell.btnDownloadRef.isHidden = true
            }else if media_type == "audio"{
                cell.imgViewPlay.isHidden = true
                cell.image_Post.image = #imageLiteral(resourceName: "audio")
                cell.btnDownloadRef.isHidden = true
            }else{
                cell.imgViewPlay.isHidden = true
                cell.image_Post.sd_setImage(with: URL(string: postList[indexPath.row].post_media), placeholderImage: UIImage(named: "user_signup"))
                if let userInfo = realm.objects(SignUpDataModel.self).first{
                    if userInfo.type == "parent"{
                        if postList[indexPath.row].display_flag == "1"{
                            cell.btnDownloadRef.tag = indexPath.row
                            cell.btnDownloadRef.isHidden = false
                            cell.btnDownloadRef.addTarget(self, action: #selector(btnDownloadRefTapped), for: .touchUpInside)
                        }else{
                            cell.btnDownloadRef.isHidden = true
                        }
                        
                    }else{
                        cell.btnDownloadRef.isHidden = true
                    }
                }
            }
        }
      
        
        
        
        cell.btnCommentRef.tag = indexPath.row
        cell.btnCommentRef.addTarget(self, action: #selector(btnCommentTapped), for: .touchUpInside)
   
        
        cell.btnPlay.tag = indexPath.row
        cell.btnPlay.addTarget(self, action: #selector(cellBtnPlayTapped(sender:)), for: .touchUpInside)
        
        
        //  cell.btnPlayRef.tag = indexPath.row
    //    cell.btnPlayRef.addTarget(self, action: #selector(btnPlayTapped), for: .touchUpInside)
      
        if let userInfo = realm.objects(SignUpDataModel.self).first{
            if userInfo.type == "parent"{
                if postList[indexPath.row].display_flag == "1"{
                    cell.btnDeleteRef.isHidden = false
                    cell.btnDeleteRef.tag = indexPath.row
                    cell.btnDeleteRef.addTarget(self, action: #selector(btnDeleteRefTapped), for: .touchUpInside)
                    cell.btnShareRef.tag = indexPath.row
                    cell.btnShareRef.isHidden = false
                    cell.btnShareRef.addTarget(self, action: #selector(btnShareRefTapped), for: .touchUpInside)
                }else{
                    cell.btnDeleteRef.isHidden = true
                    cell.btnShareRef.isHidden = true
                }
                
            }else{
                cell.btnDeleteRef.isHidden = true
                cell.btnShareRef.isHidden = true
            }
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
