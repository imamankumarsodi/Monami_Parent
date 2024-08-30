//
//  NotificationDataModel.swift
//  Monami
//
//  Created by abc on 21/12/18.
//  Copyright © 2018 mobulous. All rights reserved.
//

import Foundation
class NotificationDataModel{
    var image : String
    var msg : String
    var time : String
    var type : String
    var child_id : String
    var post_id : String
    init(image:String,msg:String,time:String,type:String,child_id:String,post_id:String){
        self.image = image
        self.msg = msg
        self.time = time
        self.type = type
        self.child_id = child_id
        self.post_id = post_id
    }
}
