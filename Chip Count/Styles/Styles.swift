//
//  Styles.swift
//  Chip Count
//
//  Created by Anthony Previte on 6/5/25.
//

import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(width: 300)
            .background(Color.white)
            .foregroundColor(.black)
            .cornerRadius(10)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
    }
}

struct PrimaryTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .frame(width: 275)
            .background(Color.black)
            .foregroundColor(.white)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.white, lineWidth:2)
            )
    }
}

struct LargeTextStyle: ViewModifier {
    var color: Color = .white
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: 50))
            .foregroundColor(color)
    }
}

struct SmallTextStyle: ViewModifier {
    var color: Color = .white
    
    func body(content: Content) -> some View {
        content
            .font(.title3)
            .foregroundColor(color)
    }
}

struct PrimaryDividerStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: 350)
            .frame(height: 2)
            .background(Color("ForegroundColor"))
            .padding(.vertical, 8)
    }
}
