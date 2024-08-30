//
//  WholeReportModel.swift
//  Monami
//
//  Created by abc on 04/02/19.
//  Copyright © 2019 mobulous. All rights reserved.
//

import Foundation
class WholeReportModel{
    var mealModelArray = [MealViewListModel]()
    var napModelArray = [NapDataModel]()
    var toiletModelArray = [ToiletDataModel]()
    var activityModelArray = [ActivityDataModel]()
    init(mealModelArray:[MealViewListModel],napModelArray:[NapDataModel],toiletModelArray:[ToiletDataModel],activityModelArray:[ActivityDataModel]){
        self.mealModelArray = mealModelArray
        self.napModelArray = napModelArray
        self.toiletModelArray = toiletModelArray
        self.activityModelArray = activityModelArray
    }
}
