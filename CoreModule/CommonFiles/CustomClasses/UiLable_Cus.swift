//
//  UiLable_Cus.swift
//  Mutasil
//
//  Created by SCT on 02/09/25.
//

import Foundation
import SwiftUICore


struct AppText: View {
    
    @Environment(\.horizontalSizeClass) var hSizeClass

    var IsIphone: Bool {
        return hSizeClass == .compact
    }

    let text: String
    var font: FontEnums = .Bold
    var color: Color = .primary
    
    var body: some View {
        let fontSize: CGFloat = IsIphone ? .BODY : .SUBHEADER

        Text(text)
            .SetFont(FontType: font, Size: fontSize)
            .foregroundColor(color)
            .lineSpacing(2)
    }
}

struct AppPageTittle: View {
    
    @Environment(\.horizontalSizeClass) var hSizeClass

    var IsIphone: Bool {
        return hSizeClass == .compact
    }

    let text: String
    var font: FontEnums = .Bold
    var color: Color = Color(SecondaryWhite)
    
    var body: some View {
        let fontSize: CGFloat = IsIphone ? .MEDIUMHEADER : .SUPERLARGE

        Text(text)
            .SetFont(FontType: font, Size: fontSize)
            .foregroundColor(color)
            .lineSpacing(2)
    }
}

//MARK: Medium Font

struct AppPrimary_Medium_SmallText: View {
    
    @Environment(\.horizontalSizeClass) var hSizeClass

    var IsIphone: Bool {
        return hSizeClass == .compact
    }

    let text: String
    var font: FontEnums = .Medium
    var Iphonefont: CGFloat = .SMALL
    var Ipadfont: CGFloat = .BODY
    var color: Color = Color(PrimaryThemecolor)
    
    var body: some View {
        let fontSize: CGFloat = IsIphone ? Iphonefont : Ipadfont

        Text(text)
            .SetFont(FontType: font, Size: fontSize)
            .foregroundColor(color)
            .lineSpacing(2)
    }
}


struct AppBlack_Medium_SmallText: View {
    
    @Environment(\.horizontalSizeClass) var hSizeClass

    var IsIphone: Bool {
        return hSizeClass == .compact
    }

    let text: String
    var font: FontEnums = .Medium
    var IphoneSize: CGFloat = .SMALL
    var IPadSize: CGFloat = .HEADER

    var color: Color = Color(SecondaryWhite)
    
    var Alignment: TextAlignment = .leading
    var LineLimit: Int = 1000
    
    var body: some View {
        let fontSize: CGFloat = IsIphone ? IphoneSize : IPadSize

        Text(text)
            .SetFont(FontType: font, Size: fontSize, LineLimit: LineLimit)
            .lineSpacing(5)
            .foregroundColor(color)
            .multilineTextAlignment(Alignment)

    }
}



struct AppBlack_Medium_BodyText: View {
    
    @Environment(\.horizontalSizeClass) var hSizeClass

    var IsIphone: Bool {
        return hSizeClass == .compact
    }

    let text: String
    var font: FontEnums = .Medium
    var color: Color = Color(SecondaryWhite)
    var Alignment: TextAlignment = .leading
    var LineLimit: Int = 2
    
    var body: some View {
        let fontSize: CGFloat = IsIphone ? .BODY : .SUPERLARGE

        Text(text)
            .SetFont(FontType: font, Size: fontSize, LineLimit: LineLimit)
            .multilineTextAlignment(Alignment)
            .foregroundColor(color)
            .lineSpacing(2)
    }
}

struct AppBlack_Medium_SubHeaderText: View {
    
    @Environment(\.horizontalSizeClass) var hSizeClass

    var IsIphone: Bool {
        return hSizeClass == .compact
    }

    let text: String
    var font: FontEnums = .Medium
    var color: Color = Color(SecondaryWhite)
    var Alignment: TextAlignment = .center
    var LineLimit: Int = 2

    
    var body: some View {
        let fontSize: CGFloat = IsIphone ? .SUBHEADER : .SEMILARGE

        Text(text)
            .SetFont(FontType: font, Size: fontSize, LineLimit: LineLimit)
            .foregroundColor(color)
            .multilineTextAlignment(Alignment)
            .lineSpacing(2)
    }
}

struct AppBlack_Medium_HeaderText: View {
    
    @Environment(\.horizontalSizeClass) var hSizeClass

    var IsIphone: Bool {
        return hSizeClass == .compact
    }

    let text: String
    var font: FontEnums = .Medium
    var color: Color = Color(SecondaryWhite)
    
    var body: some View {
        let fontSize: CGFloat = IsIphone ? .HEADER : .LARGE

        Text(text)
            .SetFont(FontType: font, Size: fontSize)
            .foregroundColor(color)
            .lineSpacing(2)
    }
}


//MARK: AppAtributed

struct AppAtributedText: View {
    
    @Environment(\.horizontalSizeClass) var hSizeClass

    var IsIphone: Bool {
        return hSizeClass == .compact
    }

    let text: String
    let Attributedtext: String
    let Action: () -> Void
    var color: Color = Color(SecondaryWhite)
    var Attributedcolor: Color = Color(PrimaryThemecolor)
    var font: FontEnums = .Medium

    var body: some View {
        
        let fontSize: CGFloat = IsIphone ? .BODY : .MEDIUMHEADER

//        HStack(spacing: 4) {
//            Text(text)
//                .SetFont(FontType: font, Size: fontSize)
//                .foregroundColor(color)
//            
//            Text(Attributedtext)
//                .SetFont(FontType: font, Size: fontSize)
//                .foregroundColor(Attributedcolor)
//                .onTapGesture {
//                    Action()
//                }
//        }
        
        (
            Text(text)
                .foregroundColor(color)
            +
            Text(Attributedtext)
                .foregroundColor(Attributedcolor)
        )
        .lineSpacing(2)
        .SetFont(FontType: font, Size: fontSize)

        .onTapGesture {
            Action()
        }

        
    }
    
}



