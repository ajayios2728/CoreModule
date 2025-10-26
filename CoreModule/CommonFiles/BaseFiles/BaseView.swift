//
//  BaseView.swift
//  NextPeak
//
//  Created by SCT on 29/08/24.
//  Copyright © 2024 Balakrishnan Ponraj. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI


class BaseView: UIView{
    fileprivate var baseVc : BaseViewController?
    let Lang = Language.getCurrentLanguage().getLocalizedInstance()
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    let isRTL = Language.isRTL
        
    var InitialTableAnimation: TableAnimation = .moveUpWithFade(rowHeight: 100, duration: 0.55, delay: 0.00)
    var TableAnimation: TableAnimation = .moveUp(rowHeight: 100, duration: 0.55, delay: 0.00)
    
    
    func didLoad(baseVC : BaseViewController){
        self.baseVc = baseVC
        self.backgroundColor = .white
        
    }
    
    func willAppear(baseVC : BaseViewController){}
    func didAppear(baseVC : BaseViewController){}
    func willDisappear(baseVC : BaseViewController){}
    func didDisappear(baseVC : BaseViewController){}
    func didLayoutSubviews(baseVC: BaseViewController){}

    
}

protocol BaseViewUI: View {
    associatedtype Content: View
    @ViewBuilder var content: Content { get }
    var isRTL: Bool { get }
    var isDataEmpty: Bool { get }   // MARK: For No Data Found
    @Sendable func onRefresh() async

}

extension BaseViewUI {
    var body: some View {
        ZStack {

            PullToRefreshView(content: {
                content
                    .noDataOverlay(isDataEmpty) // MARK: For No Data Found
            }, onRefresh: {
                await onRefresh()
            })
            .environment(\.layoutDirection, isRTL ? .rightToLeft : .leftToRight)
            .environmentObject(LoaderManager.shared)
            .environmentObject(ToastManager.shared)
        
            GlobalLoader() // loader overlay
            GlobalToast()   // overlay toast
        }

    }
    
    var isDataEmpty: Bool { false }
    @Sendable func onRefresh() async {
        // Default empty
        print("onRefresh")
    }

}


class Device {
    static var screen = Device()
    #if os(watchOS)
    var width: CGFloat = WKInterfaceDevice.current().screenBounds.size.width
    var height: CGFloat = WKInterfaceDevice.current().screenBounds.size.height
    #elseif os(iOS)
    var width: CGFloat = UIScreen.main.bounds.size.width
    var height: CGFloat = UIScreen.main.bounds.size.height
    #elseif os(macOS)
    // You could implement this to force a CGFloat and get the full device screen size width regardless of the window size with .frame.size.width
    var width: CGFloat? = NSScreen.main?.visibleFrame.size.width
    var height: CGFloat? = NSScreen.main?.visibleFrame.size.height
    #endif
}
