//
//  MenuVC.swift
//  Monami
//
//  Created by abc on 26/09/18.
//  Copyright © 2018 mobulous. All rights reserved.
//

import UIKit

class MenuVC: UIViewController {
    
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var tblMenu: UITableView!
    
    
    /////////////////////////////////////////////////////
    
    // MARK: - Global variables
    var children_id = String()
    let macroObj = MacrosForAll.sharedInstanceMacro
    let alamoFireObj = AlamofireWrapper.sharedInstance
    let documentInteractionController = UIDocumentInteractionController()
    var dataDict = NSMutableDictionary()
    var meal_list = NSArray()
    /////////////////////////////////////////////////////
    
    // MARK:- View life cycle methods

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initialSetup()
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
    
    var refreshControl: UIRefreshControl {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(MenuVC.handleRefresh(_:)), for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor(red: 59.0/255, green: 208.0/255, blue: 214.0/255, alpha: 1.0)
        return refreshControl
    }
    
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        getMealAPI()
        refreshControl.endRefreshing()
    }
    
    // TODO: TableView Actions
    

        
    }
    
    
    




/////////////////////////////////////////////////////

// MARK: - Table View Extension

extension MenuVC:UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.tblMenu.register(UINib(nibName:"MenuTableViewCell",bundle:nil), forCellReuseIdentifier: "MenuTableViewCell")
        let cell = tblMenu.dequeueReusableCell(withIdentifier: "MenuTableViewCell", for: indexPath) as! MenuTableViewCell
        cell.lbl_Break_Static.text = "Breakfast - ".localized()
        cell.lbl_Lunch_Static.text = "Lunch - ".localized()
        cell.lblSnacks.text = "Snack -".localized()

        if let date = dataDict.value(forKey: "date") as? String{
             cell.lblDate.text = date
        }
        if let Breakfast = dataDict.value(forKey: "Breakfast") as? String{
            cell.lblBreakfast.text = Breakfast
        }
        if let Lunch = dataDict.value(forKey: "Lunch") as? String{
           cell.lblAfternoonLunch.text = Lunch
        }
        if let Snack = dataDict.value(forKey: "Snack") as? String{
            cell.lblSnacks.text = Snack
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
//MARK: - Methods extension
extension MenuVC{
    func initialSetup(){
        self.tblMenu.addSubview(self.refreshControl)
        getMealAPI()
    }
}

// MARK: - Web services extension
extension MenuVC{
    func getMealAPI(){
        if InternetConnection.internetshared.isConnectedToNetwork(){
            macroObj.showLoader(view: view)
            alamoFireObj.getRequestURL("\(MacrosForAll.APINAME.getmeal.rawValue)/\(children_id)", success: { (responseJASON) in
                self.macroObj.hideLoader(view: self.view)
                if responseJASON["status"].string == "SUCCESS"{
                    print(responseJASON)
                    if let dataDict = responseJASON["response"].dictionaryObject as? NSDictionary{

                        guard let date = dataDict.value(forKey: "date") as? String else{
                            print("No date")
                            return
                        }
                        
                        var timeArray = date.components(separatedBy: "/")
                        timeArray = timeArray.flatMap { $0.localized() as? String }
                        print(timeArray)
                        let timeTranlated = timeArray.joined(separator: "/")
                        
                        let dateDict = ["date":timeTranlated]
                        self.dataDict.addEntries(from: dateDict)
                        if let meal_list = dataDict.value(forKey: "meal_list") as? NSArray{
                            for mealItem in meal_list{
                                if let mealDict = mealItem as? NSDictionary{
                                    guard let key = mealDict.value(forKey: "type") as? String else{
                                       print("No key")
                                        return
                                    }
                                    guard let value = mealDict.value(forKey: "list") as? String else{
                                        print("No value")
                                        return
                                    }
                                    let dict:NSDictionary = [key:value]
                                    self.dataDict.addEntries(from: dict as! [AnyHashable : Any])
                                    print(self.dataDict)
                                }
                            }
                             self.tblMenu.reloadData()
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
}



