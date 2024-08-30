//
//  MealViewListModel.swift
//  Monami
//
//  Created by abc on 10/01/19.
//  Copyright © 2019 mobulous. All rights reserved.
//

import Foundation
class MealViewListModel{
    var Breakfast_quantity : String
    var Lunch_quantity : String
    var Snack_quantity : String
    init(Breakfast_quantity:String,Lunch_quantity:String,Snack_quantity:String){
        self.Breakfast_quantity = Breakfast_quantity
        self.Lunch_quantity = Lunch_quantity
        self.Snack_quantity = Snack_quantity
    }
}
