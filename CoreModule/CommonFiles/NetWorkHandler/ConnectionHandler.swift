//
//  ConnectionHandler.swift
//  Mutasil
//
//  Created by SCT on 02/09/25.
//

import Foundation
import Alamofire
import SwiftUI


enum ApiType {
    case Multipart
    case RawData
    case Deafult
}

enum MultipartType {
    case Images
    case PDFAudio
}

enum APIStatusCode: Int {
//    // ✅ Success
//    case success          = 200
    
    // ⚠️ Client errors
    case badRequest       = 400   // Invalid request / missing params
    case unauthorized     = 401   // Unauthenticated
    case forbidden        = 403   // Permission denied
    case notFound         = 404   // Resource not found
    case unprocessable    = 422   // Validation error
    
    // 🚨 Server errors
    case serverError      = 500   // Internal server error
    case badGateway       = 502
    case serviceUnavailable = 503
    case gatewayTimeout   = 504
    
    // ❓ Fallback
    case unknown          = -1
    
}

struct APIErrorResponse: APIResponseProtocol {
    func responseDecode<T>(to modal: T.Type, _ result: @escaping Closure<T>) -> any APIResponseProtocol where T : Decodable {
        return self
    }
    
    func responseJSON(_ result: @escaping Closure<JSON>) -> any APIResponseProtocol {
        return self
    }
    
    func responseFailure(_ error: @escaping Closure<String>) {
        print(error)
    }
    
    let message: String
    let rawData: Data
}


class ConnectionHandler: NSObject {
    
    var Toaster = ToastManager.shared
    
    static var Sharedc = ConnectionHandler()
    
    func CallApiRequest(for api : APIEnums,
                        ShowToast:Bool = true,
                        params : Parameters,
                        apitype : ApiType = .Deafult,
                        multiPartType : MultipartType = .Images,
                        fileName : String = "",
                        dictPDFAudio: NSDictionary = NSDictionary(),
                        ArrData: [Data] = [],
                        imgData : [UIImage] = [UIImage]()) -> APIResponseProtocol {
        
        
        guard Reachability.isConnectedToNetwork() else {
        
            Timer.scheduledTimer(timeInterval: 0.1, target:self, selector:#selector(self.reloadInputViews(timer:)), userInfo:nil, repeats:true)
            print("No Internet")
            let Toaster = ToastManager.shared
            Toaster.show(style: .info, message: "No internet connection")
            
            return APIErrorResponse(message: "No internet connection", rawData: Data())
        }
        
        switch apitype {
        case .Multipart:
            switch multiPartType {
            case .Images:
                // MARK: For Multiple Image send ImageName As "\(imageName)[]"
                return self.UploadImageRequest(for: APIUrl + api.rawValue,
                                               params: params,
                                               imageName: fileName,
                                               ShowToast: ShowToast,
                                               imagesDatas: imgData)
                
            case .PDFAudio:
                return self.UploadPDFAudioRequest(for: APIUrl + api.rawValue,
                                                  params: params,
                                                  ShowToast: ShowToast,
                                                  dictPDFAudio: dictPDFAudio)
                
            }
            
        case .RawData:
            return self.PostRawRequest(forAPI: APIUrl + api.rawValue, ShowToast: ShowToast, params: params)
            
        case .Deafult:
            if api.method == .get {
                return self.GetRequest(forAPI: APIUrl + api.rawValue,
                                       params: params,
                                       ShowToast: ShowToast,
                                       CacheAttribute: api.cacheAttribute ? api : .none)
                
            }else {
                return self.PostRequest(forAPI: APIUrl + api.rawValue,
                                        ShowToast: ShowToast,
                                        params: params)
                
            }
        }
        
        
    }
    
    @objc func reloadInputViews(timer: Timer) {
        if Reachability.isConnectedToNetwork() {
            print("Back To Internet")
            //            CallApiRequest(for: ., params: <#T##Parameters#>)
            let Toaster = ToastManager.shared
            Toaster.show(style: .info, message: "Back To Internet")
            timer.invalidate()
        }
    }
    
    
}


extension ConnectionHandler {
    
    
    func UploadImageRequest(for api : String,
                            params : Parameters,
                            imageName:String = "image",
                            ShowToast:Bool,
                            imagesDatas: [UIImage])-> APIResponseProtocol {
        
        let startTime = Date()
        let responseHandler = APIResponseHandler()
        var param = params
        let token = KeyChainManager.getValue(for: "AccessToken") ?? ""
        var Header =  HTTPHeaders()
        
        Header["Accept-Language"] = Language.getCurrentLanguage() == .english ? "EN" : "AR"
        Header["Content-Type"] = "application/json"
        Header["accept"] = "application/json"
        
        if token != ""{
            Header["Accesskey"] = token
            Header["Authorization"] = "Bearer \(token)"
        }
        
        param["language"] = Language.getCurrentLanguage() == .english ? "EN" : "AR"
        
        PrintParameters(api: api, Header: Header, param: param)
        
        AF.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in param {
                if key != imageName {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                }
            }
            
            
            var dataArray = [Data]()
            for (index,image) in imagesDatas.enumerated(){
                if let data = image.jpegData(compressionQuality: 0){
                    dataArray.append(data)
                }
            }
            
            
            //          import image to request
            
            for i in 0..<imagesDatas.count {
                let imgAttach = imagesDatas[i]
                
                if let imgData = resizeImage(image: imgAttach, intWidth: 1024).jpegData(compressionQuality: 0.5) {
                    multipartFormData.append(imgData, withName: "\(imageName)", fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
                }
            }
            
            
        }, to: api, headers: Header)
        
