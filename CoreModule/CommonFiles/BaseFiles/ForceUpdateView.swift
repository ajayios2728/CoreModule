////
////  ForceUpdateView.swift
////  Mutasil
////
////  Created by SCT on 02/10/25.
////
//
//import Foundation
//import UIKit
//import SwiftUICore
//import SwiftUI
//import FirebaseRemoteConfigInterop
//import FirebaseRemoteConfig
//import Firebase
//import FirebaseAnalytics
//
//
//// MARK: - 1. Version Helpers
//
//extension Bundle {
//    /// Returns the app's Marketing Version (CFBundleShortVersionString, e.g., "1.0.0")
//    var appVersion: String {
////        return infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0.0"
//        return infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0.0"
//    }
//}
//
//extension String {
//    /// Compares two semantic version strings (e.g., "1.2.9" < "2.0.0" is true)
//    func isVersion(lessThan requiredVersion: String) -> Bool {
//        let currentComponents = self.split(separator: ".").compactMap { Int($0) }
//        let requiredComponents = requiredVersion.split(separator: ".").compactMap { Int($0) }
//        
//        for (current, required) in zip(currentComponents, requiredComponents) {
//            if current < required {
//                return true
//            } else if current > required {
//                return false
//            }
//        }
//        
//        // If versions are the same up to the shortest length (e.g., "1.0" < "1.0.0")
//        return currentComponents.count < requiredComponents.count
//    }
//}
//
//
//final class VersionCheckService: ObservableObject {
//    @Published var isForceUpdateRequired: Bool = false
//    
//    // Replace this with your actual App Store ID
//    private let appStoreID = App_ID
//    
//    // URL to open the App Store page for your app
//    var appStoreURL: URL? {
//        URL(string: "itms-apps://itunes.apple.com/app/id\(appStoreID)")
//    }
//    
//    private let remoteConfig = RemoteConfig.remoteConfig()
//    
//    init() {
//        
//        let settings = RemoteConfigSettings()
//        settings.minimumFetchInterval = 0
//        remoteConfig.configSettings = settings
//        
//        try? remoteConfig.setDefaults(from: ["min_required_version": "1.0.0"])
//        
//    }
//
//
//    func checkForUpdate() {
//        guard Bundle.main.appVersion != "" else { return }
//
//        let currentVersion = Bundle.main.appVersion
//        // --- SIMULATED REMOTE CHECK ---
//        // In a real app, this is where you'd fetch "min_required_version" from Firebase/your API.
//        
////        let minRequiredVersion = "2.5.0" // Set this remotely (e.g., in Firebase)
//        
////        let minRequiredVersion = self.remoteConfig.configValue(forKey: "min_required_version").stringValue ?? "1.0.0"
//        let minRequiredVersion = self.remoteConfig.configValue(forKey: "min_required_version").stringValue ?? "1.0.0"
//
////        let theme = RemoteConfigProvider.shared.min_required_version()
//
//        
//        // Simulating a network delay
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//            if currentVersion.isVersion(lessThan: minRequiredVersion) {
//                print("Force update triggered! Current: \(currentVersion), Min: \(minRequiredVersion)")
//                self.isForceUpdateRequired = true
//            } else {
//                print("App is up-to-date. Current: \(currentVersion), Min: \(minRequiredVersion)")
//                self.isForceUpdateRequired = false
//            }
//        }
//    }
//}
//
//
//struct ForceUpdateView: View {
//    @ObservedObject var service: VersionCheckService
//
//    var body: some View {
//        VStack(spacing: 20) {
//            Image(systemName: "exclamationmark.triangle.fill")
//                .font(.largeTitle)
//                .foregroundColor(.red)
//                .padding(.bottom, 10)
//
//            Text("Critical Update Required")
//                .font(.title2)
//                .fontWeight(.bold)
//            
//            Text("This version is no longer supported due to critical security and stability issues. Please update the app to continue.")
//                .font(.body)
//                .foregroundColor(.secondary)
//                .multilineTextAlignment(.center)
//                .padding(.horizontal, 40)
//
//            Button {
//                if let url = service.appStoreURL {
//                    UIApplication.shared.open(url)
//                }
//            } label: {
//                Text("Update Now")
//                    .font(.headline)
//                    .frame(maxWidth: .infinity)
//                    .padding()
//                    .background(Color.blue)
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//            }
//            .padding(.horizontal)
//            // Block gestures that might allow dismissal on iPad/macOS
//            .disabled(service.appStoreURL == nil)
//        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .background(Color(.systemBackground))
//        // Ignore the safe area to make it truly full-screen
//        .ignoresSafeArea(.all, edges: .all)
//    }
//}
//
//
//
//enum RemoteConfigValueKey: String {
//    case min_required_version
//}
///**
// Provider for communicate with firebase remote configs and fetch config values
// */
//final class RemoteConfigProvider {
//    static let shared = RemoteConfigProvider()
//    var loadingDoneCallback: (() -> Void)?
//    var fetchComplete = false
//    var isDebug = true
//    
//    private var remoteConfig = RemoteConfig.remoteConfig()
//    
//    private init() {
//        setupConfigs()
//        loadDefaultValues()
//        setupListener()
//    }
//    
//    func setupConfigs() {
//        let settings = RemoteConfigSettings()
//        // fetch interval that how frequent you need to check updates from the server
//        settings.minimumFetchInterval = isDebug ? 0 : 43200
//        remoteConfig.configSettings = settings
//    }
//    
//    /**
//     In case firebase failed to fetch values from the remote server due to internet failure
//     or any other circumstance, In order to run our application without any issues
//     we have to set default values for all the variables that we fetches
//     from the remote server.
//     If you have higher number of variables in use, you can use info.plist file
//     to define the defualt values as well.
//     */
//    func loadDefaultValues() {
//        let appDefaults: [String: Any?] = [
//            RemoteConfigValueKey.min_required_version.rawValue: 1
//        ]
//        remoteConfig.setDefaults(appDefaults as? [String: NSObject])
//    }
//    
//    /**
//     Setup listner functions for frequent updates
//     */
//    func setupListener() {
//        remoteConfig.addOnConfigUpdateListener { configUpdate, error in
//            if let error = error {
//                print(error.localizedDescription)
//                return
//            }
//            
//            guard configUpdate != nil else {
//                print("REMOTE CONFIG ERROR")
//                return
//            }
//            
//            self.remoteConfig.activate { changed, error in
//                if let error = error {
//                    print(error.localizedDescription)
//                } else {
//                    print("REMOTE CONFIG activation state change \(changed)")
//                }
//            }
//        }
//    }
//    
//    /**
//         Function for fectch values from the cloud
//     */
//    func fetchCloudValues() {
//        remoteConfig.fetch { [weak self] (status, error) -> Void in
//            guard let self = self else { return }
//            
//            if status == .success {
//                self.remoteConfig.activate { _, error in
//                    if let error = error {
//                        print(error.localizedDescription)
//                        return
//                    }
//                    self.fetchComplete = true
//                    print("Remote config fetch success")
//                    DispatchQueue.main.async {
//                        self.loadingDoneCallback?()
//                    }
//                }
//            } else {
//                print("Remote config fetch failed")
//                DispatchQueue.main.async {
//                    self.loadingDoneCallback?()
//                }
//            }
//        }
//    }
//}
//
//// MARK: Basic remote config value access methods
//
//extension RemoteConfigProvider {
//    func bool(forKey key: RemoteConfigValueKey) -> Bool {
//        return remoteConfig[key.rawValue].boolValue
//    }
//    
//    func string(forKey key: RemoteConfigValueKey) -> String {
//        return remoteConfig[key.rawValue].stringValue
//    }
//    
//    func double(forKey key: RemoteConfigValueKey) -> Double {
//        return remoteConfig[key.rawValue].numberValue.doubleValue
//    }
//    
//    func int(forKey key: RemoteConfigValueKey) -> Int {
//        return remoteConfig[key.rawValue].numberValue.intValue
//    }
//}
//
//// MARK: Getters for config values
//
//extension RemoteConfigProvider {
//    func min_required_version() -> Int {
//        return int(forKey: .min_required_version)
//    }
//}
