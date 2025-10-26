//
//  UiTextView_Cus.swift
//  Mutasil
//
//  Created by SCT on 02/09/25.
//

import Foundation
import SwiftUICore
import SwiftUI


struct AppTextEditor: View {
    @Binding var text: String
    var placeholder: String
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(.gray)
                    .padding(.top, 8)
                    .padding(.leading, 5)
            }
            
            TextEditor(text: $text)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray))
        }
        .padding(.horizontal)
        .frame(height: 120)
    }
}
