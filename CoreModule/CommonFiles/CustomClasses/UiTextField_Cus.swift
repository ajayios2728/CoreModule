//
//  UiTextField_Cus.swift
//  Mutasil
//
//  Created by SCT on 02/09/25.
//

import Foundation
import SwiftUICore
import SwiftUI


enum Icons: String{
    case Eye
    case InVisiableEye
    case none
}



struct LoginTextField: View, SecuredTextFieldParentProtocol {
    
    @Environment(\.horizontalSizeClass) var hSizeClass

    var IsIphone: Bool {
        return hSizeClass == .compact
    }
    
    @Binding var text: String
    @FocusState var IsFoucsed: Bool
    
    let placeholder: String
    let ErrorMsg: String

    var isSecure: Bool = false
    
    @State var Icon : Icons = .InVisiableEye
    @State var EyeBtnTapped = false

    var CornerRadius: CGFloat = 5
    var FontName : FontEnums = .Medium
    
    var body: some View {
                
        let Width: CGFloat = IsIphone ? ScreenWidth - 50 : ScreenWidth - 100
        let Height: CGFloat = IsIphone ? 50 : 60
        let FontSize : CGFloat = IsIphone ? .BODY : .SUBHEADER

        let IsActive = IsFoucsed || text.count > 0
        
        VStack(alignment: .leading) {
            ZStack(alignment: .leading) {
                
                if isSecure {
                    
                    SecuredTextFieldView(text: $text, IsFoucsed: _IsFoucsed, placeholder: placeholder, ErrorMsg: ErrorMsg, parent: self)

                } else {
                    
                    ZStack(alignment: .trailing) {
                        
                        TextField(IsActive ? placeholder : "",
                                  text: Binding(
                                    get: { text },
                                    set: { newValue in
                                        // Remove emojis from input
                                        withAnimation {
                                            text = newValue.filter { !$0.isEmoji }
                                        }
                                    }
                                  ))
                        .keyboardType(.asciiCapable) // Only allows English letters, numbers, and symbols
                        .foregroundStyle(Color(PrimaryBlack))
                        .SetFont(FontType: FontName, Size: FontSize)
                        .frame(width: Width, height: Height, alignment: .center)
                        .background(
                            RoundedRectangle(cornerRadius: CornerRadius, style: .continuous)
                                .fill(
//                                    .shadow(.drop(color: Color(ErrorMsg != "" ? .red : IsActive ? PrimaryThemecolor : .gray),radius: 2, x: 0, y: 0))
                                    .shadow(.drop(color: Color(ErrorMsg != "" ? .red : PrimaryThemecolor),radius: 2, x: 0, y: 0))
                                )
                                .foregroundColor(Color(PrimaryWhite))
                                .frame(width: Width + 10, height: Height, alignment: .center)
                            
                        )
                        .focused($IsFoucsed)
                        .padding(.vertical,5)
                        
                        if text != "" {
                            Button(action: {
                                withAnimation {
                                    text = ""
                                }
                            }, label: {
                                AppThemeIcon(imageName: .closeCross,
                                             Width: ScreenWidth / 30,
                                             Height: ScreenWidth / 30,
                                             OuterPadding: 0)
                                
                            })
                        }
                        
                    }
                    
                }
                
                
                HStack {
                    
                    HStack {
                        

                        let width = placeholder.width(using: UIFont(name: FontEnums.Medium.rawValue, size: FontSize) ?? .systemFont(ofSize: FontSize, weight: .regular))

                        Text(placeholder)
                            .SetFont(FontType: FontName, Size: FontSize)
                            .foregroundStyle(Color(IsActive ? PrimaryThemecolor : .gray))
                            .font(.headline)
                            .frame(height: 10)
                            .offset(y: IsActive ? -28 : 0)
                            .background(Rectangle()
                                .padding(.horizontal, (width / 5))
                                .padding(.vertical, 10)
                                .background(Color(IsActive ? PrimaryWhite : PrimaryWhite))
                                .offset(y: IsActive ? -28 : 0)
                            )
                            .padding(.horizontal, 11)
                            .padding(.vertical, 8)
                        Spacer()
                        
                    }
                    .frame(width: Device.screen.width / 1.4)
                    
                }
                .onTapGesture {
                    IsFoucsed = true
                }
                .animation(.bouncy(duration: 0.4,extraBounce: 0.2), value: IsActive)
                
            }
            .padding(.vertical, 5)
            
            if ErrorMsg != "" && text == "" {
                Text(ErrorMsg)
                    .SetFont(FontType: FontName, Size: FontSize)
                    .foregroundStyle(.red)
                    .padding(.top, 2)
                    .padding(.bottom, 3)
            }

        }

            
    }
    
