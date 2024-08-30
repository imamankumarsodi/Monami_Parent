//
//  FamilyMemberDataModel.swift
//  Monami
//
//  Created by abc on 29/11/18.
//  Copyright © 2018 mobulous. All rights reserved.
//

import Foundation
class FamilyMemberDataModel{
    var member_id : Int
    var image : String
    var fullname : String
    var status : String
    var access_id : Int
    init(member_id : Int,image : String,fullname : String,status : String,access_id:Int) {
        self.member_id = member_id
        self.image = image
        self.fullname = fullname
        self.status = status
        self.access_id = access_id
    }
}
