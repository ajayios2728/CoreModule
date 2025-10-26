//
//  LanguageProtocol.swift
//  Mutasil
//
//  Created by SCT on 01/09/25.
//

import Foundation

protocol LanguageProtocol {
    
    // MARK: TabBar
    var Home : String {get} //dont include special characters
    var Circular : String {get}
    var Discussion : String {get}
    var Calculation : String {get}
    var More : String {get}
    
    // MARK: More Options
    var Courses : String {get}
    var Exam : String {get}
    var share_Your_Product : String {get}
    var Survey_Form : String {get}
    var Business_Card : String {get}
    var Offer : String {get}
    var Target : String {get}
    var General_Information : String {get}

    // MARK: Login Page
    var Ok : String {get}
    var Login : String {get}
    var Dont_Receive : String {get}

    var Logging_In : String {get}
    var Forgot_Password : String {get}
    var Dont_have_an_Unique_ID : String {get}
    var Create_Now : String {get}
    var Enter_the_Unique_ID : String {get}
    var Enter_password : String {get}
    
    //MARK: OTP Page
    var Please_Login : String {get}
    var Enter_OTP : String {get}
    var Otp_Verfication : String {get}
    var If_you_dont_have_the_access : String {get}
    var If_you_are_having_trouble : String {get}
    var Resend_OTP : String {get}
    var Enter_Valid_OTP : String {get}
    
    //MARK: Home Page
    var Products : String {get}
    var Social_Media : String {get}
    var Whats_New : String {get}
    var FAQ : String {get}
    var You_all_set : String {get}
    var Collaboration_with_your_Team : String {get}

    //MARK: Knowledge Hub
    var Knowledge_Hub : String {get}
    var Search : String {get}
    var Find_suitable_products : String {get}
    
    //MARK: Knowledge Hub Filter
    var Filter : String {get}
    var Apply : String {get}
    var ClearAll : String {get}
    var SelectAll : String {get}
    
    //MARK: Knowledge Hub Details Page
    var Proceed : String {get}
    var Complete_Product_Factsheet : String {get}
    var Guided_Product_Finder : String {get}
    var Assessment : String {get}
    var Video : String {get}
    var Sales_Tips : String {get}
    var Collapse_All : String {get}
    var Product_Specifications : String {get}

}
