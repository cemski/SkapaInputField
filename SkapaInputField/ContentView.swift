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
    
    var body: some View {
        NavigationView {
            VStack {
                Divider()
                Group {
                    
                    InputField(text: $username, title: "Username")
                    InputField(text: $password, isSecure: true, title: "Pin", informationString: "Please only enter up to 8 characters")
                    
                }
                Spacer()
                Button("Login") {}
                    .buttonStyle(.plain)
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .overlay(
                        Capsule(style: .circular)
                            .stroke(.black, style: StrokeStyle(lineWidth: 1))
                    )
            }
            .navigationTitle("InputField Demo")
            .navigationBarTitleDisplayMode(.inline)
            .padding(EdgeInsets(top: 0, leading: 30, bottom: 0, trailing: 30))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
