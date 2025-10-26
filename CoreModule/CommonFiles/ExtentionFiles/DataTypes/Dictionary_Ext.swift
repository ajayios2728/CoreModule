//
//  Dictionary_Ext.swift
//  Mutasil
//
//  Created by SCT on 03/09/25.
//

import Foundation

typealias JSON = [String: Any]
extension Dictionary where Dictionary == JSON {
    var status : Bool{
        
//        var StringStatus = (self["status"] as? String ?? String())
//
//        return StringStatus == "" ? (self["status"] as? Int ?? Int()) : Int(self["status"] as? String ?? String()) ?? Int()
        
        return self["status"] as? Bool ?? Bool()
    }
    var isSuccess : Bool{
        return status != false
    }
    init?(_ data : Data){
          if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]{
              self = json ?? [String : Any]()
          }else{
              return nil
          }
      }
    var status_message : String{
        
        let statusMessage = self.string("message")
        let successMessage = self.string("message")
        return statusMessage.isEmpty ? successMessage : statusMessage
    }

//    var success_message : String{
//        return self["success_message"] as? String ?? String()
//    }
    
    func array<T>(_ key : String) -> [T]{
        return self[key] as? [T] ?? [T]()
    }
    func array(_ key : String) -> [JSON]{
        return self[key] as? [JSON] ?? [JSON]()
    }
    func json(_ key : String) -> JSON{
        return self[key] as? JSON ?? JSON()
    }
     func string(_ key : String)-> String{
     // return self[key] as? String ?? String()
         let value = self[key]
         if let str = value as? String{
            return str
         }else if let int = value as? Int{
            return int.description
         }else if let double = value as? Double{
            return double.description
         }else{
            return String()
         }
     }
    func nsString(_ key: String)-> NSString {
        return self.string(key) as NSString
    }
     func int(_ key : String)-> Int{
         //return self[key] as? Int ?? Int()
         let value = self[key]
         if let str = value as? String{
            return Int(str) ?? Int()
         }else if let int = value as? Int{
            return int
         }else if let double = value as? Double{
            return Int(double)
         }else{
            return Int()
         }
     }
     func double(_ key : String)-> Double{
     //return self[key] as? Double ?? Double()
         let value = self[key]
         if let str = value as? String{
            return Double(str) ?? Double()
         }else if let int = value as? Int{
            return Double(int)
         }else if let double = value as? Double{
            return double
         }else{
            return Double()
         }
     }
    
    func bool(_ key : String) -> Bool{
        let value = self[key]
        if let bool = value as? Bool{
            return bool
        }else if let int = value as? Int{
            return int == 1
        }else if let str = value as? String{
            return ["1","true"].contains(str)
        }else{
            return Bool()
        }
    }
}
