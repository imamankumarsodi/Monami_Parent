//
//  ReportDataModel.swift
//  Monami
//
//  Created by abc on 19/12/18.
//  Copyright © 2018 mobulous. All rights reserved.
//

import Foundation
class ReportDataModel{
    var file : String
    var date : String
    var day : String
    var report_id : String
    init(file:String,date:String,day:String,report_id:String){
        self.day = day
        self.file = file
        self.date = date
        self.report_id = report_id
    }
}
