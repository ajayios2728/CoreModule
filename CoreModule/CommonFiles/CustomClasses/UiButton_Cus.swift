//
//  UiButton_Cus.swift
//  Mutasil
//
//  Created by SCT on 02/09/25.
//

import Foundation
import SwiftUICore
import SwiftUI


struct PrimaryButton: View {
    
    @Environment(\.horizontalSizeClass) var hSizeClass

    var IsIphone: Bool {
        return hSizeClass == .compact
    }

    let title: String
    @State var isAnimating: Bool = false
    var Tapped: Bool = false
    var LoadingText: String = ""
    let action: () -> Void
    var ForGroundColor : Color = .white
    var BackGroundColor : UIColor = PrimaryThemecolor
    
    var FontName : FontEnums = .Bold
    var LineLimit : Int = 0
    
    var body: some View {
        
//        let Width: CGFloat = IsIphone ? ScreenWidth - 150 : 400
//        let Height: CGFloat = IsIphone ? 50 : 60
        let Width: CGFloat = ScreenWidth - 150
        let Height: CGFloat = ScreenWidth / (IsIphone ? 8 : 12)
        
        let FontSize : CGFloat = IsIphone ? .SUBHEADER : .HEADER

            
        Button(action: action) {
            HStack {

                if Tapped {
                    HStack(alignment: .center) {
                        
                        Circle()
                            .trim(from: 0, to: 0.8)
                            .stroke(Color.white, lineWidth: 4)
                            .frame(width: 20, height: 20)
                            .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
                            .animation(Animation.linear(duration: 0.5).repeatForever(autoreverses: false),value: isAnimating)
                            .foregroundColor(Color.blue)
                            .onAppear(){
                                isAnimating.toggle()
                            }
                        
                        
                        Text(LoadingText)
                            .SetFont(FontType: FontName, Size: FontSize, LineLimit: LineLimit)
                            .foregroundColor(ForGroundColor)
                    }
                    .disabled(true)
                        
                }
                else{
                    
                    Text(title)
                        .SetFont(FontType: FontName, Size: FontSize, LineLimit: LineLimit)
                        .foregroundColor(ForGroundColor)
                        .frame(width: Width, height: Height)
                        .disabled(false)
                    //                    .background(Color(uiColor: BackGroundColor))
                    //                    .cornerRadius(5)
                    //                    .shadow(radius: 4)
                }
                
            }
        }
        .foregroundColor(ForGroundColor)
        .frame(width: Width, height: Height)
        .background(Color(uiColor: BackGroundColor))
        .opacity(Tapped ? 0.5 : 1)
        .cornerRadius(5)
        .shadow(radius: 4)


        
    }
}


struct SecondaryMediumButton: View {
    
    @Environment(\.horizontalSizeClass) var hSizeClass

    var IsIphone: Bool {
        return hSizeClass == .compact
    }

    let title: String
    var ForGroundColor : Color = .black
    var BackGroundColor : UIColor = PrimaryBtnThemecolor
    
    var FontName : FontEnums = .Medium
    var LineLimit : Int = 0
    
    let action: () -> Void

    var body: some View {
        
        let Width: CGFloat = IsIphone ? ScreenWidth - 150 : 400
        let Height: CGFloat = IsIphone ? 45 : 55
        let FontSize : CGFloat = IsIphone ? .BODY : .SUBHEADER

            
        Button(action: action) {
            Text(title)
                .SetFont(FontType: FontName, Size: FontSize, LineLimit: LineLimit)
                .foregroundColor(ForGroundColor)
                .frame(maxWidth: Width,maxHeight: Height)
                .background(Color(uiColor: BackGroundColor))
                .cornerRadius(8)
                .shadow(radius: 4)
        }
        
    }
}


struct CustomButton: View {
    
    @Environment(\.horizontalSizeClass) var hSizeClass

    var IsIphone: Bool {
        return hSizeClass == .compact
    }

    let title: String
    var ForGroundColor : Color = .white
    var BackGroundColor : UIColor = PrimaryThemecolor
    var CornnerRadius : CGFloat = 5
    
    var FontName : FontEnums = .Bold
    var IPhoneFontSize : CGFloat = .SUBHEADER
    var IPadFontSize : CGFloat = .HEADER
    var LineLimit : Int = 0
    var Alignment: TextAlignment = .leading

