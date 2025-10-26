//
//  CoreModule.swift
//  CoreModule
//
//  Created by SCT on 26/10/25.
//

import Foundation

import UIKit

public class AppDelegate {
    public static let shared = AppDelegate()
    public static var window: UIWindow?
    public static var orientationLock = UIInterfaceOrientationMask.portrait

    private init() {}

    public func setup() {
        print("AjayCore framework initialized ✅")
        // e.g., configure API keys, logging, etc.
    }
}