        .responseJSON { (response) in
            
            let endTime = Date()
            
            Reachability.networkChecker(with: startTime, EndTime: endTime, ContentData: response.data)
            
            var StatusCode: Int?
            StatusCode = response.response?.statusCode
            
            if StatusCode != 200 {
                self.HandleErrors(StatusCode: APIStatusCode(rawValue: StatusCode ?? -1) ?? APIStatusCode.unknown, ShowToast: ShowToast, response: response)
            }

            switch response.result {
            case .success(let value):
                let json = value as! JSON
                
                let error = json.string("error")
                guard error.isEmpty else{
                    if error == "user_not_found"
                        && response.request?.url?.description.contains(APIUrl) ?? false{
                        // self.doLogoutActions()
                    }
                    responseHandler.handleFailure(value: error, data: response.data ?? Data())
                    return
                }
                if json.isSuccess
                    || !api.contains(APIUrl)
                    || response.response?.statusCode == 200 {
                    
                    responseHandler.handleSuccess(value: value,data: response.data ?? Data())
                }else{
                    responseHandler.handleFailure(value: json.status_message, data: response.data ?? Data())
                }
            case .failure(let error):
                if error._code == 13 {
                    responseHandler.handleFailure(value: "something went wrong.".localizedCapitalized, data: response.data ?? Data())
                } else if error._code == 500 {
                    responseHandler.handleFailure(value: "", data: response.data ?? Data())
                } else {
                    responseHandler.handleFailure(value: error.localizedDescription, data: response.data ?? Data())
                }
            }
            
        }
        
        
        return responseHandler
    }
    
    
}



extension ConnectionHandler {
    