    let Width: CGFloat
    let Height: CGFloat
    var Shadow : CGFloat = 4
    
    
    let action: () -> Void

    
    var body: some View {
                
        let FontSize : CGFloat = IsIphone ? IPhoneFontSize : IPadFontSize

            
        Button(action: action) {
            Text(title)
                .SetFont(FontType: FontName, Size: FontSize, LineLimit: LineLimit)
                .multilineTextAlignment(Alignment)
                .foregroundColor(ForGroundColor)
                .frame(width: Width, height: Height)
                .background(Color(uiColor: BackGroundColor))
                .cornerRadius(CornnerRadius)
                .shadow(radius: Shadow)
        }
        
    }
}

struct CustomSmallButton: View {
    
    @Environment(\.horizontalSizeClass) var hSizeClass

    var IsIphone: Bool {
        return hSizeClass == .compact
    }

    let title: String
    var ForGroundColor : Color = .white
    var BackGroundColor : UIColor = PrimaryThemecolor
    var CornnerRadius : CGFloat = 5
    
    var FontName : FontEnums = .Bold
    var IPhoneFontSize : CGFloat = .SMALL
    var IPadFontSize : CGFloat = .SUBHEADER
    var Padding: CGFloat = 7

    var LineLimit : Int = 0
    
    let Width: CGFloat
    let Height: CGFloat
    
    let action: () -> Void

    
    var body: some View {
                
        let FontSize : CGFloat = IsIphone ? IPhoneFontSize : IPadFontSize

            
        Button(action: action) {
            Text(title)
                .SetFont(FontType: FontName, Size: FontSize, LineLimit: LineLimit)
                .foregroundColor(ForGroundColor)
                .frame(width: Width, height: Height)
                .padding(.horizontal,Padding)
                .background(Color(uiColor: BackGroundColor))
                .cornerRadius(CornnerRadius)
                .shadow(radius: 4)
        }
        
    }
}


struct AutoSizeButton: View {
    
    @Environment(\.horizontalSizeClass) var hSizeClass

    var IsIphone: Bool {
        return hSizeClass == .compact
    }

    let title: String
    var ForGroundColor : Color = .white
    var BackGroundColor : UIColor = PrimaryThemecolor
    var CornnerRadius : CGFloat = 5
    var Cornners : UIRectCorner? = .allCorners
    
    var FontName : FontEnums = .Bold
    var IPhoneFontSize : CGFloat = .SUBHEADER
    var IPadFontSize : CGFloat = .HEADER
    var Padding: CGFloat = 7
    var LineLimit : Int = 0
    var Alignment: TextAlignment = .leading

//    let Width: CGFloat
//    let Height: CGFloat
    var Shadow : CGFloat = 4
    
    
    let action: () -> Void

    
    var body: some View {
                
        let FontSize : CGFloat = IsIphone ? IPhoneFontSize : IPadFontSize

            
        Button(action: action) {
            Text(title)
                .SetFont(FontType: FontName, Size: FontSize, LineLimit: LineLimit)
                .multilineTextAlignment(Alignment)
                .foregroundColor(ForGroundColor)
//                .frame(width: Width, height: Height)
                .padding(Padding)
                .background(Color(uiColor: BackGroundColor))
                .roundedCorner(CornnerRadius, corners: Cornners ?? .allCorners)
                .shadow(radius: Shadow)
        }
        
    }
}


struct ZstackButton: View {
    
    @Environment(\.horizontalSizeClass) var hSizeClass

    var IsIphone: Bool {
        return hSizeClass == .compact
    }

    let title: String
    var ForGroundColor : Color = .white
    var BackGroundColor : UIColor = PrimaryThemecolor
    var CornnerRadius : CGFloat = 5
    var Cornners : UIRectCorner? = .allCorners
    
    var FontName : FontEnums = .Bold
    var IPhoneFontSize : CGFloat = .SUBHEADER
    var IPadFontSize : CGFloat = .HEADER
    var Padding: CGFloat = 7
    var LineLimit : Int = 0
    var Alignment: TextAlignment = .leading

    let Width: CGFloat
//    let Height: CGFloat
    var Shadow : CGFloat = 4
    
    
    let action: () -> Void

    
    var body: some View {
                
        let FontSize : CGFloat = IsIphone ? IPhoneFontSize : IPadFontSize

            
        Button(action: action) {
            Text(title)
                .SetFont(FontType: FontName, Size: FontSize, LineLimit: LineLimit)
                .multilineTextAlignment(Alignment)
                .foregroundColor(ForGroundColor)
//                .frame(width: Width, height: Height)
                .padding(Padding)
                .frame(width: Width)
                .background(Color(uiColor: BackGroundColor))
                .roundedCorner(CornnerRadius, corners: Cornners ?? .allCorners)
                .shadow(radius: Shadow)
        }
        
    }
}
