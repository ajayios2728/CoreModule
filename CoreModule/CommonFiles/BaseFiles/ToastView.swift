//
//  ToastView.swift
//  Democracy X
//
//  Created by Apple on 14/05/2024.
//

import SwiftUI

struct Toast: Equatable {
  var style: ToastStyle
  var message: String
  var duration: Double = 3
  var width: Double = .infinity

}

enum ToastStyle {
  case error
  case warning
  case success
  case info
}

extension ToastStyle {
  var themeColor: Color {
    switch self {
    case .error: return Color.red
    case .warning: return Color.orange
    case .info: return Color(PrimaryThemecolor)
    case .success: return Color.green
    }
  }
  
  var iconFileName: String {
    switch self {
    case .info: return "info.circle.fill"
    case .warning: return "exclamationmark.triangle.fill"
    case .success: return "checkmark.circle.fill"
    case .error: return "xmark.circle.fill"
    }
  }
}


final class ToastManager: ObservableObject {
    static let shared = ToastManager()
    
    @Published var toast: Toast?
    
    func show(style: ToastStyle, message: String, duration: Double = 3) {
        DispatchQueue.main.async {
            self.toast = Toast(style: style, message: message, duration: duration)
        }
    }
}

struct GlobalToast: View {
    @ObservedObject var toastManager: ToastManager = .shared
    @State var Show: Bool = false
    var body: some View {
        if let toast = toastManager.toast {
            VStack {
                Spacer()
                if Show {
                    ToastView(style: toast.style, message: toast.message,duration: toast.duration) {
                        
                        withAnimation(Animation.linear(duration: 0.3)) {
                            self.Show.toggle()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                toastManager.toast = nil
                            }
                        }
                    }
                    .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .bottom)))
//                    .animation(.spring(), value: toast)

                }
            }
            .onAppear(){
                withAnimation(Animation.linear(duration: 0.3)) {
                    self.Show.toggle()
                }

            }
            
        }
    }
}




struct ToastView: View {
  
  var style: ToastStyle
  var message: String
  var width = CGFloat.infinity
  var duration: Double
  var onCancelTapped: (() -> Void)
    
  var isShowing = true
    var body: some View {
        if isShowing {
            HStack(alignment: .center, spacing: 12) {
                Image(systemName: style.iconFileName)
                    .foregroundColor(style.themeColor)
                Text(message)
                    .font(Font.headline)
                    .foregroundColor(style.themeColor)
                    .frame(alignment: .center)
                
                Spacer(minLength: 10)
                
                Button {
                    onCancelTapped()
                } label: {
                    Image(systemName: "xmark")
                        .foregroundColor(style.themeColor)
                }
            }
            .padding()
            .frame(minWidth: 0, maxWidth: width)
            .background(Color("toastBackground"))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 100)
                    .fill(style.themeColor.opacity(0.5))
                    .opacity(0.3)
                    .shadow(radius: 10)
                
            )
            .padding(.horizontal, 16)
            .onAppear {
                if duration > 0 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                        onCancelTapped()
                    }
                }
            }
            
        }
    }
}


struct ToastModifier: ViewModifier {
  
  @Binding var toast: Toast?
  @State private var workItem: DispatchWorkItem?
  
  func body(content: Content) -> some View {
    content
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .overlay(
        ZStack {
          mainToastView()
            .offset(y: 32)
        }.animation(.spring(), value: toast)
      )
      .onChange(of: toast) { value in
        showToast()
      }
  }
  
  @ViewBuilder func mainToastView() -> some View {
    if let toast = toast {
      VStack {
        ToastView(
          style: toast.style,
          message: toast.message,
          width: toast.width,
          duration: toast.duration
        ) {
          dismissToast()
        }
        Spacer()
      }
    }
  }
  
  private func showToast() {
    guard let toast = toast else { return }
    
    UIImpactFeedbackGenerator(style: .light)
      .impactOccurred()
    
    if toast.duration > 0 {
      workItem?.cancel()
      
      let task = DispatchWorkItem {
        dismissToast()
      }
      
      workItem = task
      DispatchQueue.main.asyncAfter(deadline: .now() + toast.duration, execute: task)
    }
  }
  
  private func dismissToast() {
    withAnimation {
      toast = nil
    }
    
    workItem?.cancel()
    workItem = nil
  }
}

#Preview {
    ToastView(style: .error, message: "Ajay", duration: 3,onCancelTapped: {
        
    })
}



extension View {

  func toastView(toast: Binding<Toast?>) -> some View {
    self.modifier(ToastModifier(toast: toast))
  }
}