    func UploadPDFAudioRequest(for api : String,
                               params : Parameters,
                               ShowToast:Bool,
                               dictPDFAudio: NSDictionary)-> APIResponseProtocol {
        
        let startTime = Date()
        let responseHandler = APIResponseHandler()
        var param = params
        let token = KeyChainManager.getValue(for: "AccessToken") ?? ""
        var Header =  HTTPHeaders()
        
        Header["Accept-Language"] = Language.getCurrentLanguage() == .english ? "EN" : "AR"
        Header["Content-Type"] = "application/json"
        Header["accept"] = "application/json"
        
        if token != ""{
            Header["Accesskey"] = token
            Header["Authorization"] = "Bearer \(token)"
        }
        
        param["language"] = Language.getCurrentLanguage() == .english ? "EN" : "AR"
        
        PrintParameters(api: api, Header: Header, param: param)
        
        AF.upload(multipartFormData: { (multipartFormData) in
            
            // Append PDF or audio attachment
            let dictPDFAudio = dictPDFAudio
            
            if let fileURL = dictPDFAudio.value(forKey: "file") as? URL {
                do {
                    let documentData = try Data(contentsOf: fileURL)
                    let fileType = dictPDFAudio.value(forKey: "type") as? String ?? ""
                    
                    if fileType == "Document" {
                        multipartFormData.append(documentData, withName: "files[]", fileName: "Document.pdf", mimeType: "application/pdf")
                    } else if fileType == "Record" {
                        let fileExtension = fileURL.pathExtension
                        multipartFormData.append(documentData, withName: "files[]", fileName: "Audio.\(fileExtension)", mimeType: "audio/\(fileExtension)")
                    }
                } catch {
                    print("Error appending document data:", error)
                }
            }
            
            
        }, to: api, headers: Header)
        
        .responseJSON { (response) in
            
            let queryString = self.encodeParameters(param)
            let endTime = Date()
            
            Reachability.networkChecker(with: startTime, EndTime: endTime, ContentData: response.data)
            
            var StatusCode: Int?
            StatusCode = response.response?.statusCode
            
            if StatusCode != 200 {
                self.HandleErrors(StatusCode: APIStatusCode(rawValue: StatusCode ?? -1) ?? APIStatusCode.unknown, ShowToast: ShowToast, response: response)
            }

            
            switch response.result {
            case .success(let value):
                let json = value as! JSON
                
                let error = json.string("error")
                guard error.isEmpty else{
                    if error == "user_not_found"
                        && response.request?.url?.description.contains(APIUrl) ?? false{
                        // self.doLogoutActions()
                    }
                    responseHandler.handleFailure(value: error, data: response.data ?? Data())
                    return
                }
                if json.isSuccess
                    || !api.contains(APIUrl)
                    || response.response?.statusCode == 200 {
                    
                    responseHandler.handleSuccess(value: value,data: response.data ?? Data())
                }else{
                    responseHandler.handleFailure(value: json.status_message, data: response.data ?? Data())
                }
            case .failure(let error):
                if error._code == 13 {
                    responseHandler.handleFailure(value: "something went wrong.".localizedCapitalized, data: response.data ?? Data())
                } else if error._code == 500 {
                    responseHandler.handleFailure(value: "", data: response.data ?? Data())
                } else {
                    responseHandler.handleFailure(value: error.localizedDescription, data: response.data ?? Data())
                }
            }
            
        }
        
        
        return responseHandler
    }
}



extension ConnectionHandler {
    
    func PostRawRequest(forAPI api: String,
                        ShowToast:Bool,
                        params: JSON) -> APIResponseProtocol {
        let responseHandler = APIResponseHandler()
        var parameters = params
        let token = KeyChainManager.getValue(for: "AccessToken") ?? ""
        let startTime = Date()
        var Header =  HTTPHeaders()
        
        
        Header["Accept-Language"] = Language.getCurrentLanguage() == .english ? "EN" : "AR"
        Header["Content-Type"] = "application/json"
        Header["accept"] = "application/json"
        
        if token != ""{
            Header["Accesskey"] = token
            Header["Authorization"] = "Bearer \(token)"
        }
        
        parameters["language"] = Language.getCurrentLanguage() == .english ? "EN" : "AR"
        
        var memberJson : String = ""
        do{
            let jsonEncoder = JSONEncoder()
            
        }catch{}
        
        var request = URLRequest(url: URL(string: api)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.headers = Header
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        PrintParameters(api: api, Header: Header, param: parameters)
        
        
        AF.request(request)
            .responseJSON { (response) in
                
                let queryString = self.encodeParameters(parameters)
                let endTime = Date()
                
                Reachability.networkChecker(with: startTime, EndTime: endTime, ContentData: response.data)
                
                var StatusCode: Int?
                StatusCode = response.response?.statusCode
                
                if StatusCode != 200 {
                    self.HandleErrors(StatusCode: APIStatusCode(rawValue: StatusCode ?? -1) ?? APIStatusCode.unknown, ShowToast: ShowToast, response: response)
                }

                
                switch response.result{
                case .success(let value):
                    let json = value as! JSON
                    let error = json.string("error")
                    guard error.isEmpty else{
                        if error == "user_not_found"
                            && response.request?.url?.description.contains(APIUrl) ?? false{
                            //self.doLogoutActions()
                        }else{
                            print(error)
                            responseHandler.handleFailure(value: error, data: response.data ?? Data())
                        }
                        responseHandler.handleFailure(value: error, data: response.data ?? Data())
                        return
                    }
                    if json.isSuccess
                        || !api.contains(APIUrl)
                        || response.response?.statusCode == 200{
                        
                        responseHandler.handleSuccess(value: value,data: response.data ?? Data())
                    }else{
                        responseHandler.handleFailure(value: json.status_message, data: response.data ?? Data())
                    }
                case .failure(let error):
                    if error._code == 13 {
                        responseHandler.handleFailure(value: "something went wrong.".localizedCapitalized, data: response.data ?? Data())
                    } else {
                        responseHandler.handleFailure(value: error.localizedDescription, data: response.data ?? Data())
                    }
                }
            }
        
        
        return responseHandler
    }
    
}


extension ConnectionHandler {
    
