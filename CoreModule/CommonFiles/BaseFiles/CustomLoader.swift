//
//  CustomLoader.swift
//  Mutasil
//
//  Created by SCT on 12/09/25.
//

import Foundation
import SwiftUI
import Combine


class LoaderManager: ObservableObject {
    static let shared = LoaderManager()
    
    @Published var isLoading: Bool = false
    
    func show() {
        DispatchQueue.main.async {
            self.isLoading = true
        }
    }
    
    func hide() {
        DispatchQueue.main.async {
            self.isLoading = false
        }
    }
}

struct GlobalLoader: View {
    @ObservedObject var loader: LoaderManager = .shared
    
    var body: some View {
        if loader.isLoading {
            ZStack {
                Color.black.opacity(0.3).ignoresSafeArea()
                ProgressView("Loading...")
                    .padding(20)
                    .background(Color(DarkBlack))
                    .cornerRadius(12)
            }
            .transition(.opacity)
            .animation(.easeInOut, value: loader.isLoading)
        }
    }
}