    @State var hideKeyboard: (() -> Void)?
    
    /// The secured tex the usert inputed in SecuredTextFieldView
    @State private var password = ""
    
    /// State of alert apearance.
    @State private var showingAlert = false

    
    /// Execute the clouser and perform hide keyboard in SecuredTextFieldView.
    private func performHideKeyboard() {
        
        guard let hideKeyboard = self.hideKeyboard else {
            return
        }
        
        hideKeyboard()
    }

}


extension String {
    func width(using font: UIFont) -> CGFloat {
        let attributes = [NSAttributedString.Key.font: font]
        return self.size(withAttributes: attributes).width
    }
}


struct AppTextField: View {
    
    @Environment(\.horizontalSizeClass) var hSizeClass

    var IsIphone: Bool {
        return hSizeClass == .compact
    }

    @Binding var text: String
//    @FocusState var IsFoucsed: Bool
    let placeholder: String

    var FontName: FontEnums = .Medium
    var color: Color = .black
    
    var body: some View {
        let FontSize: CGFloat = IsIphone ? .BODY : .HEADER
//        let IsActive = IsFoucsed || text.count > 0
        
        TextField(placeholder,
                  text: $text)
        .SetFont(FontType: FontName, Size: FontSize)
//        .focused($IsFoucsed)

    }
}



/// Properties and functionalities to assign and  perform in the parent view of the SecuredTextFieldView.
protocol SecuredTextFieldParentProtocol {
    
    /// Assign SecuredTextFieldView hideKeyboard method to this and
    /// then parent can excute it when needed..
    var hideKeyboard: (() -> Void)? { get set }
}

/// The identity of the TextField and the SecureField.
enum Field: Hashable {
    case showPasswordField
    case hidePasswordField
}

/// This view supports for have a secured filed with show / hide functionality.
///
/// We have managed show / hide functionality by using
/// A SecureField for hide the text, and
/// A TextField for show the text.
///
/// Please note that,
/// hide -> show -> hide senario with reset the text by the new input value.
/// It's common even in the other apps. eg: LinkedIn, MoneyGram
struct SecuredTextFieldView: View {
    
    @Environment(\.horizontalSizeClass) var hSizeClass

    var IsIphone: Bool {
        return hSizeClass == .compact
    }

    @Binding var text: String
    @FocusState var IsFoucsed: Bool
    
    let placeholder: String
    let ErrorMsg: String

    var isSecure: Bool = false
    
    @State var Icon : Icons = .InVisiableEye
    @State var EyeBtnTapped = false

    var CornerRadius: CGFloat = 5
    var FontName : FontEnums = .Medium

    /// Options for opacity of the fields.
    enum Opacity: Double {

        case hide = 0.0
        case show = 1.0

        /// Toggle the field opacity.
        mutating func toggle() {
            switch self {
            case .hide:
                self = .show
            case .show:
                self = .hide
            }
        }
    }

    /// The property wrapper type that can read and write a value that
    /// SwiftUI updates as the placement of focus.
    @FocusState private var focusedField: Field?

    /// The show / hide state of the text.
    @State private var isSecured: Bool = true

    /// The opacity of the SecureField.
    @State private var hidePasswordFieldOpacity = Opacity.show

