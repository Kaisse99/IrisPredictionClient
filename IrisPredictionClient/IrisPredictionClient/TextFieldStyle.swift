//
//  TextFieldStyle.swift
//  IrisPredictionClient
//
//  Created by Mykyta Kaisenberg on 2026-04-04.
//

import Foundation
import SwiftUI

struct CoolTextFieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(12)
            .background(Color(hex: "#000000"))
            .cornerRadius(14)
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.white.opacity(0.70), lineWidth: 1)).tint(.white.opacity(0.70)).shadow(color: .white.opacity(0.4), radius: 2, x: 0, y: 0)
            .shadow(color: .white.opacity(0.3), radius: 6, x: 0, y: 0)
    }
}

extension View {
    func coolTextFieldStyle() -> some View {
        modifier(CoolTextFieldStyle())
    }
}
