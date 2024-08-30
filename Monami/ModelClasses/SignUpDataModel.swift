//
//  SignUpDataModel.swift
//  Monami
//
//  Created by abc on 22/11/18.
//  Copyright © 2018 mobulous. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift
class SignUpDataModel:Object{
    @objc dynamic var fullname = String()
    @objc dynamic var email = String()
    @objc dynamic var password = String()
    @objc dynamic var phone = String()
    @objc dynamic var deviceType = String()
    @objc dynamic var deviceToken = String()
    @objc dynamic var password_confimation = String()
    @objc dynamic var user_id = String()
    @objc dynamic var token = String()
    @objc dynamic var type = String()
    @objc dynamic var CUID = String()
    @objc dynamic var image = String()
    @objc dynamic var chat_status = String()
    @objc dynamic var pavr_status = String()
    @objc dynamic var report_status = String()
}