    /// The opacity of the TextField.
    @State private var showPasswordFieldOpacity = Opacity.hide

    /// The text value of the SecureFiled and TextField which can be
    /// binded with the @State property of the parent view of SecuredTextFieldView.
//    @Binding var text: String
    
    /// Parent view of this SecuredTextFieldView.
    /// Also this is a struct and structs are value type.
    @State var parent: SecuredTextFieldParentProtocol

    var body: some View {
        VStack {
            ZStack(alignment: .trailing) {
                securedTextField

                Button(action: {
                    performToggle()
                }, label: {
//                    Image(systemName: self.isSecured ? "eye.slash" : "eye")
//                        .accentColor(.gray)

                    Image(self.isSecured ? .inVisiableEye : .eye)
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundStyle(Color(PrimaryThemecolor))

                })
            }
        }
        .onAppear {
            self.parent.hideKeyboard = hideKeyboard
        }
    }

    /// Secured field with the show / hide capability.
    var securedTextField: some View {
        
        let Width: CGFloat = IsIphone ? ScreenWidth - 50 : ScreenWidth - 100
        let Height: CGFloat = IsIphone ? 50 : 60
        let FontSize : CGFloat = IsIphone ? .BODY : .SUBHEADER

        let IsActive = IsFoucsed || text.count > 0

        return HStack {
            HStack {
                
                if Icon == .Eye {
                    TextField(IsActive ? placeholder : "",
                              text: Binding(
                                          get: { text },
                                          set: { newValue in
                                              // Remove emojis from input
                                              withAnimation {
                                                  text = newValue.filter { !$0.isEmoji }
                                              }
                                          }
                                      ))
                    .keyboardType(.asciiCapable) // Only allows English letters, numbers, and symbols
                    .foregroundStyle(Color(PrimaryBlack))
                    .SetFont(FontType: FontName, Size: FontSize)
                    .frame(width: Width - 100, height: Height)
                    .focused($IsFoucsed)
                    .padding(.vertical,5)
                }else{
                    SecureField(IsActive ? placeholder : "",
                                text: Binding(
                                            get: { text },
                                            set: { newValue in
                                                // Remove emojis from input
                                                withAnimation {
                                                    text = newValue.filter { !$0.isEmoji }
                                                }
                                            }
                                        ))
                    .keyboardType(.asciiCapable) // Only allows English letters, numbers, and symbols
                    .foregroundStyle(Color(PrimaryBlack))
                    .SetFont(FontType: FontName, Size: FontSize)
                    .frame(width: Width - 100, height: Height)
                    .focused($IsFoucsed)
                    .padding(.vertical,5)

                }
                
                Spacer()
            }
            
        }
        .frame(width: Width, height: Height)
        .background(
            RoundedRectangle(cornerRadius: CornerRadius, style: .continuous)
                .fill(
//                    .shadow(.drop(color: Color(ErrorMsg != "" ? .red : IsActive ? PrimaryThemecolor : .gray),radius: 2, x: 0, y: 0))
                    .shadow(.drop(color: Color(ErrorMsg != "" ? .red : PrimaryThemecolor),radius: 2, x: 0, y: 0))
                )
                .foregroundColor(Color(PrimaryWhite))
                .frame(width: Width + 10, height: Height, alignment: .center)
            
        )
    }
    
    /// This supports the parent view to perform hide the keyboard.
    func hideKeyboard() {
        self.focusedField = nil
    }
    
    /// Perform the show / hide toggle by changing the properties.
    private func performToggle() {
        isSecured.toggle()

        if isSecured {
            focusedField = .hidePasswordField
            Icon = .InVisiableEye
        } else {
            focusedField = .showPasswordField
            Icon = .Eye
        }

        hidePasswordFieldOpacity.toggle()
        showPasswordFieldOpacity.toggle()
    }
}



extension Character {
    var isEmoji: Bool {
        // Check if the scalar is emoji
        unicodeScalars.contains { $0.properties.isEmoji && ($0.value > 0x238C) }
    }
}
