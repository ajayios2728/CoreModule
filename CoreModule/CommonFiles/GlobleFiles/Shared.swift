//
//  Shared.swift
//  Mutasil
//
//  Created by SCT on 18/09/25.
//

import Foundation
import UIKit


class Shared {
    
    static var Instance = Shared()
        
    var LoginLat: Double = 0
    var LoginLong: Double = 0
    
    var currentCardIndex = 0
    var CardCount = 0
    var IsWithImage = false
    var DisContHeight = CGFloat()
//    var IsHomeCardReloaded : BtnActionEnums = .AllSwiped
    
    var DetailsFilterPassingValues = [String: [Int]]()
    var FilterPassingValues = [String: [Int]]()
    
    var Current_Step_Id: Int = 1
    var Selected_Segments_Id: String = ""
    var selected_categories: String = ""
    var selected_subcategories: String = ""
    
    var IsFromVideoBack = false
    
    var KHPopupTitle: [String] = [""]
    var KHPopupDis: [String] = [""]
    var MaximumCol: Int = 0



}
