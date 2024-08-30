//
//  FollowingChildrenDataModel.swift
//  Monami
//
//  Created by abc on 29/11/18.
//  Copyright © 2018 mobulous. All rights reserved.
//

import Foundation
class  FollowingChildrenDataModel{
    var child_id : String
    var image : String
    var name : String
    var CUID : String
    var SCUID : String
    var child_flag : String
    
    init(child_id : String,image : String,name : String,CUID : String,SCUID : String,child_flag : String) {
        self.child_id = child_id
        self.image = image
        self.name = name
        self.CUID = CUID
        self.SCUID = SCUID
        self.child_flag = child_flag
    }
}
