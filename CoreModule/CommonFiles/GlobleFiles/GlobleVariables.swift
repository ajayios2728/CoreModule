//
//  GlobleVariables.swift
//
//

import Foundation
import SwiftUI

let infoPlist = PlistReader<InfoPlistKeys>()

let APIBaseUrl : String = (infoPlist?.value(for: .App_URL) ?? "").replacingOccurrences(of: "\\", with: "")

let APIUrl : String = APIBaseUrl

let AppName : String = (infoPlist?.value(for: .App_Name) ?? "")

//let ThemeColors : JSON? = infoPlist?.value(for: .ThemeColors)

let GoogleMapKey : String = (infoPlist?.value(for: .Google_Map_keys) ?? "")
let GooglePlacesKey : String = (infoPlist?.value(for: .Google_Places_keys) ?? "")
let App_ID : String = (infoPlist?.value(for: .App_ID) ?? "")
let appStoreDisplayName : String = (infoPlist?.value(for: .appStoreDisplayName) ?? "")

var isRTLLanguage : Bool { get { return Language.isRTL } }


extension UIApplication {
    func hideKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
