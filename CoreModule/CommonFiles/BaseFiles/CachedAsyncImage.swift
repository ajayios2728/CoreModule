//
//  PaginationSwiftUi.swift
//  Mutasil
//
//  Created by SCT on 17/09/25.
//

import Foundation
import UIKit
import SwiftUI


class ImageCache {
    static let shared = NSCache<NSURL, UIImage>()
}



struct CachedAsyncImage: View {
    let url: URL
    let width: CGFloat
    let height: CGFloat
    
    @State private var uiImage: UIImage?
    @State private var isLoading = true
    
    var body: some View {
        Group {
            if let uiImage = uiImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .roundedCorner(5, corners: [.topLeft, .topRight])
                    .frame(width: width, height: height)
            } else if isLoading {
                ProgressView()
                    .frame(width: width, height: height)
                    .onAppear(perform: loadImage)

            } else if !isLoading {
                Image(.no)
                    .resizable()
                    .scaledToFit()
                    .roundedCorner(5, corners: [.topLeft, .topRight])
                    .frame(width: width, height: height)
            } else {
                Color.gray.opacity(0.3)
                    .frame(width: width, height: height)
                    .onAppear(perform: loadImage)
            }
        }
        .clipped()
        .roundedCorner(5, corners: [.topLeft, .topRight])
    }
    
//    private func loadImage() {
//        if let cached = ImageCache.shared.object(forKey: url as NSURL) {
//            self.uiImage = cached
//            return
//        }
//        
//        isLoading = true
//        Task {
//            do {
//                let (data, _) = try await URLSession.shared.data(from: url)
//                if let image = UIImage(data: data) {
//                    ImageCache.shared.setObject(image, forKey: url as NSURL)
//                    await MainActor.run { self.uiImage = image }
//                }
//            } catch {
//                print("Image load failed:", error)
//            }
//            await MainActor.run { self.isLoading = false }
//        }
//    }
    
    private func loadImage() {
        if let cached = ImageCache.shared.object(forKey: url as NSURL) {
            self.uiImage = cached
            return
        }
        
        isLoading = true
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let image = UIImage(data: data) {
                    ImageCache.shared.setObject(image, forKey: url as NSURL)
                    await MainActor.run {
                        self.uiImage = image
                        self.isLoading = false
                    }
                    return
                }
            } catch {
                print("Image load failed:", error)
            }
            
            // Ensure we stop the loader even if image fails
            await MainActor.run {
                self.isLoading = false
            }
        }
    }

}
