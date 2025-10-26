//
//  ServiceManager.swift
//  Mutasil
//
//  Created by SCT on 02/10/25.
//

import Foundation
import FirebaseCrashlytics
import FirebaseAnalytics



func setUpCrashHandler() {
    // Handle uncaught exceptions
    
    UIViewController.enableGlobalScreenTracking()
    
    NSSetUncaughtExceptionHandler { exception in
        let crashLog = createCrashLog(from: exception)
        sendCrashLogToServer(crashLog)
    }
    
    // Handle various signals that can cause crashes
    signal(SIGABRT) { signal in handleSignal(signal) }
    signal(SIGILL) { signal in handleSignal(signal) }
    signal(SIGSEGV) { signal in handleSignal(signal) }
    signal(SIGFPE) { signal in handleSignal(signal) }
    signal(SIGBUS) { signal in handleSignal(signal) }
    signal(SIGPIPE) { signal in handleSignal(signal) }
}


func handleSignal(_ signal: Int32) {
    let crashLog = createCrashLog(from: signal)
    sendCrashLogToServer(crashLog)
}

func createCrashLog(from exception: NSException) -> String {
    var crashLog = "Exception: \(exception.name.rawValue)\n"
    crashLog += "Reason: \(exception.reason ?? "No reason")\n"
    crashLog += "User Info: \(exception.userInfo ?? [:])\n"
    crashLog += "Stack Trace: \(exception.callStackSymbols.joined(separator: "\n"))\n"
    crashLog += "Timestamp: \(Date())\n"
    return crashLog
}


func createCrashLog(from signal: Int32) -> String {
    var crashLog = "Signal: \(signal)\n"
    crashLog += "Timestamp: \(Date())\n"
    return crashLog
}

func sendCrashLogToServer(_ crashLog: String) {
    
    Crashlytics.crashlytics().setCustomValue(crashLog, forKey: "CrashLog")

//    guard let url = URL(string: "https://yourserver.com/crashlogs") else { return }
//
//    var request = URLRequest(url: url)
//    request.httpMethod = "POST"
//    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//
//    let body: [String: Any] = ["crashLog": crashLog]
//    request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
//
//    let task = URLSession.shared.dataTask(with: request) { data, response, error in
//        if let error = error {
//            print("Error sending crash log: \(error)")
//            return
//        }
//        print("Crash log sent successfully")
//    }
//    task.resume()
}

// Define a protocol for screen names
protocol ScreenNameProviding {
    var screenName: String { get }
}

extension UIViewController {
    @objc func firebaseAnalyticsScreenView() {
        let name = (self as? ScreenNameProviding)?.screenName ?? String(describing: type(of: self))
        let className = String(describing: type(of: self))

        // Log to Firebase Analytics
        Analytics.logEvent(AnalyticsEventScreenView, parameters: [
            AnalyticsParameterScreenName: name,
            AnalyticsParameterScreenClass: className
        ])

        // Log to Crashlytics/Custom Breadcrumbs
        Crashlytics.crashlytics().log("Entered screen: \(name) (\(className))")
        Crashlytics.crashlytics().setCustomValue(name, forKey: "current_screen")
        BreadcrumbManager.shared.setCurrentScreen(name: name)

        print("Logged screen: \(name) (\(className))")
    }
}


// MARK: - Method Swizzling for UIViewController.viewDidAppear (Use with Extreme Caution)

extension UIViewController {
    private static let swizzleOnce: Void = {
        let originalSelector = #selector(UIViewController.viewDidAppear(_:))
        let swizzledSelector = #selector(UIViewController.swizzled_viewDidAppear(_:))

        guard let originalMethod = class_getInstanceMethod(UIViewController.self, originalSelector),
              let swizzledMethod = class_getInstanceMethod(UIViewController.self, swizzledSelector) else {
            return
        }

        method_exchangeImplementations(originalMethod, swizzledMethod)
    }()

    @objc func swizzled_viewDidAppear(_ animated: Bool) {
        // Call the original implementation (now swizzled_viewDidAppear points to it)
        swizzled_viewDidAppear(animated)

        // Your screen tracking logic here
        let name = (self as? ScreenNameProviding)?.screenName ?? String(describing: type(of: self))
        let className = String(describing: type(of: self))

        Analytics.logEvent(AnalyticsEventScreenView, parameters: [
            AnalyticsParameterScreenName: name,
            AnalyticsParameterScreenClass: className
        ])
        Crashlytics.crashlytics().log("Swizzled Entered screen: \(name) (\(className))")
        Crashlytics.crashlytics().setCustomValue(name, forKey: "current_screen")
        BreadcrumbManager.shared.setCurrentScreen(name: name)

        print("Swizzled Logged screen: \(name) (\(className))")
    }

    static func enableGlobalScreenTracking() {
        _ = UIViewController.swizzleOnce
    }
}

// Call this early in your app lifecycle, e.g., in AppDelegate's didFinishLaunchingWithOptions
// UIViewController.enableGlobalScreenTracking()


// Assuming you have this BreadcrumbManager
class BreadcrumbManager {
    static let shared = BreadcrumbManager()
    private init() {}

    private var breadcrumbs: [String] = []
    private let maxBreadcrumbs = 50
    private var currentScreenName: String?

    func addBreadcrumb(message: String) {
        let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .long)
        let breadcrumb = "[\(timestamp)] \(message)"
        breadcrumbs.append(breadcrumb)
        if breadcrumbs.count > maxBreadcrumbs {
            breadcrumbs.removeFirst()
        }
        print("Breadcrumb added: \(breadcrumb)")
    }

    func setCurrentScreen(name: String) {
        self.currentScreenName = name
        addBreadcrumb(message: "SCREEN_CHANGE: \(name)") // Log screen changes as breadcrumbs
        print("Current screen updated to: \(name)")
    }

    func getCurrentScreenName() -> String? {
        return currentScreenName
    }

    func getBreadcrumbs() -> [String] {
        return breadcrumbs
    }
}
