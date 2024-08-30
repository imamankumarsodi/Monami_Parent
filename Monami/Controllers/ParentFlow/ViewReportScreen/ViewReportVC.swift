//
//  ViewReportVC.swift
//  Monami
//
//  Created by abc on 10/01/19.
//  Copyright © 2019 mobulous. All rights reserved.
//

import UIKit

class ViewReportVC: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var tblViewReports: UITableView!
    // MARK: - Global variables
    let macroObj = MacrosForAll.sharedInstanceMacro
    let alamoFireObj = AlamofireWrapper.sharedInstance
    var report_id = String()
    var mealViewArray = [MealViewListModel]()
    var toiletArray = [ToiletDataModel]()
    var napArray = [NapDataModel]()
    var activityArray = [ActivityDataModel]()
    var wholeReportArray = [WholeReportModel]()
    var refreshControl: UIRefreshControl {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(ViewReportVC.handleRefresh(_:)), for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor(red: 59.0/255, green: 208.0/255, blue: 214.0/255, alpha: 1.0)
        return refreshControl
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        // Do any additional setup after loading the view.
    }
    // TODO: Actions
    @IBAction func btnBackTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        viewReportsAPI()
        refreshControl.endRefreshing()
    }
}

//MARK: - Extension Table view delegates


extension ViewReportVC: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
             return mealViewArray.count
        }else if section == 1{
            return napArray.count
        }else if section == 2{
            return toiletArray.count
        }else{
            return activityArray.count
        }
       
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.section == 0{
            self.tblViewReports.register(UINib(nibName:"ReportMenuCell",bundle:nil), forCellReuseIdentifier: "ReportMenuCell")
            let cell = tblViewReports.dequeueReusableCell(withIdentifier: "ReportMenuCell", for: indexPath) as! ReportMenuCell
            cell.lblHeader.text = "Meals".localized()
            cell.lbl_Break_Static.text = "Breakfast - ".localized()
            cell.lbl_Lunch_Static.text = "Lunch - ".localized()
            cell.lblSnacks.text = "Snack -".localized()
           
            if mealViewArray[indexPath.row].Breakfast_quantity == "Lots" || mealViewArray[indexPath.row].Breakfast_quantity == "large"{
                cell.imgViewBreakfast.image = #imageLiteral(resourceName: "lot")
            }else if mealViewArray[indexPath.row].Breakfast_quantity == "Small"{
                cell.imgViewBreakfast.image = #imageLiteral(resourceName: "small")
            }else{
                cell.imgViewBreakfast.image = #imageLiteral(resourceName: "none")
            }
            if mealViewArray[indexPath.row].Lunch_quantity == "Lots" || mealViewArray[indexPath.row].Lunch_quantity == "large"{
                cell.imgViewLunch.image = #imageLiteral(resourceName: "lot")
            }else if mealViewArray[indexPath.row].Lunch_quantity == "Small"{
                cell.imgViewLunch.image = #imageLiteral(resourceName: "small")
            }else{
                cell.imgViewLunch.image = #imageLiteral(resourceName: "none")
            }
            if mealViewArray[indexPath.row].Snack_quantity == "Lots" || mealViewArray[indexPath.row].Snack_quantity == "large"{
                cell.imgViewSnacks.image = #imageLiteral(resourceName: "lot")
            }else if mealViewArray[indexPath.row].Snack_quantity == "Small"{
                cell.imgViewSnacks.image = #imageLiteral(resourceName: "small")
            }else{
                cell.imgViewSnacks.image = #imageLiteral(resourceName: "none")
            }
            cell.lblBreakfast.text = mealViewArray[indexPath.row].Breakfast_quantity.localized()
            cell.lblAfternoonLunch.text = mealViewArray[indexPath.row].Lunch_quantity.localized()
            cell.lblSnacks.text = mealViewArray[indexPath.row].Snack_quantity.localized()
            return cell
        }else if indexPath.section == 1{
            self.tblViewReports.register(UINib(nibName:"NapToiletActivityTableViewCell",bundle:nil), forCellReuseIdentifier: "NapToiletActivityTableViewCell")
            let cell = tblViewReports.dequeueReusableCell(withIdentifier: "NapToiletActivityTableViewCell", for: indexPath) as! NapToiletActivityTableViewCell
            if indexPath.row == 0{
                cell.lblMeals.text = "Naps".localized()
            }else{
                cell.lblMeals.text = ""
            }
            cell.lblTopic.text = "Time".localized()
            cell.lblContent.text = "\(napArray[indexPath.row].start_time) - \(napArray[indexPath.row].end_time)"
            return cell
        }else if indexPath.section == 2{
            self.tblViewReports.register(UINib(nibName:"NapToiletActivityTableViewCell",bundle:nil), forCellReuseIdentifier: "NapToiletActivityTableViewCell")
            let cell = tblViewReports.dequeueReusableCell(withIdentifier: "NapToiletActivityTableViewCell", for: indexPath) as! NapToiletActivityTableViewCell
            if indexPath.row == 0{
                cell.lblMeals.text = "Toilet".localized()
            }else{
                cell.lblMeals.text = ""
            }
            cell.lblTopic.text = "Time".localized()
            cell.lblContent.text = "\(toiletArray[indexPath.row].time) (\(toiletArray[indexPath.row].type))"
            return cell
        }else{
            self.tblViewReports.register(UINib(nibName:"NapToiletActivityTableViewCell",bundle:nil), forCellReuseIdentifier: "NapToiletActivityTableViewCell")
            let cell = tblViewReports.dequeueReusableCell(withIdentifier: "NapToiletActivityTableViewCell", for: indexPath) as! NapToiletActivityTableViewCell
            if indexPath.row == 0{
            cell.lblMeals.text = "Activities".localized()
            }else{
                cell.lblMeals.text = ""
            }
            cell.lblTopic.text = "Activity".localized()
            cell.lblContent.text = "\(activityArray[indexPath.row].activity)"
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

//MARK: - Methods extension
extension ViewReportVC{
    func initialSetup(){
        self.tblViewReports.tableFooterView = UIView()
        self.tblViewReports.addSubview(self.refreshControl)
        viewReportsAPI()
    }
    
}

//MARK: - Web services extension
extension ViewReportVC{
    func viewReportsAPI(){
        if InternetConnection.internetshared.isConnectedToNetwork(){
            macroObj.showLoader(view: view)
            alamoFireObj.getRequestURL("\(MacrosForAll.APINAME.reportpreview.rawValue)/\(report_id)", success: { (responseJASON) in
                if self.mealViewArray.count > 0{
                    self.mealViewArray.removeAll()
                }
                if self.toiletArray.count > 0{
                    self.toiletArray.removeAll()
                }
                if self.napArray.count > 0{
                    self.napArray.removeAll()
                }
                if self.activityArray.count > 0{
                    self.activityArray.removeAll()
                }
                if self.wholeReportArray.count > 0{
                    self.wholeReportArray.removeAll()
                }
                self.macroObj.hideLoader(view: self.view)
                if responseJASON["status"].string == "SUCCESS"{
                    print(responseJASON)
                    if let responseDict = responseJASON["response"].dictionaryObject as? NSDictionary{
                    if let meal_array = responseDict.value(forKey: "meal_array") as? NSArray{
                        for mealItem in meal_array{
                            if let mealDict = mealItem as? NSDictionary{
                                guard let Breakfast_quantity = mealDict.value(forKey: "Breakfast_quantity") as? String else{
                                    print("NO Breakfast_quantity")
                                    return
                                }
                                guard let Lunch_quantity = mealDict.value(forKey: "Lunch_quantity") as? String else{
                                    print("NO Lunch_quantity")
                                    return
                                }
                                guard let Snack_quantity = mealDict.value(forKey: "Snack_quantity") as? String else{
                                    print("NO Snack_quantity")
                                    return
                                }
                                let mealModelItem = MealViewListModel(Breakfast_quantity: Breakfast_quantity, Lunch_quantity: Lunch_quantity, Snack_quantity: Snack_quantity)
                                self.mealViewArray.append(mealModelItem)
                            }
                        }
                        
                        if self.mealViewArray.isEmpty{
                            let mealModelItem = MealViewListModel(Breakfast_quantity: "No Data Yet!".localized(), Lunch_quantity: "No Data Yet!".localized(), Snack_quantity: "No Data Yet!".localized())
                            self.mealViewArray.append(mealModelItem)
                        }
                    }
                    
                    if let nap_array = responseDict.value(forKey: "nap_array") as? NSArray{
                        for napItem in nap_array{
                            if let napDict = napItem as? NSDictionary{
                                guard let end_time = napDict.value(forKey: "end_time") as? String else{
                                    print("NO end_time")
                                    return
                                }
                                guard let start_time = napDict.value(forKey: "start_time") as? String else{
                                    print("NO start_time")
                                    return
                                }
                                let napModelItem = NapDataModel(end_time: end_time, start_time: start_time)
                                self.napArray.append(napModelItem)
                                
                            }
                        }
                        if self.napArray.isEmpty{
                            let napModelItem = NapDataModel(end_time: "No Data Yet!".localized(), start_time: "No Data Yet!".localized())
                            self.napArray.append(napModelItem)
                        }
                        
                    }
                    if let toilet_array = responseDict.value(forKey: "toilet_array") as? NSArray{
                        for toiletItem in toilet_array{
                            if let toiletDict = toiletItem as? NSDictionary{
                                guard let time = toiletDict.value(forKey: "time") as? String else{
                                    print("NO time")
                                    return
                                }
                                guard let type = toiletDict.value(forKey: "type") as? String else{
                                    print("NO type")
                                    return
                                }
                                let toiletModelItem = ToiletDataModel(time: time, type: type)
                                self.toiletArray.append(toiletModelItem)
                            }
                        }
                        if self.toiletArray.isEmpty{
                            let toiletModelItem = ToiletDataModel(time: "No Data Yet!".localized(), type: "No Data Yet!".localized())
                            self.toiletArray.append(toiletModelItem)
                        }
                    }
                         if let activity_array = responseDict.value(forKey: "activity_array") as? NSArray{
                            for activityItem in activity_array{
                                guard let activityString = activityItem as? String else{
                                    print("No acitvityString")
                                    return
                                }
                                let activityModelItem = ActivityDataModel(activity: activityString)
                                self.activityArray.append(activityModelItem)
                            }
                            if self.activityArray.isEmpty{
                                let activityModelItem = ActivityDataModel(activity: "No Data Yet!".localized())
                                self.activityArray.append(activityModelItem)
                            }
                        }
                }
                    let wholeReportModelItem = WholeReportModel(mealModelArray: self.mealViewArray, napModelArray: self.napArray, toiletModelArray: self.toiletArray, activityModelArray: self.activityArray)
                    self.wholeReportArray.append(wholeReportModelItem)
                    print(self.wholeReportArray.count)
                    self.tblViewReports.reloadData()
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
