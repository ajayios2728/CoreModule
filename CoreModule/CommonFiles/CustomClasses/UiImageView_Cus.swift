//
//  UiImageView_Cus.swift
//  Mutasil
//
//  Created by SCT on 02/09/25.
//

import Foundation
import SwiftUI

var IconWidth = Device.screen.width / 16
var IconHeight = Device.screen.width / 16

func AppThemeIcon(imageName: ImageResource,
                Width: CGFloat = IconWidth, Height: CGFloat = IconHeight,
                InnerPadding: CGFloat = 5, OuterPadding: CGFloat = 5,
                IsRounded: Bool = true,
                CornerRadius: CGFloat = 20, Corners: UIRectCorner = .allCorners,
                IconColor: UIColor = IconsThemeColor, BackGroundColor: UIColor = IconsBackGroundColor,
                  RenderingMode: Image.TemplateRenderingMode = .template) -> some View {
    
    let IconSize: CGFloat = (Width == Height) ? Width : min(Width, Height)
    let Radius: CGFloat = IsRounded ? IconSize : CornerRadius
    
    
    
    let CustomImage = Image(imageName)
        .renderingMode(RenderingMode)
        .resizable()
        .scaledToFit()
        .frame(width: IconSize, height: IconSize)
        .foregroundStyle(Color(IconColor))
        .padding(InnerPadding)
        .background(Color(BackGroundColor))
        .roundedCorner(Radius, corners: .allCorners)
        .padding(OuterPadding)

    
    return CustomImage
    
}

extension UIView {
    
    var isRoundCorner : Bool{
        get{
            return self.layer.cornerRadius != 0
        }
        set(newValue){
            if newValue{
                self.clipsToBounds = true
                self.layer.cornerRadius = self.frame.height / 2
            }else{
                self.layer.cornerRadius = 0
            }
        }
    }
    
}
