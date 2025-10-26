//
//  UiView_Cus.swift
//  Mutasil
//
//  Created by SCT on 02/09/25.
//

import Foundation
import SwiftUI




struct CheckBoxView: View {
    @State var checked: Bool

    var body: some View {
        Image(systemName: checked ? "checkmark.square.fill" : "square")
            .resizable()
            .frame(width: ScreenWidth/15, height: ScreenWidth/15)
            .foregroundColor(checked ? Color(UIColor.systemBlue) : Color.secondary)
//            .onTapGesture {
//                self.checked.toggle()
//            }
    }
}
