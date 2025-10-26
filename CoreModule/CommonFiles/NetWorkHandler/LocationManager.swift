//
//  LocationManager.swift
//  NextPeak
//
//  Created by SivaCerulean Technologies on 19/07/23.
//  Copyright © 2023 Balakrishnan Ponraj. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    
    private var locationManager: CLLocationManager
    private var locationCompletion: ((Result<CLLocation?, Error>) -> Void)?
    
    var ToastManage = ToastManager.shared
    
    private override init() {
        locationManager = CLLocationManager()
        super.init()
        setupLocationManager()
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization() // You can also use .requestAlwaysAuthorization() if needed
    }
    
    func requestLocation(completion: @escaping (Result<CLLocation?, Error>) -> Void) {
        locationCompletion = completion
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationCompletion?(.success(location))
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        switch CLLocationManager.authorizationStatus() {
                case .authorizedWhenInUse, .authorizedAlways:
                    
            locationManager.requestLocation()
        case .denied, .restricted: 
            locationCompletion?(.success(nil))
            
            DispatchQueue.main.async {
                // Show custom alert to user to open Settings
                self.ToastManage.show(style: .warning, message: "Location Access Needed. Please enable location access in Settings -> Apps -> \(AppName) -> Location", duration: 100)
                
            }

        case .notDetermined:
            locationCompletion?(.failure(error))

//                    LocationManager.shared.locationManager.requestWhenInUseAuthorization()
                @unknown default:
                    break
                }
    }
}

