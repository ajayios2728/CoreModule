//
//  Arabic.swift
//  Mutasil
//
//  Created by SCT on 01/09/25.
//

import Foundation

class Arabic:LanguageProtocol {
    
    // MARK: TabBar
    lazy var Home: String = {return "الرئيسية"}()
    lazy var Circular: String = {return "التعاميم"}()
    lazy var Discussion: String = {return "المنتدى"}()
    lazy var Calculation: String = {return "الحاسبة"}()
    lazy var More: String = {return "المزيد"}()
    
    // MARK: More Options
    lazy var Courses: String = {return "Courses"}()
    lazy var Exam: String = {return "Exam"}()
    lazy var share_Your_Product: String = {return "Share Your Product"}()
    lazy var Survey_Form: String = {return "Survey Form"}()
    lazy var Business_Card: String = {return "Business_Card"}()
    lazy var Offer: String = {return "Offer"}()
    lazy var Target: String = {return "Target"}()
    lazy var General_Information: String = {return "General Information"}()

    // MARK: Login Page
    lazy var Login: String = {return "تسجيل الدخول"}()
    lazy var Dont_Receive: String = {return "Don't receive the OTP?"}()

    lazy var Forgot_Password: String = {return "نسيت الرقم السري"}()
    lazy var Dont_have_an_Unique_ID: String = {return "Don't have an Unique ID?"}()
    lazy var Create_Now: String = {return "Create Now"}()
    lazy var Enter_the_Unique_ID: String = {return "Enter the Unique ID"}()
    lazy var Enter_password: String = {return "Enter password"}()
    
    //MARK: OTP Page
    lazy var Ok: String = {return "OK"}()
    lazy var Please_Login: String = {return "Please Login"}()
    lazy var Logging_In: String = {return "Loging In"}()
    lazy var Enter_OTP: String = {return "Enter the code from the sms we sent"}()
    lazy var Otp_Verfication: String = {return "OTP Verification"}()
    lazy var If_you_dont_have_the_access: String = {return "If you don't have the access, please click the  Skip  to proceed.?"}()
    lazy var If_you_are_having_trouble: String = {return "If you are having trouble logging in, or have forgotten your username or password, please contact your Adminstrator."}()
    lazy var Resend_OTP: String = {return "Resend OTP"}()
    lazy var Enter_Valid_OTP: String = {return "Please enter valid otp"}()

    //MARK: Home Page
    lazy var Products: String = {return "Products"}()
    lazy var Social_Media: String = {return "Social Media"}()
    lazy var Whats_New: String = {return "What's New"}()
    lazy var FAQ: String = {return "FAQ"}()
    lazy var You_all_set : String = {return "انتهاء الرسائل"}()
    lazy var Collaboration_with_your_Team : String = {return "التواصل في منتدى النقاش"}()
    
    //MARK: Knowledge Hub
    lazy var Knowledge_Hub: String = {return "Knowledge Hub"}()
    lazy var Search: String = {return "Search"}()
    lazy var Find_suitable_products: String = {return "Find suitable products"}()

    //MARK: Knowledge Hub Filter
    lazy var Filter: String = {return "Filter"}()
    lazy var Apply: String = {return "Apply"}()
    lazy var ClearAll: String = {return "Clear All"}()
    lazy var SelectAll: String = {return "Select All"}()

    //MARK: Knowledge Hub Details Page
    lazy var Proceed: String = {return "Proceed"}()
    lazy var Complete_Product_Factsheet: String = {return "Complete Product Factsheet"}()
    lazy var Guided_Product_Finder: String = {return "Guided Product Finder"}()
    lazy var Assessment: String = {return "Assessment"}()
    lazy var Video: String = {return "Video"}()
    lazy var Sales_Tips: String = {return "Sales Tips"}()
    lazy var Collapse_All: String = {return "Collapse All"}()
    lazy var Product_Specifications: String = {return "Product Specifications"}()

}
