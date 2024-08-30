//
//  AlamoFireWrapper.swift
//  Monami
//
//  Created by abc on 22/11/18.
//  Copyright © 2018 mobulous. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class AlamofireWrapper:NSObject{
    //MARK: - Variables for getting web services
    
    
    public class var sharedInstance: AlamofireWrapper {
        struct Singleton {
            static let instance: AlamofireWrapper = AlamofireWrapper()
        }
        return Singleton.instance
    }
    
    override init() {}
  
    //let baseURL = "http://18.217.134.167/monami/"
    let baseURL = "http://18.217.134.167/monami/api/"
    var responseCode = 0
    
    //MARK:- Methods
    //TODO: For requesting get types url
    
    func getRequestURL(_ strURL:String, success:@escaping (JSON)-> Void,failure:@escaping (Error) -> Void){
        var strURL =  (strURL as String)
        strURL = baseURL + "\(strURL)"
        print(strURL)
        let urlValue = URL(string: strURL)!
        _ = URLRequest(url: urlValue)
        Alamofire.request(urlValue).responseJSON { (responseObject) -> Void in
            
            print(responseObject)
            
            if responseObject.result.isSuccess {
                
                let resJson = JSON(responseObject.result.value!)
                success(resJson)
                self.responseCode = 1
                
            }
            if responseObject.result.isFailure {
                let error : Error = responseObject.result.error!
                failure(error)
                
                self.responseCode = 2
            }
        }
    }
    
    //TODO: For requesting post types url
    func postRequestURL(_ strURL : String, params : [String : AnyObject]!, headers : [String : String]?, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void){
        let urlString = baseURL + (strURL as String)
        print(urlString)
        let urlValue = URL(string: urlString)!
        var request = URLRequest(url: urlValue)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        Alamofire.request(urlValue, method: .post, parameters: params, encoding: JSONEncoding.default, headers:headers).responseJSON { (responseObject) -> Void in
            
            if responseObject.result.isSuccess {
                
                let resJson = JSON(responseObject.result.value!)
                success(resJson)
                self.responseCode = 1
            }
            if responseObject.result.isFailure {
                
                let error : Error = responseObject.result.error!
                failure(error)
                
                self.responseCode = 2
            }
        }
    }
    //TODO: For requesting post types url with file
    func postRequestURLWithFile( imageData:NSData,fileName: String,imageparam:String, urlString:String, parameters : [String : AnyObject]?, headers : [String : String]?,success: @escaping (JSON) -> Void,failure:@escaping (Error) -> Void){
        let urlString = baseURL + (urlString as String)
        print(urlString)
        let urlValue = URL(string: urlString)!
        var request = URLRequest(url: urlValue)
        request.setValue("multipart/form-data", forHTTPHeaderField: "Content-Type")
        Alamofire.upload( multipartFormData: { multipartFormData in
            
            multipartFormData.append(imageData as Data, withName: imageparam, fileName: fileName, mimeType:"image/png")
            
            for (key, value) in parameters! {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key )
            }
        },to: urlString,encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    if((response.result.value != nil)){
                        self.responseCode = 1
                        let resJson = JSON(response.result.value!)
                        success(resJson)
                    }else{
                        self.responseCode = 2
                        let error : Error = response.result.error!
                        failure(error)
                    }
                }
            case .failure(let encodingError):
                self.responseCode = 2
                print(encodingError)
                let error : Error = encodingError
                failure(error)
            }
        })
    }
}
