//
//  PlistKeys.swift
//

import Foundation


enum InfoPlistKeys : String{
    case Google_Map_keys
    case Google_Places_keys
    case App_URL
    case RedirectionLink_user
    case ThemeColors
    case ReleaseVersion
    case UserType
    case App_Name
    case iTunesData_user
    case App_ID
    case appStoreDisplayName
    case appName
    case Bundle_id
}
extension InfoPlistKeys : PlistKeys{
    var key: String{
        return self.rawValue
    }
    
    static var fileName: String {
        return "Info"
    }
    
    
}
