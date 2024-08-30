//
//  HomeScreenVC.swift
//  Monami
//
//  Created by abc on 21/09/18.
//  Copyright © 2018 mobulous. All rights reserved.
//

import UIKit
import DatePickerDialog
import RealmSwift
import SDWebImage
import AVKit
import AVFoundation

class HomeVC: UIViewController {
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var btnSearchRef: UIButton!
    
    @IBOutlet weak var tblHome: UITableView!
    
    @IBOutlet weak var search_bar: UISearchBar!
    
    @IBOutlet weak var btnProfileRef: UIButton!
    
    @IBOutlet weak var btnFilterOrNotification: UIButton!
    
    @IBOutlet weak var stackWidthNSLayoutContstraints: NSLayoutConstraint!
    
    
    @IBOutlet weak var searchViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var searchViewBottom: NSLayoutConstraint!
    
    @IBOutlet weak var searchView: UIView!
    
    /////////////////////////////////////////////////////
    
    // MARK: - Global variables
    var defaultDate: Date!
    var postList = [PostDataModel]()
    let macroObj = MacrosForAll.sharedInstanceMacro
    let alamoFireObj = AlamofireWrapper.sharedInstance
    let realm = try! Realm()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var filterStatus = false
    var date = String()
    var searchButtonStatus = false
    var searchActive = false
    var filtered = [PostDataModel]()
    
    
    let shotTableViewCellIdentifier = "ShotTableViewCell"
    let loadingCellTableViewCellCellIdentifier = "LoadingCellTableViewCell"
    
    /////////////////////////////////////////////////////
    
