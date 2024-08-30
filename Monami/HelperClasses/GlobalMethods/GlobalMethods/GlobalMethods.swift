//
//  import UIKit     GlobleMethods.swift
//  
//
//  Created by Callsoft on 19/12/17.


import UIKit
import SystemConfiguration

public class InternetConnection {
    
    static  let internetshared = InternetConnection()
    
    public func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
 
}

// SINGLTON CLASS FOR SCREEN NAME  that on That screen notification popup will not come
class ScreeNNameClass {
    static let shareScreenInstance = ScreeNNameClass()
    var  screenName = ""
    private init() {}
}
