//
//  LoginButton.swift
//  SkapaInputField
//
//  Created by Cem on 2023-06-20.
//

import SwiftUI

struct LoginButton<Content: View>: View {
    let action: () -> Void
    let label: () -> Content
    
    
    init(action: @escaping () -> Void, @ViewBuilder label: @escaping () -> Content) {
        self.action = action
        self.label = label
    }
    
    init(action: @escaping () -> Void, title: String) where Content == Text {
        
        self.init(action: action, label: {
            Text(title)
        })
    }
    
    var body: some View {
        let label = label()
        label.onTapGesture {
            action()
        }
        .buttonStyle(.plain)
        .font(.headingXS)
        .frame(maxWidth: .infinity, minHeight: 56)
        .overlay(
            Capsule(style: .circular)
                .stroke(Color.textAndIcon1, style: StrokeStyle(lineWidth: 1))
        )
    }
}

struct LoginButton_Previews: PreviewProvider {
    static var previews: some View {
        LoginButton(action: {
            print("ok")
            
        }, title: "Login")
        .padding(.horizontal, 30)
    }
}
