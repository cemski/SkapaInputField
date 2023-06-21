//
//  ContentView.swift
//  SkapaInputField
//
//  Created by Cem on 2023-06-14.
//

import SwiftUI

struct ContentView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    
    private var usernameModel = InputFieldModel(text: "", title: "Username")
    private var passModel = InputFieldModel(text: "", isSecure: true, maxLength: 8, title: "Pin", promptString: "Only numeric input allowed")
    
    var body: some View {
        NavigationView {
            VStack {
                InputField(model: usernameModel)
                InputField(model: passModel)
                Spacer()
                LoginButton(action: {
                    
                }, title: "Login")
                    .accessibilityIdentifier("loginButton")
                    
            }
            .navigationTitle("InputField Demo")
            .navigationBarTitleDisplayMode(.inline)
            .padding(EdgeInsets(top: 30, leading: 33, bottom: 0, trailing: 33))
            .background(Color.neutral1)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDisplayName("Standard")
        ContentView()
            .environment(\.colorScheme, .dark)
            .previewDisplayName("Dark")
        ContentView()
            .environment(\.layoutDirection, .rightToLeft)
            .previewDisplayName("RTL")
        ContentView()
            .environment(\.colorScheme, .dark)
            .environment(\.layoutDirection, .rightToLeft)
            .previewDisplayName("RTL Dark")
    }
}
