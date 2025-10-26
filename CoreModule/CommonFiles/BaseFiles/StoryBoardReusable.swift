//
//  StoryBoardReusable.swift
//  NextPeak
//
//  Created by SCT on 29/08/24.
//  Copyright © 2024 Balakrishnan Ponraj. All rights reserved.
//

import Foundation
import UIKit

protocol ReusableView: class {}

extension ReusableView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

// UIViewController.swift
extension UIViewController: ReusableView { }

// UIStoryboard.swift
extension UIStoryboard {
    
    
    static var MainStory : UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    static var Common : UIStoryboard {
        return UIStoryboard(name: "Common", bundle: nil)
    }
    static var NewStoryboard : UIStoryboard {
        return UIStoryboard(name: "NewStoryboard", bundle: nil)
    }
    /**
     initialte viewController with identifier as class name
     - Author: Abishek Robin
     - Returns: ViewController
     - Warning: Only ViewController which has identifier equal to class should be parsed
     */
    func instantiateViewController<T>() -> T where T: ReusableView {
        return instantiateViewController(withIdentifier: T.reuseIdentifier) as! T
    }
    /**
     initialte viewController with identifier as class name and suffix("ID")
     - Author: Abishek Robin
     - Returns: ViewController
     - Warning: Only ViewController with "ID" in suffix should be parsed
     */
    func instantiateIDViewController<T>() -> T where T: ReusableView {
        return instantiateViewController(withIdentifier: T.reuseIdentifier + "ID") as! T
    }
}


extension UITableViewCell: ReusableView { }
extension UICollectionViewCell: ReusableView { }
extension UITableView{
    /**
    Registers UITableViewCell with identifier and nibName as class name
    - Author: Abishek Robin
    - Parameters:
       - cell: the Cell class instance to be registered
    - Warning: Only UITableViewCell which has identifier equal to class should be parsed
    */
    func registerNib(forCell cell : ReusableView.Type){
        
        let nib = UINib(nibName: cell.reuseIdentifier, bundle: nil)
        
        self.register(nib, forCellReuseIdentifier: cell.reuseIdentifier)
    }
    /**
     initialte UITableViewCell with identifier as class name
     - Author: Abishek Robin
     - Returns: ReusableView(UITableViewCell)
     - Warning: Only UITableViewCell which has identifier equal to class should be parsed
     */
    func dequeueReusableCell<T>(for index : IndexPath) -> T where T : ReusableView{
        return self.dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: index) as! T
    }
}

extension UICollectionView{
    /**
     initialte UICollectionViewCell with identifier as class name
     - Author: Abishek Robin
     - Returns: ReusableView(UITableViewCell)
     - Warning: Only UICollectionViewCell which has identifier equal to class should be parsed
     */
    func dequeueReusableCell<T>(for index : IndexPath) -> T where T : ReusableView{
        return self.dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: index) as! T
    }
}

extension UIView {
    func getCurrentCell<T:AnyObject>(cellType:T.Type) -> T? {
        if let cell = self.superview?.superview as? T {
            return cell
        }
        return nil
    }
}


extension UIApplication {
    static func topViewController(
        base: UIViewController? = UIApplication.shared.connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .first?.rootViewController
    ) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            return topViewController(base: tab.selectedViewController)
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}
