//
//  CommentDataModel.swift
//  Monami
//
//  Created by abc on 04/12/18.
//  Copyright © 2018 mobulous. All rights reserved.
//

import Foundation
class CommentDataModel{

    
    
    var image : String
    var name : String
    var msg : String
    var time : String
    var comment_id : String
    var user_id : String
    init(image:String,name:String,msg:String,time:String,comment_id:String,user_id:String){
        self.image = image
        self.name = name
        self.msg = msg
        self.time = time
        self.comment_id = comment_id
        self.user_id = user_id
    }
}


