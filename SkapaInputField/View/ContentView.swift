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
    @State var usernameState = InputFieldStates.unselected
    @State var passwordState = InputFieldStates.unselected
    
    var body: some View {
        NavigationView {
            VStack {
                InputField(text: $username,
                           isSecure: false,
                           state: $usernameState,
                           title: "Username",
                           maxLength: 0)
                InputField(text: $password,
                           isSecure: true,
                           state: $passwordState,
                           title: "Pin",
                           promptString: "Only numeric input allowed",
                           maxLength: 8)
                Spacer()
                LoginButton(action: {
                    print("Begin login process")
                }, title: "Login")
                    
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
