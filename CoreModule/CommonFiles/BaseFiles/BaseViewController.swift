//
//  BaseViewController.swift
//  NextPeak
//
//  Created by SCT on 29/08/24.
//  Copyright © 2024 Balakrishnan Ponraj. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    let lang = Language.getCurrentLanguage().getLocalizedInstance()
    let isRTL = Language.isRTL
    
    fileprivate var _baseView : BaseView? {
        return self.view as? BaseView
    }
    fileprivate var onExit : (()->())? = nil
    
    var stopSwipeExitFromThisScreen : Bool? {
        return nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self._baseView?.didLoad(baseVC: self)
    }
    
//    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
//        self._baseView?.darkModeChange()
//    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self._baseView?.willAppear(baseVC: self)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self._baseView?.didAppear(baseVC: self)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self._baseView?.willDisappear(baseVC: self)
        
      
    }
    
    override
    var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return self.traitCollection.userInterfaceStyle == .dark ? .lightContent : .darkContent
        } else {
            // Fallback on earlier versions
            return self.preferredStatusBarStyle
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self._baseView?.didDisappear(baseVC: self)
        
        if self.isMovingFromParent{
            self.willExitFromScreen()
        }
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self._baseView?.didLayoutSubviews(baseVC: self)
    }
    
    
    func exitScreen(animated : Bool,_ completion : (()->())? = nil){
        self.onExit = completion
        if self.isPresented(){
            self.dismiss(animated: animated) {
                completion?()
            }
        }else{
            self.navigationController?.popViewController(animated: true)
            completion?()
        }
    }
    
    func willExitFromScreen(){
        
    }
    
    //MARK: Check screen presentation status
    func isPresented() -> Bool {
        if self.presentingViewController != nil {
            return true
        } else if self.navigationController?.presentingViewController?.presentedViewController == self.navigationController  {
            return true
        } else if self.tabBarController?.presentingViewController is UITabBarController {
            return true
        }

        return false
    }



}

extension BaseViewController : UIGestureRecognizerDelegate{
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let nav = self.navigationController else {return true}
        if self.stopSwipeExitFromThisScreen ?? false{return false }
        return nav.viewControllers.count > 1
    }
    // This is necessary because without it, subviews of your top controller can
    // cancel out your gesture recognizer on the edge.
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    
}
