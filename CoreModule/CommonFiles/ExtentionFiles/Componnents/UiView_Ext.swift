//
//  UiView_Ext.swift
//  Mutasil
//
//  Created by SCT on 02/09/25.
//

import Foundation
import SwiftUI
import UIKit


extension View {
    
    var ScreenWidth : CGFloat {
        Device.screen.width
    }
    var ScreenHeight : CGFloat {
        Device.screen.height
    }
    
    
    var Lang : LanguageProtocol {
        Language.getCurrentLanguage().getLocalizedInstance()
    }
        
}

extension UIView {
    
    var ScreenWidth : CGFloat {
        Device.screen.width
    }
    var ScreenHeight : CGFloat {
        Device.screen.height
    }
}



extension View {
    func limitInputLength(value: Binding<String>, length: Int) -> some View {
        self.modifier(TextFieldLimitModifer(value: value, length: length))
    }
    
}

struct TextFieldLimitModifer: ViewModifier {
    @Binding var value: String
    var length: Int

    func body(content: Content) -> some View {
        content
            .onReceive(value.publisher.collect()) {
                value = String($0.prefix(length))
            }
    }
}


extension View {
    func roundedCorner(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners) )
    }
}


struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func ElevateView(cornerRadius: CGFloat = 5, X: CGFloat = 0, Y: CGFloat = 0, color: UIColor = DarkBlack, IsOnlyBottom: Bool = true) -> some View {
        
        self.background(
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(Color(color))
                .offset(x: X, y: Y)
                .shadow(color: .gray.opacity(0.4), radius: 3, x: 0, y: 0) // 👈 bottom only
        )
        
    }
}



private var AssociatedObjectHandle: UInt8 = 25
private var ButtonAssociatedObjectHandle: UInt8 = 10
public enum closureActions : Int{
    case none = 0
    case tap = 1
    case swipe_left = 2
    case swipe_right = 3
    case swipe_down = 4
    case swipe_up = 5
}
public struct closure {
    typealias emptyCallback = ()->()
    static var actionDict = [Int:[closureActions : emptyCallback]]()
    static var btnActionDict = [Int:[String: emptyCallback]]()
}



public extension UIView{
    