    func GetRequest(forAPI api: String,
                    params: JSON,
                    ShowToast:Bool,
                    CacheAttribute: APIEnums) -> APIResponseProtocol {
        let responseHandler = APIResponseHandler()
        let parameters = params
        let startTime = Date()
        let token = KeyChainManager.getValue(for: "AccessToken") ?? ""
        var Header =  HTTPHeaders()
        
        Header["Accept-Language"] = Language.getCurrentLanguage() == .english ? "EN" : "AR"
        Header["Content-Type"] = "application/json"
        Header["accept"] = "application/json"
        
        if token != ""{
            Header["Accesskey"] = token
            Header["Authorization"] = "Bearer \(token)"
        }

        
        PrintParameters(api: api, Header: Header, param: parameters)
        
        AF.request(api,
                   method: .get,
                   parameters: parameters,
                   encoding: URLEncoding.default,
                   headers: Header)
        .responseJSON { (response) in
            
            let queryString = self.encodeParameters(parameters)
            let endTime = Date()
            
            Reachability.networkChecker(with: startTime, EndTime: endTime, ContentData: response.data)
            
            var StatusCode: Int?
            StatusCode = response.response?.statusCode
            
            if StatusCode != 200 {
                self.HandleErrors(StatusCode: APIStatusCode(rawValue: StatusCode ?? -1) ?? APIStatusCode.unknown, ShowToast: ShowToast, response: response)
            }

            
            switch response.result {
            case .success(let value):
                let json = value as! JSON
                
                //                    let RefreshedToken = json.string("authToken")
                //
                //                    if RefreshedToken != nil && RefreshedToken != ""{
                //                        UserDefaults.set(RefreshedToken, for: .access_token)
                //                    }
                let error = json.string("error")
                guard error.isEmpty else{
                    if error == "user_not_found"
                        && response.request?.url?.description.contains(APIUrl) ?? false{
                        // self.doLogoutActions()
                    }
                    responseHandler.handleFailure(value: error, data: response.data ?? Data())
                    return
                }
                if json.isSuccess
                    || !api.contains(APIUrl)
                    || response.response?.statusCode == 200 {
                    
                    responseHandler.handleSuccess(value: value,data: response.data ?? Data())
                }else{
                    responseHandler.handleFailure(value: json.status_message, data: response.data ?? Data())
                }
            case .failure(let error):
                if error._code == 13 {
                    responseHandler.handleFailure(value: "something went wrong.".localizedCapitalized, data: response.data ?? Data())
                } else if error._code == 500 {
                    responseHandler.handleFailure(value: "", data: response.data ?? Data())
                } else {
                    responseHandler.handleFailure(value: error.localizedDescription, data: response.data ?? Data())
                }
            }
        }
        
        
        return responseHandler
    }
    
}


extension ConnectionHandler {
    
    func PostRequest(forAPI api: String,
                     ShowToast:Bool,
                     params: JSON) -> APIResponseProtocol {
        let responseHandler = APIResponseHandler()
        var parameters = params
        let token = KeyChainManager.getValue(for: "AccessToken") ?? ""
        let startTime = Date()
        var Header =  HTTPHeaders()
        
        Header["Accept-Language"] = Language.getCurrentLanguage() == .english ? "EN" : "AR"
        Header["Content-Type"] = "application/json"
        Header["accept"] = "application/json"
                
        if token != "" {
            Header["Accesskey"] = token
            Header["Authorization"] = "Bearer \(token)"
        }
        
        parameters["language"] = Language.getCurrentLanguage() == .english ? "EN" : "AR"
        
        PrintParameters(api: api, Header: Header, param: parameters)
        
        AF.request(api,
                   method: .post,
                   parameters: parameters,
                   encoding: URLEncoding.queryString,
                   headers: Header)
        .responseJSON { (response) in
            
//            let queryString = self.encodeParameters(parameters)
            let endTime = Date()
            
            Reachability.networkChecker(with: startTime, EndTime: endTime, ContentData: response.data)
            
            var StatusCode: Int?
            StatusCode = response.response?.statusCode
            
            if StatusCode != 200 {
                self.HandleErrors(StatusCode: APIStatusCode(rawValue: StatusCode ?? -1) ?? APIStatusCode.unknown, ShowToast: ShowToast, response: response)
            }

            switch response.result{
            case .success(let value):
                let json = value as! JSON
                let error = json.string("error")
                guard error.isEmpty else{
                    if error == "user_not_found"
                        && response.request?.url?.description.contains(APIUrl) ?? false{
                        //self.doLogoutActions()
                    }else{
                        print(error)
                        responseHandler.handleFailure(value: error, data: response.data ?? Data())
                    }
                    responseHandler.handleFailure(value: error, data: response.data ?? Data())
                    return
                }
                if json.isSuccess
                    || !api.contains(APIUrl)
                    || response.response?.statusCode == 200{
                    
                    responseHandler.handleSuccess(value: value,data: response.data ?? Data())
                }else{
                    responseHandler.handleFailure(value: json.status_message, data: response.data ?? Data())
                }
            case .failure(let error):
                if error._code == 13 {
                    responseHandler.handleFailure(value: "something went wrong.".localizedCapitalized, data: response.data ?? Data())
                } else {
                    responseHandler.handleFailure(value: error.localizedDescription, data: response.data ?? Data())
                }
            }
        }
        
        
        return responseHandler
    }
    
}


extension ConnectionHandler {
    
