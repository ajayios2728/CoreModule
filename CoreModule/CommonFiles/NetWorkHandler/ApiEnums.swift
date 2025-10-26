//
//  ApiEnums.swift
//  Mutasil
//
//  Created by SCT on 02/09/25.
//

import Foundation
import Alamofire

enum APIEnums : String {
    case none
    // MARK: Login Flow
    case Login = "login"
    case Logout = "logout"
    case Verify_OTP = "verify-otp"
    case Regenerate_OTP = "regenerate-otp"
    case Refresh_Token = "refresh"
    
    // MARK: Knowledgehub Flow
    case knowledgehub_guidedproductfinder = "knowledgehub/guidedproductfinder"
    case Knowledgehub_list = "knowledgehub/list"
    case Knowledgehub_filters = "knowledgehub/filters"
    
    // MARK: Knowledgehub Details
    case KHcompletefactsheet_info = "knowledgehub/completefactsheet/info"
    case KHcompletefactsheet_specifications = "knowledgehub/completefactsheet/specifications"
    case KHcompletefactsheet_filter = "knowledgehub/completefactsheet/filter"
        
}



extension APIEnums{
    
    var method : HTTPMethod {
        switch self {
        case .none:
            return .get
            
        default:
            return .post
        }
    }
    
    var cacheAttribute: Bool{
            switch self {
            case .none:
                return true
                
            default:
                return false
            }
        }
    
}

