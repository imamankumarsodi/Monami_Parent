//
//  MessageDataModel.swift
//  Monami
//
//  Created by abc on 10/12/18.
//  Copyright © 2018 mobulous. All rights reserved.
//

import Foundation
class MessageDataModel{
    var time : String
    var msg : String
    var flag : String
    init(time:String,msg:String,flag:String){
        self.flag = flag
        self.msg = msg
        self.time = time
    }
}
