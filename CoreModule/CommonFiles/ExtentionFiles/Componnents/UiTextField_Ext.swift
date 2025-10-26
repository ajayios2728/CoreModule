//
//  UiTextField_Ext.swift
//  Mutasil
//
//  Created by SCT on 02/09/25.
//

import Foundation
import SwiftUI
import UIKit


extension TextField {
    
    func Elevate(IsfocusedOTP0: Bool = false, OTPText: String, Error: String) -> some View {
        self.frame(width: ScreenWidth/8,height: ScreenWidth/8)
//            .offset(x:10)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(
                        .shadow(.drop(color: (Error != "" ? .red : (IsfocusedOTP0 || OTPText != "") ? Color(PrimaryThemecolor) : .gray),radius: 2, x: 0, y: 0))
                    )
                    .foregroundColor(Color(PrimaryWhite))
                    .frame(width: ScreenWidth/8, height: ScreenWidth/8, alignment: .center)
            )
            .SetFont(FontType: .Bold, Size: .LARGE, LineLimit: 0)
            .multilineTextAlignment(.center)
            .foregroundStyle(Color.black)
            .accentColor(Color(PrimaryThemecolor))
//            .keyboardType(.numberPad)


            

        
        
    }
    
    
}

//extension OTPCustomTextField {
//    
//    func Elevate(IsfocusedOTP0: Bool = false, OTPText: String, Error: String) -> some View {
//        self.frame(width: ScreenWidth/8,height: ScreenWidth/8)
////            .offset(x:10)
//            .background(
//                RoundedRectangle(cornerRadius: 10, style: .continuous)
//                    .fill(
//                        .shadow(.drop(color: (Error != "" ? .red : (IsfocusedOTP0 || OTPText != "") ? Color(PrimaryThemecolor) : .gray),radius: 2, x: 0, y: 0))
//                    )
//                    .foregroundColor(Color(PrimaryWhite))
//                    .frame(width: ScreenWidth/8, height: ScreenWidth/8, alignment: .center)
//            )
//            .SetFont(FontType: .Bold, Size: .LARGE, LineLimit: 0)
//            .multilineTextAlignment(.center)
//            .foregroundStyle(Color.black)
//            .accentColor(Color(PrimaryThemecolor))
//            .keyboardType(.numberPad)
//        
//    }
//    
//    
//}


extension UITextField {
    
    func Elevate() {
        self.frame = CGRect(x: 0, y: 0, width: ScreenWidth/8, height: ScreenWidth/8)
        self.font = UIFont.systemFont(ofSize: .SEMILARGE, weight: .bold)
        self.textAlignment = .center
        self.keyboardType = .numberPad
    }
    
    
}
