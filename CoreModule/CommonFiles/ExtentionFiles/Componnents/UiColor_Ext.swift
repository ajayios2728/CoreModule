//
//  UiColor_Ext.swift
//  Mutasil
//
//  Created by SCT on 02/09/25.
//

import Foundation
import UIKit


extension UIColor {
            
    static func SetColorCode(DarkColorCode: Any, LightColorCode: Any) -> UIColor {
        
        let DarkColor = DarkColorCode is String ? self.hexStringToUIColor(hex: "\(DarkColorCode)") : DarkColorCode
        let LightColor = LightColorCode is String ? self.hexStringToUIColor(hex: "\(LightColorCode)") : LightColorCode
        
        return UIColor(dynamicProvider: { traitCollection in
            if traitCollection.userInterfaceStyle == .dark {
                return DarkColor as? UIColor ?? .white
            } else {
                return LightColor as? UIColor ?? .white
            }
        })
    }
        
    
    static func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
