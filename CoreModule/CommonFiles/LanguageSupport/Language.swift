//
//  Language.swift
//  Mutasil
//
//  Created by SCT on 01/09/25.
//

import Foundation
import UIKit

enum Language : String{
    
    case english = "en"
    case spanish = "es"
    case arabic = "ar"
    

}
extension Language{
    
    
    
    //MARK:- get Current Language
    static func getCurrentLanguage() -> Language{
        let def:String = UserDefaults.standard.string(forKey: "lang") ?? "en"
        
        return Language(rawValue: def) ?? .english
    }
    static func saveLanguage(_ Lang:Language){
        UserDefaults.standard.set(Lang.rawValue, forKey:  "lang")
    }
    //MARK:- get localization  instace
    func getLocalizedInstance()-> LanguageProtocol{
        
        switch self{
            //        case .spanish:
            //            return Spanish()
        case .arabic:
            return Arabic()
        default:
            return English()
        }
    }
    
    static var isRTL : Bool{
        
        if Language.getCurrentLanguage().rawValue == "ar"{
            return true
        }
        return false
    }
    var locale : Locale{
        switch self {
        case .arabic:
            return Locale(identifier: "ar")
        default:
            return Locale(identifier: "en")
        }
    }
    //NSCalendar(calendarIdentifier:
    var identifier : NSCalendar{
        switch self {
        case .arabic:
            return NSCalendar.init(identifier: NSCalendar.Identifier.islamicCivil)!
        default:
            return NSCalendar.init(identifier: NSCalendar.Identifier.gregorian)!
        }
    }
    var calIdentifier : Calendar{
        switch self {
        case .arabic:
            return Calendar.init(identifier: Calendar.Identifier.islamicCivil)
        default:
            return Calendar.init(identifier: Calendar.Identifier.gregorian)
        }
    }
    //MARK:- get display semantice
    var getSemantic:UISemanticContentAttribute {
        
        return Language.isRTL ? .forceRightToLeft : .forceLeftToRight
        
    }
    
}
