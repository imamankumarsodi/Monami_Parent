//
//  MacrosForAll.swift
//  Monami
//
//  Created by abc on 22/11/18.
//  Copyright © 2018 mobulous. All rights reserved.
//

import Foundation
import UIKit
import Lottie
public class MacrosForAll:NSObject{
    public class var sharedInstanceMacro: MacrosForAll {
        struct Singleton {
            static let instance: MacrosForAll = MacrosForAll()
        }
        return Singleton.instance
    }
    override init() {}
    //MARK: - Variables
    //TODO: App Delegate
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    //TODO: Base URL
    let API_BASE_URL = "http://mobuloustech.com/monami/api/"
    let appName = "Monami"
    let animationView = AnimationView(name: "LittleGirl")
    //TODO: App Languages
    enum AppLanguage : String {
        case ENGLISH = "en"
        case PORTUGUESE  = "portu"
    }
    enum APINAME : String {
        case ParentSignUp       = "parentsignup"
        case CheckEmailId       = "checkemailid"
        case login              = "login"
        case editprofile        = "editprofile"
        case mapparentcuid      = "mapparentcuid"
        case followaction       = "followaction"
        case sociallogin        = "sociallogin"
        case postlist           = "postlist"
        case changepassword     = "changepassword"
        case followinglist      = "followinglist"
        case familylist         = "familylist"
        case accessforfamily    = "accessforfamily"
        case deleteaccessoffamily    = "deleteaccessoffamily"
        case forgotpassword     = "forgotpassword"
        case resetpassword      = "resetpassword"
        case notificationtrigger      = "notificationtrigger"
        case commentlist        = "commentlist"
        case commentonpost      = "commentonpost"
        case childprofile       = "childprofile"
        case commonsection      = "commonsection"
        case chatlist           = "chatlist"
        case sendmsg            = "sendmsg"
        case aboutus            = "aboutus"
        case reportsection      = "reportsection"
        case getmeal            = "getmeal"
        case notificationList   = "notficationlist"
        case deletepostbyparent   = "deletepostbyparent"
        case reportpreview   = "reportpreview"
        case notify_count   = "notify_count"
        case changelang   = "changelang"
        case deletecomment = "deletecomment"
        case editcomment = "editcomment"
        
    }
    enum VALIDMESSAGE : String {
        //Basic Signup
        case EnterFullName                           = "Please enter full name."
        case EnterValidFullName                      = "Please enter your valid full name. (Full Name contains A-Z or a-z, no special character or digits are allowed.)"
        case EnterValidFullNameLength                = "Full name length should atleast of 4 characters."
        case EnterMobileNumber                       = "Please enter phone number."
        case EmailAddressNotBeBlank                  = "Please enter Email ID."
        case EnterValidEmail                         = "Please enter valid email address."
        case PasswordNotBeBlank                      = "Please enter password."
        case PasswordShouldBeLong                    = "Password length should be 6-10 characters."
        case ConfirmPasswordNotBeBlank               = "Please enter confirm password."
        case ConfirmPasswordShouldBeLong             = "Confirm password length should be 6-10 characters."
        case NewPasswordNotBeBlank                   = "Please enter new password."
        case NewPasswordShouldBeLong                 = "New password length should be 6-10 characters."
        case PasswordAndConfimePasswordNotMatched    = "Password and Confirm Pasword is not matching."
        case AcceptTermsAndConditions                = "Please accept terms & conditions."
        case CUIDAlert                               = "Please enter CUID."
        case invalidCUIDAlert                        = "Please enter correct CUID."
        case CUIDMaxLength                           = "CUID length should be 6 digit long."
        case OldPasswordNotBeBlank                      = "Please enter old password."
        case OldPasswordShouldBeLong                    = "Old Password length should be 6-10 characters."
        case NewPasswordAndConfimePasswordNotMatched    = "New Password and Confirm Pasword is not matching."
        case LoginTokenExpire                       = "User already logged in some other device."
        case IncorrectOTP                           = "Incorrect OTP."
        case WantToLogout                           = "Are you sure?\nYou want to Log out!"
        case ContinueApp                           = "Please enter CUID to continue in the app."
        case ProfileUpdate                         = "Profile updated successfully."
        case DeleteAccess                          = "Are you sure?\nYou want to delete access of "
        case UnfollowChild                         = "Are you sure?\nYou want to unfollow "
        case DeletePost                          = "Are you sure?\nYou want to delete post of "
        case AudioMissing                         = "Audio file is missing."
        case DeleteComment                         = "Are you sure?\nYou want to delete this comment"
        case CommentAlert                              = "Please enter Comment."
    }
    enum ERRORMESSAGE : String {
        case NoInternet                              = "There is no internet connection. Please try again later."
        case ErrorMessage                            = "There is some error occured. Please try again later."
    }
    
    
    
    
}

//MARK: - Extension Lottie loader
extension MacrosForAll{
    func showLoader(view: UIView) {
        animationView.isHidden = false
        animationView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        animationView.center = view.center
        animationView.contentMode = .center
        animationView.animationSpeed = 1.0
        animationView.loopMode = .loop
        view.addSubview(animationView)
        animationView.play()
    }
    func hideLoader(view: UIView) {
        animationView.isHidden = true
        animationView.stop()
    }
    
}
