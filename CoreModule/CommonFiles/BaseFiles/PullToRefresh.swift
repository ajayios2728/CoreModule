//
//  PullToRefresh.swift
//  Mutasil
//
//  Created by SCT on 18/09/25.
//

import SwiftUI


struct PullToRefreshView<Content: View>: View {
    let content: () -> Content
    var onRefresh: () async -> Void
    
    @State private var dragOffset: CGFloat = 0
    @State private var isRefreshing = false
    
    var body: some View {
        ZStack(alignment: .top) {
            
            if isRefreshing {
                ProgressView()
                    .padding(.top, 10)
                    .zIndex(1)
            }
            
            content()
                .offset(y: dragOffset)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            if value.translation.height > 0 && !isRefreshing {
                                dragOffset = value.translation.height / 2 // smooth pull
                            }
                        }
                        .onEnded { value in
                            if dragOffset > 80 { // threshold
                                Task {
                                    isRefreshing = true
                                    await onRefresh()
                                    withAnimation {
                                        isRefreshing = false
                                    }
                                }
                            }
                            withAnimation {
                                dragOffset = 0
                            }
                        }
                )
        }
    }
}


struct TopLineLoader: View {
    var isLoading: Bool
    @State private var progress: CGFloat = 0
    @State private var timer: Timer? = nil
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            if isLoading {
                Rectangle()
                    .fill(Color(PrimaryThemecolor))
                    .frame(height: 3)
                    .frame(maxWidth: .infinity)
                    .opacity(0.2)
                
                Rectangle()
                    .fill(Color((PrimaryThemecolor)))
                    .frame(width: UIScreen.main.bounds.width * progress, height: 3)
                    .animation(.easeInOut(duration: 0.3), value: progress)
                    .onAppear {
                        startLoading()
                    }
                    .onDisappear {
                        stopLoading()
                    }
            }
        }
    }
    
    private func startLoading() {
        progress = 0.0
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
            withAnimation {
                if progress < 0.9 {
                    progress += 0.02
                }
            }
        }
    }
    
    private func stopLoading() {
        timer?.invalidate()
        timer = nil
        withAnimation(.easeOut(duration: 0.3)) {
            progress = 1.0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            withAnimation {
                progress = 0
            }
        }
    }
}