    var closureId:Int{
        get {
            let value = objc_getAssociatedObject(self, &AssociatedObjectHandle) as? Int ?? Int()
            return value
        }
        set {
            objc_setAssociatedObject(self, &AssociatedObjectHandle, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    func actionHandleBlocks(_ type : closureActions = .none,action:(() -> Void)? = nil) {
        
        if type == .none{
            return
        }
        var actionDict : [closureActions : closure.emptyCallback]
        if self.closureId == Int(){
            self.closureId = closure.actionDict.count + 1
            closure.actionDict[self.closureId] = [:]
        }
        if action != nil {
            actionDict = closure.actionDict[self.closureId]!
            actionDict[type] = action
            closure.actionDict[self.closureId] = actionDict
        } else {
            let valueForId = closure.actionDict[self.closureId]
            if let exe = valueForId![type]{
                exe()
            }
        }
    }
    
    @objc func triggerTapActionHandleBlocks() {
        self.actionHandleBlocks(.tap)
    }
    @objc func triggerSwipeLeftActionHandleBlocks() {
        self.actionHandleBlocks(.swipe_left)
    }
    @objc func triggerSwipeRightActionHandleBlocks() {
        self.actionHandleBlocks(.swipe_right)
    }
    @objc func triggerSwipeUpActionHandleBlocks() {
        self.actionHandleBlocks(.swipe_up)
    }
    @objc func triggerSwipeDownActionHandleBlocks() {
        self.actionHandleBlocks(.swipe_down)
    }
    func addTap(Action action:@escaping() -> Void){
        self.actionHandleBlocks(.tap,action:action)
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(triggerTapActionHandleBlocks))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(gesture)
    }
    
    func addTap(IsEnabled: Bool = false,Action action:@escaping() -> Void){
        self.actionHandleBlocks(.tap,action:action)
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(triggerTapActionHandleBlocks))
        self.isUserInteractionEnabled = IsEnabled
        self.addGestureRecognizer(gesture)
    }
    
    func addLongPressAction(minimumPressDuration: CFTimeInterval = 0.5, handler: @escaping () -> Void) -> UILongPressGestureRecognizer {
        
        let longPressGesture = UILongPressGestureRecognizer()
        longPressGesture.minimumPressDuration = minimumPressDuration
        longPressGesture.addAction(handler)
        self.addGestureRecognizer(longPressGesture)
        self.isUserInteractionEnabled = true
        
        return longPressGesture
    }

    
    func addAction(for type: closureActions ,Action action:@escaping() -> Void){
        
        self.isUserInteractionEnabled = true
        self.actionHandleBlocks(type,action:action)
        switch type{
        case .none:
            return
        case .tap:
            let gesture = UITapGestureRecognizer()
            gesture.addTarget(self, action: #selector(triggerTapActionHandleBlocks))
            self.isUserInteractionEnabled = true
            self.addGestureRecognizer(gesture)
        case .swipe_left:
            let gesture = UISwipeGestureRecognizer()
            gesture.direction = UISwipeGestureRecognizer.Direction.left
            gesture.addTarget(self, action: #selector(triggerSwipeLeftActionHandleBlocks))
            self.isUserInteractionEnabled = true
            self.addGestureRecognizer(gesture)
        case .swipe_right:
            let gesture = UISwipeGestureRecognizer()
            gesture.direction = UISwipeGestureRecognizer.Direction.right
            gesture.addTarget(self, action: #selector(triggerSwipeRightActionHandleBlocks))
            self.isUserInteractionEnabled = true
            self.addGestureRecognizer(gesture)
        case .swipe_up:
            let gesture = UISwipeGestureRecognizer()
            gesture.direction = UISwipeGestureRecognizer.Direction.up
            gesture.addTarget(self, action: #selector(triggerSwipeUpActionHandleBlocks))
            self.isUserInteractionEnabled = true
            self.addGestureRecognizer(gesture)
        case .swipe_down:
            let gesture = UISwipeGestureRecognizer()
            gesture.direction = UISwipeGestureRecognizer.Direction.down
            gesture.addTarget(self, action: #selector(triggerSwipeDownActionHandleBlocks))
            self.isUserInteractionEnabled = true
            self.addGestureRecognizer(gesture)
        }
        
        
    }
}


// MARK: - Internal Gesture Helper
private var gestureActionKey: UInt8 = 0

private class GestureActionWrapper {
    let action: () -> Void
    init(action: @escaping () -> Void) {
        self.action = action
    }
}


private extension UIGestureRecognizer {
    func addAction(_ action: @escaping () -> Void) {
        let wrapper = GestureActionWrapper(action: action)
        objc_setAssociatedObject(self, &gestureActionKey, wrapper, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        self.addTarget(self, action: #selector(handleAction))
    }

    @objc func handleAction() {
        if let wrapper = objc_getAssociatedObject(self, &gestureActionKey) as? GestureActionWrapper {
            wrapper.action()
        }
    }
}


extension View {
    func noDataOverlay(_ show: Bool, message: String = "No Data Found") -> some View {
        ZStack {
            self
            if show {
                VStack(spacing: 12) {
                    Image(systemName: "tray")
                        .font(.system(size: 50))
                        .foregroundColor(.gray.opacity(0.5))
                    Text(message)
                        .font(.headline)
                        .foregroundColor(.gray)
                }
                .padding()
                .multilineTextAlignment(.center)
                .background(
                    Color(.systemBackground)
                        .opacity(0.7)
                        .blur(radius: 5)
                )
                .cornerRadius(12)
            }
        }
    }
}