    func DeleteRequest(forAPI api: String,
                       params: JSON,
                       ShowToast:Bool,
                       CacheAttribute: APIEnums) -> APIResponseProtocol {
        let responseHandler = APIResponseHandler()
        var parameters = params
        let token = KeyChainManager.getValue(for: "AccessToken") ?? ""
        let startTime = Date()
        var Header =  HTTPHeaders()
        
        Header["Accept-Language"] = Language.getCurrentLanguage() == .english ? "EN" : "AR"
        Header["Content-Type"] = "application/json"
        Header["accept"] = "application/json"
        
        if token != "" {
            Header["Accesskey"] = token
            Header["Authorization"] = "Bearer \(token)"
        }
        
        parameters["language"] = Language.getCurrentLanguage() == .english ? "EN" : "AR"
        
        PrintParameters(api: api, Header: Header, param: parameters)
        
        AF.request(api,
                   method: .delete,
                   parameters: parameters,
                   encoding: URLEncoding.default,
                   headers: Header)
        .responseJSON { (response) in
            
            let queryString = self.encodeParameters(parameters)
            let endTime = Date()
            
            Reachability.networkChecker(with: startTime, EndTime: endTime, ContentData: response.data)
            
            var StatusCode: Int?
            StatusCode = response.response?.statusCode
            
            if StatusCode != 200 {
                self.HandleErrors(StatusCode: APIStatusCode(rawValue: StatusCode ?? -1) ?? APIStatusCode.unknown, ShowToast: ShowToast, response: response)
            }
            
            switch response.result {
            case .success(let value):
                let json = value as! JSON
                
                let error = json.string("error")
                guard error.isEmpty else{
                    if error == "user_not_found"
                        && response.request?.url?.description.contains(APIUrl) ?? false{
                        // self.doLogoutActions()
                    }
                    responseHandler.handleFailure(value: error, data: response.data ?? Data())
                    return
                }
                if json.isSuccess
                    || !api.contains(APIUrl)
                    || response.response?.statusCode == 200 {
                    
                    responseHandler.handleSuccess(value: value,data: response.data ?? Data())
                }else{
                    responseHandler.handleFailure(value: json.status_message, data: response.data ?? Data())
                }
            case .failure(let error):
                if error._code == 13 {
                    responseHandler.handleFailure(value: "something went wrong.".localizedCapitalized, data: response.data ?? Data())
                } else if error._code == 500 {
                    responseHandler.handleFailure(value: "", data: response.data ?? Data())
                } else {
                    responseHandler.handleFailure(value: error.localizedDescription, data: response.data ?? Data())
                }
            }
        }
        
        
        return responseHandler
    }
}

extension ConnectionHandler {
    
    func encodeParameters(_ parameters: [String: Any]) -> String {
        
        var parameters: [String: Any] = parameters
        
        // Convert Date to String
        let dateFormatter = ISO8601DateFormatter()
        if let date = parameters["date"] as? Date {
            parameters["date"] = dateFormatter.string(from: date)
        }
        if let date = parameters["visitdate"] as? Date {
            parameters["visitdate"] = dateFormatter.string(from: date)
        }
        
        if (try? JSONSerialization.data(withJSONObject: parameters, options: [])) != nil {
            // JSON encoding succeeds
        }
        
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: parameters, options: []),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            print(jsonString)
        }
        
