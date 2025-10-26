//
//  BaseViewModel.swift
//  Mutasil
//
//  Created by SCT on 03/09/25.
//

import Foundation
import UIKit


protocol BaseModel: Codable {
    var status: Bool? { get }
    var message: String? { get }
}


class BaseViewModel: ObservableObject {
//    @Published var ApiSuccess = false
    
    @Published var onDataUpdate: (() -> Void)?
//    @Published var onError: ((String) -> Void)?
    
    var Loader = LoaderManager.shared
    var Toaster = ToastManager.shared
    
    func FetchApiData<T: BaseModel>(for api: APIEnums, params: JSON, model: T.Type, IsHideLoader: Bool = false, IsHoideToast: Bool = false, onDataUpdate: ((T) -> Void)? = nil, result: @escaping (Result<T, Error>) -> Void) {

        if !IsHideLoader {
            Loader.show()
        }
        
        ConnectionHandler().CallApiRequest(for: api, ShowToast: !IsHoideToast,params: params)
            .responseDecode(to: model.self, {  json in
                result(.success(json))
                if json.status ?? false {
//                    DispatchQueue.main.async { self.ApiSuccess = true }
                    DispatchQueue.main.async { self.onDataUpdate?() }
                    
                    if !IsHoideToast {
                        self.Toaster.show(style: .success, message: json.message ?? "")
                    }
                    
                }else{
//                    DispatchQueue.main.async { self.ApiSuccess = false }
//                    DispatchQueue.main.async { self.onError?(error.localizedCapitalized) }
                    if !IsHoideToast {
                        self.Toaster.show(style: .error, message: json.message ?? "")
                    }
                }
                self.Loader.hide()
                
            }) .responseFailure({ (error) in
                print("Error::", error)
//                DispatchQueue.main.async { self.ApiSuccess = false }
//                DispatchQueue.main.async { self.onError?(error.localizedCapitalized) }
//                self.Toaster.show(style: .error, message: error.localizedCapitalized)
                self.Loader.hide()
            })
        
    }
    


    

}


extension KeyedDecodingContainer {
    func decodeSafe<T>(_ type: T.Type, forKey key: KeyedDecodingContainer.Key) -> T? where T: Decodable {
        return (try? decodeIfPresent(type, forKey: key)) ?? nil
    }
}
