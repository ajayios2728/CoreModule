//
//  Custom_Fonts.swift
//  Mutasil
//
//  Created by SCT on 04/09/25.
//

import Foundation
import SwiftUICore
import SwiftUI


enum FontEnums: String, CaseIterable{
    
    case Thin             = "CodecPro-Thin"
    case ExtraLight       = "CodecPro-ExtraLight"
    case Light            = "CodecPro-Light"
//    case Regular          = "CodecPro-Regular"
    case Medium           = "CodecPro-Regular"
//    case SemiBold         = "CodecPro-Bold"
    case Bold             = "CodecPro-Bold"
    case ExtraBold        = "CodecPro-ExtraBold"
    case Black            = "NotoSans-Black"
    case ThinItalic       = "CodecPro-ThinItalic"
    case ExtraLightItalic = "CodecPro-ExtraLightItalic"
    case LightItalic      = "CodecPro-LightItalic"
    case Italic           = "CodecPro-Italic"
    case MediumItalic     = "NotoSans-MediumItalic"
    case SemiBoldItalic   = "NotoSans-SemiBoldItalic"
    case BoldItalic       = "CodecPro-BoldItalic"
    case ExtraBoldItalic  = "CodecPro-ExtraBoldItalic"
    case BlackItalic      = "NotoSans-BlackItalic"
    
}

extension CGFloat {
    static let EXTRALARGE :CGFloat = 52
    static let LARGE :CGFloat = 35
    static let SUPERLARGE :CGFloat = 30
    static let SEMILARGE :CGFloat = 24
    static let HEADER:CGFloat = 20
    static let MEDIUMHEADER:CGFloat = 18
    static let SUBHEADER:CGFloat = 16
    static let BODY:CGFloat = 14
    static let MiniBODY:CGFloat = 13
    static let SMALL:CGFloat = 12
    static let TINY:CGFloat = 10
    static let TINYSMALL:CGFloat = 8
}

extension UIFont {
    open class func lightFont(size: CGFloat) -> UIFont {
        return UIFont(name: FontEnums.Light.rawValue,
                      size: size) ?? .systemFont(ofSize: 14,
                                                 weight: .light)
    }
    
//    open class func MediumFont(size: CGFloat) -> UIFont {
//        return UIFont(name: Fonts.CodecPro_Plain,
//                      size: size) ?? .systemFont(ofSize: 14,
//                                                 weight: .medium)
//    }
//    
//    open class func BoldFont(size: CGFloat) -> UIFont {
//        return UIFont(name: Fonts.CodecPro_Plain,
//                      size: size) ?? .systemFont(ofSize: 14,
//                                                 weight: .bold)
//    }
}
extension Text {
    
    func SetFont(FontType: FontEnums,Size: CGFloat, LineLimit: Int = 10) -> some View {
        
        self.font(Font.custom(FontType.rawValue, size: Size))
            .lineLimit(LineLimit)
        
    }
}

extension TextField {
    
    func SetFont(FontType: FontEnums,Size: CGFloat, LineLimit: Int = 10) -> some View {
        
        self.font(Font.custom(FontType.rawValue, size: Size))
            .lineLimit(LineLimit)
        
    }
}

extension SecureField {
    
    func SetFont(FontType: FontEnums,Size: CGFloat, LineLimit: Int = 10) -> some View {
        
        self.font(Font.custom(FontType.rawValue, size: Size))
            .lineLimit(LineLimit)
        
    }
}

extension TextEditor {
    
    func SetFont(FontType: FontEnums,Size: CGFloat, LineLimit: Int = 10) -> some View {
        
        self.font(Font.custom(FontType.rawValue, size: Size))
            .lineLimit(LineLimit)
        
    }
}

extension Button {
    
    func SetFont(FontType: FontEnums,Size: CGFloat, LineLimit: Int = 10) -> some View {
        
        self.font(Font.custom(FontType.rawValue, size: Size))
            .lineLimit(LineLimit)
        
    }
}

extension View {
    
    func SetFont(FontType: FontEnums,Size: CGFloat, LineLimit: Int = 10) -> some View {
        
        self.font(Font.custom(FontType.rawValue, size: Size))
            .lineLimit(LineLimit)
        
    }
}