    // MARK:- View life cycle methods
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        search_bar.placeholder = "Search".localized()
        self.tabBarController?.tabBar.items?[0].title = "Home".localized()
        self.tabBarController?.tabBar.items?[1].title = "My Chat".localized()
        self.tabBarController?.tabBar.items?[2].title = "Notifications".localized()
        self.tabBarController?.tabBar.items?[3].title = "Profile".localized()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        pausePlayeVideos()
    }
    
    /////////////////////////////////////////////////////
    
    
    
    
    // TODO: Web services
    
    
    /////////////////////////////////////////////////////
    
    // MARK: - Actions, gestures, tableViewActions
    
    
    // TODO: Actions
    
    @IBAction func btnSearchTapped(_ sender: UIButton) {
        if  searchButtonStatus == false{
            self.searchView.fadeOutImmidiatlyWithoutshowingEffect()
            self.search_bar.fadeOutImmidiatlyWithoutshowingEffect()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.searchViewHeight.constant = 45
                self.searchViewBottom.constant = 15
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.searchView.fadeIn()
                self.search_bar.fadeIn()
            }
            
        }else{
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.searchView.fadeOut()
                self.search_bar.fadeOut()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.searchViewHeight.constant = 0
                self.searchViewBottom.constant = 0
            }
        }
        search_bar.text = ""
        searchActive = false
        tblHome.reloadData()
        searchButtonStatus = !searchButtonStatus
    }
    @IBAction func btnCalenderTapped(_ sender: Any) {
        if let userInfo = realm.objects(SignUpDataModel.self).first{
            print(userInfo.type)
            if userInfo.type == "parent"{
                dobDropDown()
            }else if userInfo.type == "family"{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                print("Do nothing")
            }
        }
        
    }
    
    
    @IBAction func btnProfileTapped(_ sender: UIButton) {
        
        
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileVC") as! MyProfileVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    // TODO: Gestures
    @objc func appEnteredFromBackground() {
        ASVideoPlayerController.sharedVideoPlayer.pausePlayeVideosFor(tableView: tblHome, appEnteredFromBackground: true)
    }
    
   
    // TODO: TableView Actions
    
    @objc func btnShareRefTapped(sender: UIButton){
        print(sender.tag)
      
        
        if searchActive == true{
            
            if filtered[sender.tag].post_type == "image"{
                shareApp(media: "image", link: filtered[sender.tag].post_media)
                
            }else if filtered[sender.tag].post_type == "video"{
                shareApp(media: "video", link: filtered[sender.tag].post_media)
                
            }else{
                
                shareApp(media: "audio", link: filtered[sender.tag].post_media)
            }
            
        }else{
            
            if postList[sender.tag].post_type == "image"{
                shareApp(media: "image", link: postList[sender.tag].post_media)
                
            }else if postList[sender.tag].post_type == "video"{
                shareApp(media: "video", link: postList[sender.tag].post_media)
                
            }else{
                shareApp(media: "audio", link: postList[sender.tag].post_media)
            
            }
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
        var name = String()
        var postID = String()
        if searchActive == true{
           name  = filtered[sender.tag].children_name
            postID = filtered[sender.tag].post_id
        }else{
            name = postList[sender.tag].children_name
            postID = postList[sender.tag].post_id
        }
        
        
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
        
        if searchActive == true{
            downloadImageInGallary(imageUrl:filtered[sender.tag].post_media)
        }else{
            downloadImageInGallary(imageUrl:postList[sender.tag].post_media)
        }
        
       
    }
    
    
    
    
    
    
    @objc func btnCommentTapped(sender: UIButton){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommentsVC") as! CommentsVC
        if searchActive == true{
            vc.post_id = filtered[sender.tag].post_id
        }else{
            vc.post_id = postList[sender.tag].post_id
        }
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc func btnPlayTapped(sender: UIButton){
        
        if searchActive == true{
            
            if filtered[sender.tag].post_type == "image"{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ShowImageVC") as! ShowImageVC
                vc.imageUrl = filtered[sender.tag].post_media
                self.navigationController?.pushViewController(vc, animated: true)
           
            
            }else if filtered[sender.tag].post_type == "video"{
                let avPlayerViewController = AVPlayerViewController()
                var avPlayer:AVPlayer? = nil
                let url = URL(string: filtered[sender.tag].post_media)
                avPlayer = AVPlayer.init(url: url!)
                avPlayerViewController.player = avPlayer
                print("downloadUrl obtained and set")
                self.present(avPlayerViewController, animated: true) { () -> Void in
                    avPlayerViewController.player?.play()
                }
          
            
            }else{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "PlayAudioVC") as! PlayAudioVC
                vc.audioURLString = filtered[sender.tag].post_media
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }else{
            
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
    
    @objc func btnChildProfileTapped(sender: UIButton){
        
        print(sender.tag)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChildProfileVC") as! ChildProfileVC
        if searchActive == true{
             vc.children_id = filtered[sender.tag].children_id
        }else{
             vc.children_id = postList[sender.tag].children_id
        }
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        filterStatus = false
        postlistService()
        refreshControl.endRefreshing()
    }
    
    @objc func reloadHomeApi(_ notification: Notification){
       postlistService()
    }
    
}
/////////////////////////////////////////////////////

// MARK: - Methods Extension

extension HomeVC{
    
    func initialSetup(){
        ScreeNNameClass.shareScreenInstance.screenName = "HomeVC"
    NotificationCenter.default.addObserver(self,selector:#selector(HomeVC.reloadHomeApi(_:)),name:NSNotification.Name(rawValue: "HOMENOTIFYRELOAD"),object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.appEnteredFromBackground),
                                               name: UIApplication.willEnterForegroundNotification, object: nil)
        
        
        search_bar.delegate = self
        if let userInfo = realm.objects(SignUpDataModel.self).first{
            print(userInfo.type)
            if userInfo.type == "parent"{
                stackWidthNSLayoutContstraints.constant = 54
                btnProfileRef.isHidden = true
                btnFilterOrNotification.setImage(#imageLiteral(resourceName: "home_filter"), for: .normal)
                self.tabBarController?.tabBar.isHidden = false
            }else if userInfo.type == "family"{
                stackWidthNSLayoutContstraints.constant = 108
                btnProfileRef.isHidden = false
                btnFilterOrNotification.setImage(#imageLiteral(resourceName: "notification"), for: .normal)
                btnProfileRef.setImage(#imageLiteral(resourceName: "user"), for: .normal)
                self.tabBarController?.tabBar.isHidden = true
            }else{
                print("Do nothing")
            }
        }
        
        tblHome.tableFooterView = UIView()
        self.tblHome.addSubview(self.refreshControl)
        postlistService()
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

    
    // TODO: Drop downs
    
    func dobDropDown() {
        
        
        let date = Date()
        DatePickerDialog().show("Select date".localized(), doneButtonTitle: "Done".localized(), cancelButtonTitle: "Cancel".localized(), defaultDate: defaultDate ?? Date(), minimumDate: nil, maximumDate: date, datePickerMode: .date) { (date) -> Void in
            if let dt = date
            {
                let formatter  = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                self.defaultDate = dt
                print(formatter.string(from: dt))
                self.date = formatter.string(from: dt)
                self.filterStatus = !self.filterStatus
                self.postlistService()
            }
        }
    }
  
    func pausePlayeVideos(){
        ASVideoPlayerController.sharedVideoPlayer.pausePlayeVideosFor(tableView: tblHome)
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
        refreshControl.addTarget(self, action: #selector(HomeVC.handleRefresh(_:)), for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor(red: 59.0/255, green: 208.0/255, blue: 214.0/255, alpha: 1.0)
        return refreshControl
    }
    
}

/////////////////////////////////////////////////////

// MARK: - Table View Extension

extension HomeVC:UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive == true{
             return filtered.count
        }else{
             return postList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if searchActive == true{

            self.tblHome.register(UINib(nibName:"HomeTableViewCell",bundle:nil), forCellReuseIdentifier: "HomeTableViewCell")
            let cell = tblHome.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell


            cell.lblDescription.text = filtered[indexPath.row].post_descrption
            cell.img_view_child.sd_setImage(with: URL(string: filtered[indexPath.row].children_image), placeholderImage: UIImage(named: "user_signup"))
            cell.lblChild_name.text = filtered[indexPath.row].children_name
            cell.lblChildCUID.text = filtered[indexPath.row].children_cuid
            cell.lblDateTime.text = filtered[indexPath.row].created_on


            if let media_type = filtered[indexPath.row].post_type as? String{
                if media_type == "video"{
                    cell.imgViewPlay.isHidden = false
                    cell.image_Post.sd_setImage(with: URL(string: filtered[indexPath.row].thumbnail), placeholderImage: UIImage(named: "user_signup"))
                    cell.btnDownloadRef.isHidden = true
                }else if media_type == "audio"{
                    cell.imgViewPlay.isHidden = true
                    cell.image_Post.image = #imageLiteral(resourceName: "audio")
                    cell.btnDownloadRef.isHidden = true
                }else{
                    cell.imgViewPlay.isHidden = true
                    cell.image_Post.sd_setImage(with: URL(string: filtered[indexPath.row].post_media), placeholderImage: UIImage(named: "user_signup"))
                    if let userInfo = realm.objects(SignUpDataModel.self).first{
                        if userInfo.type == "parent"{
                            if filtered[indexPath.row].display_flag == "1"{
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

            cell.btnImageRef.tag = indexPath.row
            cell.btnImageRef.addTarget(self, action: #selector(btnChildProfileTapped), for: .touchUpInside)
            cell.btnProfileRef.tag = indexPath.row
            cell.btnProfileRef.addTarget(self, action: #selector(btnChildProfileTapped), for: .touchUpInside)
            cell.btnCommentRef.tag = indexPath.row
            cell.btnCommentRef.addTarget(self, action: #selector(btnCommentTapped), for: .touchUpInside)
            cell.btnPlay.tag = indexPath.row
            cell.btnPlay.addTarget(self, action: #selector(btnPlayTapped), for: .touchUpInside)
            if let userInfo = realm.objects(SignUpDataModel.self).first{
                if userInfo.type == "parent"{
                    if filtered[indexPath.row].display_flag == "1"{
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
        }else{

            self.tblHome.register(UINib(nibName:"HomeTableViewCell",bundle:nil), forCellReuseIdentifier: "HomeTableViewCell")
            let cell = tblHome.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
            cell.lblDescription.text = postList[indexPath.row].post_descrption
            cell.img_view_child.sd_setImage(with: URL(string: postList[indexPath.row].children_image), placeholderImage: UIImage(named: "user_signup"))
            cell.lblChild_name.text = postList[indexPath.row].children_name
            cell.lblChildCUID.text = postList[indexPath.row].children_cuid
            cell.lblDateTime.text = postList[indexPath.row].created_on
            if let media_type = postList[indexPath.row].post_type as? String{
                if media_type == "video"{
                    
                    
                    if postList[indexPath.row].type == "ad"{
                        
                        var cellNib = UINib(nibName:shotTableViewCellIdentifier, bundle: nil)
                        self.tblHome.register(cellNib, forCellReuseIdentifier: shotTableViewCellIdentifier)
                        cellNib = UINib(nibName:loadingCellTableViewCellCellIdentifier, bundle: nil)
                        tblHome.register(cellNib, forCellReuseIdentifier: loadingCellTableViewCellCellIdentifier)
                        let cell = tableView.dequeueReusableCell(withIdentifier: shotTableViewCellIdentifier, for: indexPath) as! ShotTableViewCell
                        cell.configureCell(imageUrl: postList[indexPath.row].thumbnail, description: "Video", videoUrl: postList[indexPath.row].post_media, sponserImageUrl: postList[indexPath.row].children_image, title: postList[indexPath.row].children_name, subtitle: postList[indexPath.row].children_cuid)
                        return cell
                        
                    }else{
                        cell.imgViewPlay.isHidden = false
                        cell.image_Post.sd_setImage(with: URL(string: postList[indexPath.row].thumbnail), placeholderImage: UIImage(named: "user_signup"))
                        cell.btnDownloadRef.isHidden = true
                    }
                }else if media_type == "audio"{
                    cell.imgViewPlay.isHidden = true
                    cell.image_Post.image = #imageLiteral(resourceName: "audio")
                    cell.btnDownloadRef.isHidden = true
                }else{
                    if postList[indexPath.row].type == "ad"{
                        var cellNib = UINib(nibName:shotTableViewCellIdentifier, bundle: nil)
                        self.tblHome.register(cellNib, forCellReuseIdentifier: shotTableViewCellIdentifier)
                        cellNib = UINib(nibName:loadingCellTableViewCellCellIdentifier, bundle: nil)
                        tblHome.register(cellNib, forCellReuseIdentifier: loadingCellTableViewCellCellIdentifier)
                        let cell = tableView.dequeueReusableCell(withIdentifier: shotTableViewCellIdentifier, for: indexPath) as! ShotTableViewCell
                        cell.configureCell(imageUrl: self.postList[indexPath.row].post_media, description: "Image", videoUrl: nil, sponserImageUrl: postList[indexPath.row].children_image, title: postList[indexPath.row].children_name, subtitle: postList[indexPath.row].children_cuid)
                        return cell
                        
                        
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
            }

            cell.btnImageRef.tag = indexPath.row
            cell.btnImageRef.addTarget(self, action: #selector(btnChildProfileTapped), for: .touchUpInside)
            cell.btnProfileRef.tag = indexPath.row
            cell.btnProfileRef.addTarget(self, action: #selector(btnChildProfileTapped), for: .touchUpInside)
            cell.btnCommentRef.tag = indexPath.row
            cell.btnCommentRef.addTarget(self, action: #selector(btnCommentTapped), for: .touchUpInside)
            cell.btnPlay.tag = indexPath.row
            cell.btnPlay.addTarget(self, action: #selector(btnPlayTapped), for: .touchUpInside)

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
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let videoCell = cell as? ASAutoPlayVideoLayerContainer, videoCell.videoURL != nil {
            ASVideoPlayerController.sharedVideoPlayer.removeLayerFor(cell: videoCell)
        }
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            pausePlayeVideos()
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pausePlayeVideos()
    }
    
}


/////////////////////////////////////////////////////

// MARK: - Web services extensions

extension HomeVC{
    func postlistService(){
        if InternetConnection.internetshared.isConnectedToNetwork(){
            var user_id = String()
            var token = String()
            if let userInfo = realm.objects(SignUpDataModel.self).first{
                user_id = userInfo.user_id
                token = userInfo.token
            }
            
            var passDict = NSDictionary()
            if filterStatus == true{
                passDict = ["token":token,
                            "user_id":user_id,
                            "devicetype":"ios",
                            "date":date]
            }else{
                passDict = ["token":token,
                            "user_id":user_id,
                            "devicetype":"ios"]
            }
            macroObj.showLoader(view: view)
            alamoFireObj.postRequestURL(MacrosForAll.APINAME.postlist.rawValue, params: passDict as! [String : AnyObject], headers: nil, success: { (responseJASON) in
                self.macroObj.hideLoader(view: self.view)
                print(responseJASON)
                if self.postList.count != 0{
                    self.postList.removeAll()
                }
                if responseJASON["status"].string == "SUCCESS"{
                    if let responseArray = responseJASON["response"].arrayObject{
                        for post in responseArray{
                            if let postDict = post as? NSDictionary{
                                print(postDict)
                                
                                guard let post_id = postDict["post_id"] as? String else {
                                    print("No post_id")
                                    return
                                }
                                guard let post_media = postDict["post_media"] as? String else {
                                    print("No post_media")
                                    return
                                }
                                guard let post_type = postDict["post_type"] as? String else {
                                    print("No post_type")
                                    return
                                }
                                guard let children_image = postDict["children_image"] as? String else {
                                    print("No children_image")
                                    return
                                }
                                guard let children_name = postDict["children_name"] as? String else {
                                    print("No children_name")
                                    return
                                }
                                guard let children_cuid = postDict["children_cuid"] as? String else {
                                    print("No children_cuid")
                                    return
                                }
                                guard let post_descrption = postDict["post_descrption"] as? String else {
                                    print("No post_descrption")
                                    return
                                }
                                guard let children_id = postDict["children_id"] as? String else {
                                    print("No children_id")
                                    return
                                }
                                guard let thumbnail = postDict["thumbnail"] as? String else {
                                    print("No thumbnail")
                                    return
                                }
                                guard let created_on = postDict["created_on"] as? String else {
                                    print("No created_on")
                                    return
                                }
                                
                                var timeArray = created_on.components(separatedBy: " ")
                                timeArray = timeArray.flatMap { $0.localized() as? String }
                                print(timeArray)
                                let timeTranlated = timeArray.joined(separator: " ")
                                
                                guard let display_flag = postDict["display_flag"] as? String else {
                                    print("No display_flag")
                                    return
                                }
                                guard let type = postDict["type"] as? String else {
                                    print("No display_flag")
                                    return
                                }

                                let postItem = PostDataModel(post_id: post_id, post_media: post_media, post_type: post_type, children_image: children_image, children_name: children_name, children_cuid: children_cuid, post_descrption: post_descrption, children_id: children_id, thumbnail: thumbnail, created_on: timeTranlated, display_flag:display_flag, type: type)
                                self.postList.append(postItem)
                            }
                        }
                        
                        self.tblHome.dataSource = self
                        self.tblHome.delegate = self
                        self.tblHome.reloadData()
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
                    self.postlistService()
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

// MARK: - Search extensions

extension HomeVC:UISearchBarDelegate{
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if searchBar.text == ""{
            searchActive = false
        }else{
            searchActive = true
        }
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        self.search_bar.endEditing(true)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if filtered.count > 0{
            filtered.removeAll()
        }
        if searchBar.text!.isEmpty {
            searchActive = false
        }
        else {
            searchActive = true
            if postList.count >= 1 {
                for index in 0...postList.count - 1 {
                    if let dictResponse = postList[index] as? PostDataModel{
                        if let childName = dictResponse.children_name as? String{
                            if dictResponse.type == "ad"{
                                print("append nahi karna hai....")
                            }else{
                                if (childName.lowercased().range(of: searchText.lowercased()) != nil) {
                                    filtered.append(dictResponse)
                                }
                            }
                            
                        }
                    }
                }
            }
        }
        tblHome.reloadData()
    }
}


