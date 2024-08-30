//
//  ReportsVC.swift
//  Monami
//
//  Created by abc on 25/09/18.
//  Copyright © 2018 mobulous. All rights reserved.
//

import UIKit

class ReportsVC: UIViewController{

    
    // MARK: - Outlets
    
    @IBOutlet weak var tblReports: UITableView!
    
    
    
    
    /////////////////////////////////////////////////////
    
    // MARK: - Global variables
    
    var isComing = String()
    var children_id = String()
    let macroObj = MacrosForAll.sharedInstanceMacro
    let alamoFireObj = AlamofireWrapper.sharedInstance
    var reportList = [ReportDataModel]()
    let documentInteractionController = UIDocumentInteractionController()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    /////////////////////////////////////////////////////
    
    // MARK:- View life cycle methods
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initialSetup()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = true
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
    
    // TODO: Gestures
    
    
    
    var refreshControl: UIRefreshControl {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(ReportsVC.handleRefresh(_:)), for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor(red: 59.0/255, green: 208.0/255, blue: 214.0/255, alpha: 1.0)
        return refreshControl
    }
    
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        viewReportsAPI()
        refreshControl.endRefreshing()
    }
    
    // TODO: TableView Actions
    
    
    @objc func btnPdfTapped(sender: UIButton){
        
        guard let file = reportList[sender.tag].file as? String else{
            print("No file")
            return
        }
        storeAndShare(withURLString: file)
    }
    @objc func btnViewTapped(sender: UIButton){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewReportVC") as! ViewReportVC
        vc.report_id = reportList[sender.tag].report_id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func reloadReportApi(_ notification: Notification){
        viewReportsAPI()
    }
    
}



/////////////////////////////////////////////////////

// MARK: - Table View Extension



extension ReportsVC: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return reportList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        self.tblReports.register(UINib(nibName:"ReportTableViewCell",bundle:nil), forCellReuseIdentifier: "ReportTableViewCell")
        let cell = tblReports.dequeueReusableCell(withIdentifier: "ReportTableViewCell", for: indexPath) as! ReportTableViewCell
        cell.lblTime.text = "\(reportList[indexPath.row].date),\n\(reportList[indexPath.row].day)"
        cell.btnPdfRef.tag = indexPath.row
        cell.btnPdfRef.addTarget(self, action: #selector(btnPdfTapped), for: .touchUpInside)
        cell.btnViewRef.tag = indexPath.row
        cell.btnViewRef.addTarget(self, action: #selector(btnViewTapped), for: .touchUpInside)
        cell.btnViewRef.setTitle("View".localized(), for: .normal)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        return 170
     
    }
    
}

//MARK: - Methods extension
extension ReportsVC{
    func initialSetup(){
        ScreeNNameClass.shareScreenInstance.screenName = "ReportsVC"
        NotificationCenter.default.addObserver(self,selector:#selector(ReportsVC.reloadReportApi(_:)),name:NSNotification.Name(rawValue: "REPORTNOTIFYRELOAD"),object: nil)
        documentInteractionController.delegate = self
        self.tblReports.tableFooterView = UIView()
        self.tblReports.addSubview(self.refreshControl)
        viewReportsAPI()
    }
}


// MARK: - Web services extension
extension ReportsVC{
    func viewReportsAPI(){
        if InternetConnection.internetshared.isConnectedToNetwork(){
            macroObj.showLoader(view: view)
            alamoFireObj.getRequestURL("\(MacrosForAll.APINAME.reportsection.rawValue)/\(children_id)", success: { (responseJASON) in
                self.macroObj.hideLoader(view: self.view)
                print(responseJASON)
                if responseJASON["status"].string == "SUCCESS"{
                    
                    if self.reportList.count > 0{
                        self.reportList.removeAll()
                    }
                    if let responseArray = responseJASON["response"].arrayObject as? NSArray {
                        for item in responseArray{
                            if let reportDict = item as? NSDictionary{
                                guard let file = reportDict.value(forKey: "file") as? String else {
                                    print("No file")
                                    return
                                }
                                
                                guard let date = reportDict.value(forKey: "date") as? String else {
                                    print("No date")
                                    return
                                }
                                
                                var timeArray = date.components(separatedBy: "/")
                                timeArray = timeArray.flatMap { $0.localized() as? String }
                                print(timeArray)
                                let timeTranlated = timeArray.joined(separator: "/")
                                
                                guard let day = reportDict.value(forKey: "day") as? String else {
                                    print("No day")
                                    return
                                }
                                guard let report_id = reportDict.value(forKey: "report_id") as? String else {
                                    print("No report_id")
                                    return
                                }
                               
                                let reportItem = ReportDataModel(file: file, date: timeTranlated, day: day.localized(),report_id:report_id)
                                self.reportList.append(reportItem)
                            }else{
                                print("Aman")
                            }
                        }
                      
                        self.tblReports.reloadData()
                        
                        
                        
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


//MARK:- Document Interaction Controller
//MARK:-
extension ReportsVC {
    /// This function will set all the required properties, and then provide a preview for the document
    func share(url: URL) {
        documentInteractionController.url = url
        documentInteractionController.uti = url.typeIdentifier ?? "public.data, public.content"
        documentInteractionController.name = url.localizedName ?? url.lastPathComponent
        documentInteractionController.presentPreview(animated: true)
    }
    
    /// This function will store your document to some temporary URL and then provide sharing, copying, printing, saving options to the user
    func storeAndShare(withURLString: String) {
        guard let url = URL(string: withURLString) else { return }
        /// START YOUR ACTIVITY INDICATOR HERE
        self.macroObj.showLoader(view: self.view)
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            let tmpURL = FileManager.default.temporaryDirectory
                .appendingPathComponent(response?.suggestedFilename ?? "fileName.png")
            do {
                try data.write(to: tmpURL)
            } catch {
                print(error)
            }
            DispatchQueue.main.async {
                /// STOP YOUR ACTIVITY INDICATOR HERE
                self.macroObj.hideLoader(view: self.view)
                self.share(url: tmpURL)
            }
            }.resume()
    }
}

extension ReportsVC: UIDocumentInteractionControllerDelegate {
    /// If presenting atop a navigation stack, provide the navigation controller in order to animate in a manner consistent with the rest of the platform
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        guard let navVC = self.navigationController else {
            return self
        }
//        navVC.navigationBar.isHidden = true
        return navVC
    }
    
  
}



extension URL {
    var typeIdentifier: String? {
        return (try? resourceValues(forKeys: [.typeIdentifierKey]))?.typeIdentifier
    }
    var localizedName: String? {
        return (try? resourceValues(forKeys: [.localizedNameKey]))?.localizedName
    }
}