        let Bodey = parameters.compactMap { key, value in
            if let stringValue = value as? String {
                return "\(key):\(stringValue)"
            } else {
                return "\(key):\(value)" // Convert non-string values to strings
            }
            //        }.joined(separator: "&")
        }.joined(separator: ",")
        
        return "{\(Bodey)}"
    }
    
    func printParametersLineByLine(_ parameters: [String: Any]) -> String {
        let body = parameters.map { key, value in
            return "\(key): \(value)"
        }.joined(separator: "\n")
        
        return "{\n\(body)\n}"
    }
    
    
    func PrintParameters(api: String, Header: HTTPHeaders, param: [String: Any]) {
        
        if JSONSerialization.isValidJSONObject(param),
           let jsonData = try? JSONSerialization.data(withJSONObject: param, options: .fragmentsAllowed),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            
            let query = printParametersLineByLine(param)
            let queryString = self.encodeParameters(param)
            
            print("""
                  <------------------------------------------------ Start_Api ---------------------------------------------------->
                  Api_Url = \(api),
                  Api_Method = POST,
                  Api_Header = \(Header),
                  Api_parameters = \(jsonString),
                  Api_Query = \(queryString),
                  Api_Query = \(query),
                  <-------------------------------------------------- End_Api ----------------------------------------------------->
                  
                  """)
            
        } else {
            let query = printParametersLineByLine(param)
            let queryString = self.encodeParameters(param)
            print("""
                  <------------------------------------------------ Start_Api ---------------------------------------------------->
                  Api_Url = \(api),
                  Api_Method = POST,
                  Api_Header = \(Header),
                  Api_parameters = \(param),
                  Api_Query = \(queryString),
                  Api_Query = \(query),
                  <-------------------------------------------------- End_Api ----------------------------------------------------->
                  
                  """)
            
            print("❌ Invalid parameters for JSON serialization: \(param)")
        }
        
    }
    
    
    
    func HandleErrors<T>(StatusCode: APIStatusCode, ShowToast: Bool, response: DataResponse<T, AFError>) {
        
        switch StatusCode {
        case .badRequest:
            if response.request?.url?.description.contains(APIUrl) ?? false{
                if let dict = response.value as? [String: Any],
                   let message = dict["message"] as? String {
                    
                    if message == "Unauthenticated." {
                        if ShowToast {
                            self.CallApiRequest(for: .Refresh_Token, params: JSON())
                        }
                    }else{
                        
                        CallLogoutFunc()
                    }
                    
                }
            }
            return

        case .unauthorized:
            if response.request?.url?.description.contains(APIUrl) ?? false{
                if let dict = response.value as? [String: Any],
                   let message = dict["message"] as? String {
                    if ShowToast {
                        self.Toaster.show(style: .error, message: message)
                    }

//                    CallLogoutFunc()
                    
                } else {
                    print("401 Error but no message found")
                }
            }
            return

        case .unprocessable:
            if response.request?.url?.description.contains(APIUrl) ?? false{
                if let dict = response.value as? [String: Any],
                   let message = dict["message"] as? String {
                    if ShowToast {
                        self.Toaster.show(style: .error, message: message)
                    }
                } else {
                    print("422 Error but no message found")
                }
            }
            return


        case .forbidden, .notFound, .serverError, .badGateway, .serviceUnavailable, .gatewayTimeout, .unknown:
            
            if let dict = response.value as? [String: Any],
               let message = dict["message"] as? String {
                if ShowToast {
                    self.Toaster.show(style: .error, message: message)
                }
            } else {
                print("503 Error but no message found")
                if ShowToast {
                    self.Toaster.show(style: .error, message: "\(StatusCode) Error but no message found")
                }
            }
            return

        }
        
        
    }
    
}


//func CallLogoutFunc() {
//    
//    if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//       let sceneDelegate = scene.delegate as? SceneDelegate {
//        
//        KeyChainManager.delete(for: "AccessToken")
//        sceneDelegate.SetRootVC(windowScene: scene)
//    }
//
//}


func CallLogoutFunc() {
    KeyChainManager.delete(for: "AccessToken")
    UserDefaults.standard.set("", forKey: "AccessToken")
    // SwiftUI automatically switches root view
}
