//
//  NetworkChecker.swift
//  Mutasil
//
//  Created by SCT on 03/09/25.
//

import Foundation
import SystemConfiguration


open class Reachability {
    
    class func isConnectedToNetwork() -> Bool {
        
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
    
    
    class func networkChecker(with StartTime:Date,
                        EndTime: Date,
                        ContentData: Data?) {
        
        let dataInByte = ContentData?.count
        
        if let dataInByte = dataInByte {
            
            // Standard Values
            let standardMinContentSize : Float = 3
            let standardKbps : Float = 2
            
            // Kb Conversion
            let dataInKb : Float = Float(dataInByte / 1000)
            
            // Time Interval Calculation
            let milSec  = EndTime.timeIntervalSince(StartTime)
            let duration = String(format: "%.01f", milSec)
            let dur: Float = Float(duration) ?? 0
            
            // Kbps Calculation
            let Kbps = dataInKb / dur
            
            if dataInKb > standardMinContentSize {
                if Kbps < standardKbps {
                    print("å:::: Low Network Kbps : \(Kbps)")
//                       self.appDelegate.createToastMessage("LOW NETWORK")
                } else {
                    print("å:::: Normal NetWork Kbps : \(Kbps)")
                }
            } else {
                print("å:::: Small Content : \(Kbps)")
            }
            
        }
    }

    
}
