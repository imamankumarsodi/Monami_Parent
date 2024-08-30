//
//  PostDataModel.swift
//  Monami
//
//  Created by abc on 28/11/18.
//  Copyright © 2018 mobulous. All rights reserved.
//

import Foundation
class PostDataModel{
    var post_id : String
    var post_media : String
    var post_type : String
    var children_image : String
    var children_name : String
    var children_cuid : String
    var post_descrption : String
    var children_id : String
    var thumbnail : String
    var created_on : String
    var display_flag : String
    var type : String
    
    init(post_id : String,post_media : String,post_type : String,children_image : String,children_name : String,children_cuid : String,post_descrption : String,children_id : String,thumbnail:String,created_on:String,display_flag:String,type:String) {
        self.post_id = post_id
        self.post_media = post_media
        self.post_type = post_type
        self.children_image = children_image
        self.children_name = children_name
        self.children_cuid = children_cuid
        self.post_descrption = post_descrption
        self.children_id = children_id
        self.thumbnail = thumbnail
        self.created_on = created_on
        self.display_flag = display_flag
        self.type = type
    }
}
