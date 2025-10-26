//
//  UiImageView_Ext.swift
//  Mutasil
//
//  Created by SCT on 02/09/25.
//

import Foundation
import UIKit


func resizeImage(image: UIImage, intWidth: Int) -> UIImage {
    UIGraphicsBeginImageContext(CGSize(width:CGFloat(intWidth), height:((image.size.height/image.size.width) * CGFloat(intWidth))))
    image.draw(in: CGRect(x:0, y:0, width:CGFloat(intWidth), height:((image.size.height/image.size.width) * CGFloat(intWidth))))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage!
}

