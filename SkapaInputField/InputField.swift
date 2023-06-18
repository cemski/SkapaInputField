//
//  InputField.swift
//  SkapaInputField
//
//  Created by Cem on 2023-06-14.
//

import SwiftUI
import Combine

enum InputFieldStates {
    case unselected, selected, success, error
}

enum InputFieldError {
    case unselected, selected, error, success
    
    var message: String {
        switch self {
        case .unselected, .selected:
            return "Only numeric input allowed"
        case .error:
            return "Please only X characters"
        case .success:
            return "Success"
        }
    }
    
    func hintMessage(_ message: String, maxLength: UInt16) -> String {
        switch self {
        case .unselected, .selected:
            return message
        case .error:
            return "Please only enter up to \(maxLength) characters"
        case .success:
            return "Success"
        }
    }
    
    var state: InputFieldStates {
        switch self {
        case .unselected:
            return .unselected
        case .selected:
            return .selected
        case .error:
            return .error
        case .success:
            return .success
        }
    }
    
    var color: Color {
        switch self {
        case .unselected:
            return .neutral5
        case .selected:
            return .interactiveEmphasisedBgDefault
        case .error:
            return .semanticNegative
        case .success:
            return .semanticPositive
        }
    }
}

enum SubtitleCases {
    case normal, error, success
    
    var color: Color {
        switch self {
        case .normal:
            return .textAndIcon3
        case .error:
            return .semanticNegative
        case .success:
            return .semanticPositive
        }
    }
    
    var stateIcon: String? {
        switch self {
        case .normal:
            return nil
        case .error:
            return "exclamationmark.circle.fill"
        case .success:
            return "checkmark.circle.fill"
        }
    }
}

struct InputField: View {
    @FocusState var isFocused: Bool
    @Binding var text: String
    @State var isSecure: Bool = false
    @State var isTextHidden: Bool = true
    @State var inputFieldState: InputFieldError = .unselected
    @State var subtitleCase: SubtitleCases = .normal
    var maxLength: UInt16 = 10
    var title: String?
    var hintString: String?
    var errorString: String?
    var placeholder: String = ""
    
    var body: some View {
        VStack {
            if let title = title {
                setupTopStack(title: title)
            }
            setupInputFields()
            if let hint = hintString {
                setupBottomStack(hint: hint)
            }
        }
    }
    
    private func setupTopStack(title: String) -> some View {
        HStack {
            Text(title)
                .font(.body)
                .foregroundColor(.textAndIcon2)
            Spacer()
        }
        .padding(.bottom, 2)
    }
    
    private func setupInputFields() -> some View {
        VStack {
            Group {
                if isSecure {
                    Group {
                        if isTextHidden {
                            SecureField(placeholder, text: $text)
                        } else {
                            TextField(placeholder, text: $text)
                        }
                    }
                    .overlay(
                        Button(action: {
                            self.isTextHidden.toggle()
                        }){
                            Image(systemName: isTextHidden ? "eye" : "eye.slash")
                                .foregroundColor(.textAndIcon1)
                        }
                            .padding(.trailing, 0),
                        alignment: .trailing)
                    
                } else {
                    TextField(placeholder, text: $text)
                    
                }
            }
            .focused($isFocused)
            .onChange(of: isFocused, perform: { focus in
                self.inputFieldState = focus ? .selected : .unselected
            })
            .padding(EdgeInsets(top: 11, leading: 8, bottom: 11, trailing: 8))
            .font(.body)
            .textFieldStyle(.plain)
            .background(Color.neutral1)
            .foregroundColor(.textAndIcon1)
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(self.inputFieldState.color, lineWidth: 1)
            )
            
            .onReceive(Just(text), perform: { text in
                verifyInput()
            })
        }
        .frame(height: 48)
        .padding(.bottom, 4)
    }
    
    private func setupBottomStack(hint: String) -> some View {
        HStack {
            if subtitleCase != .normal {
                Image(systemName: subtitleCase.stateIcon ?? "")
                    .foregroundColor(subtitleCase.color)
            }
                Text(inputFieldState.hintMessage(hint, maxLength: maxLength))
                    .foregroundColor(subtitleCase.color)
                    .font(.caption)
                    .lineSpacing(22)
            Spacer()
            if maxLength > 0 {
                if text.count < maxLength {
                    Text("\(text.count)/\(maxLength)")
                        .font(.caption)
                        .foregroundColor(.textAndIcon3)
                }
            }
        }
//        .padding(.top, 4)
    }
    
    private func verifyInput() {
        guard maxLength > 0 else {
            return
        }
        
        if text.count < maxLength {
            inputFieldState = isFocused ? .selected : .unselected
            subtitleCase = .normal
        }
        
        if text.count > maxLength {
            inputFieldState = .error
            subtitleCase = .error
        }
        
        if text.count == maxLength {
            inputFieldState = .success
            subtitleCase = .success
        }
    }
}



struct InputPreview: View {
    @State private var text: String = ""
    @State private var pass: String = ""
    
    var body: some View {
        ZStack{
            Color.neutral1.ignoresSafeArea()
            VStack {
                InputField(text: $text, title: "Username")
                InputField(text: $pass, isSecure: true, maxLength: 10, title: "Pin", hintString: "Only numeric input allowed")
            }
            .padding(30)
        }
    }
}

struct InputField_Previews: PreviewProvider {
    static var previews: some View {
        InputPreview()
            .previewDisplayName("Standard")
        InputPreview()
            .environment(\.colorScheme, .dark)
            .previewDisplayName("Dark")
        InputPreview()
            .environment(\.layoutDirection, .rightToLeft)
            .previewDisplayName("RTL")
        InputPreview()
            .environment(\.colorScheme, .dark)
            .environment(\.layoutDirection, .rightToLeft)
            .previewDisplayName("RTL Dark")
        
    }
}
